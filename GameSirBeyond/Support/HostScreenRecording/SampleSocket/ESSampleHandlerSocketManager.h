//
//  ESSampleHandlerSocketManager.h
//  Eggshell
//
//  Created by leslie lee on 2022/11/21.
//

#import <Foundation/Foundation.h>
#import <ReplayKit/ReplayKit.h>
NS_ASSUME_NONNULL_BEGIN
static int ScreenRecordTime = 0;
@interface ESSampleHandlerSocketManager : NSObject
+ (ESSampleHandlerSocketManager *)sharedManager;
- (void)setUpSocket;
- (void)socketDelloc;
- (void)sendVideoBufferToHostApp:(CMSampleBufferRef)sampleBuffer;
- (long)getCurUsedMemory;
@end

NS_ASSUME_NONNULL_END
