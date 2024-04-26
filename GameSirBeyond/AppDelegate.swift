//
//  AppDelegate.swift
//  GameSirBeyond
//
//  Created by 刘富铭 on 2024/2/29.
//

import UIKit
import Moya
import SwiftyJSON
import GameController
import ReplayKit
import Photos
import UserNotifications
//import SwiftVideoBackground
import Alamofire
import ZIPFoundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import RxSwift
import RxCocoa
import ExternalAccessory
//#if !DEBUG
//import NIMSDK
//#endif

enum NetworkErrorType: Int {
    case NeedLogin = 401
}

enum ControllerABXYLayout: Int {
    case MFi = 0
    case Switch = 1
}

enum ControllerNotificationName: String {
    case LeftJoystickMoveLeft   = "LeftJoystickMoveLeft"
    case LeftJoystickMoveRight  = "LeftJoystickMoveRight"
    case LeftJoystickMoveUp     = "LeftJoystickMoveUp"
    case LeftJoystickMoveDown   = "LeftJoystickMoveDown"
    case KeyAPressed            = "KeyAPressed"
    case KeyBPressed            = "KeyBPressed"
    case KeyXPressed            = "KeyXPressed"
    case KeyYPressed            = "KeyYPressed"
    case KeyMenuPressed         = "KeyMenuPressed"
    
    case KeyMenuPressIn         = "KeyMenuPressIn"
    case KeyMenuPressOut         = "KeyMenuPressOut"
    
    case KeyLTPressed            = "KeyLTPressed"
    case KeyLBPressed            = "KeyLBPressed"
    case KeyRTPressed            = "KeyRTPressed"
    case KeyRBPressed            = "KeyRBPressed"
    
    case KeyL3Pressed            = "KeyL3Pressed"
    case KeyR3Pressed            = "KeyR3Pressed"
    
    case KeyOPPressed            = "KeyOPPressed"
    
    case KeyScreenshotPressed   = "KeyScreenshotPressed"
    case KeyHomePressed         = "KeyHomePressed"
    
    
    
    case KeyAPressIn             = "KeyAPressIn"
    case KeyAPressOut            = "KeyAPressOut"
    case KeyBPressIn             = "KeyBPressIn"
    case KeyBPressOut            = "KeyBPressOut"
}

/**
 真机环境下需添加代理方法：, NIMLoginManagerDelegate
 模拟器环境下需移除代理方法：, NIMLoginManagerDelegate
 */
@main
class AppDelegate: UIResponder, UIApplicationDelegate, GSGameControllerConnectDelegate, UNUserNotificationCenterDelegate {
    
    let userDidFinishGettingStarted = "UserDidFinishGettingStarted"
    
    /// 注册通知回调，使用完毕设置为 {(result:Bool) in}
    var registerForRemoteNotificationHandler = {(result:Bool) in}
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        FirebaseApp.configure()
        
        setControllerName(name: "")
        
        IQKeyboardManager.shared.enable = true// 键盘管理
        observeGamepadNotification()
        
//        let isLoggedIn = getUserInfo().count > 0
//        if isLoggedIn {// 需要登录才能使用的功能
            doLoggedInFunction()
//        }
        
        if UserDefaults.standard.object(forKey: "TokenScreenshotDatesKey") == nil {
            UserDefaults.standard.set([], forKey: "TokenScreenshotDatesKey")
        }
        
        // 登录成功，刷新IM、游戏数据、设备Token等信息
        NotificationCenter.default.addObserver(forName: Notification.Name("UserDidLoginNotification"), object: nil, queue: OperationQueue.main) { notification in
            self.doLoggedInFunction()
        }
        
        // 退出账号/账号被顶后，回退到引导页面
        NotificationCenter.default.addObserver(forName: Notification.Name("UserDidLogoutNotification"), object: nil, queue: OperationQueue.main) { [weak self] notification in
            /*  原本的代码
            removeUserInfo()
            
            let window = UIApplication.shared.windows.first
//            let gettingStartedPage = GettingStartedViewController.init()
        
            window?.backgroundColor = .white
            window?.rootViewController = UIViewController()
            
            appRemoveVideoPlayer()
            self.logoutNetWork()
             */
            guard let `self` = self else { return }
            removeUserInfo()
            appRemoveVideoPlayer()
            self.logoutNetWork()
        }
        
        //        NotificationCenter.default.addObserver(forName: Notification.Name("ShowGamePageNotification"), object: nil, queue: OperationQueue.main) { notification in
        //            if UIViewController.current() is GameViewController {
        //                return
        //            }
        //
        //            let window = UIApplication.shared.windows.first
        //            let homePage = GameViewController.init()
        //            let naviPage = UINavigationController.init(rootViewController: homePage)
        //            window?.backgroundColor = .white
        //            window?.rootViewController = naviPage
        //        }
        
        //        NotificationCenter.default.addObserver(forName: Notification.Name("ShowGamepadPageNotification"), object: nil, queue: OperationQueue.main) { notification in
        //            blockVideo()
        //
        //            let window = UIApplication.shared.windows.first
        //            let homePage = GSWNewPersonalViewController.init()
        //            let naviPage = UINavigationController.init(rootViewController: homePage)
        //            window?.backgroundColor = .white
        //            window?.rootViewController = naviPage
        //        }
#if DEBUG// 在RELEASE模式下会报错，无法编译
        Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")?.load()
#endif
        return true
    }
    
    func doLoggedInFunction() {
        downloadGameCoversInAdvance()
        requestGamePlatforms()
//        checkToken()
//        refreshUserInfo()
//        setupInitNIMSDK()
//        requestNotificationAuthorization()// 延迟操作，当打开Menu页面时请求。以免影响MFi模式切换弹窗的显示，原因：UIViewControll.current()为nil
        
        delay(interval: 2) {
            requestGamePlatforms()
            requestAllGames()
        }
    }
    
    func observeGamepadNotification() {
        supportLightnings = Bundle.main.object(forInfoDictionaryKey: "UISupportedExternalAccessoryProtocols") as! [String]
        // 监听手柄的连接和断开
//        NotificationCenter.default.addObserver(self, selector: #selector(didConnectAccessory(notification:)), name:NSNotification.Name.EAAccessoryDidConnect , object: nil)// 连上手柄后，再启动App，不会触发EAAccessoryDidConnect
//        NotificationCenter.default.addObserver(self, selector: #selector(didDisconnectAccessory(notification:)), name:NSNotification.Name.EAAccessoryDidDisconnect , object: nil)
        GSGameControllerManager.shared().connectDelegate = self// 连上手柄后，再启动App，会触发GCControllerDidConnectNotification
        
        // 监听手柄按键动作
        observeGamepadKey()
        
        EAAccessoryManager.shared().registerForLocalNotifications()
        // 监听手柄传来的数据
        NotificationCenter.default.addObserver(self, selector: #selector(receiveGamepadData(notification:)), name: NSNotification.Name.EADSessionDataReceived, object: nil)
        
        
        // 监听系统截图动作
        NotificationCenter.default.addObserver(self, selector: #selector(didTakeScreenshot), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
    }
    
    @objc func didTakeScreenshot() {
        delay(interval: 2) {// 需延迟一定时间后再获取截图，如果时间过短，截图可能还没有保存到相册，导致获取失败
            self.saveSpecifiedTimeScreenshot()
        }
    }
    
    var joystickOriginalAngle: Float = -888
    var lastLeftJoystickAngle: Float = -888
    var lastRightJoystickAngle: Float = -888
    
    // MARK: 手柄按键监听
    func observeGamepadKey() {
        GSGameControllerManager.shared().keyAPressed = { pressed in
            if pressed {
                print("按下A键")
                if isMFiLayout() {
                    NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyAPressed.rawValue), object: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyAPressIn.rawValue), object: nil)
                    
                }
                else {
                    NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyBPressed.rawValue), object: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyBPressIn.rawValue), object: nil)
                }
            }
            else {
                if isMFiLayout() {
                    NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyAPressOut.rawValue), object: nil)
                }else {
                    NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyBPressOut.rawValue), object: nil)
                }
                
                print("松开A键")
            }
        }
        
        GSGameControllerManager.shared().keyBPressed = { pressed in
            if pressed {
                print("按下B键")
                // 如果使用非默认的ABXY模式，则发送A键通知
                if isMFiLayout() {
                    NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyBPressIn.rawValue), object: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyBPressed.rawValue), object: nil)
                }
                else {
                    NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyAPressIn.rawValue), object: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyAPressed.rawValue), object: nil)
                }
            }
            else {
                if isMFiLayout() {
                    NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyBPressOut.rawValue), object: nil)
                }
                else {
                    NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyAPressOut.rawValue), object: nil)
                }
                print("松开B键")
            }
        }
        
        GSGameControllerManager.shared().keyXPressed = { pressed in
            if pressed {
                print("按下X键")
                if isMFiLayout() {
                    NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyXPressed.rawValue), object: nil)
                }
                else {
                    NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyYPressed.rawValue), object: nil)
                }
            }
            else {
                print("松开X键")
            }
        }
        
        GSGameControllerManager.shared().keyYPressed = { pressed in
            if pressed {
                print("按下Y键")
                if isMFiLayout() {
                    NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyYPressed.rawValue), object: nil)
                }
                else {
                    NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyXPressed.rawValue), object: nil)
                }
            }
            else {
                print("松开Y键")
            }
        }
        
        GSGameControllerManager.shared().keyL1Pressed = { pressed in
            if pressed {
                print("按下L1键")
            }
            else {
                print("松开L1键")
                NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyLTPressed.rawValue), object: nil)
            }
        }
        
        GSGameControllerManager.shared().keyL2Pressed = { pressed, value in
            if pressed {
                print("按下L2键，按压值：", value)
            }
            else {
                print("松开L2键，按压值：", value)
                NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyLBPressed.rawValue), object: nil)
            }
        }
        
        GSGameControllerManager.shared().keyL3Pressed = { pressed in
            if pressed {
                print("按下L3键")
            }
            else {
                print("松开L3键")
                NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyL3Pressed.rawValue), object: nil)
            }
        }
        
        GSGameControllerManager.shared().keyR1Pressed = { pressed in
            if pressed {
                print("按下R1键")
            }
            else {
                print("松开R1键")
                NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyRTPressed.rawValue), object: nil)
            }
        }
        
        GSGameControllerManager.shared().keyR2Pressed = { pressed, value in
            if pressed {
                print("按下R2键，按压值：", value)
            }
            else {
                print("松开R2键，按压值：", value)
                NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyRBPressed.rawValue), object: nil)
            }
        }
        
        GSGameControllerManager.shared().keyR3Pressed = { pressed in
            if pressed {
                print("按下R3键")
            }
            else {
                print("松开R3键")
                NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyR3Pressed.rawValue), object: nil)
            }
        }
        
        GSGameControllerManager.shared().keyUpPressed = { pressed in
            if pressed {
                print("按下Up键")
                NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.LeftJoystickMoveUp.rawValue), object: nil)
            }
            else {
                //print("松开Up键")
            }
        }
        
        GSGameControllerManager.shared().keyDownPressed = { pressed in
            if pressed {
                print("按下Down键")
                NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.LeftJoystickMoveDown.rawValue), object: nil)
            }
            else {
                //print("松开Down键")
            }
        }
        
        GSGameControllerManager.shared().keyLeftPressed = { pressed in
            if pressed {
                print("按下Left键")
                NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.LeftJoystickMoveLeft.rawValue), object: nil)
            }
            else {
                //print("松开Left键")
            }
        }
        
        GSGameControllerManager.shared().keyRightPressed = { pressed in
            if pressed {
                print("按下Right键")
                NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.LeftJoystickMoveRight.rawValue), object: nil)
            }
            else {
                //print("松开Right键")
            }
        }
        
        GSGameControllerManager.shared().leftJoystickChanged = { dpad, x, y in
            //            print("左摇杆数据：", x, y)
            if x == 0.0 && y == 0.0 {
                self.lastLeftJoystickAngle = self.joystickOriginalAngle
                //                print("摇杆归中")
                return
            }
            
            if dpad!.up.isPressed || dpad!.down.isPressed || dpad!.left.isPressed || dpad!.right.isPressed {
                /** 准确计算摇杆滑动方向
                 现象：拨动摇杆往一个方向滑动，摇杆会传来10次左右的x，y值
                 
                 根据x、y值可算出摇杆与X轴形成的角度，从而算出此时摇杆滑动的方向，角度对应方向如下：
                 [-45°, 45°】：右滑
                 [45°, 135°】：上滑
                 [135°, 180°】、【-180°, -135°】：左滑
                 [-135°, -45°】：下滑
                 
                 问题：往一个方向滑动时，很大概率出现另一个方向的角度
                 解决方法：当出现异常方向（除了摇杆居中后的第一个值），忽略该方向
                 
                 另外，在测试中发现，摇杆上下滑动时，初始角度可能是0.0，此时判定为右滑，导致上下滑无效，因此忽略角度0.0，此解决方法不影响右滑
                 */
                
                let a = atan2(y, x)
                let j = (a*180)/(Float.pi)
                
                let rightMin: Float = -45
                let rightMax: Float = 45
                let upMin: Float = 45
                let upMax: Float = 135
                let leftMin: Float = 135
                let leftMax: Float = -135
                let downMin: Float = -135
                let downMax: Float = -45
                
                if j == 0.0 || j == 180.0 {
                    //                    print("忽略角度：0.0 或 180.0")// 上下滑时，初始角度为0.0或者180.0，判断为右滑或者左滑，导致其他滑动被判断为无效，因此忽略此角度
                    return
                }
                
                if (j > leftMin && j <= 180) || (j <= leftMax && j >= -180) {
                    if self.lastLeftJoystickAngle != self.joystickOriginalAngle &&
                        (( self.lastLeftJoystickAngle >= 0 && self.lastLeftJoystickAngle <= leftMin) || (self.lastLeftJoystickAngle > leftMax && self.lastLeftJoystickAngle <= 0)) {// 此次滑动方向是左滑，但是上次滑动方向不是左滑，判定为无效滑动（除了摇杆归中的情况，即self.lastLeftJoystickAngle == self.joystickOriginalAngle）
                        //                        print("无效左滑，角度：", j)
                        return
                    }
                    
                    //                    print("左摇杆 左滑，角度：", j)
                    NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.LeftJoystickMoveLeft.rawValue), object: nil)
                    self.lastLeftJoystickAngle = j
                }
                else if j > rightMin && j <= rightMax {
                    if self.lastLeftJoystickAngle != self.joystickOriginalAngle && ( self.lastLeftJoystickAngle <= rightMin || self.lastLeftJoystickAngle > rightMax) {
                        //                        print("无效右滑，角度：", j)
                        return
                    }
                    //                    print("左摇杆 右滑，角度：", j)
                    NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.LeftJoystickMoveRight.rawValue), object: nil)
                    self.lastLeftJoystickAngle = j
                }
                else if j > upMin && j <= upMax {
                    if self.lastLeftJoystickAngle != self.joystickOriginalAngle && ( self.lastLeftJoystickAngle <= upMin || self.lastLeftJoystickAngle > upMax) {
                        //                        print("无效上滑，角度：", j)
                        return
                    }
                    //                    print("左摇杆 上滑，角度：", j)
                    NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.LeftJoystickMoveUp.rawValue), object: nil)
                    self.lastLeftJoystickAngle = j
                }
                else if j > downMin && j <= downMax {
                    if self.lastLeftJoystickAngle != self.joystickOriginalAngle && ( self.lastLeftJoystickAngle <= downMin || self.lastLeftJoystickAngle > downMax) {
                        //                        print("无效下滑，角度：", j)
                        return
                    }
                    
                    //                    print("左摇杆 下滑，角度：", j)
                    NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.LeftJoystickMoveDown.rawValue), object: nil)
                    self.lastLeftJoystickAngle = j
                }
            }
        }
        
        GSGameControllerManager.shared().rightJoystickChanged = { dpad, x, y in
            //            print("右摇杆数据：", x, y)
        }
        
        // 注意：Home键通过私有协议传给App（截图键也是）
        GSGameControllerManager.shared().keyHomePressed = { pressed in
            if pressed {
                print("按下Home键")
            }
            else {
                print("松开Home键")
                NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyHomePressed.rawValue), object: nil)
            }
        }
        
        GSGameControllerManager.shared().keyOptionsPressed = { pressed in
            if pressed {
                print("按下Options键")
            }
            else {
                print("松开Options键")
                NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyOPPressed.rawValue), object: nil)
            }
        }
        
        GSGameControllerManager.shared().keyMenuPressed = { pressed in
            if pressed {
                print("按下Menu键")
                NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyMenuPressed.rawValue), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyMenuPressIn.rawValue), object: nil)
                
            }
            else {
                NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyMenuPressOut.rawValue), object: nil)
                print("松开Menu键")
            }
        }
    }
    
    func unobserveGamepadKey() {
        GSGameControllerManager.shared().keyAPressed = nil
        GSGameControllerManager.shared().keyBPressed = nil
        GSGameControllerManager.shared().keyXPressed = nil
        GSGameControllerManager.shared().keyYPressed = nil
        
        GSGameControllerManager.shared().keyL1Pressed = nil
        GSGameControllerManager.shared().keyL2Pressed = nil
        GSGameControllerManager.shared().keyL3Pressed = nil
        GSGameControllerManager.shared().keyR1Pressed = nil
        GSGameControllerManager.shared().keyR2Pressed = nil
        GSGameControllerManager.shared().keyR3Pressed = nil
        
        GSGameControllerManager.shared().keyUpPressed = nil
        GSGameControllerManager.shared().keyDownPressed = nil
        GSGameControllerManager.shared().keyLeftPressed = nil
        GSGameControllerManager.shared().keyRightPressed = nil
        
        GSGameControllerManager.shared().leftJoystickChanged = nil
        GSGameControllerManager.shared().rightJoystickChanged = nil
        
        GSGameControllerManager.shared().keyHomePressed = nil
        GSGameControllerManager.shared().keyOptionsPressed = nil
        GSGameControllerManager.shared().keyMenuPressed = nil
    }
    
    var isInUpdatingFirmwareState = false
    // MARK: 手柄数据交互
    @objc func receiveGamepadData(notification: Notification) {
//        print(#function)
        let accessoryManager = EAAccessoryManager.shared()
        //print("---------\(accessoryManager.connectedAccessories.count)")
        if sendGamepadDataCallback != nil {
            let sessionController = notification.object as! EADSessionController
            var bytesAvailable = sessionController.readBytesAvailable()
            
            while bytesAvailable > 0 {
                let data = sessionController.readData(bytesAvailable)
                if data != nil {
                    sendGamepadDataCallback!(data!)
                }
                
                bytesAvailable = sessionController.readBytesAvailable()// 更新可用数据
            }
        }
        else {
            let sessionController = notification.object as! EADSessionController
            var bytesAvailable = sessionController.readBytesAvailable()
            while bytesAvailable > 0 {
                let data = sessionController.readData(bytesAvailable)
                if data != nil {
                    let hexString = GSDataTool.hexString(fromDataSeparatly: data!)
                    print("\n收到手柄发来的数据：\(hexString)")
                    let stringArray = hexString.components(separatedBy: " ")
                    
                    // 读取指令的响应 或者 手柄操作的响应（数据指令）
                    if stringArray[3] == "00" {
                        if stringArray.count < 9 {
                            return
                        }
                        
                        if stringArray[4] == "00" {// 手柄信息指令
                            var name = ""
                            var data: [String] = []
                            for index in 8..<stringArray.count {
                                data.append(stringArray[index])
                            }
                            
                            if stringArray[5] == "00" {
                                name = "硬件版本"
                            }
                            else if stringArray[5] == "01" {
                                name = "固件版本"
                                NotificationCenter.default.post(name: Notification.Name("DidGetFirmwareVersionNotification"), object: data)
                                //joyconDetailData = data
                            }
                            else if stringArray[5] == "02" {
                                name = "生产日期"
                            }
                            else if stringArray[5] == "03" {
                                name = "序列号"
                            }
                            print("读取\(name)：", data)
                        }
                        else if stringArray[4] == "02" {// 校准模式指令
                            if stringArray[8] == "00" {
                                print("读取校准模式：未在校准")
                            }
                            else if stringArray[8] == "01" {
                                print("读取校准模式：正在校准")
                            }
                        }
                        else if stringArray[4] == "06" {// 按键指令
                            if stringArray[5] == "01" {// 截屏键
                                if stringArray[8] == "01" {// 双击
                                    print("\n接收到手柄操作：双击截屏键")
                                    print("给手柄发送截屏指令")
                                    let bytes: [UInt8] = [0x61, 0x63, 0x70, 0x06, 0x01, 0x00, 0x01, 0x01, 0x01]
                                    let data: Data = Data.init(bytes: bytes, count: bytes.count)
                                    send(gamepadData: data)
                                    
                                    var dates = UserDefaults.standard.object(forKey: "TokenScreenshotDatesKey") as! [Date]
                                    dates.append(Date())
                                    UserDefaults.standard.set(dates, forKey: "TokenScreenshotDatesKey")
                                }
                                else if stringArray[8] == "02" {// 长按
                                    print("\n接收到手柄操作：长按截屏键")
                                    print("App调用系统的录屏功能")
                                    let pickView = RPSystemBroadcastPickerView.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                                    (UIApplication.shared.connectedScenes.first as! UIWindowScene).windows.first!.addSubview(pickView)
#if !DEBUG
//                                    pickView.preferredExtension = ScreenRecSharePathKey.ScreenExtension
#endif
                                    pickView.center = (UIApplication.shared.connectedScenes.first as! UIWindowScene).windows.first!.center;
                                    
                                    for subview in pickView.subviews {
                                        if subview.isKind(of: UIButton.self) {
                                            (subview as! UIButton).sendActions(for: .touchUpInside)
                                            pickView.removeFromSuperview()
                                            break
                                        }
                                    }
                                }
                                else if stringArray[8] == "03" {// 单击
                                    print("\n接收到手柄操作：单击截屏键")
                                    NotificationCenter.default.post(name: Notification.Name("DidClickGamepadCaptureKeyNotification"), object: nil)
                                }
                            }
                            else if stringArray[5] == "02" {// Home键
                                if stringArray[8] == "01" {// 单击
                                    print("\n接收到手柄操作：单击Home键")
                                    print("唤出App")
                                    
                                    if isDisplayingControllerTestingView {
                                        NotificationCenter.default.post(name: Notification.Name("DidClickGamepadHomeKeyNotification"), object: nil)
                                    }
                                    else {
                                        let bytes: [UInt8] = [0x61, 0x63, 0x70, 0x06, 0x02, 0x00, 0x01, 0x01, 0x01]
                                        let data: Data = Data.init(bytes: bytes, count: bytes.count)
                                        send(gamepadData: data)
                                    }
                                }
                                else if stringArray[8] == "02" {// 长按
                                    print("\n接收到手柄操作：长按Home键")
                                }
                            }
                        }
                        else if stringArray[4] == "07" {// ABXY布局指令
                            if stringArray[8] == "00" {
                                print("读取ABXY布局：MFi（默认）")
                            }
                            else if stringArray[8] == "01" {
                                print("读取ABXY布局：Switch")
                            }
                            let valueInt = stringArray[8].hexValue()
                            UserDefaults.standard.setValue(valueInt, forKey: mfiABXYLayoutKey)
                            NotificationCenter.default.post(name: Notification.Name("DidGetABXYLayoutNotification"), object: valueInt)
                        }
                        else if stringArray[4] == "08" {// 快速扳机指令
                            if stringArray[5] == "00" {
                                if stringArray[8] == "00" {
                                    print("读取左快速扳机开关：关闭")
                                }
                                else if stringArray[8] == "01" {
                                    print("读取左快速扳机开关：开启")
                                }
                                NotificationCenter.default.post(name: Notification.Name("DidGetLeftQuickTriggerNotification"), object: stringArray[8].hexValue())
                            }
                            else if stringArray[5] == "01" {
                                if stringArray[8] == "00" {
                                    print("读取右快速扳机开关：关闭")
                                }
                                else if stringArray[8] == "01" {
                                    print("读取右快速扳机开关：开启")
                                }
                                NotificationCenter.default.post(name: Notification.Name("DidGetRightQuickTriggerNotification"), object: stringArray[8].hexValue())
                            }
                        }
                        else if stringArray[4] == "09" {// 死区指令
                            var name = ""
                            let data = stringArray[8]
                            if stringArray[5] == "00" {
                                if stringArray[6] == "00" {
                                    name = "左摇杆内死区"
                                    NotificationCenter.default.post(name: Notification.Name("DidGetLeftJoystickInnerDeadZoneNotification"), object: stringArray[8].hexValue())
                                }
                                else if stringArray[6] == "01" {
                                    name = "左摇杆外死区"
                                    NotificationCenter.default.post(name: Notification.Name("DidGetLeftJoystickOutDeadZoneNotification"), object: stringArray[8].hexValue())
                                }
                            }
                            else if stringArray[5] == "01" {
                                if stringArray[6] == "00" {
                                    name = "右摇杆内死区"
                                    NotificationCenter.default.post(name: Notification.Name("DidGetRightJoystickInnerDeadZoneNotification"), object: stringArray[8].hexValue())
                                }
                                else if stringArray[6] == "01" {
                                    name = "右摇杆外死区"
                                    NotificationCenter.default.post(name: Notification.Name("DidGetRightJoystickOutDeadZoneNotification"), object: stringArray[8].hexValue())
                                }
                            }
                            else if stringArray[5] == "02" {
                                if stringArray[6] == "00" {
                                    name = "左扳机内死区"
                                    NotificationCenter.default.post(name: Notification.Name("DidGetLeftTriggerInnerDeadZoneNotification"), object: stringArray[8].hexValue())
                                }
                                else if stringArray[6] == "01" {
                                    name = "左扳机外死区"
                                    NotificationCenter.default.post(name: Notification.Name("DidGetLeftTriggerOutDeadZoneNotification"), object: stringArray[8].hexValue())
                                }
                            }
                            else if stringArray[5] == "03" {
                                if stringArray[6] == "00" {
                                    name = "右扳机内死区"
                                    NotificationCenter.default.post(name: Notification.Name("DidGetRightTriggerInnerDeadZoneNotification"), object: stringArray[8].hexValue())
                                }
                                else if stringArray[6] == "01" {
                                    name = "右扳机外死区"
                                    NotificationCenter.default.post(name: Notification.Name("DidGetRightTriggerOutDeadZoneNotification"), object: stringArray[8].hexValue())
                                }
                            }
                            print("读取\(name)：", data.hexValue())
                        }
                        else if stringArray[4] == "0a" {// 十字键斜向锁指令
                            if stringArray[8] == "00" {
                                print("读取十字键斜向锁开关：未开启")
                                NotificationCenter.default.post(name: Notification.Name("DidGetDpadLockNotification"), object: stringArray[8].hexValue())
                            }
                            else if stringArray[8] == "01" {
                                print("读取十字键斜向锁开关：已开启")
                                NotificationCenter.default.post(name: Notification.Name("DidGetDpadLockNotification"), object: stringArray[8].hexValue())
                            }
                        }
                        else if stringArray[4] == "0b" {// UUID指令
                            var name = ""
                            var data: [String] = []
                            for index in 8..<stringArray.count {
                                data.append(stringArray[index])
                            }
                            
                            if stringArray[5] == "00" {
                                name = "UUID"
                            }
                            else if stringArray[5] == "01" {
                                name = "UUID加密数据"
                            }
                            
                            print("读取\(name)：", data)
                        }
                    }
                    
                    // 写入指令的响应（状态指令）
                    else if stringArray[3] == "01" {
                        // 在MFi模式下，如果手柄处于升级状态，给手柄发送读取固件版本号的命令61 63 70 00 01 00 00 00，手柄会返回61 63 70 01 00 01 00 01 01，根据这个数据来判断手柄处于升级状态，强制升级固件。
                        let specialStringArray = ["61", "63", "70", "01", "00", "01", "00", "01", "01"]
                        if checkIfInMFiMode() && stringArray == specialStringArray {
                            isInUpdatingFirmwareState = true
                            checkIfForceToUpdateFirmware()
                            return
                        }
                        
                        if stringArray.count < 9 {// 升级状态下，写入【告知App开启】指令后，会收到手柄发来的数据：61 63 70 01 05 00 00 00，长度为8
                            return
                        }
                        
                        if stringArray[4] == "00" {// 手柄信息指令
                            if stringArray[8] == "00" {
                                print("写入手柄信息结果：成功")
                            }
                            else if stringArray[8] == "01" {
                                print("写入手柄信息结果：失败")
                            }
                        }
                        else if stringArray[4] == "05" {// 告诉App开关指令
                            if stringArray[8] == "00" {
                                print("写入App开关结果：成功")
                            }
                            else if stringArray[8] == "01" {
                                print("写入App开关结果：失败")
                            }
                        }
                        else if stringArray[4] == "06" {// 按键指令
                            if stringArray[8] == "00" {
                                print("写入按键指令结果：成功")
                            }
                            else if stringArray[8] == "01" {
                                print("写入按键指令结果：失败")
                            }
                        }
                        else if stringArray[4] == "07" {// ABXY布局指令
                            if stringArray[8] == "00" {
                                print("写入ABXY布局结果：成功")
                            }
                            else if stringArray[8] == "01" {
                                print("写入ABXY布局结果：失败")
                            }
                        }
                        else if stringArray[4] == "08" {// 快速扳机指令
                            var name = ""
                            if stringArray[5] == "00" {
                                name = "左"
                            }
                            else if stringArray[5] == "01" {
                                name = "右"
                            }
                            
                            if stringArray[8] == "00" {
                                print("写入\(name)快速扳机结果：成功")
                            }
                            else if stringArray[8] == "01" {
                                print("写入\(name)快速扳机结果：失败")
                            }
                        }
                        else if stringArray[4] == "09" {// 死区指令
                            if stringArray[8] == "00" {
                                print("写入死区结果：成功")
                            }
                            else if stringArray[8] == "01" {
                                print("写入死区结果：失败")
                            }
                        }
                        else if stringArray[4] == "0a" {// 十字键斜向锁指令
                            if stringArray[8] == "00" {
                                print("写入十字键斜向锁结果：成功")
                            }
                            else if stringArray[8] == "01" {
                                print("写入十字键斜向锁结果：失败")
                            }
                        }
                    }
                }
                
                bytesAvailable = sessionController.readBytesAvailable()// 更新可用数据
            }
        }
    }
    
    // 告诉手柄：App已打开
    func writeCommandAppOpened() {
        let bytes: [UInt8] = [0x61, 0x63, 0x70, 0x05, 0x00, 0x00, 0x01, 0x01, 0x01]
        let data: Data = Data.init(bytes: bytes, count: bytes.count)
        send(gamepadData: data)
    }
    
    // 告诉手柄：App已关闭
    func writeCommandAppClosed() {
        let bytes: [UInt8] = [0x61, 0x63, 0x70, 0x05, 0x00, 0x00, 0x01, 0x01, 0x00]
        let data: Data = Data.init(bytes: bytes, count: bytes.count)
        send(gamepadData: data)
    }
    
    // 读取ABXY布局
    func writeCommandReadABXYLayout() {
        let bytes: [UInt8] = [0x61, 0x63, 0x70, 0x07, 0x00, 0x00, 0x00, 0x00]
        let data: Data = Data.init(bytes: bytes, count: bytes.count)
        send(gamepadData: data)
    }
    
    // 写入ABXY布局
    func writeCommandSetABXY(layout: ControllerABXYLayout) {
        let bytes: [UInt8] = [0x61, 0x63, 0x70, 0x07, 0x00, 0x00, 0x01, 0x01, UInt8(layout.rawValue)]
        let data: Data = Data.init(bytes: bytes, count: bytes.count)
        send(gamepadData: data)
    }
    
    // 读取快速扳机
    func writeCommandReadQuickTrigger(isLeft: Bool) {
        var type = 0x00
        if !isLeft {
            type = 0x01
        }
        let bytes: [UInt8] = [0x61, 0x63, 0x70, 0x08, UInt8(type), 0x00, 0x00, 0x00]
        let data: Data = Data.init(bytes: bytes, count: bytes.count)
        send(gamepadData: data)
    }
    
    // 写入快速扳机
    func writeCommandSetQuickTrigger(isLeftTrigger: Bool, isOn: Bool) {
        var trigger = 0x00
        if !isLeftTrigger {
            trigger = 0x01
        }
        
        var value = 0x00
        if isOn {
            value = 0x01
        }
        
        let bytes: [UInt8] = [0x61, 0x63, 0x70, 0x08, UInt8(trigger), 0x00, 0x01, 0x01, UInt8(value)]
        let data: Data = Data.init(bytes: bytes, count: bytes.count)
        send(gamepadData: data)
    }
    
    // 读取扳机死区
    func writeCommandReadTriggerDeadZone(isLeftTrigger: Bool, isInnerDeadZone: Bool) {
        var trigger = 0x02
        if !isLeftTrigger {
            trigger = 0x03
        }
        
        var inner = 0x00
        if !isInnerDeadZone {
            inner = 0x01
        }
        
        let bytes: [UInt8] = [0x61, 0x63, 0x70, 0x09, UInt8(trigger), UInt8(inner), 0x00, 0x00]
        let data: Data = Data.init(bytes: bytes, count: bytes.count)
        send(gamepadData: data)
    }
    
    // 写入扳机死区
    func writeCommandSetTriggerDeadZone(isLeftTrigger: Bool, isInnerDeadZone: Bool, value: Int) {
        var trigger = 0x02
        if !isLeftTrigger {
            trigger = 0x03
        }
        
        var inner = 0x00
        if !isInnerDeadZone {
            inner = 0x01
        }
        
        let bytes: [UInt8] = [0x61, 0x63, 0x70, 0x09, UInt8(trigger), UInt8(inner), 0x01, 0x01, UInt8(value)]
        let data: Data = Data.init(bytes: bytes, count: bytes.count)
        send(gamepadData: data)
    }
    
    // 读取摇杆死区
    func writeCommandReadJoystickDeadZone(isLeftJoystick: Bool, isInnerDeadZone: Bool) {
        var trigger = 0x00
        if !isLeftJoystick {
            trigger = 0x01
        }
        
        var inner = 0x00
        if !isInnerDeadZone {
            inner = 0x01
        }
        
        let bytes: [UInt8] = [0x61, 0x63, 0x70, 0x09, UInt8(trigger), UInt8(inner), 0x00, 0x00]
        let data: Data = Data.init(bytes: bytes, count: bytes.count)
        send(gamepadData: data)
    }
    
    // 写入摇杆死区
    func writeCommandSetJoystickDeadZone(isLeftJoystick: Bool, isInnerDeadZone: Bool, value: Int) {
        var trigger = 0x00
        if !isLeftJoystick {
            trigger = 0x01
        }
        
        var inner = 0x00
        if !isInnerDeadZone {
            inner = 0x01
        }
        
        let bytes: [UInt8] = [0x61, 0x63, 0x70, 0x09, UInt8(trigger), UInt8(inner), 0x01, 0x01, UInt8(value)]
        let data: Data = Data.init(bytes: bytes, count: bytes.count)
        send(gamepadData: data)
    }
    
    // 读取十字键斜向锁
    func writeCommandReadDpadLock() {
        let bytes: [UInt8] = [0x61, 0x63, 0x70, 0x0a, 0x00, 0x00, 0x00, 0x00]
        let data: Data = Data.init(bytes: bytes, count: bytes.count)
        send(gamepadData: data)
    }
    
    // 写入十字键斜向锁
    func writeCommandSetDpadLock(isOn: Bool) {
        var value = 0x00
        if isOn {
            value = 0x01
        }
        
        let bytes: [UInt8] = [0x61, 0x63, 0x70, 0x0a, 0x00, 0x00, 0x01, 0x01, UInt8(value)]
        let data: Data = Data.init(bytes: bytes, count: bytes.count)
        send(gamepadData: data)
    }
    
    // 读取固件版本
    func writeCommandReadFirmwareVersion() {
        print("读取版本号，发送 61 63 70 00 01 00 00 00")
        let bytes: [UInt8] = [0x61, 0x63, 0x70, 0x00, 0x01, 0x00, 0x00, 0x00]
        let data: Data = Data.init(bytes: bytes, count: bytes.count)
        send(gamepadData: data)
    }
    
    // 给手柄发送数据
    func send(gamepadData: Data) {
        EADSessionController.shared().write(gamepadData)
    }
    
    typealias sendDataCallback = (_: Data) -> Void
    private var sendGamepadDataCallback: sendDataCallback? = nil
    func send(data: Data, callback: sendDataCallback?) {
        sendGamepadDataCallback = callback
        EADSessionController.shared().write(data)
    }
    
    // 从相册获取指定时间的截图，保存到App
    func saveSpecifiedTimeScreenshot() {
        var dates = UserDefaults.standard.object(forKey: "TokenScreenshotDatesKey") as! [Date]
        if dates.count == 0 {
            return
        }
        
        for date in dates.reversed() {
            print("剩余需要获取的截图时间：", dates)
            
            let options = PHFetchOptions()
            options.predicate = NSPredicate(format: "creationDate > %@ AND creationDate < %@", date.addingTimeInterval(-1) as CVarArg, date.addingTimeInterval(1) as CVarArg)
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            let result = PHAsset.fetchAssets(with: options)
            if let asset = result.firstObject {
                let manager = PHImageManager.default()
                manager.requestImage(for: asset,
                                     targetSize: PHImageManagerMaximumSize,
                                     contentMode: .aspectFill,
                                     options: nil) { (image, infoDic) in
                    if infoDic?.keys.contains(PHImageResultIsDegradedKey) != nil {
                        if infoDic![PHImageResultIsDegradedKey] as! Int == 0 {
                            if image != nil {
                                save(image: image!, name: stringFrom(date: date))
                                print("保存截图")
                            }
                        }
                    }
                }
            }
            
            dates.removeAll {
                $0 == date
            }
        }
        
        UserDefaults.standard.set(dates, forKey: "TokenScreenshotDatesKey")
    }
    
    var supportLightnings = [String]()
    var accessory: EAAccessory? = nil
    var mfiController = GCController.init()
    // MARK: =====手柄连接与断开=====
    func openMFiControllerSession() {
        if self.accessory != nil {// 防止多个session
            return
        }
        
        let connectedAccessoriesCount = EAAccessoryManager.shared().connectedAccessories.count
        if connectedAccessoriesCount == 0 {
            UserDefaults.standard.setValue(false, forKey: isInMFiModeKey)
            _ = checkIfInMFiMode()
            return
        }
        UserDefaults.standard.setValue(true, forKey: isInMFiModeKey)
        
        let accessorys = EAAccessoryManager.shared().connectedAccessories
        for accessory in accessorys {
            if accessory.isKind(of: EAAccessory.self) {
                let accessoryStrings = accessory.protocolStrings
                for accessoryString in accessoryStrings {
                    self.accessory = accessory
                    
                    print("已连接MFi手柄：\n", accessory)
                    EADSessionController.shared().setupController(for: accessory, withProtocolString: accessoryString)
                    
                    delay(interval: 0.5) {// 延后开启Session，保证USB重连后数据通信正常。否则可能出现写入数据没回复的问题
                        EADSessionController.shared().openSession()
                        delay(interval: 2) {
                            NotificationCenter.default.post(name: Notification.Name("DidOpenControllerSessionNotification"), object: nil)
                            
                            self.writeCommandAppOpened()
                            
                            delay(interval: 1) {
                                self.writeCommandReadFirmwareVersion()// 用于检测手柄是否处于升级状态。如果是，则会返回失败数据：61 63 70 01 00 01 00 01 01
                                
                                delay(interval: 1) {// 读取ABXY布局，以决定部分页面的按钮上的返回键和确定键图标
                                    self.writeCommandReadABXYLayout()
                                }
                            }
                        }
                    }
                    return
                }
            }
        }
    }
    
    // 连上手柄后再启动App，不会触发此方法。
    // 启动App后再连接手柄，会触发此方法。
//    @objc func didConnectAccessory(notification: Notification) {
//        print("=====did Connect Accessory=====")
//        var controllerName = ""
//        if notification.object is EAAccessoryManager {
//            let accessoryManager = notification.object as! EAAccessoryManager
//            controllerName = accessoryManager.connectedAccessories.first?.name ?? ""
//        }
//        else if notification.object is GCController {
//            let controller = notification.object as! GCController
//            controllerName = controller.vendorName ?? ""
//        }
//        connectController(name: controllerName)
//    }
    
    // 连上手柄后再启动App，会触发此方法。
    // 启动App后再连接手柄，会触发此方法。
    func didConnect(_ gameController: GSGameController) {
        print("=====did Connect Controller=====")
        
        let controller = gameController.controller!
        self.mfiController = controller
        
        print("vendorName == \(controller.vendorName)")
        print("productCategory == \(controller.productCategory)")
        if #available(iOS 14.0, *) {
            print("physicalInputProfile == \(controller.motion)")
        } else {
            // Fallback on earlier versions
        }
        // 如果手柄名称是“wireless controller”，productCategory才是正确的手柄名称
        var controllerName = controller.vendorName
        if controllerName?.lowercased().contains("wireless controller") == true ||
            controllerName == "0" {
            controllerName = controller.productCategory
        }
        
        connectController(name: controllerName)
    }
    
    func connectController(name: String?) {
        print("已连接手柄：\(name!)")
        setControllerName(name: name ?? "")
        
        openMFiControllerSession()
        
        DispatchQueue.once {
            requestControllerFirmwares()// 连接手柄后再下载固件。只下载一次，防止每次重连手柄都选中最新版本的固件，导致无法升级到其他版本的固件
        }
        NotificationCenter.default.post(name: Notification.Name("DidConnectControllerNotification"), object: nil)
    }
    
    // 非MFi模式下断开手柄，不会触发此方法。
//    @objc func didDisconnectAccessory(notification: Notification) {
//        print("=====did Disconnect Accessory=====")
//        accessory = nil
//
//        var controllerName = ""
//        if notification.object is EAAccessoryManager {
//            let accessoryManager = notification.object as! EAAccessoryManager
//            controllerName = accessoryManager.connectedAccessories.first?.name ?? ""
//        }
//        else if notification.object is GCController {
//            let controller = notification.object as! GCController
//            controllerName = controller.vendorName ?? ""
//        }
//        disconnectController(name: controllerName)
//        print("已断开手柄：", controllerName)
//    }
    
    func didDisconnectController(_ gameController: GSGameController!) {
        print("=====did Disconnect Controller=====")
        accessory = nil
        
        var controllerName = ""
        controllerName = gameController.controller.vendorName ?? ""
        if controllerName.lowercased().contains("wireless controller") == true {
            controllerName = gameController.controller.productCategory
        }
        disconnectController(name: controllerName)
        print("已断开手柄：", controllerName)
    }
    
    func disconnectController(name: String?) {
        setControllerName(name: "")
        sendGamepadDataCallback = nil
        NotificationCenter.default.post(name: Notification.Name("DidDisconnectControllerNotification"), object: nil)
    }
    
    // MARK: 云信IM
    func setupInitNIMSDK(){
#if !DEBUG
//        // init
//        let option = NIMSDKOption()
//        option.appKey = "d74073ba887f7b504d4616fd0cf75440"
//        option.apnsCername = ""
//        NIMSDK.shared().register(with: option)
//        NIMSDK.shared().loginManager.add(self)
//        if (getToken() == ""){
//            return
//        }
//        let yunxin_token =  UserDefaults.standard.value(forKey: "yunxin_token") as? String
//        let accid =  UserDefaults.standard.value(forKey: "accid") as? String
//        if (yunxin_token != nil && accid != nil){
//            NIMSDK.shared().loginManager.login(accid!, token: yunxin_token!) { error in
//                print("InitNIMSDK error: \(String(describing: error))")
//                if((error) != nil){
//                    delay(interval: 5) {
//                        self.refreshYUNXINToken()
//                    }
//                }
//            }
//        }else{
//            delay(interval: 5) {
//                self.refreshYUNXINToken()
//            }
//        }
#endif
    }
    
    func refreshYUNXINToken(){
#if !DEBUG
//        let networker = MoyaProvider<UserService>()
//        networker.request(.refreshYUNXINToken) { result in
//            switch result {
//            case let .success(response): do {
//                let data = try? response.mapJSON()
//                if data == nil {return}
//                let json = JSON(data!)
//                let responseData = json.dictionaryObject!
//                let code = responseData["code"] as! Int
//                if code == NetworkErrorType.NeedLogin.rawValue {
//                    return
//                }
//                if code == 200 {
//                    let data = responseData["data"] as! NSDictionary
//                    let accid = data.value(forKey: "accid") as! String
//                    let yunxin_token = data.value(forKey: "yunxin_token") as! String
//                    NIMSDK.shared().loginManager.login(accid, token: yunxin_token) { error in
//                        print("NIM loginManager error: \(String(describing: error))")
//                    }
//                    UserDefaults.standard.set(accid, forKey: "accid")
//                    UserDefaults.standard.set(yunxin_token, forKey: "yunxin_token")
//                }
//                else {
//                    print("获取yunxin_token失败", responseData["msg"]!)
//                }
//            }
//            case .failure(_): do {
//                print("网络错误")
//            }
//                break
//            }
//        }
#endif
    }
    
#if !DEBUG
//    func onLogin(_ step: NIMLoginStep) {
//        if (step == .loginFailed){
//            delay(interval: 5) {
//                self.setupInitNIMSDK()
//            }
//        }
//    }
#endif
    
    func logoutNetWork() {
        let networker = MoyaProvider<UserService>()
        networker.request(.logout) { result in
            switch result {
            case let .success(response): do {
                let data = try? response.mapJSON()
                if data == nil {return}
                let json = JSON(data!)
                let responseData = json.dictionaryObject!
                let code = responseData["code"] as! Int
                if code == 200 {
                    print("退出IM账号成功")
                }else {
                    print("退出IM账号失败", responseData["msg"]!)
                }
                NotificationCenter.default.post(name: NSNotification.Name("SceneDelegateRunLogoutScript"), object: nil)
            }
            case .failure(_): do {
                print("网络错误")
                NotificationCenter.default.post(name: NSNotification.Name("SceneDelegateRunLogoutScript"), object: nil)
            }
                break
            }
        }
    }
    
    // 用户登录和数据
    func checkToken() {
        let networker = MoyaProvider<UserService>()
        networker.request(.checkTokenEnabled) { result in
            switch result {
            case let .success(response): do {
                let data = try? response.mapJSON()
                if data == nil {return}
                let json = JSON(data!)
                let responseData = json.dictionaryObject!
                let code = responseData["code"] as! Int
                if code == NetworkErrorType.NeedLogin.rawValue {
                    NotificationCenter.default.post(name: Notification.Name("UserDidLogoutNotification"), object: nil)
                    return
                }
                if code == 200 || code == 201 {
                    print("Token依然有效，仍处于登录状态")
                    self.refreshYUNXINToken()
                }
                else {
                    print("Token已过期，需重新登录", responseData["msg"]!)
                }
            }
            case .failure(_): do {
                print("网络错误")
            }
                break
            }
        }
    }
    
    
    // MARK: 消息推送
    // 1. 请求推送权限
    func requestNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                print("Notification authorization granted")
                self.registerRemoteNotifications()
            } else {
                print("Notification authorization denied")
            }
        }
        
        center.delegate = self
    }
    
    // 2. 获得推送权限后，注册推送，以获取设备信息
    func registerRemoteNotifications() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestNotificationAuthorization()
            case .authorized, .provisional:
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            default:
                break
            }
        }
    }
    
    /// 获取系统当前语言
    func getCurrentLanguage() -> String {
        // 返回设备曾使用过的语言列表
        let languages: [String] = UserDefaults.standard.object(forKey: "AppleLanguages") as! [String]
        // 当前使用的语言排在第一
        let currentLanguage = languages.first
        if (currentLanguage == "zh-Hans-CN" || currentLanguage == "zh-Hant-CN" || currentLanguage == "zh-Hant-HK" || currentLanguage == "zh-Hant-MO" || currentLanguage == "zh-Hant-TW"){
            return "zh-cn"
        }else{
            return "en-us"
        }
    }
    
    // 2.1 注册推送成功
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        print("注册消息推送成功。设备信息：\(token)")
        // 把数据传给后台
        let language = getCurrentLanguage()
        upload(deviceToken: token,language: language)
        registerForRemoteNotificationHandler(true)
    }
    
    // 2.2 注册推送失败！
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("注册消息推送失败！: \(error)")
        registerForRemoteNotificationHandler(false)
    }
    
    // App处于Background时接收到推送消息
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
        
        let info = response.notification.request.content.userInfo
        print("App处于后台，收到推送消息：\(info)")
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationCenterDidReceive"), object: nil, userInfo: info)
    }
    
    // App处于Foreground时接收到推送消息
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
        
        let info = notification.request.content.userInfo as? [String: Any]
        let content = info?["aps"] as? [String: Any]
        let alertContent = content?["alert"] as? [String: Any]
        print("收到推送消息：\(String(describing: alertContent))")
        
    }
    
    
    // 上传设备Token
    func upload(deviceToken: String,language:String) {
        let networker = MoyaProvider<UserService>()
        networker.request(.uploadDeviceTokenForUserNotification(token: deviceToken,language: language)) { result in
            switch result {
            case let .success(response): do {
                let data = try? response.mapJSON()
                if data == nil {return}
                let json = JSON(data!)
                let responseData = json.dictionaryObject!
                let code = responseData["code"] as! Int
                if code == NetworkErrorType.NeedLogin.rawValue {
                    return
                }
                if code == 200 {
                    print("上传设备Token成功")
                }
                else {
                    print("上传设备Token失败", responseData["msg"]!)
                    delay(interval: 2) {
                        self.upload(deviceToken: deviceToken,language: language)
                    }
                }
            }
            case .failure(_): do {
                print("上传设备Token失败！网络错误")
                delay(interval: 2) {
                    self.upload(deviceToken: deviceToken,language: language)
                }
            }
                break
            }
        }
    }
    
    private var firmwareData: Data? = nil
    private var sendedPackageNumber = 0// 已发送包数
    private var maxPackageNumber = 0// 最大包数
    private var packageSize = 32// 每包的数据量：32
    
    // MARK: 强制升级固件
    
    func checkIfForceToUpdateFirmware() {
        if isInUpdatingFirmwareState {
            showForceUpdateFirmwareView()
        }
    }
    
    // 使用场景：正常升级中拔掉手柄，再重连
    func showForceUpdateFirmwareView() {
        isInUpdatingFirmwareState = false
        
        if UIViewController.current()?.view.subviews.last is UpdateFirmwareView {
            forceToUpdateFirmware()
            return
        }
        
        let alertView = ForceUpdateFirmwareView(frame: UIScreen.main.bounds)
        UIViewController.current()?.view.addSubview(alertView)
    }
    
    func forceToUpdateFirmware() {
        if selectedControllerFirmwareFilePath == nil ||
            selectedControllerFirmwareFilePath?.absoluteString == "" {
            print("升级失败：没有固件！")
            MBProgressHUD.showActivityLoading(i18n(string: "Downloading firmware, please wait..."))
            requestControllerFirmwares()
            
            delay(interval: 10) {
                MBProgressHUD.hide(for: currentWindow()!, animated: true)
                self.forceToUpdateFirmware()
            }
            return
        }
        
        do {
            var data: Data? = nil
            data = try Data.init(contentsOf: selectedControllerFirmwareFilePath!)
            firmwareData = data
            
            startUpdateFirmware()
        }
        catch {
            print("升级失败：没有固件！", error)
        }
    }
    
    // MARK: ==========升级固件==========
    
    func prepareToUpdateFirmware() {
        enterUpdateMode()
    }
    
    private func enterUpdateMode() {
        // 手柄将重启，然后进入Bootloader模式
        var startUpdateBytes: [UInt8] = []
        startUpdateBytes = [0x61, 0x63, 0x70, 0x01, 0x00, 0x00, 0x01, 0x01, 0x00]
        let startUpdateData: Data = Data.init(bytes: startUpdateBytes, count: startUpdateBytes.count)
        send(data: startUpdateData, callback: nil)
    }
    
    func startUpdateFirmware() {
        if firmwareData == nil {
            return
        }
        
        let firmwareBytes = firmwareData!.bytes
        let bytesCount = firmwareBytes.count
        maxPackageNumber = bytesCount / packageSize + 1
        
        var startUpdateBytes: [UInt8] = []
        startUpdateBytes = [0x61, 0x63, 0x70, 0x01, 0x00, 0x00, 0x01, 0x01, 0x00]
        let startUpdateData: Data = Data.init(bytes: startUpdateBytes, count: startUpdateBytes.count)
        // first: Start Update
        send(data: startUpdateData) { callbackData in
            print("--------------------------回调--------------------------")
            
            let callbackString = GSDataTool.transData2HexString(callbackData)
            let startIndex = callbackString.index(callbackString.startIndex, offsetBy: 16)
            let endIndex = callbackString.index(callbackString.startIndex, offsetBy: 17)
            let resultString = callbackString[startIndex...endIndex]
            
            // Start Update的结果
            if resultString == "00" {// 00：成功，01：失败
                self.sendedPackageNumber = 0
                self.writeFirmwareData()
            }
            else {
                print("Start Update 验证失败")
            }
        }// end Start Update
    }
    
    private func writeFirmwareData() {
        if firmwareData == nil {
            return
        }
        
        let firmwareBytes = firmwareData!.bytes
        let headerBytes: [UInt8] = [0x61, 0x63, 0x70, 0x01, 0x01, 0x00, 0x01, 0x20]// 开头
        let verifyHeaderBytes: [UInt8] = [0x61, 0x63, 0x70, 0x01, 0x02, 0x00, 0x01, 0x20]// 验证开头
        
        var willSendBytes: [UInt8] = headerBytes
        let startIndex = self.sendedPackageNumber*32
        let endIndex = (self.sendedPackageNumber + 1)*32
        // 注释原因：允许超出index，超出部分值为0x00
        //        if endIndex > firmwareBytes.count {
        //            endIndex = firmwareBytes.count
        //        }
        /**
         packageIndex   startIndex   endIndex < firmwareBytes.count
         0              0            32
         1              32*1         32*2
         2              32*2         32*3
         3              32*3         32*4
         4              32*4         32*5
         */
        for index in startIndex..<endIndex {
            var byte: UInt8 = 0x00
            if index < firmwareBytes.count {
                byte = firmwareBytes[index]
            }
            willSendBytes.append(byte)
        }
        
        let willSendData = Data(bytes: willSendBytes, count: willSendBytes.count)
        
        // 1 写入数据包
        self.send(data: willSendData) { callbackData in
            let callbackString = GSDataTool.transData2HexString(callbackData)
            let stringStartIndex = callbackString.index(callbackString.startIndex, offsetBy: 16)
            let stringEndIndex = callbackString.index(callbackString.startIndex, offsetBy: 17)
            let resultString = callbackString[stringStartIndex...stringEndIndex]
            
            // 2 写入的结果
            if resultString == "00" {
                var willSendBytes: [UInt8] = verifyHeaderBytes
                for index in startIndex..<endIndex {
                    var byte: UInt8 = 0x00
                    if index < firmwareBytes.count {
                        byte = firmwareBytes[index]
                    }
                    willSendBytes.append(byte)
                }
                
                let willSendData = Data(bytes: willSendBytes, count: willSendBytes.count)
                
                // 3 验证数据包
                self.send(data: willSendData) { callbackData in
                    let callbackString = GSDataTool.transData2HexString(callbackData)
                    let startIndex = callbackString.index(callbackString.startIndex, offsetBy: 16)
                    let endIndex = callbackString.index(callbackString.startIndex, offsetBy: 17)
                    let resultString = callbackString[startIndex...endIndex]
                    
                    // 4 验证的结果
                    if resultString == "00" {
                        self.sendedPackageNumber += 1
                        // 1/2150
                        let progress = CGFloat(self.sendedPackageNumber)/(CGFloat(self.maxPackageNumber)*1.0)
                        print("升级进度：\(self.sendedPackageNumber)/\(self.maxPackageNumber)")
                        NotificationCenter.default.post(name: Notification.Name("DidUpdateFirmwareProgressNotification"), object: progress*100.0)
                        
                        if self.sendedPackageNumber == self.maxPackageNumber {// 已发完所有数据
                            let endUpdateBytes: [UInt8] = [0x61, 0x63, 0x70, 0x01, 0x03, 0x00, 0x01, 0x00]
                            let endUpdateData: Data = Data.init(bytes: endUpdateBytes, count: endUpdateBytes.count)
                            
                            // finally: End Update
                            self.send(data: endUpdateData) { callbackData in
                                if resultString == "00" {
                                    self.sendGamepadDataCallback = nil
                                    // 固件升级成功
                                    print("固件升级成功")
                                }
                                else {
                                    // 固件升级失败
                                }
                            }
                        }
                        else {
                            self.writeFirmwareData()// 重复写入数据包
                        }
                    }
                    else {
                        // 固件升级失败
                    }
                }// end Prog Verify
            }
            else {
                // 固件升级失败
            }
        }// end Prog Block
    }
    
    // MARK: 横竖屏管理
    // 界面支持的方向（默认横屏）
    var interfaceOrientations: UIInterfaceOrientationMask = [.landscapeRight, .landscapeLeft] {
        didSet {
            // 强制竖屏
            if interfaceOrientations == .portrait {
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            }
            // 强制横屏
            else if interfaceOrientations.contains(.portrait) == false {
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
            }
        }
    }
    /*
     * 好似并没有用，强制横竖屏
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return interfaceOrientations
    }
    */
    @objc var isForcePortrait: Bool = false
    @objc func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        if (isForcePortrait){
            return .portrait;
        }
        
        return .landscapeRight;
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        writeCommandAppClosed()
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}


// MARK: 播放视频
var appVideoPlayer: VideoBackground?
var appVideoLayer: AVPlayerLayer?
var waitingToPlayVideoUrl: URL?
var waitingToPlayVideoBgView: UIView?

// 播放视频
func appPlayVideo() {
    if isDisablingVideo ||
        waitingToPlayVideoUrl == nil ||
        waitingToPlayVideoBgView == nil {
        return
    }
    print("播放视频")
    
    // 删除前一个播放器
    if appVideoLayer?.player?.timeControlStatus == .playing {
        appVideoLayer?.player?.pause()
        appVideoLayer?.removeFromSuperlayer()
    }
    
    appVideoPlayer = VideoBackground()// 新建一个播放器，以防止下个视频出现上个视频的残影
    appVideoPlayer!.play(view: waitingToPlayVideoBgView!, url: waitingToPlayVideoUrl!)
    appVideoLayer = appVideoPlayer!.playerLayer
    appVideoLayer?.player?.isMuted = false// 播放声音
}

// 暂定视频播放
func appPauseVideo() {
    if appVideoLayer?.player?.timeControlStatus == .playing {
        appVideoLayer?.player?.pause()
        appVideoLayer?.removeFromSuperlayer()
        print("暂停视频播放")
    }
}

// 移除视频播放器
func appRemoveVideoPlayer() {
    print("移除视频播放器")
    waitingToPlayVideoUrl = nil
    waitingToPlayVideoBgView?.removeFromSuperview()
    waitingToPlayVideoBgView = nil
    
    appVideoLayer?.player?.pause()
    appVideoLayer?.removeFromSuperlayer()
}

// 禁止播放视频
var isDisablingVideo = false
func appDisablePlayingVideo() {
    print("禁止播放视频")
    isDisablingVideo = true
    appRemoveVideoPlayer()
}

// 允许播放视频
func appEnablePlayingVideo() {
    print("允许播放视频")
    isDisablingVideo = false
}


// MARK: 播放音频
func appPlayScrollSound() {
    appPlaySound(name: "scroll")
}

func appPlayIneffectiveSound() {
    appPlaySound(name: "ineffective")
}

func appPlaySelectSound() {
    appPlaySound(name: "select")
}

/** 播放音频的注意事项：
 必须把audioPlayer设为全局变量，否则无声音
 */
var appAudioPlayer: AVAudioPlayer!
func appPlaySound(name: String) {
    do {
        try AVAudioSession.sharedInstance().setActive(true)
        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
    } catch {
        print(error.localizedDescription)
    }
    
    //    print("播放音效")
    
    let fileUrl = Bundle.main.url(forResource: name, withExtension: "wav")
    do {
        appAudioPlayer = try AVAudioPlayer(contentsOf: fileUrl!)
        appAudioPlayer.volume = 1.0
        appAudioPlayer.play()
    }
    catch {
        print(error)
    }
}

// MARK: 游戏数据
// 提前下载游戏封面，以提升首次进入游戏列表页面时的视觉体验
func downloadGameCoversInAdvance() {
    if let savedData = UserDefaults.standard.dictionary(forKey: "GameGetIndexListData") {
        let code = savedData["code"] as! Int
        if code == NetworkErrorType.NeedLogin.rawValue {
            NotificationCenter.default.post(name: Notification.Name("UserDidLogoutNotification"), object: nil)
            return
        }
        if code == 200 {
            guard let gameList = (savedData["data"] as? [[String: Any]]) else {return}
            var gameListModels: [GameListModel] = []
            for gameList in gameList {
                let model = GameListModel(JSON: gameList , context: nil)!
                gameListModels.append(model)
            }
            GameManager.shared.gameListModels = gameListModels
        }
    }
    let networker = MoyaProvider<GameService>()
    networker.request(.getIndexList) { result in
        switch result {
        case let .success(response): do {
            let data = try? response.mapJSON()
            if data == nil {return}
            let json = JSON(data!)
            let responseData = json.dictionaryObject!
            let code = responseData["code"] as! Int
            if code == NetworkErrorType.NeedLogin.rawValue {
                NotificationCenter.default.post(name: Notification.Name("UserDidLogoutNotification"), object: nil)
                return
            }
            if code == 200 {
                guard let gameList = (responseData["data"] as? [[String: Any]]) else {return}
                var gameListModels: [GameListModel] = []
                for gameList in gameList {
                    //                        guard let games = gameList as? [String: Any] else {return}
                    let model = GameListModel(JSON: gameList , context: nil)!
                    //                        for newModel in model.list{
                    //                            print("model model   \(newModel.name)")
                    //                        }
                    //
                    gameListModels.append(model)
                }
                GameManager.shared.gameListModels = gameListModels
                UserDefaults.standard.set(responseData, forKey: "GameGetIndexListData")
            }
            else {
                //print("获取首页数据失败：", responseData["msg"]!)
                delay(interval: 2) {
                    downloadGameCoversInAdvance()
                }
            }
        }
        case .failure(_): do {
            //print("获取首页数据失败：网络错误")
            delay(interval: 2) {
                downloadGameCoversInAdvance()
            }
        }
            break
        }
    }
    
    
}

var downloadingIndex = 0
var gameCoverUrlStrings: [String] = []
func downloadImages(urlStrings: [String]) {
    downloadingIndex = 0
    
    gameCoverUrlStrings = urlStrings
    downloadImageOneByOne()
}

// 逐张下载图片
func downloadImageOneByOne() {
    if downloadingIndex < 0 || downloadingIndex >= gameCoverUrlStrings.count {
        return
    }
    
    let url = gameCoverUrlStrings[downloadingIndex]
    if let realUrl = URL(string: url) {
        //        print("开始下载第\(downloadingIndex)张图片")
        SDWebImageManager.shared.loadImage(with: realUrl, progress: nil) { image, data, error, cacheType, finished, url in
            if error == nil {
                //                print("成功下载第\(downloadingIndex)张图片")
            }
            else {
                //                print("下载第\(downloadingIndex)张图片失败！")
            }
            
            downloadingIndex += 1
            downloadImageOneByOne()
        }
    }
}

func stopDownloadingImage() {
    downloadingIndex = -88
}


// 获取游戏平台数据
func requestGamePlatforms() {
    let networker = MoyaProvider<GameService>()
    networker.request(.getGamePlatformList) { result in
        switch result {
        case let .success(response): do {
            let data = try? response.mapJSON()
            if data == nil {return}
            let json = JSON(data!)
            let responseData = json.dictionaryObject!
            let code = responseData["code"] as! Int
            if code == NetworkErrorType.NeedLogin.rawValue {
                return
            }
            if code == 200 {
                print("获取游戏平台列表成功 \(responseData)")
                guard let platforms = (responseData["data"] as? [[String: Any]]) else {return}
//                // 增加一个All平台，放在第一位
//                let firstPlatform = ["platformId": "0", "platformName": i18n(string: "All"), "platformAbbr": i18n(string: "All"), "platformLogo": ""]
//                platforms.insert(firstPlatform, at: 0)
                save(gamePlatforms: platforms)
                //                    print("游戏平台列表：", platforms)
            }
            else {
                //print("获取游戏平台列表失败", responseData["msg"]!)
                delay(interval: 2) {
                    requestGamePlatforms()
                }
            }
        }
        case .failure(_): do {
            //print("获取游戏平台列表失败：网络错误")
        }
            break
        }
    }
}


// 获取所有游戏
func requestAllGames() {
    var allModels: [SearchGameModel] = []
    let networker = MoyaProvider<GameService>()
    networker.request(.getSearchGameList(page: nil, categoryID: nil, keyword: nil)) { result in
        switch result {
        case let .success(response): do {
            let data = try? response.mapJSON()
            if data == nil {return}
            let json = JSON(data!)
            let responseData = json.dictionaryObject!
            let code = responseData["code"] as! Int
            if code == NetworkErrorType.NeedLogin.rawValue {
                return
            }
            if code == 200 {
                guard let gameList = (responseData["data"] as? [String: Any])?["list"] as? [[String: Any]] else {return}
                for game in gameList {
                    let model = SearchGameModel(JSONString: game.string()!)!
                    allModels.append(model)
                }
                //                    print("获取所有游戏成功：", gameList)
                GameManager.shared.allGames = allModels// 保存数据
//                print("获取所有游戏", responseData)
            }
            else {
                //print("获取所有游戏失败", responseData["msg"]!)
                delay(interval: 2) {
                    requestAllGames()
                }
            }
        }
        case .failure(_): do {
            //print("网络错误")
            delay(interval: 2) {
                requestAllGames()
            }
        }
            break
        }
    }
}

// MARK: 手柄名称
let gamepadNameKey = "GamepadNameKey"
func getControllerName() -> String {
    return UserDefaults.standard.object(forKey: gamepadNameKey) as? String ?? ""
}

func setControllerName(name: String) {
    UserDefaults.standard.set(name, forKey: gamepadNameKey)
}

var latestControllerFirmwareVersion = ""// 选中固件的版本号，如0.1
var selectedControllerFirmwareFilePath = URL(string: "")// 选中固件的路径
var selectedControllerFirmwareVersion = ""// 选中固件的版本号，如0.1
var selectedControllerFirmwareDate = ""// 选中固件的日期，如2023-11-07
var selectedControllerFirmwareReleaseNotes = ""// 选中固件的更新说明
var controllerFirmwareDatas: [[String: Any]] = []

// MARK: 获取手柄的最新固件信息（此方法需在连接手柄之后再调用，以下内容基于手柄的名称创建文件夹）
func requestControllerFirmwares() {
    
    let controllerName = getControllerName()
    // 获取新固件
    let networker = MoyaProvider<ControllerService>()
    networker.request(.getControllerFirmwares(gamepadName: controllerName)) { result in
        switch result {
        case let .success(response): do {
            let data = try? response.mapJSON()
            if data == nil {return}
            let json = JSON(data!)
            let responseData = json.dictionaryObject!
            let code = responseData["status"] as! Int
            
            if code == 1 {
//                let updateStatus = responseData["data"] as? Int// 强制升级/非强制升级
                let firmwares = (responseData["data"] as? Array<[String: AnyObject]>)
                print("拿到手柄的最新固件信息：", firmwares as Any)
                controllerFirmwareDatas = firmwares!
                
                let asyncQueue = DispatchQueue(label: "downloadFirmwareFiles", attributes: .concurrent)
                asyncQueue.async {
                    if firmwares != nil {
                        for index in 0..<firmwares!.count {
                            let firmwareData = firmwares![index]
                            let version = firmwareData["ver"] as! String
                            
                            let filePath = firmwareData["path"] as! String
                            downloadFirmwareFile(path: URL(string: filePath)!, controllerName: controllerName, version: version)
                        }
                    }
                }
                
                // 获取最新版固件的信息
                if firmwares != nil && firmwares!.count > 0 {
                    let latestFirmwareData = firmwares![0]
                    latestControllerFirmwareVersion = latestFirmwareData["ver"] as! String
                    selectFirmware(data: latestFirmwareData)
                }
            }
            else {
                print("获取手柄的最新固件信息：", responseData["msg"]!)
                delay(interval: 2) {
                    requestGamePlatforms()
                }
            }
        }
        case .failure(_): do {
            print("获取手柄的最新固件信息：网络错误")
        }
            break
        }
    }
}

// 说明：固件保存路径：Firmwares/手柄名称/版本号/*.bin
private let firmwaresDirectoryName = "Firmwares"
func downloadFirmwareFile(path: URL, controllerName: String, version: String) {
    let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    // 创建Firmwares文件夹
    let firmwaresURL = documentDirectoryURL.appendingPathComponent(firmwaresDirectoryName)
    if !FileManager.default.fileExists(atPath: firmwaresURL.path) {
        do {
            try FileManager.default.createDirectory(at: firmwaresURL, withIntermediateDirectories: true, attributes: nil)
            print("创建Firmwares文件夹 成功")
        } catch {
            print("创建Firmwares文件夹 失败：\(error)")
        }
    }
    else {
        print("Firmwares文件夹已经存在，无需创建")
    }
    
    // 创建手柄名文件夹
    let controllerDirectoryURL = documentDirectoryURL.appendingPathComponent("\(firmwaresDirectoryName)/\(controllerName)")
    if !FileManager.default.fileExists(atPath: controllerDirectoryURL.path) {
        do {
            try FileManager.default.createDirectory(at: controllerDirectoryURL, withIntermediateDirectories: true, attributes: nil)
            print("创建\(controllerName)文件夹 成功")
        } catch {
            print("创建\(controllerName)文件夹 失败：\(error)")
        }
    }
    else {
        print("\(controllerName)文件夹已经存在，无需创建")
    }
    
    // 创建版本号文件夹
    let versionDirectoryURL = documentDirectoryURL.appendingPathComponent("\(firmwaresDirectoryName)/\(controllerName)/\(version)")
    // 先删除已经下载的固件
    do {
        try FileManager.default.removeItem(at: versionDirectoryURL)
        print("删除文件夹\(controllerName)/\(version)成功")
    }
    catch {
        print("删除文件夹\(controllerName)/\(version) 失败：", error)
    }
    
    if !FileManager.default.fileExists(atPath: versionDirectoryURL.path) {
        do {
            try FileManager.default.createDirectory(at: versionDirectoryURL, withIntermediateDirectories: true, attributes: nil)
            print("创建\(controllerName)/\(version)文件夹 成功")
        } catch {
            print("创建\(controllerName)/\(version)文件夹 失败：\(error)")
        }
    }
    else {
        print("\(controllerName)/\(version)文件夹已经存在，无需创建")
    }
    
    
    let downloadTask = URLSession.shared.downloadTask(with: path) { (location, response, error) in
        if let sourceLocation = location {
            print("下载固件成功")
            do {
                let fileName = path.absoluteString.components(separatedBy: "/").last!
                let destinationURL = documentDirectoryURL.appendingPathComponent("\(firmwaresDirectoryName)/\(controllerName)/\(version)/\(fileName)")
                try FileManager.default.moveItem(at: sourceLocation, to: destinationURL)
                print("将下载的固件移动到指定位置 成功")
                
                unzipFile(source: destinationURL, toDirectory: versionDirectoryURL)
            }
            catch {
                print("将下载的固件移动到指定位置 失败：\(error)")
            }
        }
        else {
            print("下载失败：\(error?.localizedDescription ?? "未知错误")")
        }
    }
    downloadTask.resume()
}

func unzipFile(source: URL, toDirectory: URL) {
    do {
        try FileManager().unzipItem(at: source, to: toDirectory)
        print("解压固件压缩包 成功")
        
        // 删除zip文件
        try FileManager.default.removeItem(at: source)
        print("删除固件压缩包 成功")
    }
    catch {
        print("解压固件压缩包 ：\(error.localizedDescription )")
    }
}

func selectFirmware(data: [String: Any]) {
    if data.count == 0 {
        return
    }
    
    // 版本号
    let version = data["ver"] as! String
    selectedControllerFirmwareVersion = version
    
    // 更新说明
    if isUsingChinese() {
        selectedControllerFirmwareReleaseNotes = data["upgrade_msg"] as! String
    }
    else {
        selectedControllerFirmwareReleaseNotes = data["upgrade_en_msg"] as! String
    }
    
    // 日期
    let date = data["upgrade_time"] as! String
    selectedControllerFirmwareDate = date
    
    let bins = (data["manifest"] as? Array<[String: AnyObject]>)
    if bins != nil && bins!.count > 0 {
        for bin in bins! {
            let binName = bin["bin_file"] as? String ?? ""
            if binName.contains("main") {// iOS端的固件升级只用到m1c_usb_main.bin
                let version = bin["ver"] as? String ?? ""// 0.1
                let controllerName = getControllerName()
                // 固件的本地路径
                selectedControllerFirmwareFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(firmwaresDirectoryName)/\(controllerName)/\(version)/\(binName)")
                print("已选择固件的路径：", selectedControllerFirmwareFilePath as Any)
            }
        }
    }
}

extension Data {
    var bytes: [UInt8] {
        return [UInt8](self)
    }
}

// MARK: 全局弹窗提示切换MFi模式
private let isInMFiModeKey = "InMFiModeKey"
func checkIfInMFiMode() -> Bool {
    let isInMFiMode = UserDefaults.standard.bool(forKey: isInMFiModeKey)
    if !isInMFiMode && getControllerName().lowercased() == "leadjoy-m1c" {
//        if UIViewController.current() is LaunchViewController {// 启动页不弹此窗
//            return true
//        }
        
        if UIViewController.current()?.view.subviews.last is SwitchMFiAlertView {
            return true
        }
        
        let alertView = SwitchMFiAlertView(frame: UIScreen.main.bounds)
        UIViewController.current()?.view.addSubview(alertView)
        print("当前ViewController：\(UIViewController.current() as Any)")
        
        // 重新让AppDelegate监听手柄按键
        eggshellAppDelegate().unobserveGamepadKey()
        eggshellAppDelegate().observeGamepadKey()
    }
    
    return isInMFiMode
}

enum ABXYLayout: Int {
    case MFi = 0
    case Switch = 1
}

// TODO: 改为默认MFi模式
let mfiABXYLayoutKey = "IsMFiABXYLayoutKey"
func abxyLayout() -> ABXYLayout.RawValue {
    return ABXYLayout.RawValue(UserDefaults.standard.integer(forKey: mfiABXYLayoutKey))
}

func isMFiLayout() -> Bool {
    return UserDefaults.standard.integer(forKey: mfiABXYLayoutKey) == ABXYLayout.MFi.rawValue
}

func isConnectedLeadJoyM1Controller() -> Bool {
    return getControllerName().lowercased() == "leadjoy-m1c"
}

var isDisplayingControllerTestingView = false

// MARK: 更新用户信息
func refreshUserInfo() {
    // 获取用户信息，接口2.5
    let networker = MoyaProvider<UserService>()
    networker.request(.getUserInfo) { result in
        switch result {
        case let .success(response): do {
            let data = try? response.mapJSON()
            if data != nil {
                let json = JSON(data!)
                let responseData = json.dictionaryObject!
                let code = responseData["code"] as! Int
                if code == NetworkErrorType.NeedLogin.rawValue {
                    return
                }
                if code == 200 {
                    print("更新用户数据成功")
                    // 保存用户信息
                    saveUserInfo(info: (responseData["data"] as! [String: Any])["userinfo"] as! [String: Any])
                    NotificationCenter.default.post(name: Notification.Name("UserDidUpdateInfoNotification"), object: nil)
                }
                else {
                    print("更新用户数据失败", responseData["msg"]!)
                }
            }
        }
        case .failure(_): do {
            print("网络错误")
        }
            break
        }
    }
}

//private var joyconDetailKey: Void?
//extension AppDelegate /*! 手柄详情 !*/ {
//    var joyconDetailData: [String]?{
//        get {
//            return objc_getAssociatedObject(self, &joyconDetailKey) as? [String]
//        }
//        set {
//            objc_setAssociatedObject(self, &joyconDetailKey, newValue, .OBJC_ASSOCIATION_RETAIN)
//            
//            if let versionData = joyconDetailData {
//                let bigVersion = GSDataTool.int(withHexString: versionData[0])
//                let smallVersion = GSDataTool.int(withHexString: versionData[1])
//                let version = "\(bigVersion).\(smallVersion)"
//                let currentVersion = version
//                NotificationCenter.default
//                    .post(name: NSNotification.Name("AppDelegateDidChangeJoyconDetailData"),
//                          object: version)
//                
//            }
//            
//        }
//    }
//    
//}
