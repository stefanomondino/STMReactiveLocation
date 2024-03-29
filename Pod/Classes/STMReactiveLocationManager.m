//
//  STMReactiveLocationManager.m
//  Pods
//
//  Created by Stefano Mondino on 27/02/15.
//
//

#import "STMReactiveLocationManager.h"
#import "EXTScope.h"

@interface STMReactiveLocationManager() <CLLocationManagerDelegate>
@property (nonatomic,strong) CLLocationManager* locationManager;
@property (nonatomic,strong) RACSubject* locationSubject;
@property (readwrite, nonatomic) int numberOfLocationSubscribers;
@end

@implementation STMReactiveLocationManager
+ (instancetype) sharedManager {
    static STMReactiveLocationManager * _shared;
    if (!_shared) {
        _shared = [self new];
    }
    return _shared;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.locationManager = [CLLocationManager new];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        self.locationManager.distanceFilter = kCLLocationAccuracyBest;
        
        self.locationSubject = [RACSubject subject];
        RACSignal* newLocations = [[[self rac_signalForSelector:@selector(locationManager:didUpdateLocations:) fromProtocol:@protocol(CLLocationManagerDelegate)] map:^id(RACTuple* parameters) {
            return parameters.second;
        }] filter:^BOOL(NSArray* locations) {
            return locations!=nil && [locations isKindOfClass:[NSArray class]] && locations.count>0;
        }];
        
        RACSignal* locationErrors = [self rac_signalForSelector:@selector(locationManager:didFailWithError:) fromProtocol:@protocol(CLLocationManagerDelegate)];
        
        [self.locationSubject rac_liftSelector:@selector(sendNext:) withSignalsFromArray:@[newLocations]];
        //[self.locationSubject rac_liftSelector:@selector(sendError:) withSignalsFromArray:@[locationErrors]]
        ;
        self.locationManager.delegate = self;
    }
    return self;
}



- (void) requestWhenInUseAuthorization {
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        BOOL isInfoDictionaryValueSet = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"NSLocationWhenInUseUsageDescription"] != nil;
        NSAssert(isInfoDictionaryValueSet, @"You need to set NSLocationWhenInUseUsageDescription in your app's Info.plist to use location services when the app is in foreground");
        [self.locationManager requestWhenInUseAuthorization];
    }
}
- (void) requestAlwaysAuthorization {
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        BOOL isInfoDictionaryValueSet = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"NSLocationAlwaysUsageDescription"] != nil;
        NSAssert(isInfoDictionaryValueSet, @"You need to set NSLocationAlwaysUsageDescription in your app's Info.plist to use location services when the app is in background");
        [self.locationManager requestAlwaysAuthorization];
    }
}

- (RACSignal *)rac_signalForAllLocationUpdates  {
    @weakify(self);
    
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        @synchronized(self) {
            if(self.numberOfLocationSubscribers == 0) {
                [self.locationManager startUpdatingLocation];
            }
            ++self.numberOfLocationSubscribers;
        }
        
        [self.locationSubject subscribe:subscriber];
        
        return [RACDisposable disposableWithBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                @synchronized(self) {
                    --self.numberOfLocationSubscribers;
                    if(self.numberOfLocationSubscribers == 0) {
                        [self.locationManager stopUpdatingLocation];
                    }
                }
            });
        }];
    }];
}
- (RACSignal*) rac_signalForMostAccurateLocationUpdates {
    
    return [[self rac_signalForAllLocationUpdates] map:^id(NSArray* value) {
        return [[[value.rac_sequence filter:^BOOL(CLLocation*  value) {
            return (value.horizontalAccuracy>=0);
        }].array sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"horizontalAccuracy" ascending:YES]]] firstObject];
    }];
            
}

- (RACSignal*) rac_signalForCurrentLocation {
    return [[[self rac_signalForMostAccurateLocationUpdates] filter:^BOOL(id value) {
        return value!=nil;
    }] take:1];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{;}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{;}
@end
