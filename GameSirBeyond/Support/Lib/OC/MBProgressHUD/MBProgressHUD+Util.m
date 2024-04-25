//
//  MBProgressHUD+Util.m
//  Dylib
//
//  Created by Xiaoji on 2017/2/28.
//  Copyright © 2017年 xugelei. All rights reserved.
//

#import "MBProgressHUD+Util.h"
// 颜色
#define UIColorFromHex(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0  alpha:1.0]

@implementation MBProgressHUD (Util)

+ (void)showMsgIn:(UIView *)view text:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:view animated:YES];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.numberOfLines = 0;
        hud.label.text = text;
        hud.userInteractionEnabled = NO;
        hud.bezelView.color = UIColorFromHex(0x2d2d2d);
        [hud hideAnimated:YES afterDelay:1.5];
    });
}

+ (void)showMsgWithtext:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:[MBProgressHUD getKeyWindow] animated:YES];

        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[MBProgressHUD getKeyWindow] animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.numberOfLines = 0;
        hud.label.text = text;
        hud.userInteractionEnabled = NO;
        hud.bezelView.color = UIColorFromHex(0x2d2d2d);
        [hud hideAnimated:YES afterDelay:1.5];
    });
}

+ (void)showMsgWithtext:(NSString *)text afterDelay:(NSTimeInterval)afterDelay {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:[MBProgressHUD getKeyWindow] animated:YES];

        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[MBProgressHUD getKeyWindow] animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.numberOfLines = 0;
        hud.label.text = text;
        hud.userInteractionEnabled = NO;
        hud.bezelView.color = UIColorFromHex(0x2d2d2d);
        [hud hideAnimated:YES afterDelay:afterDelay];
    });
}

+ (void)showMsgIn:(UIView *)view text:(NSString *)text afterDelay:(NSTimeInterval)afterDelay {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:view animated:YES];

        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = text;
        hud.label.numberOfLines = 0;
        // 提示文字的颜色
        hud.label.textColor = [UIColor whiteColor];
        hud.userInteractionEnabled = NO;
        hud.bezelView.color = UIColorFromHex(0x2d2d2d);
        [hud hideAnimated:YES afterDelay:afterDelay];
    });
}

+ (void)showWaitingViewAfterDelay:(NSTimeInterval)afterDelay {
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[MBProgressHUD getKeyWindow] animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.userInteractionEnabled = NO;
        [hud hideAnimated:YES afterDelay:afterDelay];
    });
}

+ (void)showMsgIn:(UIView *)view atbText:(NSMutableAttributedString *)atbText {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:view animated:YES];

        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.attributedText = atbText;
        hud.label.numberOfLines = 0;
        hud.userInteractionEnabled = NO;
        hud.bezelView.color = UIColorFromHex(0x2d2d2d);
        [hud hideAnimated:YES afterDelay:1.5];
    });
}

+ (void)showMsgIn:(UIView *)view atbText:(NSMutableAttributedString *)atbText afterDelay:(NSTimeInterval)afterDelay {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:view animated:YES];

        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.attributedText = atbText;
        hud.label.numberOfLines = 0;
        hud.userInteractionEnabled = NO;
        hud.bezelView.color = UIColorFromHex(0x2d2d2d);
        [hud hideAnimated:YES afterDelay:afterDelay];
    });
}

+ (instancetype)showActivityLoading:(nullable NSString *)message toView:(nullable UIView *)view {
    if (view == nil) {
        return nil;
    }
    
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    // 默认
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.userInteractionEnabled = NO;

    if (message) {
        hud.label.text = message;
    }
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

+ (instancetype)showActivityLoading:(nullable NSString *)message {
    return [self showActivityLoading:message toView:[MBProgressHUD getKeyWindow]];
}

+ (void)showActivityLoading:(nullable NSString *)message afterDelay:(NSTimeInterval)afterDelay {
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[MBProgressHUD getKeyWindow] animated:YES];
        // 默认
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.label.text = message;
        hud.label.numberOfLines = 0;
        hud.userInteractionEnabled = NO;
        hud.bezelView.color = UIColorFromHex(0x2d2d2d);
        [hud hideAnimated:YES afterDelay:afterDelay];
    });
}

//+ (UIWindow *)getKeyWindow {
//    for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) {
//        if (windowScene.activationState == UISceneActivationStateForegroundActive) {
//            for (UIWindow *window in windowScene.windows) {
//                if (window.isKeyWindow) {
//                    return window;
//                    break;
//                }
//            }
//        }
//    }
//    return nil;
//}

+ (nullable UIWindow*)getKeyWindow {
    UIWindow *foundWindow = nil;
    NSArray  *windows = [[UIApplication sharedApplication] windows];
    for (UIWindow *window in windows) {
        if (window.isKeyWindow) {
            foundWindow = window;
            break;
        }
    }
    return foundWindow;
}

@end
