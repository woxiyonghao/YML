//
//  UIViewController+YCPopover.m
//  YCTransitionAnimation
//
//  Created by 蔡亚超 on 2018/5/17.
//  Copyright © 2018年 WellsCai. All rights reserved.
//

#import "UIViewController+YCPopover.h"
#import <objc/runtime.h>

static const char popoverAnimatorKey;

@implementation UIViewController (YCPopover)

- (YCPopoverAnimator *)popoverAnimator{
    return objc_getAssociatedObject(self, &popoverAnimatorKey);
}
- (void)setPopoverAnimator:(YCPopoverAnimator *)popoverAnimator{
    objc_setAssociatedObject(self, &popoverAnimatorKey, popoverAnimator, OBJC_ASSOCIATION_RETAIN) ;
}

- (BOOL)isDisable {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setIsDisable:(BOOL)disabled {
    objc_setAssociatedObject(self, @selector(isDisable), @(disabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)yc_bottomPresentController:(UIViewController *)vc presentedHeight:(CGFloat)height completeHandle:(YCCompleteHandle)completion{
    self.popoverAnimator = [YCPopoverAnimator popoverAnimatorWithStyle:YCPopoverTypeActionSheet completeHandle:completion];
    
    vc.modalPresentationStyle = UIModalPresentationCustom;
    __weak typeof(self.popoverAnimator) weakObj = self.popoverAnimator;
    vc.transitioningDelegate = weakObj;
    [self.popoverAnimator setBottomViewHeight:height];
    [self.popoverAnimator setGestureEnbel:self.isDisable];
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)yc_centerPresentController:(UIViewController *)vc presentedSize:(CGSize)size completeHandle:(YCCompleteHandle)completion{
    self.popoverAnimator = [YCPopoverAnimator popoverAnimatorWithStyle:YCPopoverTypeAlert completeHandle:completion];
    [self.popoverAnimator setCenterViewSize:size];
    
    vc.modalPresentationStyle = UIModalPresentationCustom;
    __weak typeof(self.popoverAnimator) weakObj = self.popoverAnimator;
    vc.transitioningDelegate = weakObj;
    [self.popoverAnimator setGestureEnbel:self.isDisable];
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (BOOL)willDealloc {
    return NO;
}

@end
