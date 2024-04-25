//
//  GSDataTool.h
//  GameSirOTA
//
//  Created by 刘富铭 on 2020/2/14.
//  Copyright © 2020 Guangzhou Xiaojikuaipao Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSDataTool : NSObject

/// 十六进制字符串转数字
+ (NSInteger)intWithHexString:(NSString *)hexString;

+ (NSString *)bigStringFromSmallString:(NSString *)string;

/// [0x01, 0x02, ...] -> @"01 02"
+ (NSString *)hexStringFromDataSeparatly:(NSData *)data;
/// [0x01, 0x02, ...] -> @"0102"
+ (NSString *)hexStringFromData:(NSData *)data;
/// @"0102" -> [0x01, 0x02, ...]
+ (NSData *)dataFromHexString:(NSString *)hexString;

+ (NSString *)bit2HexStringFromNumber:(NSUInteger)number;
+ (NSString *)bit8HexStringFromInt:(NSUInteger)number;

/// 十六进制 转 十进制
+ (NSInteger)decFromHexString:(NSString *)string;
/// 十进制 转 十六进制
+ (NSString *)hexStringFromDec:(NSInteger)dec;

// aabbccdd -> aa bb cc dd
+ (NSString *)addBlankToString:(NSString *)string;
// aa bb cc dd -> 0xaa, 0xbb, 0xcc, 0xdd
+ (NSString *)byteStringFromString:(NSString *)string;

+ (NSInteger)intFromHexString:(NSString *)str;

// 小端 -> 大端 或者 大端 -> 小端
+ (NSString *)changeSmallBigModeString:(NSString *)string;

+ (NSString *)transData2HexString:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
