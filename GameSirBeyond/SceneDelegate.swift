//
//  SceneDelegate.swift
//  GameSirBeyond
//
//  Created by 刘富铭 on 2024/2/29.
//

import UIKit
import SwiftyJSON
import Moya
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        // 确保当前 appdelegate已经运行完毕
        NotificationCenter.default.addObserver(forName: Notification.Name("SceneDelegateRunLogoutScript"), object: nil, queue: OperationQueue.main) { [weak self] notification in
           
            guard let `self` = self else { return }
            self.toLogin()
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name("AppToHomePage"), object: nil, queue: OperationQueue.main) { [weak self] notification in
           
            guard let `self` = self else { return }
            self.toHome()
        }
        /* 内测时建议先不要注册这两个通知。
        NotificationCenter.default.addObserver(self, selector: #selector(didConnectGamepad), name: Notification.Name("DidConnectControllerNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didDisconnectGamepad), name: Notification.Name("DidDisconnectControllerNotification"), object: nil)
        */
        GSAuthTool.readUNUserNotificationCenterState()
        GSAuthTool.readPhotoLibraryPermission()
        
        /// 用户emoji背景色
        emojiColorLocatStrong()
        
        // 是否有本地token
        checkLocatStrong { [weak self] in
            guard let `self` = self else {return}
            guard $0 == true else {
                self.toLogin()
                return
            }
            
            // 本地token是否有效
            self.checkToken { [weak self](reslut, _) in
                guard let `self` = self else {return}
                guard reslut == true else {
                    self.toLogin()
                    return
                }
                
                // 是否已完成登录，指引等操作
                self.refreshUserInfo {[weak self] (refresh, _) in
                    guard let `self` = self else {return}
                    let emoji = getUserEmojiString().isBlank == false
                    let phone = getBindPhoneNumber().isBlank == false
                    let keyPrompt = getUserKeyPrompt() == "1"
                    let guide = getUserGuide() == "1"
                    let username = getUsername().isBlank == false
                    var ifNeedNoti = UserDefaultWrapper<Int?>(key: UserDefaultKeys.ifNeedNoti)
                    let noti = ifNeedNoti.wrappedValue != 0
                    
                    var ifNeedLibrary = UserDefaultWrapper<Int?>(key: UserDefaultKeys.ifNeedLibrary)
                    let library = ifNeedLibrary.wrappedValue != 0
                    
                    if (emoji && phone && keyPrompt && guide && username && noti && library && reslut){
                        self.toHome()
                    }
                    else {
                        self.toLogin()
                    }
                }
            }
            
        }
        
    }
    
    func emojiColorLocatStrong(){
        var emojiColro = UserDefaultWrapper<String?>(key: UserDefaultKeys.saveEmojiColor)
        if emojiColro.wrappedValue == nil {
            emojiColro.wrappedValue = "#ADED5C"
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func didConnectGamepad(){
        print("手柄已链接，检测是否有登录信息")
        
        // 是否有本地token
        checkLocatStrong { [weak self] in
            guard let `self` = self else {return}
            guard $0 == true else {
                self.toLogin()
                return
            }
            
            // 本地token是否有效
            self.checkToken { [weak self](reslut, _) in
                guard let `self` = self else {return}
                guard reslut == true else {
                    self.toLogin()
                    return
                }
                
                // 是否已完成登录，指引等操作
                self.refreshUserInfo {[weak self] (refresh, _) in
                    guard let `self` = self else {return}
                    let emoji = getUserEmojiString().isBlank == false
                    let phone = getBindPhoneNumber().isBlank == false
                    let keyPrompt = getUserKeyPrompt() == "1"
                    let guide = getUserGuide() == "1"
                    let username = getUsername().isBlank == false
                    var ifNeedNoti = UserDefaultWrapper<Int?>(key: UserDefaultKeys.ifNeedNoti)
                    let noti = (ifNeedNoti.wrappedValue != 0 && ifNeedNoti.wrappedValue != nil)
                    
                    var ifNeedLibrary = UserDefaultWrapper<Int?>(key: UserDefaultKeys.ifNeedLibrary)
                    let library = (ifNeedLibrary.wrappedValue != 0 && ifNeedLibrary.wrappedValue != nil)
                    
                    if (emoji && phone && keyPrompt && guide && username && noti && library && reslut){
                        self.toHome()
                    }
                    else {
                        self.toLogin()
                    }
                }
            }
            
        }
        
    }
    
    @objc func didDisconnectGamepad(){
        //toBuy() // 这个去购买的，正式的时候再打开吧
    }
    
    func toBuy(){
        print("手柄已断开链接，去购买页面")
        let buy = GSBuyViewController()
        let navPage = UINavigationController(rootViewController: buy)
        self.window?.backgroundColor = .white
        self.window?.rootViewController = navPage
        buy.onBuyHandler = {[weak self] in
            guard let `self` = self else { return }
            // 跳转h5
        }
    }
    
    func toHome(){
        let home = GameViewController()
        let navPage = UINavigationController(rootViewController: home)
        window?.backgroundColor = .black
        window?.rootViewController = navPage
    }
    
    func toUserInfo(){
        let vc = GSUserInfoViewController()
        vc.regisNotis()
        let navPage = UINavigationController(rootViewController: vc)
        window?.backgroundColor = .black
        window?.rootViewController = navPage
    }
    
    func toLogin(){
        let sign = GSWelcomeSignViewController()
        let navPage = UINavigationController(rootViewController: sign)
        self.window?.backgroundColor = .white
        self.window?.rootViewController = navPage
        
        sign.doneWithSignHandler = {[weak self] in
            
            guard let `self` = self , let window = `self`.window else { return }
            /// 可以添加一个转床动画【淡入淡出】
            let userInfo = GameViewController()
            let navPage = UINavigationController(rootViewController: userInfo)
            window.backgroundColor = .black
            userInfo.view.alpha = 0
            userInfo.view.transform3D = CATransform3DMakeScale(0.8, 0.8, 0.8)
            window.rootViewController = navPage
            UIView.animate(withDuration: 0.3) {
                userInfo.view.alpha = 1
                userInfo.view.transform3D = CATransform3DMakeScale(1, 1, 1)
            }
        }
    }
    
    func toMineInfo(){
        let vc = GSUserInfoViewController()
        let navPage = UINavigationController(rootViewController: vc)
        self.window?.backgroundColor = .white
        self.window?.rootViewController = navPage
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        print(#function)
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        print(#function)
        
        appPauseVideo()
        (UIApplication.shared.delegate as? AppDelegate)?.saveSpecifiedTimeScreenshot()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        print(#function)
        
        appPauseVideo()
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        print(#function)
        
        if appEnteredBackground {
            appEnteredBackground = false
            
            delay(interval: 1) {// 延迟检测，保证UIViewController.current()有值
                _ = checkIfInMFiMode()// 不能放在sceneDidBecomeActive，因为关闭Apple ID登录页面后会调用sceneDidBecomeActive
            }
        }
    }
    
    var appEnteredBackground = false
    func sceneDidEnterBackground(_ scene: UIScene) {
        print(#function)
        
        appEnteredBackground = true
    }
    
    // MARK: 更新用户信息
    func refreshUserInfo(x:@escaping CallbackReslut) {
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
                    print("responseData == \(responseData)")
                    if code == NetworkErrorType.NeedLogin.rawValue {
                        print("更新用户数据失败，需要重新登录")
                        x(false,nil)
                        return
                    }
                    if code == 200 {
                        print("更新用户数据成功")
                        saveUserInfo(info: (responseData["data"] as! [String: Any])["userinfo"] as! [String: Any])
                        NotificationCenter.default.post(name: Notification.Name("UserDidUpdateInfoNotification"), object: nil)
                        x(true,responseData["data"] as? [String : Any])
                    }
                    else {
                        print("更新用户数据失败", responseData["msg"]!)
                        x(false,nil)
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
    
    
    // 用户登录和数据
    func checkToken(x:@escaping CallbackReslut) {
        let networker = MoyaProvider<UserService>()
        networker.request(.checkTokenEnabled) {[weak self]  result in
            guard let `self` = self else { return }
            switch result {
            case let .success(response): do {
                let data = try? response.mapJSON()
                if data == nil {return}
                let json = JSON(data!)
                let responseData = json.dictionaryObject!
                let code = responseData["code"] as! Int
                if code == NetworkErrorType.NeedLogin.rawValue {
                    x(false,nil)
                    NotificationCenter.default.post(name: Notification.Name("UserDidLogoutNotification"), object: nil)
                    return
                }
                if code == 200 || code == 201 {
                    print("Token依然有效，仍处于登录状态")
                    x(true,responseData)
                }
                else {
                    print("Token已过期，需重新登录", responseData["msg"]!)
                    x(false,nil)
                }
            }
            case .failure(_): do {
                print("网络错误")
                x(false,nil)
            }
                break
            }
        }
    }
    
    /// 检查本地用户数据
    func checkLocatStrong(x:@escaping Callback){
        x(getUserInfo().count > 0)
    }
}


