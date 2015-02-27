//
//  STMViewController.m
//  STMReactiveLocation
//
//  Created by Stefano Mondino on 02/27/2015.
//  Copyright (c) 2014 Stefano Mondino. All rights reserved.
//

#import "STMViewController.h"
#import <STMReactiveLocationManager.h>
@interface STMViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lbl_currentPosition;

@end

@implementation STMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[STMReactiveLocationManager sharedManager] requestWhenInUseAuthorization];
    RAC(self.lbl_currentPosition,text) = [[[STMReactiveLocationManager sharedManager] rac_signalForMostAccurateLocationUpdates] map:^id(CLLocation* value) {
        return [value description];
    }];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
