//
//  GSGameController.m
//  gameController
//
//  Created by César Manuel Pinto Castillo on 20/04/14.
//  Copyright (c) 2014 JagCesar. All rights reserved.
//

#import "GSGameController.h"
#import "GSGameControllerManager.h"

@interface GSGameController ()
@property (nonatomic) GCExtendedGamepad *extendedGamepad;
@end

@implementation GSGameController

- (void)setController:(GCController *)controller {
    if (_controller == controller) {
        return;
    }
    
    _controller = controller;
    
    if (controller.extendedGamepad) {
        self.extendedGamepad = controller.extendedGamepad;
        [self __setupExtendedGamepad];
    }
}

//static CGFloat oldDpadDefaultValue = -8.f;
//static CGFloat oldDpadXValue = -8.f, oldDpadYValue = -8.f;// 用于记录方向键的按下情况，初始值给-8，便于区分
static float lastLX = 0, lastLY = 0, lastRX = 0, lastRY = 0;
static float maxUp = 0, maxLeft = 0, maxDown = 0, maxRight = 0;
static float maxRightJoystickUp = 0, maxRightJoystickLeft = 0, maxRightJoystickDown = 0, maxRightJoystickRight = 0;
- (void)__setupExtendedGamepad {
    
    GCControllerButtonInput *a = [self.extendedGamepad buttonA];
    GCControllerButtonInput *b = [self.extendedGamepad buttonB];
    GCControllerButtonInput *x = [self.extendedGamepad buttonX];
    GCControllerButtonInput *y = [self.extendedGamepad buttonY];
    GCControllerButtonInput *leftShoulder  = [self.extendedGamepad leftShoulder];
    GCControllerButtonInput *leftTrigger   = [self.extendedGamepad leftTrigger];
    GCControllerButtonInput *rightShoulder = [self.extendedGamepad rightShoulder];
    GCControllerButtonInput *rightTrigger  = [self.extendedGamepad rightTrigger];

    if (@available(iOS 14.0, *)) {
        GCControllerButtonInput *home = [self.extendedGamepad buttonHome];
        // Home
        [home setValueChangedHandler:^(GCControllerButtonInput *button, float value, BOOL pressed) {
            if (GSGameControllerManager.shared.keyHomePressed) {
                GSGameControllerManager.shared.keyHomePressed(pressed);
            }
        }];
    }

    if (@available(iOS 13.0, *)) {
        GCControllerButtonInput *menu    = [self.extendedGamepad buttonMenu];
        GCControllerButtonInput *options = [self.extendedGamepad buttonOptions];
        
        // Options
        [options setValueChangedHandler:^(GCControllerButtonInput *button, float value, BOOL pressed) {
//            NSLog(@"%@ %@ %@", button, @(value), @(pressed));

            if (GSGameControllerManager.shared.keyOptionsPressed) {
                GSGameControllerManager.shared.keyOptionsPressed(pressed);
            }
        }];
        
        // Menu
        [menu setValueChangedHandler:^(GCControllerButtonInput *button, float value, BOOL pressed) {
            if (GSGameControllerManager.shared.keyMenuPressed) {
                GSGameControllerManager.shared.keyMenuPressed(pressed);
            }
        }];
    }
    
    // A
    [a setValueChangedHandler:^(GCControllerButtonInput *button, float value, BOOL pressed) {
        if (GSGameControllerManager.shared.keyAPressed) {
            GSGameControllerManager.shared.keyAPressed(pressed);
        }
    }];
    
    // B
    [b setValueChangedHandler:^(GCControllerButtonInput *button, float value, BOOL pressed) {
        if (GSGameControllerManager.shared.keyBPressed) {
            GSGameControllerManager.shared.keyBPressed(pressed);
        }
    }];
    
    // X
    [x setValueChangedHandler:^(GCControllerButtonInput *button, float value, BOOL pressed) {
        if (GSGameControllerManager.shared.keyXPressed) {
            GSGameControllerManager.shared.keyXPressed(pressed);
        }
    }];
    
    // Y
    [y setValueChangedHandler:^(GCControllerButtonInput *button, float value, BOOL pressed) {
        if (GSGameControllerManager.shared.keyYPressed) {
            GSGameControllerManager.shared.keyYPressed(pressed);
        }
    }];
    
    // L1
    [leftShoulder setValueChangedHandler:^(GCControllerButtonInput *button, float value, BOOL pressed) {
        if (GSGameControllerManager.shared.keyL1Pressed) {
            GSGameControllerManager.shared.keyL1Pressed(pressed);
        }
    }];
    
    // L2
    [leftTrigger setValueChangedHandler:^(GCControllerButtonInput *button, float value, BOOL pressed) {
//        NSLog(@"L2按压值：%f", value);
        if (GSGameControllerManager.shared.keyL2Pressed) {
            GSGameControllerManager.shared.keyL2Pressed(pressed, value);
        }
    }];
    
    // R1
    [rightShoulder setValueChangedHandler:^(GCControllerButtonInput *button, float value, BOOL pressed) {
        if (GSGameControllerManager.shared.keyR1Pressed) {
            GSGameControllerManager.shared.keyR1Pressed(pressed);
        }
    }];
    
    // R2
    [rightTrigger setValueChangedHandler:^(GCControllerButtonInput *button, float value, BOOL pressed) {
//        NSLog(@"R2按压值：%f", value);
        if (GSGameControllerManager.shared.keyR2Pressed) {
            GSGameControllerManager.shared.keyR2Pressed(pressed, value);
        }
    }];
    
    if (@available(iOS 12.1, *)) {
        GCControllerButtonInput *leftThumbstickButton  = [self.extendedGamepad leftThumbstickButton];
        GCControllerButtonInput *rightThumbstickButton = [self.extendedGamepad rightThumbstickButton];
        
        // L3
        [leftThumbstickButton setPressedChangedHandler:^(GCControllerButtonInput * _Nonnull button, float value, BOOL pressed) {
            if (GSGameControllerManager.shared.keyL3Pressed) {
                GSGameControllerManager.shared.keyL3Pressed(pressed);
            }
        }];
        
        // R3
        [rightThumbstickButton setPressedChangedHandler:^(GCControllerButtonInput * _Nonnull button, float value, BOOL pressed) {
            if (GSGameControllerManager.shared.keyR3Pressed) {
                GSGameControllerManager.shared.keyR3Pressed(pressed);
            }
        }];
    }
    
    // 方向键
    GCControllerDirectionPad *dPad = [self.extendedGamepad dpad];
    [dPad setValueChangedHandler:^(GCControllerDirectionPad *dpad, float xValue, float yValue) {
//        if (dpad.up.pressed) {
//            NSLog(@"按下UP");
//        }
//
//        if (dpad.down.pressed) {
//            NSLog(@"按下DOWN");
//        }
//
//        if (dpad.left.pressed) {
//            NSLog(@"按下LEFT");
//        }
//
//        if (dpad.right.pressed) {
//            NSLog(@"按下RIGHT");
//        }
        
        !GSGameControllerManager.shared.keyUpPressed ? : GSGameControllerManager.shared.keyUpPressed(dpad.up.pressed);
        !GSGameControllerManager.shared.keyDownPressed ? : GSGameControllerManager.shared.keyDownPressed(dpad.down.pressed);
        !GSGameControllerManager.shared.keyLeftPressed ? : GSGameControllerManager.shared.keyLeftPressed(dpad.left.pressed);
        !GSGameControllerManager.shared.keyRightPressed ? : GSGameControllerManager.shared.keyRightPressed(dpad.right.pressed);
        
        // 根据 xValue 和 yValue 判断哪个按键按下
        // 根据 xValue 和 yValue 的变化 判断哪个按键弹起
        
        /**
         第一次：1.0 0.0
         第二次：0.0 0.0
         */
        /*
        // 第一次记录值，必然是按下状态
        if (oldDpadXValue == oldDpadDefaultValue) {
            oldDpadXValue = xValue;// 1.0
        }
        
        if (oldDpadYValue == oldDpadDefaultValue) {
            oldDpadYValue = yValue;// 0.0
        }
        
        if (xValue == 0.f &&
            yValue == 0.f) {// 按键弹起
            // 取出旧值，判断哪个按键弹起
            if (oldDpadYValue == 1.f) {// ↑
                !GSGameControllerManager.shared.keyUpPressed ? : GSGameControllerManager.shared.keyUpPressed(NO);
            }
            else if (oldDpadYValue == -1.f) {// ↓
                !GSGameControllerManager.shared.keyDownPressed ? : GSGameControllerManager.shared.keyDownPressed(NO);
            }
            else if (oldDpadXValue == -1.f) {// ←
                !GSGameControllerManager.shared.keyLeftPressed ? : GSGameControllerManager.shared.keyLeftPressed(NO);
            }
            else if (oldDpadXValue == 1.f) {// →
                !GSGameControllerManager.shared.keyRightPressed ? : GSGameControllerManager.shared.keyRightPressed(NO);
            }
            
            // 重置旧值
            oldDpadXValue = oldDpadDefaultValue;
            oldDpadYValue = oldDpadDefaultValue;
        }
        else {
            if (yValue == 1.f) {// ↑
                !GSGameControllerManager.shared.keyUpPressed ? : GSGameControllerManager.shared.keyUpPressed(YES);
            }
            else if (yValue == -1.f) {// ↓
                !GSGameControllerManager.shared.keyDownPressed ? : GSGameControllerManager.shared.keyDownPressed(YES);
            }
            else if (xValue == -1.f) {// ←
                !GSGameControllerManager.shared.keyLeftPressed ? : GSGameControllerManager.shared.keyLeftPressed(YES);
            }
            else if (xValue == 1.f) {// →
                !GSGameControllerManager.shared.keyRightPressed ? : GSGameControllerManager.shared.keyRightPressed(YES);
            }
        }
        */
    }];
    
    GCControllerDirectionPad *leftThumbstick  = [self.extendedGamepad leftThumbstick];
    GCControllerDirectionPad *rightThumbstick = [self.extendedGamepad rightThumbstick];
    
    // 左摇杆
    [leftThumbstick setValueChangedHandler:^(GCControllerDirectionPad *dpad, float xValue, float yValue) {
//        NSLog(@"X: %@, Y: %@", @(xValue), @(yValue));
        !GSGameControllerManager.shared.leftJoystickChanged ? : GSGameControllerManager.shared.leftJoystickChanged(dpad, xValue, yValue);
        
//        !GSGameControllerManager.shared.leftJoystickChanged ? : GSGameControllerManager.shared.leftJoystickChanged(dpad, xValue - lastLX, yValue - lastLY);
//
//        if (xValue == 1.0) {
//            maxRight = 1.0;
//        }
//        if (xValue == -1.0) {
//            maxLeft = -1.0;
//        }
//        if (yValue == 1.0) {
//            maxUp = 1.0;
//        }
//        if (yValue == -1.0) {
//            maxDown = -1.0;
//        }
//        lastLX = xValue;
//        lastLY = yValue;
    }];
    
    // 右摇杆
    [rightThumbstick setValueChangedHandler:^(GCControllerDirectionPad *dpad, float xValue, float yValue) {
        !GSGameControllerManager.shared.rightJoystickChanged ? : GSGameControllerManager.shared.rightJoystickChanged(dpad, xValue, yValue);
        
//        !GSGameControllerManager.shared.rightJoystickChanged ? : GSGameControllerManager.shared.rightJoystickChanged(dpad, xValue - lastRX, yValue - lastRY);
//
//        if (xValue == 1.0) {
//            maxRightJoystickRight = 1.0;
//        }
//        if (xValue == -1.0) {
//            maxRightJoystickLeft = -1.0;
//        }
//        if (yValue == 1.0) {
//            maxRightJoystickUp = 1.0;
//        }
//        if (yValue == -1.0) {
//            maxRightJoystickDown = -1.0;
//        }
//        lastRX = xValue;
//        lastRY = yValue;
    }];
}

@end
