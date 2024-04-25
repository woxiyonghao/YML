//
//  UIColor+Hex.h
//  NewRidesBike
//
//  Created by 骠骑 on 2020/3/31.
//  Copyright © 2020 骠骑. All rights reserved.
//
#import <UIKit/UIKit.h>


/**
 渐变方式

 - IHGradientChangeDirectionLevel:              水平渐变
 - IHGradientChangeDirectionVertical:           竖直渐变
 - IHGradientChangeDirectionUpwardDiagonalLine: 向下对角线渐变
 - IHGradientChangeDirectionDownDiagonalLine:   向上对角线渐变
 */
typedef NS_ENUM(NSInteger, IHGradientChangeDirection) {
    IHGradientChangeDirectionLevel,
    IHGradientChangeDirectionVertical,
    IHGradientChangeDirectionUpwardDiagonalLine,
    IHGradientChangeDirectionDownDiagonalLine,
};


NS_ASSUME_NONNULL_BEGIN

//  safeepay-ios-new
//
//  Created by xzf on 2017/8/24.
//  Copyright © 2017年 com.app.huakala. All rights reserved.
//


@interface UIColor (Hex)

/**
 透明度固定为1，以0x开头的十六进制转换成的颜色

 @param hexColor 颜色
 @return 系统能识别的颜色
 */
+ (UIColor *)colorWithHex:(long)hexColor;

/**
 0x开头的十六进制转换成的颜色,透明度可调整

 @param hexColor 颜色
 @param opacity 透明度
 @return 系统能识别的颜色
 */
+ (UIColor *)colorwihthHex:(long)hexColor alpha:(float)opacity;

/**
 颜色转换三：iOS中十六进制的颜色（以#开头）转换为UIColor

 @param color 十六进制的颜色
 @return 系统能识别的颜色
 */
+ (UIColor *)colorwithHexString:(NSString *)color;

- (NSString *)HEXString;

+ (UIColor *)colorWithHexString:(NSString *)hexString;

UIColor * COLORHEX(NSString *stringToConvert);

UIColor * COLORHEXALPHA(NSString *stringToConvert,CGFloat alpha);

+ (instancetype)bm_colorGradientChangeWithSize:(CGSize)size
                                     direction:(IHGradientChangeDirection)direction
                                    startColor:(UIColor *)startcolor
                                      endColor:(UIColor *)endColor ;

@end

NS_ASSUME_NONNULL_END


