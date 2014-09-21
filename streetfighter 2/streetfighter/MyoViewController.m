//
//  MyoViewController.m
//  streetfighter
//
//  Created by Angela Zhou on 9/20/14.
//  Copyright (c) 2014 hackthenorth. All rights reserved.
//

#import "MyoViewController.h"
#import <MyoKit/MyoKit.h>
#import "FightMove.h"
@interface MyoViewController ()

@property (atomic) float acceleration;
@property (atomic) Boolean existsAcceleration;

@end

@implementation MyoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.acceleration = 0;
        self.existsAcceleration = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Data notifications are received through NSNotificationCenter.
    // Posted whenever a TLMMyo connects
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didConnectDevice:)
                                                 name:TLMHubDidAttachDeviceNotification
                                               object:nil];
    // Posted whenever a TLMMyo disconnects
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didDisconnectDevice:)
                                                 name:TLMHubDidDisconnectDeviceNotification
                                               object:nil];
    // Posted whenever the user does a Sync Gesture, and the Myo is calibrated
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didRecognizeArm:)
                                                 name:TLMMyoDidReceiveArmRecognizedEventNotification
                                               object:nil];
    // Posted whenever Myo loses its calibration (when Myo is taken off, or moved enough on the user's arm)
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didLoseArm:)
                                                 name:TLMMyoDidReceiveArmLostEventNotification
                                               object:nil];
    // Posted when a new accelerometer event is available from a TLMMyo. Notifications are posted at a rate of 50 Hz.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveAccelerometerEvent:)
                                                 name:TLMMyoDidReceiveAccelerometerEventNotification
                                               object:nil];
    // Posted when a new pose is available from a TLMMyo
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceivePoseChange:)
                                                 name:TLMMyoDidReceivePoseChangedNotification
                                               object:nil];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didConnectDevice:(NSNotification *)notification {
    // Notify the Myo handler that the device is connected
    NSLog(@"MYO HAS ATTACHED TO THE DEVICE!");
    [self.delegate updateMyoStatus:CONNECT_STATE];
}

- (void)didDisconnectDevice:(NSNotification *)notification {
    // Notify the Myo handler that the device is disconnected
    [self.delegate updateMyoStatus:DISCONNECT_STATE];
}

- (void)didRecognizeArm:(NSNotification *)notification {
    [self.delegate updateMyoStatus:SYNC_GESTURE];
}

- (void)didLoseArm:(NSNotification *)notification {
    [self.delegate updateMyoStatus:RECALIBRATE_REQUIRED_STATE];
}


- (void)didReceiveAccelerometerEvent:(NSNotification *)notification {
    // Retrieve the accelerometer event from the NSNotification's userInfo with the kTLMKeyAccelerometerEvent.
    TLMAccelerometerEvent *accelerometerEvent = notification.userInfo[kTLMKeyAccelerometerEvent];
    
    // Get the acceleration vector from the accelerometer event.
    GLKVector3 accelerationVector = accelerometerEvent.vector;
    
    // Calculate the magnitude of the acceleration vector.
    float magnitude = GLKVector3Length(accelerationVector);
    
    self.existsAcceleration = true;
    self.acceleration = magnitude;
    NSString *printAcc = [NSString localizedStringWithFormat:@"%.2F", magnitude];
    NSLog(@"The acceleration is %@", printAcc );
    
//    // Update the progress bar based on the magnitude of the acceleration vector.
//    self.accelerationProgressBar.progress = magnitude / 8;
    
    /* Note you can also access the x, y, z values of the acceleration (in G's) like below
     float x = accelerationVector.x;
     float y = accelerationVector.y;
     float z = accelerationVector.z;
     */
}

- (void)didReceivePoseChange:(NSNotification *)notification {
    // Retrieve the pose from the NSNotification's userInfo with the kTLMKeyPose key.
    TLMPose *pose = notification.userInfo[kTLMKeyPose];
    
    // Handle the cases of the TLMPoseType enumeration, and change the color of helloLabel based on the pose we receive.
    switch (pose.type) {
//        case TLMPoseTypeUnknown:
            
        case TLMPoseTypeRest:
            self.acceleration = 0;
            self.existsAcceleration = false;
            NSLog(@"Rest pose detected.");
            break;
            
        case TLMPoseTypeFist:
            // Punch attack
            [self.delegate initiateFightMove:FIST_GESTURE withDamage:(NSInteger) 1];
            NSLog(@"PUNCH!!!");
            break;

        case TLMPoseTypeFingersSpread:
            // Magic attack or blocking
            if (self.existsAcceleration)
            {
                [self.delegate initiateFightMove:PALM_GESTURE withDamage:(NSInteger) 1];
            }
            else
            {
                [self.delegate initiateFightMove:BLOCK_GESTURE withDamage:(NSInteger) 0];
            }
            NSLog(@"PALM!!!");

            break;
            
            
//        case TLMPoseTypeWaveIn:
//            break;
//        case TLMPoseTypeWaveOut:
//            break;
//        case TLMPoseTypeThumbToPinky:
//            break;
            
        default:
            self.acceleration = 0;
            self.existsAcceleration = false;
            NSLog(@"Other poses detected...");
    }
}

- (IBAction)didTapSettings:(id)sender {
    // Note that when the settings view controller is presented to the user, it must be in a UINavigationController.
    UINavigationController *controller = [TLMSettingsViewController settingsInNavigationController];
    // Present the settings view controller modally.
    [self presentViewController:controller animated:YES completion:nil];
}


@end
