//
//  GSGameControllerManager.h
//  gameController
//
//  Created by César Manuel Pinto Castillo on 02/05/14.
//  Copyright (c) 2014 JagCesar. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GSGameController;
@class GCControllerDirectionPad;

@protocol GSGameControllerConnectDelegate <NSObject>
@optional
- (void)didConnectController:(GSGameController *)gameController;
- (void)didDisconnectController:(GSGameController *)gameController;
@end

typedef void (^GSGamepadKeyPressedBlock)(BOOL pressed);
typedef void (^GSGamepadKeyValueChangedBlock)(BOOL pressed, float value);
typedef void (^GSGamepadJoystickChangedBlock)(GCControllerDirectionPad *dpad, float x, float y);
@interface GSGameControllerManager : NSObject

@property (nonatomic, assign) id <GSGameControllerConnectDelegate> connectDelegate;
@property (nonatomic, copy) GSGamepadKeyPressedBlock keyAPressed, keyBPressed, keyXPressed, keyYPressed;
@property (nonatomic, copy) GSGamepadKeyPressedBlock keyL1Pressed, keyL3Pressed, keyR1Pressed, keyR3Pressed;
@property (nonatomic, copy) GSGamepadKeyValueChangedBlock keyL2Pressed, keyR2Pressed;
@property (nonatomic, copy) GSGamepadKeyPressedBlock keyUpPressed, keyDownPressed, keyLeftPressed, keyRightPressed;
@property (nonatomic, copy) GSGamepadKeyPressedBlock keyHomePressed, keyMenuPressed, keyOptionsPressed;
@property (nonatomic, copy) GSGamepadJoystickChangedBlock leftJoystickChanged, rightJoystickChanged;

+ (instancetype)shared;

- (NSArray *)connectedGameControllers;

@end
