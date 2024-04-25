//
//  GSAuthTool.swift
//  GameSirBeyond
//
//  Created by lu on 2024/3/25.
//

import UIKit
import Photos
class GSAuthTool: NSObject {
   static func checkPushNotificationAuthorization(_ block: @escaping (Bool) -> Void) {
       if #available(iOS 10.0, *) {
           UNUserNotificationCenter.current().getNotificationSettings { settings in
               let result = {
                   switch settings.authorizationStatus {
                   case .authorized:
                       return true
                   default:
                       return false
                   }
               }()
               DispatchQueue.main.async {
                   block(result)
               }
           }
       } else {
           let setting = UIApplication.shared.currentUserNotificationSettings
           let bl = setting?.types.isEmpty ?? true
           block(!bl)
       }
   }
   //跳转app设置
    static func openAppSysSetting() {
       guard let url = URL(string: UIApplication.openSettingsURLString),
             UIApplication.shared.canOpenURL(url) else {
           //Toast.show("无法打开系统设置")
           print("无法打开系统设置")
           return
       }
       if #available(iOS 10.0, *) {
           UIApplication.shared.open(url, options: [:], completionHandler: nil)
       } else {
           UIApplication.shared.openURL(url)
       }
   }
    
    
    static func checkPhotoLibraryPermission(_ block: @escaping (Int) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .notDetermined:
            // 权限尚未请求，请求权限
            PHPhotoLibrary.requestAuthorization { (newStatus) in
                if newStatus == .authorized {
                    // 用户已授权访问相册
                    print("相册访问权限已授权")
                    DispatchQueue.main.async {
                        block(1)
                    }
                } else {
                    // 用户拒绝访问相册或者访问相册被限制
                    print("相册访问权限被拒绝或限制")
                    DispatchQueue.main.async {
                        block(2)
                    }
                }
            }
        case .restricted, .denied:
            // 访问相册受限或被拒绝
            print("相册访问权限受限或被拒绝")
            DispatchQueue.main.async {
                block(2)
            }
        case .authorized:
            // 已授权访问相册
            print("相册访问权限已授权")
            DispatchQueue.main.async {
                block(1)
            }
        @unknown default:
            // 未知状态
            print("未知相册访问权限状态")
            DispatchQueue.main.async {
                block(0)
            }
        }
    }
    
    
    
    static func readUNUserNotificationCenterState(){
        // 如果需要，可以获取已授权的通知设置
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("通知设置：\(settings.authorizationStatus)")
            var ifNeedNoti = UserDefaultWrapper<Int?>(key: UserDefaultKeys.ifNeedNoti)
            if settings.authorizationStatus == .authorized {
                ifNeedNoti.wrappedValue = 1
            }
            else if settings.authorizationStatus == .denied {
                ifNeedNoti.wrappedValue = 2
            }
            else{
                ifNeedNoti.wrappedValue = 0
            }
        }
    }

    
    static func readPhotoLibraryPermission(){
        var ifNeedLibrary = UserDefaultWrapper<Int?>(key: UserDefaultKeys.ifNeedLibrary)
        let status = PHPhotoLibrary.authorizationStatus()
        print("相册权限：\(status)")
        switch status {
        case .notDetermined:
            ifNeedLibrary.wrappedValue = 0
        case .restricted, .denied:
            // 访问相册受限或被拒绝
            ifNeedLibrary.wrappedValue = 2
        case .authorized:
            // 已授权访问相册
            ifNeedLibrary.wrappedValue = 1
        case .limited:
            ifNeedLibrary.wrappedValue = 0
        @unknown default:
            // 未知状态
            ifNeedLibrary.wrappedValue = 0
        }
        
    }
}
