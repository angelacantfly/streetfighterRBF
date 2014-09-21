//
//  Coordinator.h
//  streetfighter
//
//  Created by Sasha Heinen on 9/20/14.
//  Copyright (c) 2014 hackthenorth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>
#import "MainViewControllerDelegate.h"
#import "MainViewController.h"

@interface Coordinator : NSObject <CBPeripheralManagerDelegate, CLLocationManagerDelegate, MainViewControllerDelegate>

@property (nonatomic, strong) MainViewController *view;
@property (nonatomic, strong) CBPeripheralManager *periphManager;
@property (nonatomic, strong) CLLocationManager *locManager;

@end
