//
//  GameSirBeyond-Bridging-Header.h
//  GameSirBeyond
//
//  Created by leslie lee on 2024/3/7.
//

//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//   swift 调用oc类  在下面添加oc的.h文件名

#ifndef Header_h
#define Header_h

// Lightning数据交互
#import "EADSessionController.h"

// 手柄管理：按键监测等
#import "GSGameController.h"
#import "GSGameControllerManager.h"

#import "GSDataTool.h"

#if (TARGET_IPHONE_SIMULATOR)
// 在模拟器的情况下
#else
// 在真机情况下
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#endif

#import "YYText.h"

#import "MBProgressHUD+Util.h"
#import "SAMKeychain.h"// 钥匙串管理
#import "UINavigationController+FDFullscreenPopGesture.h"// 隐藏导航栏
#import "UIColor+Hex.h"
#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import "UIViewController+YCPopover.h"
/** 以下库只在真机环境下使用
 真机环境下取消注释
 模拟器环境下需注释
 */

#import "ESSampleHandlerClientSocketManager.h"
#import "ESSampleHandlerSocketManager.h"
#import "NTESYUVConverter.h"
//#import "SMS_SDK/SMSSDK.h"
//#import <MOBFoundation/MobSDK+Privacy.h>


#endif /* Header_h */
