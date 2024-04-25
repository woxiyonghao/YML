//
//  GSGameControllerManager.m
//  gameController
//
//  Created by César Manuel Pinto Castillo on 02/05/14.
//  Copyright (c) 2014 JagCesar. All rights reserved.
//

#import "GSGameControllerManager.h"
#import "GSGameController.h"

@implementation GSGameControllerManager

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static GSGameControllerManager *shared;
    dispatch_once(&onceToken, ^{
        shared = [GSGameControllerManager new];
        
        // 监听手柄连接
        [[NSNotificationCenter defaultCenter] addObserver:shared
                                                 selector:@selector(gameControllerConnected:)
                                                     name:GCControllerDidConnectNotification
                                                   object:nil];
        // 监听手柄断开
        [[NSNotificationCenter defaultCenter] addObserver:shared
                                                 selector:@selector(gameControllerDisconnected:)
                                                     name:GCControllerDidDisconnectNotification
                                                   object:nil];
    });
    return shared;
}

- (NSArray *)connectedGameControllers {
    return [GCController controllers];
}

#pragma mark - Private functions
- (void)gameControllerConnected:(NSNotification *)notification {
    GCController *controller = notification.object;
    if ([controller playerIndex] == -1) {
        [controller setPlayerIndex:[[self connectedGameControllers] count]-1];
    }
    
    GSGameController *gameController = [GSGameController new];
    gameController.controller = controller;
    
    // 注释原因：此处不对连接的手柄进行限制
    // 只处理Xbox、PS5、iVAST（Lightning）三种手柄
    //    NSString *controllerName = controller.vendorName.lowercaseString;
    //    if (controllerName == nil) {
    //        controllerName = controller.productCategory.lowercaseString;
    //    }
    
    //    if ([controllerName containsString:@"xbox"] ||
    //        [controllerName containsString:@"dualsense"] ||// PS5手柄蓝牙连接时的名称
    //        [controllerName containsString:@"wireless controller"] ||// PS5手柄有线连接时的名称
    //        [controllerName containsString:@"0"]) {// 0表示没有手柄名称，包括：Lightning手柄、其他
    if ([self.connectDelegate respondsToSelector:@selector(didConnectController:)]) {
        [self.connectDelegate didConnectController:gameController];
    }
    //    }
}

- (void)gameControllerDisconnected:(NSNotification *)notification {
    GCController *controller = notification.object;
    GSGameController *gameController = [GSGameController new];
    gameController.controller = controller;
    
    if ([self.connectDelegate respondsToSelector:@selector(didDisconnectController:)]) {
        [self.connectDelegate didDisconnectController:gameController];
    }
}

@end
