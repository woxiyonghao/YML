//
//  GSDataTool.m
//  GameSirOTA
//
//  Created by 刘富铭 on 2020/2/14.
//  Copyright © 2020 Guangzhou Xiaojikuaipao Network Technology Co., Ltd. All rights reserved.
//

#import "GSDataTool.h"

@implementation GSDataTool

+ (NSString *)bigStringFromSmallString:(NSString *)string {
    NSMutableArray *tmpArra = [NSMutableArray array];
    for (int i = 0; i < string.length; i += 2) {
        NSString *str = [string substringWithRange:NSMakeRange(i, 2)];
        [tmpArra addObject:str];
    }
    NSArray *lastArray = [[tmpArra reverseObjectEnumerator] allObjects];
    NSMutableString *lastStr = [NSMutableString string];
    for (NSString *str in lastArray) {
        [lastStr appendString:str];
    }
    return [lastStr copy];
}

+ (NSString *)hexStringFromDataSeparatly:(NSData *)data {
    Byte *bytes = (Byte *)[data bytes];
    NSString *hexStr = @"";
    for (NSUInteger i = 0; i < data.length; i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%x", bytes[i]&0xff];///16进制数

        if (i == data.length-1) {// 最后一个，末尾不加空格
            if ([newHexStr length] == 1) {
                hexStr = [NSString stringWithFormat:@"%@0%@", hexStr, newHexStr];
            }
            else {
                hexStr = [NSString stringWithFormat:@"%@%@", hexStr, newHexStr];
            }
        }
        else {
            if ([newHexStr length] == 1) {
                hexStr = [NSString stringWithFormat:@"%@0%@ ", hexStr, newHexStr];
            }
            else {
                hexStr = [NSString stringWithFormat:@"%@%@ ", hexStr, newHexStr];
            }
        }
        
    }
    return hexStr;
}

+ (NSString *)hexStringFromData:(NSData *)data {
    Byte *bytes = (Byte *)[data bytes];
    NSString *hexStr = @"";
    for (NSUInteger i = 0; i < data.length; i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%x", bytes[i]&0xff];///16进制数
        if ([newHexStr length] == 1) {
            hexStr = [NSString stringWithFormat:@"%@0%@", hexStr, newHexStr];
        }
        else {
            hexStr = [NSString stringWithFormat:@"%@%@", hexStr, newHexStr];
        }
    }
    return hexStr;
}

+ (NSData *)dataFromHexString:(NSString *)hexString {
    const char* buf = [hexString UTF8String];
    NSMutableData* data = [NSMutableData data];
    if (buf) {
        uint32_t len = (uint32_t)strlen(buf);
        char singleNumberString[3] = {'\0', '\0', '\0'};
        uint32_t singleNumber = 0;
        for (uint32_t i = 0; i < len; i += 2) {
            if (((i + 1) < len) && isxdigit(buf[i]) && (isxdigit(buf[i + 1]))) {
                singleNumberString[0] = buf[i];
                singleNumberString[1] = buf[i + 1];
                sscanf(singleNumberString, "%x", &singleNumber);
                uint8_t tmp = (uint8_t)(singleNumber & 0x000000FF);
                [data appendBytes:(void*)(&tmp) length:1];
            }
            else {
                break;
            }
        }
    }
    return data;
}

+ (NSString *)bit2HexStringFromNumber:(NSUInteger)number {
    NSUInteger num = number;
    num = num > 255 ? 255 : num;
    return [NSString stringWithFormat:@"%02lx", (unsigned long)num];
}

+ (NSString *)bit8HexStringFromInt:(NSUInteger )number {
    NSString *sstr = [NSString stringWithFormat:@"%08lx", (unsigned long)number];
    return [self bigStringFromSmallString:sstr];
}

/// 十六进制 转 十进制
+ (NSInteger)decFromHexString:(NSString *)string {
    return [[NSString stringWithFormat:@"%lu",strtoul([string UTF8String],0,16)] integerValue];
}

/// 十进制 转 十六进制
+ (NSString *)hexStringFromDec:(NSInteger)dec {
    NSString *letter;
    NSString *str = @"";
    int tmp;
    for (int i = 0; i<9; i++) {
        tmp = dec%16;
        dec = dec/16;
        switch (tmp) {
            case 0:
                letter = @"0";
                break;
            case 1:
                letter = @"1";
                break;
            case 2:
                letter = @"2";
                break;
            case 3:
                letter = @"3";
                break;
            case 4:
                letter = @"4";
                break;
            case 5:
                letter = @"5";
                break;
            case 6:
                letter = @"6";
                break;
            case 7:
                letter = @"7";
                break;
            case 8:
                letter = @"8";
                break;
            case 9:
                letter = @"9";
                break;
            case 10:
                letter = @"a";
                break;
            case 11:
                letter = @"b";
                break;
            case 12:
                letter = @"c";
                break;
            case 13:
                letter = @"d";
                break;
            case 14:
                letter = @"e";
                break;
            case 15:
                letter = @"f";
                break;
            default:
                break;
        }
        
        str = [letter stringByAppendingString:str];
        
        if (dec == 0) {
            break;
        }
    }
    return str;
}

// aa bb cc dd
+ (NSString *)addBlankToString:(NSString *)data {
    NSUInteger len = data.length;
    NSMutableString *str = [@"" mutableCopy];
    for (int i = 0; i < len; i++) {
        NSString *substr = @"";
        if (len % 2 == 0 ||
            (len % 2 != 0 && i != len -1)) {
            substr = [data substringWithRange:NSMakeRange(i, 2)];
        }
        else {
            substr = [data substringWithRange:NSMakeRange(i, 1)];
        }
        if ((i != len - 2) && substr.length == 2) {
            [str appendString:[NSString stringWithFormat:@"%@ ", substr]];
        }
        else {
            [str appendString:substr];
        }
        i += 1;
    }
    return str;
}

// 0xaa, 0xbb, 0xcc, 0xdd
+ (NSString *)byteStringFromString:(NSString *)data {
    NSUInteger len = data.length;
    NSMutableString *str = [@"" mutableCopy];
    for (int i = 0; i < len; i++) {
        NSString *substr = @"";
        if (len % 2 == 0 || (len % 2 != 0 && i != len -1)) {
            substr = [data substringWithRange:NSMakeRange(i, 2)];
        }
        else {
            substr = [data substringWithRange:NSMakeRange(i, 1)];
        }
        if ((i != len - 2) && substr.length == 2) {
            [str appendString:[NSString stringWithFormat:@"0x%@,", substr]];
        }
        else {
            [str appendString:[NSString stringWithFormat:@"0x%@", substr]];
        }
        i += 1;
    }
    return str;
}

+ (NSInteger)intFromHexString:(NSString *)str {
    if (str.length == 1) {
        str = [@"0" stringByAppendingString:str];
    }
    if (str.length != 2 &&
        str.length != 1) {
        return -1;
    }
    NSData *data =  [GSDataTool dataFromHexString:str];
    Byte *bytes = (Byte *)[data bytes];
    int  returnInt = bytes[0];
    return returnInt;
}

+ (NSInteger)integerFromMouseSensitivityHexByteString:(NSString *)str {
    NSString *t = [NSString stringWithFormat:@"%@", str];
    if (t.length  == 1 ) {
        t = [@"0" stringByAppendingString:t];
    }
    if (t.length > 2) {
        return 0;
    }
    NSData *data =  [GSDataTool dataFromHexString:t];
    Byte *bytes = (Byte *)[data bytes];
    int  returnInt = bytes[0];
    return returnInt;
}

+ (NSString *)changeSmallBigModeString:(NSString *)string {
    NSMutableArray *tmpArra = [NSMutableArray array];
    for (int i = 0; i < string.length; i += 2) {
        NSString *str = [string substringWithRange:NSMakeRange(i, 2)];
        [tmpArra addObject:str];
    }
    NSArray *lastArray = [[tmpArra reverseObjectEnumerator] allObjects];
    NSMutableString *lastStr = [NSMutableString string];
    for (NSString *str in lastArray) {
        [lastStr appendString:str];
    }
    return [lastStr copy];
}

+ (NSString *)jsonStringWithDict:(NSDictionary *)json_config_dict {
    if (!json_config_dict) {
        return @"";
    }
    NSError *error;
    NSString *jsonString = @"";
    if (@available(iOS 11.0, *)) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json_config_dict options:NSJSONWritingSortedKeys error:&error];
        if (!jsonData) {
            jsonString = [[NSString alloc] initWithData:[NSData data] encoding:NSUTF8StringEncoding];
        }
        else {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
    }
    else {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json_config_dict options:NSJSONWritingPrettyPrinted error:&error];
        if (!jsonData) {
            jsonString = [[NSString alloc] initWithData:[NSData data] encoding:NSUTF8StringEncoding];
        }
        else {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
    }
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
    return jsonString;
}

+ (NSString *)jsonStringWithArray:(NSArray *)array {
    NSError *error;
    NSString *jsonString = @"";
    // NSJSONWritingSortedKeys这个枚举类型只适用iOS11所以我是使用下面写法解决的
    if (@available(iOS 11.0, *)) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingSortedKeys error:&error];
        if (!jsonData) {
            jsonString = [[NSString alloc] initWithData:[NSData data] encoding:NSUTF8StringEncoding];
        }
        else {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
    }
    else {
        // Fallback on earlier versions
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
        if (!jsonData) {
            jsonString = [[NSString alloc] initWithData:[NSData data] encoding:NSUTF8StringEncoding];
        }
        else {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
    }
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //    NSLog(@"%@:\n %@",jsonString,[jsonString class]);
    return jsonString;
}


+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if (err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSInteger)intWithHexString:(NSString *)hexString {
    const char *hexChar = [hexString cStringUsingEncoding:NSUTF8StringEncoding];
    int hexNumber;
    sscanf(hexChar, "%x", &hexNumber);
    return (NSInteger)hexNumber;
}

+ (NSString *)transData2HexString:(NSData *)data {
    Byte *bytes = (Byte *)[data bytes];
    NSString *hexStr = @"";
    for (NSUInteger i = 0; i < data.length; i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%x", bytes[i]&0xff];///16进制数
        if ([newHexStr length] == 1) {
            hexStr = [NSString stringWithFormat:@"%@0%@", hexStr, newHexStr];
        }
        else {
            hexStr = [NSString stringWithFormat:@"%@%@", hexStr, newHexStr];
        }
    }
    return hexStr;
}

@end

