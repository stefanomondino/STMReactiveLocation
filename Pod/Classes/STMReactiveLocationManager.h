//
//  STMReactiveLocationManager.h
//  Pods
//
//  Created by Stefano Mondino on 27/02/15.
//
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>
@import CoreLocation;
@interface STMReactiveLocationManager : NSObject

+ (instancetype) sharedManager;

@property (nonatomic,readonly) CLLocationManager* locationManager;

- (void) requestWhenInUseAuthorization ;
- (void) requestAlwaysAuthorization;

- (RACSignal *)rac_signalForAllLocationUpdates;
- (RACSignal*) rac_signalForMostAccurateLocationUpdates;
- (RACSignal*) rac_signalForCurrentLocation;

@end
