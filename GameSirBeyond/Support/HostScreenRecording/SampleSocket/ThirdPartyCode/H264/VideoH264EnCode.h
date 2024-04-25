//
//  VideoH264EnCode.h
//  InteractiveScreen
//
//  Created by leslie lee on 2022/11/21.
//  
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoH264EnCode : NSObject


/**
 硬编码

 @param sampleBuffer CMSampleBufferRef每一帧原始数据
 @param h264DataBlock 十六进制数据
 */
- (void)encodeSampleBuffer:(CMSampleBufferRef)sampleBuffer
             H264DataBlock:(void (^)(NSData *data)) h264DataBlock;

/**
 结束编码
 */
- (void)endEncode;

@end

NS_ASSUME_NONNULL_END
