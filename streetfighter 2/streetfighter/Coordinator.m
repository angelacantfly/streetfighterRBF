//
//  Coordinator.m
//  streetfighter
//
//  Created by Sasha Heinen on 9/20/14.
//  Copyright (c) 2014 hackthenorth. All rights reserved.
//

#import "Coordinator.h"
#import "MyoActionHandler.h"
#import "PebbleHandler.h"
#import "GameState.h"

#define UUID @"6973d400-40be-11e4-916c-0800200c9a66"
#define PHONE_IDENTIFIER @"streetfighterPhone"

#define STARTING_LIFE @20

typedef NS_ENUM(NSInteger, HardwareError) {
    bluetoothError,
    myoError,
    pebbleError
};

@interface Coordinator () <MyoActionHandlerDelegate, PebbleHandlerDelegate>

@property (nonatomic, strong) MyoActionHandler *myoHandler;
@property (nonatomic, strong) PebbleHandler *pebbleHandler;

@property (nonatomic) BOOL secondDeviceConnected;
@property (nonatomic) BOOL myoConnected;
@property (nonatomic) BOOL pebbleConnected;
@property (nonatomic) int numAttacks;

@property (nonatomic) NSMutableArray *attacksSoFar;

@end

@implementation Coordinator

-(id)init
{
    self = [super init];
    if (self) {
        self.view = [MainViewController new];
        self.view.delegate = self;
        
        self.secondDeviceConnected = YES;
        self.myoConnected = YES;
        self.pebbleConnected = YES;
        self.numAttacks = 0;
        self.attacksSoFar = [NSMutableArray new];
        
        self.myoHandler = [MyoActionHandler new];
        self.myoHandler.delegate = self;
        
        self.pebbleHandler = [[PebbleHandler alloc] initWithLife:STARTING_LIFE];
        self.pebbleHandler.delegate = self;
        
        GameState *game = [GameState getInstance];
        [game setLife:[STARTING_LIFE intValue]];
        
        [self _setUpBLEBroadcaster];
        [self _setUpBLEListener];
    }
    
    return self;
}

#pragma mark Private methods

-(void)_setUpBLEBroadcaster
{
    self.periphManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
}

-(void)_setUpBLEListener
{
    self.locManager = [CLLocationManager new];
    self.locManager.delegate = self;
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:UUID];;
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                identifier:PHONE_IDENTIFIER];
    
    if ([CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
        [self.locManager startMonitoringForRegion:region];
        [self.locManager startRangingBeaconsInRegion:region];
    } else
        [self _passAlongError:bluetoothError withSpecifications:@"Bluetooth connectivity not available on this device."];
    
    NSLog(@"listening...");
    
}

-(void)_passAlongError:(HardwareError)error withSpecifications:(NSString *)specifications
{
    NSString *errorSpecificText;
    switch (error) {
        case myoError:
            errorSpecificText = @"Myo armband";
            break;
        case pebbleError:
            errorSpecificText = @"Pebble wristwatch";
            break;
        case bluetoothError:
            errorSpecificText = @"iOS device bluetooth connection";
        default:
            break;
    }
    
    if (![specifications isEqual:@""])
        errorSpecificText = [NSString stringWithFormat:@"%@: %@",errorSpecificText,specifications];
    
    [self.view broadcastError:[NSString stringWithFormat:@"There appears to be an issue with your %@ Please retry.",errorSpecificText]];
}

#pragma mark MyoActionHandler delegate methods

-(void)broadcastFightMove:(FightMove *)move
{
    NSLog(@"broadcasting fight move!");
    if (move.movement != PALM_GESTURE) { // TODO: this should be "block gesture"!
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:UUID];
        CLBeaconRegion *fightRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                              major:move.damage
                                                                              minor:self.numAttacks
                                                                         identifier:PHONE_IDENTIFIER];
        [self.periphManager stopAdvertising];
        [self.periphManager startAdvertising:[fightRegion peripheralDataWithMeasuredPower:nil]];
        ++self.numAttacks;
        
        GameState *game = [GameState getInstance];
        game.damageDealt += move.damage;
        game.lastDamageDealt = move.damage;
        
        // TODO: send Myo / Pebble the signal to vibrate
    }
    
}

-(void)_broadcastBlockedMove
{
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:UUID];
    CLBeaconRegion *fightRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                          major:0
                                                                          minor:-1
                                                                     identifier:PHONE_IDENTIFIER];
    [self.periphManager stopAdvertising];
    [self.periphManager startAdvertising:[fightRegion peripheralDataWithMeasuredPower:nil]];
}

-(void)myoDidConnect
{
    self.myoConnected = YES;
    return;
}

-(void)handleMyoError:(NSString *)description
{
    [self _passAlongError:myoError withSpecifications:description];
}

#pragma mark PebbleHandler delegate methods

-(void)handlePebbleError:(NSString *)description
{
    [self _passAlongError:pebbleError withSpecifications:description];
}

#pragma mark MainViewController delegate methods

-(void)beginGameWithCompletion:(void (^)(void))callbackBlock
{
    while (YES) {
        if (!(self.secondDeviceConnected && self.myoConnected && self.pebbleConnected)) {
            sleep(5);
            continue;
        }
        
        callbackBlock();
        return;
    }
    
}

#pragma mark CBPeripheralManager delegate methods

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    if (peripheral.state != CBPeripheralManagerStatePoweredOn)
        return;
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:UUID];
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                           major:0
                                                                           minor:0
                                                                      identifier:PHONE_IDENTIFIER];
    
    NSDictionary *beaconInfo = [beaconRegion peripheralDataWithMeasuredPower:nil];
    
    [self.periphManager startAdvertising:beaconInfo];
}

#pragma mark CLLocationManager delegate methods

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if ([beacons count] > 0){
        CLBeacon *beacon = [beacons objectAtIndex:0];
        
        NSNumber *damage = beacon.major;
        
        GameState *game = [GameState getInstance];
        
        if (([damage intValue] == 0) &&
            !self.secondDeviceConnected) {
            self.secondDeviceConnected = YES;
        
        } else if ([beacon.minor intValue] == -1) {
            game.damageDealt -= game.lastDamageDealt;
            game.lastDamageDealt = 0;
        
        } else if (!([self.attacksSoFar containsObject:beacon.minor]) &&
                 !game.isBlocking) {
            [self.attacksSoFar addObject:beacon.minor];
            [self.view displayUserDamage:[beacon.major intValue]];
            
            game.damageDealt += [damage intValue];
            game.lastDamageDealt = [damage intValue];
            
            // pass damage along to pebble!
            
        } else if (!([self.attacksSoFar containsObject:beacon.minor]) && game.isBlocking) {
            [self _broadcastBlockedMove];
            
        }
        
        // otherwise this is a "stale" attack and we do nothing.
    }
}


@end
