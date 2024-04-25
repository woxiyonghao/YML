//
//  ESSampleHandlerClientSocketManager.h
//  Eggshell
//
//  Created by leslie lee on 2022/11/21.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
NS_ASSUME_NONNULL_BEGIN

typedef void(^GetBufferBlock) (CMSampleBufferRef sampleBuffer);

@interface ESSampleHandlerClientSocketManager : NSObject
+ (ESSampleHandlerClientSocketManager *)sharedManager;
- (void)stopSocket;
- (void)setupSocket;
@property(nonatomic, copy) GetBufferBlock getBufferBlock;

@end

NS_ASSUME_NONNULL_END
