//
//  MBProgressHUD+Util.h
//  Dylib
//
//  Created by Xiaoji on 2017/2/28.
//  Copyright © 2017年 xugelei. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Util)

// 普通文本
+ (void)showMsgIn:(UIView *_Nonnull)view text:(NSString *_Nonnull)text;
+ (void)showMsgWithtext:(NSString *_Nonnull)text;
+ (void)showMsgWithtext:(NSString *_Nonnull)text afterDelay:(NSTimeInterval)afterDelay;
+ (void)showMsgIn:(UIView *_Nonnull)view text:(NSString *_Nonnull)text afterDelay:(NSTimeInterval)afterDelay;
    
// 富文本
+ (void)showMsgIn:(UIView *_Nonnull)view atbText:(NSMutableAttributedString *_Nonnull)atbText;
+ (void)showMsgIn:(UIView *_Nonnull)view atbText:(NSMutableAttributedString *_Nonnull)atbText afterDelay:(NSTimeInterval)afterDelay;

// 等待
+ (void)showWaitingViewAfterDelay:(NSTimeInterval)afterDelay;
+ (instancetype _Nonnull )showActivityLoading:(nullable NSString *)message toView:(nullable UIView *)view;
+ (instancetype _Nonnull)showActivityLoading:(nullable NSString *)message;

+ (void)showActivityLoading:(nullable NSString *)message afterDelay:(NSTimeInterval)afterDelay;
    
@end
