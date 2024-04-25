//
//  GSWelcomeSignViewController.swift
//  GameSirBeyond
//
//  Created by lu on 2024/3/22.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import FirebaseCore
import GoogleSignIn
import FirebaseAuth
import AuthenticationServices
import Moya
import SwiftyJSON
//import IQKeyboardManager
class GSWelcomeSignViewController: UIViewController {
  
    /// 完成登录流程，返回首页
    open var doneWithSignHandler = {() in
        
    }
    
    var menuAgainFlag = false
    var tokenEffective = false
    var onPressing = false
    let disposeBag = DisposeBag()
    let screenshotLongPressedID = "screenshotLongPressed.id"
    var screenshotLongPressedTime = ScreenshotLongPressSpaceTime
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        prepareUI()
        
        regisNotis()
        
        redo()
        
    }
    
    func prepareUI(){
        self.view.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalTo(self.view)
        }
        
        // -----
        contentView.codeView.backBtn.backEnterHandler = { [weak self] in
            guard let `self` = self else { return }
            self.pressBIn()
        }
        
        contentView.codeView.backBtn.backHandler = {[weak self] in
            guard let `self` = self else { return }
            self.pressBOut()
        }
        
        // -----
        contentView.codeInputView.backBtn.backEnterHandler = { [weak self] in
            guard let `self` = self else { return }
            self.pressBIn()
        }
        
        contentView.codeInputView.backBtn.backHandler = {[weak self] in
            guard let `self` = self else { return }
            self.pressBOut()
        }
      
        // ----
        contentView.shareIntroView.backBtn.backEnterHandler = { [weak self] in
            guard let `self` = self else { return }
            self.pressBIn()
        }
        
        contentView.shareIntroView.backBtn.backHandler = {[weak self] in
            guard let `self` = self else { return }
            self.pressBOut()
        }
        
      
        // ----
        contentView.showView.backBtn.backEnterHandler = { [weak self] in
            guard let `self` = self else { return }
            self.pressBIn()
        }
        
        contentView.showView.backBtn.backHandler = {[weak self] in
            guard let `self` = self else { return }
            self.pressBOut()
        }
        
       
        // ----
        contentView.notiAuthView.backBtn.backEnterHandler = { [weak self] in
            guard let `self` = self else { return }
            self.pressBIn()
        }
        
        contentView.notiAuthView.backBtn.backHandler = {[weak self] in
            guard let `self` = self else { return }
            self.pressBOut()
        }
        
        contentView.notiAuthView.touchBtnAgain = {[weak self](onFcourId:Int) in
            guard let `self` = self else { return }
            self.pressAOut()
        }
        
        // ----
        contentView.libAuthView.backBtn.backEnterHandler = { [weak self] in
            guard let `self` = self else { return }
            self.pressBIn()
        }
        
        contentView.libAuthView.backBtn.backHandler = {[weak self] in
            guard let `self` = self else { return }
            self.pressBOut()
        }
        
        contentView.libAuthView.touchAgainHandler = {[weak self](onFcourId:Int) in
            guard let `self` = self else { return }
            self.pressAOut()
        }
        
        
        
        // ----
        contentView.shellView.backBtn.backEnterHandler = { [weak self] in
            guard let `self` = self else { return }
            self.pressBIn()
        }
        
        contentView.shellView.backBtn.backHandler = {[weak self] in
            guard let `self` = self else { return }
            self.pressBOut()
        }
        
        // ----
        contentView.shellTwoView.backBtn.backEnterHandler = { [weak self] in
            guard let `self` = self else { return }
            self.pressBIn()
        }
        
        contentView.shellTwoView.backBtn.backHandler = {[weak self] in
            guard let `self` = self else { return }
            self.pressBOut()
        }
        
        // ----
        contentView.shellThreeView.backBtn.backEnterHandler = { [weak self] in
            guard let `self` = self else { return }
            self.pressBIn()
        }
        
        contentView.shellThreeView.backBtn.backHandler = {[weak self] in
            guard let `self` = self else { return }
            self.pressBOut()
        }
     
        // ----
        contentView.shellFourView.backBtn.backEnterHandler = { [weak self] in
            guard let `self` = self else { return }
            self.pressBIn()
        }
        
        contentView.shellFourView.backBtn.backHandler = {[weak self] in
            guard let `self` = self else { return }
            self.pressBOut()
        }
        
        
        // ----
        contentView.shellFiveView.backBtn.backEnterHandler = { [weak self] in
            guard let `self` = self else { return }
            self.pressBIn()
        }
        
        contentView.shellFiveView.backBtn.backHandler = {[weak self] in
            guard let `self` = self else { return }
            self.pressBOut()
        }
        
        contentView.codeView.sendCodeCallBack = {[weak self](result:Bool) in
            guard let `self` = self else { return }
            print("sendCodeCallBack")
            self.getSmsCode()
        }
        
        contentView.defaultUI()
    }
    
    
    func addTectView(){
        self.view.setNeedsLayout()
        tectView = TectView(frame: CGRectMake(kWidth - 240, 0, 240, kHeight))
        view.addSubview(tectView)
        tectView.backgroundColor = .blue
        tectView.alpha = 0.2
        self.view.layoutIfNeeded()
    }
    
    var tectView:TectView!
 
    func getSmsCode(){
        guard let phone = contentView.codeView.phoneTF.text else { return }
        let zone = "86"
        let networker = MoyaProvider<UserService>()
        networker.request(.getSmsCode(mobile: phone, event: "bindmobile", zone: zone)) {[weak self] result in
            guard let `self` = self else { return }
            switch result {
            case let .success(response): do {
                let data = try? response.mapJSON()
                let json = JSON(data!)
                let responseData = json.dictionaryObject!
                let code = responseData["code"] as! Int
                if code == 200 {
                    print("验证码已发送 【666666】")
                    delay(interval: 0.15) {self.scrNext()}
                }
                else {
                    print("验证码发送失败", responseData["msg"] as Any)
                    //MBProgressHUD.showMsgWithtext(i18n(string: "Failed to bind mobile number") + i18n(string: ":") + (responseData["msg"] as! String))
                }
            }
            case .failure(_): do {
                print("网络错误")
            }
                break
            }
        }
    }
    
    func googleSign(){
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else {return}
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                print("google 授权失败")
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
         
//            var thirdSignName =  UserDefaultWrapper<String?>(key: UserDefaultKeys.thirdSignName)
//            thirdSignName.wrappedValue = result?.user.profile?.name
            // 调用蛋壳登录接口
            let networker = MoyaProvider<UserService>()
            networker.request(.loginFromThirdPlatform(platform: ThirdLoginPlatform.google.rawValue, openID: result?.user.userID ?? "", unionID: "", nickname: result?.user.profile?.name ?? "", email: result?.user.profile?.email ?? "")) { result in
                switch result {
                case let .success(response): do {
                    print("response  == \(response)")
                    let data = try? response.mapJSON()
                    if  data == nil {
                        print("网络错误 data == nil")
                        return
                    }
                    let json = JSON(data!)
                    let responseData = json.dictionaryObject!
                    let code = responseData["code"] as! Int
                    if code == 200 {
                        print("登录成功")
                        self.loggedIn(responseData: responseData)
                        self.contentView.loginViewFade(fade: true)
                        /*
                        self.refreshUserInfo {[unowned self] (refresh, data) in
                            
                            guard refresh == true else {
                                // 如果刷新用户失败，则继续
                                delay(interval: 0.15) {self.scrNext()}
                                return
                            }
                            
                            self.contentView.rebuildUI()
                            // 表示已经获取了相对应的用户数据，可以编排 contentview的scr
                            //delay(interval: 0.15) {self.scrNext()}
                        }
                         */
                    }
                    else {
                        print("登录失败", code, responseData["msg"] as Any)
                    }
                    
                }
                case .failure(_): do {
                    print("网络错误")
                }
                    break
                }
                
            }
        }
    }
    var appleIDInfoTextView: UITextView = UITextView.init(frame: CGRect.zero)// 用于展示appleID授权信息
    
    
    lazy var contentView = GameLoginWelcomeView(visual: CGSize(width: kWidth, height: kHeight))
    
    @objc func scrNextAndRecommendPhone(){
//        var phone = UserDefaultWrapper<String?>(key: UserDefaultKeys.ifNeedBindPhone)
//        phone.wrappedValue = contentView.codeView.phoneTF.text
//        scrNext()
        
        /** 分2种情况
         如果使用第三方账号登录 -> 绑定手机号，接口2.12
         如果使用手机号码登录 -> 手机号一键登录（如果未注册则默认注册），接口2.10
         */
        guard let phone = contentView.codeView.phoneTF.text else { return }
        let code = contentView.codeInputView.pinCodeInputView.text
        let zone = "86"
        if isLoginFromThirdPlatform() {
            let networker = MoyaProvider<UserService>()
            networker.request(.bindPhoneNumber(phoneNumber: phone, zone: zone, smsCode: code)) {[weak self] result in
                guard let `self` = self else { return }
                switch result {
                case let .success(response): do {
                    let data = try? response.mapJSON()
                    let json = JSON(data!)
                    let responseData = json.dictionaryObject!
                    let code = responseData["code"] as! Int
                    if code == 200 {
                        print("绑定手机号码成功 \(responseData)")
                        //MBProgressHUD.showMsgWithtext(i18n(string: "Bind mobile number successfully"))
                        setBindPhoneNumber(moblie: phone)
                        self.scrNext()
                    }
                    else {
                        print("绑定手机号码失败", responseData["msg"] as Any)
                        //MBProgressHUD.showMsgWithtext(i18n(string: "Failed to bind mobile number") + i18n(string: ":") + (responseData["msg"] as! String))
                    }
                }
                case .failure(_): do {
                    print("网络错误")
                }
                    break
                }
            }
        }
        else {
            let networker = MoyaProvider<UserService>()
            networker.request(.registerAndLogin(phoneNumber: phone, zone: zone, smsCode: code)) { result in
                switch result {
                case let .success(response): do {

                    let data = try? response.mapJSON()
                    let json = JSON(data!)
                    if  data == nil {
//                        MBProgressHUD.showMsg(in: self, text: "网络错误")
                        return
                    }
                    let responseData = json.dictionaryObject!
                    let code = responseData["code"] as! Int
                    if code == 200 {
                        print("登录成功，进入下一页")
                        //MBProgressHUD.showMsgWithtext(i18n(string: "Logged in"))
                        self.loggedIn(responseData: responseData)
                    }
                    else {
                        //MBProgressHUD.showMsgWithtext(i18n(string: "Failed to log in") + i18n(string: ":") + (responseData["msg"] as! String))
                        print("登录失败", responseData["msg"]!)
                    }
                }
                case .failure(_): do {
                    print("网络错误")
                }
                    break
                }
            }
        }
    }
    
    @objc func scrNext(){
        contentView.endEditing(false)
        let contentOffX = Int(contentView.scr.contentOffset.x / kWidth)
        guard kWidth * CGFloat(contentOffX + 1) < contentView.scr.contentSize.width else {
            print("scr 超出内容")
            return
        }
       
        contentView.scr.setContentOffset(CGPointMake(kWidth * CGFloat(contentOffX + 1), 0), animated: true)
        
    }
    
    @objc func scrBack(){
        contentView.endEditing(false)
        let contentOffX = Int(contentView.scr.contentOffset.x / kWidth)
        guard contentOffX - 1 >= 0 else {
            print("scr 超出内容")
            return
        }
        contentView.scr.setContentOffset(CGPointMake(kWidth * CGFloat(contentOffX - 1), 0), animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        // 重新标注 appdelegate
        //eggshellAppDelegate().observeGamepadKey()
    }
    
    func appleLogin(){
        let provider = ASAuthorizationAppleIDProvider.init()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController.init(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    func loggedIn(responseData: [String: Any]) {
        saveLoginPlatform(isThirdPlatform: true)
        
        delay(interval: 1) {
            NotificationCenter.default.post(name: Notification.Name("UserDidLoginNotification"), object: nil)
        }
        
        let userInfo = (responseData["data"] as! [String: Any])["userinfo"] as! [String: Any]
        saveUserInfo(info: userInfo)
    }
    
    
    func uploadEmoji(){
        guard case contentView.emojiInputView.emojiTF.text?.count = 1 else { return }
        
        let networker = MoyaProvider<UserService>()
        networker.request(.uploadEmoji(emoji: contentView.emojiInputView.emojiTF.text!)) {[weak self] result in
            guard let `self` = self else { return }
            switch result {
            case let .success(response): do {
                let data = try? response.mapJSON()
                let json = JSON(data!)
                let responseData = json.dictionaryObject!
                let code = responseData["code"] as! Int
                if code == 200 {
                    print("上传emoji成功 \(responseData)")
                    setUserEmojiString(emoji: self.contentView.emojiInputView.emojiTF.text!)
                    self.scrNext()
                }
                else {
                    print("上传emoji失败", responseData["msg"] as Any)
                }
            }
            case .failure(_): do {
                print("网络错误")
            }
                break
            }
        }
    }
    
    func setApiUsername(){
        guard let text = contentView.inputNameView.nameTF.text else { return }
        guard text.isBlank == false else {
            return
        }
        let networker = MoyaProvider<UserService>()
        //.setApiUsername(name: text)
        var bio = ""
        let tmp = getUserInfo()
        if let _bio = tmp["bio"] as? String {
            bio = _bio
        }
        print("bio == \(bio)")
        networker.request(.setApiBio(bio: bio, name: text, avatar: getAvatarPath())) { [weak self] result in
            guard let `self` = self else {return}
            switch result {
            case let .success(response): do {
                let data = try? response.mapJSON()
                let json = JSON(data!)
                let responseData = json.dictionaryObject!
                let code = responseData["code"] as! Int
                if code == NetworkErrorType.NeedLogin.rawValue {
                    NotificationCenter.default.post(name: Notification.Name("UserDidLogoutNotification"), object: nil)
                    return
                }
                if code == 200 {
                    print("设置Username成功")
                    setInfoUsername(nicname: text)
                    GameSirBeyond.refreshUserInfo()
                    delay(interval: 0.15) {
                        self.scrNext()
                    }
                }
                else {
                    //MBProgressHUD.showMsgWithtext(responseData["msg"] as! String)
                    print("设置Username失败", responseData["msg"]!)
                    self.contentView.inputNameView.nameAble = false
                }
            }
            case .failure(_): do {
                print("网络错误")
            }
                break
            }
        }
    }
    
    
    func setUserKeyPromtOrGuide(keyPrompt:String?,guide:String?,x:@escaping Callback){
       
        let networker = MoyaProvider<UserService>()
        networker.request(.setKeyPromptOrGuide(keyPrompt: keyPrompt, guide: guide)) { [weak self] result in
            guard let `self` = self else {return}
            switch result {
            case let .success(response): do {
                let data = try? response.mapJSON()
                let json = JSON(data!)
                let responseData = json.dictionaryObject!
                let code = responseData["code"] as! Int
                if code == NetworkErrorType.NeedLogin.rawValue {
                    NotificationCenter.default.post(name: Notification.Name("UserDidLogoutNotification"), object: nil)
                    x(false)
                    return
                }
                if code == 200 {
                    print("设置keyPrompt 或 guide 成功")
                    GameSirBeyond.refreshUserInfo()
                    x(true)
                }
                else {
                    print("设置keyPrompt 或 guide ", responseData["msg"]!)
                    x(false)
                    
                }
            }
            case .failure(_): do {
                print("网络错误")
                x(false)
            }
                break
            }
        }
    }
}

extension GSWelcomeSignViewController:ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding{
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error){
        print("apple 登录失败 err == \(error)")
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.appleIDInfoTextView.window!
    }
    // 授权成功
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        print("授权成功")
        
        if authorization.credential.isKind(of: ASAuthorizationAppleIDCredential.self) {
            print("授权ID")
            
            let appleIDCredential = authorization.credential as! ASAuthorizationAppleIDCredential
            let user = appleIDCredential.user
            let appBundleID = Bundle.main.bundleIdentifier
            //SAMKeychain.setPassword(user, forService: appBundleID!, account: "UserAccount")// 保存密码到钥匙串
            
            // 只在第一次授权时有数据
            let givenName = appleIDCredential.fullName?.givenName
            let familyName = appleIDCredential.fullName?.familyName
            let email = appleIDCredential.email
            
//            print("appleIDCredential = \(appleIDCredential)")
//            print("user = \(user)")
//            print("appBundleID = \(appBundleID)")
//            print("givenName = \(givenName)")
//            print("familyName = \(familyName)")
//            print("email = \(email)")
            
            var nickname = ""
            if isUsingEnglish() {
                nickname = givenName?.appending(familyName ?? "") ?? ""
            }
            else {
                nickname = familyName?.appending(givenName ?? "") ?? ""
            }
            
            print("user == \(user)")
            // 调用蛋壳登录接口
            let networker = MoyaProvider<UserService>()
            networker.request(.loginFromThirdPlatform(platform: ThirdLoginPlatform.apple.rawValue, openID: user, unionID: "", nickname: nickname, email: email ?? "")) { [weak self] result in
                guard let `self` = self else { return }
                switch result {
                case let .success(response): do {
                    let data = try? response.mapJSON()
                    if  data == nil {
//                        MBProgressHUD.showMsg(in: self, text: "网络错误")
                        return
                    }
                    let json = JSON(data!)
                    let responseData = json.dictionaryObject!
                    let code = responseData["code"] as! Int
                    if code == 200 {
                        print("登录成功")
                        self.loggedIn(responseData: responseData)
                        // 由于正在使用的短信SDK无法给海外手机号码发送短信，因此暂时取消功能：强制绑定手机号码，才能使用App
                        self.contentView.loginViewFade(fade: true)
                        /*
                        self.refreshUserInfo {[unowned self] (refresh, data) in
                            
                            guard refresh == true else {
                                // 如果刷新用户失败，则继续
                                delay(interval: 0.15) {self.scrNext()}
                                return
                            }
                            // 表示已经获取了相对应的用户数据，可以编排 contentview的scr
                            //delay(interval: 0.15) {self.scrNext()}
                            self.contentView.rebuildUI()
                        }
                        */
                    }
                    else {
                        print("登录失败", code, responseData["msg"] as Any)
                    }
                }
                case .failure(_): do {
                    print("网络错误")
                }
                    break
                }
                
            }
        }
        else if authorization.credential.isKind(of: ASPasswordCredential.self) {
            print("授权密码")
            
            let passwordCredential = authorization.credential as! ASPasswordCredential
            let user = passwordCredential.user
            _ = passwordCredential.password
            
            // 调用蛋壳登录接口
            let networker = MoyaProvider<UserService>()
            networker.request(.loginFromThirdPlatform(platform: ThirdLoginPlatform.apple.rawValue, openID: user, unionID: "", nickname: "", email: "")) { [weak self] result in
                guard let `self` = self else { return }
                switch result {
                case let .success(response): do {
                    let data = try? response.mapJSON()
                    if  data == nil {
//                        MBProgressHUD.showMsg(in: self, text: "网络错误")
                        return
                    }
                    let json = JSON(data!)
                    let responseData = json.dictionaryObject!
                    let code = responseData["code"] as! Int
                    if code == 200 {
                        print("登录成功")
                        self.loggedIn(responseData: responseData)
                        // 由于正在使用的短信SDK无法给海外手机号码发送短信，因此暂时取消功能：强制绑定手机号码，才能使用App
                        self.contentView.loginViewFade(fade: true)
                        /*
                        self.refreshUserInfo {[unowned self] (refresh, data) in
                            
                            guard refresh == true else {
                                // 如果刷新用户失败，则继续
                                delay(interval: 0.15) {self.scrNext()}
                                return
                            }
                            // 表示已经获取了相对应的用户数据，可以编排 contentview的scr
                            //delay(interval: 0.15) {self.scrNext()}
                            self.contentView.rebuildUI()
                        }
                         */
                    }
                    else {
                        print("登录失败", responseData["msg"] as Any)
                    }
                }
                case .failure(_): do {
                    print("网络错误")
                }
                    break
                }
             
            }
        }
        else {
            print("授权信息不符")
        }
    }
   
}

//MARK: -----
//MARK: ----- 检查用户登录状态
extension GSWelcomeSignViewController {
    
    
   
    func regisNotis(){
      
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressAIn),
                                               name: NSNotification.Name(ControllerNotificationName.KeyAPressIn.rawValue),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressAOut),
                                               name: NSNotification.Name(ControllerNotificationName.KeyAPressOut.rawValue),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressBIn),
                                               name: NSNotification.Name(ControllerNotificationName.KeyBPressIn.rawValue),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressBOut),
                                               name: NSNotification.Name(ControllerNotificationName.KeyBPressOut.rawValue),
                                               object: nil)
        
     
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressUp),
                                               name: NSNotification.Name(ControllerNotificationName.LeftJoystickMoveUp.rawValue),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressDown),
                                               name: NSNotification.Name(ControllerNotificationName.LeftJoystickMoveDown.rawValue),
                                               object: nil)
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressScreenshot),
                                               name: NSNotification.Name(ControllerNotificationName.KeyScreenshotPressed.rawValue),
                                               object: nil)
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressHome),
                                               name: NSNotification.Name(ControllerNotificationName.KeyHomePressed.rawValue),
                                               object: nil)
        /// 输入完毕6个验证码
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(scrNextAndRecommendPhone),
                                               name: NSNotification.Name("CommitSmsCode"),
                                               object: nil)
        
        
        
        
        /// 截图，进入长按状态
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressInMenu),
                                               name: NSNotification.Name(ControllerNotificationName.KeyMenuPressIn.rawValue),
                                               object: nil)
        /// 截图，退出长按状态
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressOutMenu),
                                               name: NSNotification.Name(ControllerNotificationName.KeyMenuPressOut.rawValue),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(sureToSign),
                                               name: NSNotification.Name("SureToSign"),
                                               object: nil)
        
        // 模拟 按下首页的功能
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressOption),
                                               name: NSNotification.Name(ControllerNotificationName.KeyOPPressed.rawValue),
                                               object: nil)
        
    }
    
    @objc func pressOption(){
        guard let tagView = findScrollViewTagSubview() else { return }
        if let shell5 = tagView as? GameShellFiveView {
            NotificationCenter.default.post(name: NSNotification.Name("AppToHomePage"), object: nil)
            // 
            setUserKeyPromtOrGuide(keyPrompt: nil, guide: "1") { result in
                print("setUserKeyPromtOrGuide == \(result)")
            }
            return
        }
    }
    
    
    @objc func sureToSign(){
        self.tokenEffective = true
        self.contentView.rebuildUI()
        // 表示已经获取了相对应的用户数据，可以编排 contentview的scr
        // 已经移除登录的界面，将scr滚动到第二
        if self.contentView.scr.subviews.count < 2 {
            // 去首页
            self.doneWithSignHandler()
        }
        else {
            self.contentView.scr.setContentOffset(CGPointMake(self.contentView.visualRect.width, 0), animated: false)
        }
    }
 
    @objc func pressAIn(){
        
        onPressing = true
        guard let tagView = findScrollViewTagSubview() else { return }
        
        if let homePage = tagView as? GameLoginView {
            if homePage.idx == 0 {
              // 第一页的欢迎，并不需要处理
            }
            else {
                let fade = contentView.loginView.fade
                if fade == true {
                    if contentView.loginView.onFocusIdx == 0 {
                        contentView.loginView.setNeedsLayout()
                        contentView.loginView.appleLoginBtn.snp.remakeConstraints {
                            $0.height.equalTo(login_btn_h)
                            $0.width.equalTo(login_btn_blur_w).priority(.high)
                            $0.centerX.equalTo(contentView.loginView.welcomeLabel)
                            $0.top.equalTo(contentView.loginView.passAView.snp.bottom).offset(10.widthScale)
                        }
                        UIView.animate(withDuration: 0.25) {
                            self.contentView.layoutIfNeeded()
                        }
                    }
                    else {
                        contentView.loginView.setNeedsLayout()
                        contentView.loginView.googleLoginBtn.snp.remakeConstraints {
                            $0.height.equalTo(login_btn_h)
                            $0.width.equalTo(login_btn_blur_w).priority(.high)
                            $0.centerX.equalTo(contentView.loginView.welcomeLabel)
                            $0.top.equalTo(contentView.loginView.appleLoginBtn.snp.bottom).offset(10.widthScale)
                        }
                        UIView.animate(withDuration: 0.25) {
                            self.contentView.layoutIfNeeded()
                        }
                    }
                }
                else {
                    
                    if contentView.loginView.onFocusIdx == 0 {
                        contentView.loginView.setNeedsLayout()
                        contentView.loginView.appleLoginBtn.snp.remakeConstraints {
                            $0.height.equalTo(login_btn_h)
                            $0.width.equalTo(login_btn_blur_w).priority(.high)
                            $0.centerX.equalTo(contentView.loginView.welcomeLabel)
                            $0.top.equalTo(contentView.loginView.passAView.snp.bottom).offset(10.widthScale)
                        }
                        UIView.animate(withDuration: 0.25) {
                            self.contentView.layoutIfNeeded()
                        }
                    }
                    else {
                        contentView.loginView.setNeedsLayout()
                        contentView.loginView.googleLoginBtn.snp.remakeConstraints {
                            $0.height.equalTo(login_btn_h)
                            $0.width.equalTo(login_btn_blur_w).priority(.high)
                            $0.centerX.equalTo(contentView.loginView.welcomeLabel)
                            $0.top.equalTo(contentView.loginView.appleLoginBtn.snp.bottom).offset(10.widthScale)
                        }
                        UIView.animate(withDuration: 0.25) {
                            self.contentView.layoutIfNeeded()
                        }
                    }
                   
                }
            }
            return
        }
        
        if let phoneTFView = tagView as? GameMsgCodeView {
            UIView.animate(withDuration: 0.15) {
                phoneTFView.getCodeBtn.transform3D = CATransform3DScale(CATransform3DIdentity, Transform3DScale, Transform3DScale, Transform3DScale)
            }
            
            return
        }
        
        if let nicnameTFView = tagView as? GameInputNameView{
            guard nicnameTFView.nameTF.text?.isBlank != true else { return }
            UIView.animate(withDuration: 0.15) {
                nicnameTFView.nextBtn.transform3D = CATransform3DScale(CATransform3DIdentity, Transform3DScale, Transform3DScale, Transform3DScale)
            }
            return
        }
        
        if let share = tagView as? GameIntroduceView {
            
            if share.index == 0 {
                share.setNeedsLayout()
                share.continueBtn.snp.remakeConstraints{
                    $0.left.equalTo(share.titleL).offset(8.widthScale)
                    $0.bottom.equalTo(share.projectImage)
                    $0.right.equalTo(share.detailL).offset(-8.widthScale)
                    $0.height.equalTo(40.widthScale)
                }
                UIView.animate(withDuration: 0.2) {
                    share.layoutIfNeeded()
                }
            }
            else {
                share.setNeedsLayout()
                share.continueBtn.snp.remakeConstraints{
                    $0.left.equalTo(share.longPassView).offset(8.widthScale)
                    $0.top.equalTo(share.recordView.snp.bottom).offset(20.widthScale)
                    $0.right.equalTo(share.recordView).offset(-18.widthScale)
                    $0.height.equalTo(40.widthScale)
                }
                UIView.animate(withDuration: 0.2) {
                    share.layoutIfNeeded()
                }
            }
            
            return
        }
        
        if let shell = tagView as? GameShellView {
            shell.setNeedsLayout()
            shell.applyBtn.snp.remakeConstraints {
                $0.left.equalTo(shell.titleL).offset(16.widthScale)
                $0.right.equalTo(shell.titleL).offset(-16.widthScale)
                $0.top.equalTo(shell.subtitleL.snp.bottom).offset(24.widthScale)
                $0.height.equalTo(50.widthScale)
            }
            UIView.animate(withDuration: 0.2) {
                shell.layoutIfNeeded()
            } 
            return
        }
        
        if let shell2 = tagView as? GameShellTwoView {
            shell2.setNeedsLayout()
            shell2.applyBtn.snp.remakeConstraints {
                $0.left.equalTo(shell2.titleL).offset(8.widthScale)
                $0.right.equalTo(shell2.snp.centerX).offset(-88.widthScale)
                $0.top.equalTo(shell2.titleL.snp.bottom).offset(32.widthScale)
                $0.height.equalTo(44.widthScale)
            }
            UIView.animate(withDuration: 0.2) {
                shell2.layoutIfNeeded()
            }
            return
        }
        
        if let shell3 = tagView as? GameShellThreeView {
            shell3.setNeedsLayout()
            shell3.applyBtn.snp.remakeConstraints {
                $0.left.equalTo(shell3.titleL).offset(8.widthScale)
                $0.right.equalTo(shell3.snp.centerX).offset(-88.widthScale)
                $0.top.equalTo(shell3.subtitleL.snp.bottom).offset(32.widthScale)
                $0.height.equalTo(44.widthScale)
            }
            UIView.animate(withDuration: 0.2) {
                shell3.layoutIfNeeded()
            }
        }
        
        if let shell4 = tagView as? GameShellFourView {
            shell4.setNeedsLayout()
            shell4.applyBtn.snp.remakeConstraints {
                $0.left.equalTo(shell4.titleL).offset(8.widthScale)
                $0.right.equalTo(shell4.snp.centerX).offset(-88.widthScale)
                $0.top.equalTo(shell4.subtitleL.snp.bottom).offset(32.widthScale)
                $0.height.equalTo(44.widthScale)
            }
            UIView.animate(withDuration: 0.2) {
                shell4.layoutIfNeeded()
            }
            return
        }
        
        if let noti = tagView as? GameNotiAuthView{
            noti.setNeedsLayout()
            if noti.onFocusIdx == 0 {
                noti.applyBtn.snp.remakeConstraints {
                    $0.left.equalTo(noti.titleL).offset(8.widthScale)
                    $0.right.equalTo(noti.titleL).offset(-8.widthScale)
                    $0.top.equalTo(noti.subtitleL.snp.bottom).offset(16.widthScale)
                    $0.height.equalTo(50.widthScale)
                }
            }
            else {
                noti.lateBtn.snp.remakeConstraints {
                    $0.left.equalTo(noti.titleL).offset(8.widthScale)
                    $0.right.equalTo(noti.titleL).offset(-8.widthScale)
                    $0.top.equalTo(noti.applyBtn.snp.bottom).offset(12.widthScale)
                    $0.height.equalTo(50.widthScale)
                }
            }
            UIView.animate(withDuration: 0.2) {
                noti.layoutIfNeeded()
            }
            return
        }
        
        if let lib = tagView as? GameLibAuthView{
            lib.setNeedsLayout()
            if lib.onFocusIdx == 0 {
                lib.applyBtn.snp.remakeConstraints {
                    $0.left.equalTo(lib.titleL).offset(8.widthScale)
                    $0.right.equalTo(lib.titleL).offset(-8.widthScale)
                    $0.top.equalTo(lib.subtitleL.snp.bottom).offset(24.widthScale)
                    $0.height.equalTo(50.widthScale)
                }
            }
            else {
                lib.lateBtn.snp.remakeConstraints {
                    $0.left.equalTo(lib.titleL).offset(8.widthScale)
                    $0.right.equalTo(lib.titleL).offset(-8.widthScale)
                    $0.top.equalTo(lib.applyBtn.snp.bottom).offset(12.widthScale)
                    $0.height.equalTo(50.widthScale)
                }
            }
            UIView.animate(withDuration: 0.2) {
                lib.layoutIfNeeded()
            }
            return
        }
    }
    
    @objc func pressAOut(){
        onPressing = false
        //antiShakeNoti(name: ControllerNotificationName.KeyAPressed.rawValue, aSelector: #selector(pressA))
        
        guard let tagView = findScrollViewTagSubview() else { return }
        
        // 首页
        if let homePage = tagView as? GameLoginView {
            if homePage.idx == 0 {
                // 判断是否已经完成所有的操作
                let noti = UserDefaultWrapper<Int?>(key: UserDefaultKeys.ifNeedNoti)
                
                let library = UserDefaultWrapper<Int?>(key: UserDefaultKeys.ifNeedLibrary)
                
                //print("A --- \(noti.wrappedValue)   \(library.wrappedValue)")
                let done =  (self.tokenEffective == true)
                            && (getBindPhoneNumber().isBlank == false)
                            && (getAvatarPath().isBlank == false)
                            && (getUsername().isBlank == false)
                            && (getUserKeyPrompt() == "1")
                            && (noti.wrappedValue != 0 && noti.wrappedValue != nil)
                            && (library.wrappedValue != 0  && noti.wrappedValue != nil)
                
                done == true ? doneWithSignHandler():scrNext()
            }
            else {
                let fade = contentView.loginView.fade
                if fade == true {
                    if contentView.loginView.onFocusIdx == 0 {
                        contentView.loginView.setNeedsLayout()
                        contentView.loginView.appleLoginBtn.snp.remakeConstraints {
                            $0.height.equalTo(login_btn_h)
                            $0.width.equalTo(login_btn_focus_w).priority(.high)
                            $0.centerX.equalTo(contentView.loginView.welcomeLabel)
                            $0.top.equalTo(contentView.loginView.passAView.snp.bottom).offset(10.widthScale)
                        }
                        UIView.animate(withDuration: 0.25) {
                            self.contentView.layoutIfNeeded()
                        } completion: { finish in
                            if finish {
                                NotificationCenter.default.post(name: NSNotification.Name("SureToSign"), object: nil)
                            }
                        }
                    }
                    else {
                        
                        contentView.loginView.setNeedsLayout()
                        contentView.loginView.googleLoginBtn.snp.remakeConstraints {
                            $0.height.equalTo(login_btn_h)
                            $0.width.equalTo(login_btn_focus_w).priority(.high)
                            $0.centerX.equalTo(contentView.loginView.welcomeLabel)
                            $0.top.equalTo(contentView.loginView.appleLoginBtn.snp.bottom).offset(10.widthScale)
                        }
                        UIView.animate(withDuration: 0.25) {
                            self.contentView.layoutIfNeeded()
                        } completion: {[weak self] finish in
                            if finish {
                                removeUserInfo()
                                self?.contentView.loginView.fade = false
                            }
                        }
                        
                    }
                }
                else {
                    let appleSignIn = contentView.loginView.onFocusIdx == 0 ? true:false
                    print( appleSignIn ? "apple" : "google" + "登录")
                    if appleSignIn == true {
                        appleLogin()
                        contentView.loginView.setNeedsLayout()
                        contentView.loginView.appleLoginBtn.snp.remakeConstraints {
                            $0.height.equalTo(login_btn_h)
                            $0.width.equalTo(login_btn_focus_w).priority(.high)
                            $0.centerX.equalTo(contentView.loginView.welcomeLabel)
                            $0.top.equalTo(contentView.loginView.passAView.snp.bottom).offset(10.widthScale)
                        }
                        UIView.animate(withDuration: 0.25) {
                            self.contentView.layoutIfNeeded()
                        }
                    }
                    else{
                        
                        contentView.loginView.setNeedsLayout()
                        contentView.loginView.googleLoginBtn.snp.remakeConstraints {
                            $0.height.equalTo(login_btn_h)
                            $0.width.equalTo(login_btn_focus_w).priority(.high)
                            $0.centerX.equalTo(contentView.loginView.welcomeLabel)
                            $0.top.equalTo(contentView.loginView.appleLoginBtn.snp.bottom).offset(10.widthScale)
                        }
                        UIView.animate(withDuration: 0.25) {
                            self.contentView.layoutIfNeeded()
                        }
                        
                        googleSign()
                    }
                }
            }
            return
        }
        
        if let phoneTFView = tagView as? GameMsgCodeView{
            guard case phoneTFView.phoneTF.text?.count = 11 else {
                UIView.animate(withDuration: 0.15) {
                    phoneTFView.getCodeBtn.transform3D = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
                }
                return
            }
            guard String.isPhoneNumber(phoneNumber: phoneTFView.phoneTF.text ?? "") == true else {
                UIView.animate(withDuration: 0.15) {
                    phoneTFView.getCodeBtn.transform3D = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
                }
                print("请输入正确的手机号码")
                return
            }
            phoneTFView.sendCode()
            delay(interval: AntiShakeTime) {[weak self] in
                guard let `self` = self else { return }
                self.scrNext()
                self.contentView.codeInputView.isAgain = self.contentView.codeView.sendAgain > 1
            }
            return
        }
        
        
        if let emojiTFView = tagView as? GameInputEmojiView{
            guard case emojiTFView.emojiTF.text?.count = 1 else { return }
            uploadEmoji()
            return
        }
        
        if let nicnameTFView = tagView as? GameInputNameView{
            UIView.animate(withDuration: 0.15) {
                nicnameTFView.nextBtn.transform3D = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
            }
            guard nicnameTFView.nameTF.text?.isBlank != true else { return }
            setApiUsername()
            
            return
        }
        
        if let share = tagView as? GameIntroduceView {
            
            if share.index == 0 {
                share.setNeedsLayout()
                share.continueBtn.snp.remakeConstraints{
                    $0.left.equalTo(share.titleL).offset(0)
                    $0.bottom.equalTo(share.projectImage)
                    $0.right.equalTo(share.detailL).offset(0)
                    $0.height.equalTo(40.widthScale)
                }
                UIView.animate(withDuration: 0.2) {
                    share.layoutIfNeeded()
                } completion: {[weak self] finish in
                    if finish {
                        self?.scrNext()
                    }
                }
            }
            else {
                guard share.introduceState == .doneRecode  else { return }
                share.setNeedsLayout()
                share.continueBtn.snp.remakeConstraints{
                    $0.left.equalTo(share.longPassView).offset(0)
                    $0.top.equalTo(share.recordView.snp.bottom).offset(20.widthScale)
                    $0.right.equalTo(share.recordView).offset(-10.widthScale)
                    $0.height.equalTo(40.widthScale)
                }
                UIView.animate(withDuration: 0.2) {
                    share.layoutIfNeeded()
                } completion: { [weak self] finish in
                    if finish {
                        self?.setUserKeyPromtOrGuide(keyPrompt: "1", guide: nil) { [weak self] res in
                            if res == true {
                                delay(interval: 0.15) {
                                    self?.scrNext()
                                }
                            }
                        }
                    }
                }
            }
            return
        }
        
        if let noti = tagView as? GameNotiAuthView {
            if noti.onFocusIdx == 0 {
                noti.setNeedsLayout()
                noti.applyBtn.snp.remakeConstraints {
                    $0.left.equalTo(noti.titleL).offset(0)
                    $0.right.equalTo(noti.titleL).offset(0)
                    $0.top.equalTo(noti.subtitleL.snp.bottom).offset(16.widthScale)
                    $0.height.equalTo(50.widthScale)
                }
                UIView.animate(withDuration: 0.2) {
                    noti.layoutIfNeeded()
                } completion: { finish in
                    if finish {
                        if let app = UIApplication.shared.delegate as? AppDelegate{
                            app.registerForRemoteNotificationHandler = {[weak self] in
                                guard let `self` = self else { return }
                                print($0 == true ? "注册通知成功，回调执行":"注册通知失败，回调执行")
                                GSAuthTool.readUNUserNotificationCenterState()
                                self.scrNext()
                            }
                            app.requestNotificationAuthorization()
                        }
                    }
                }

               
               
            }
            else{
                noti.setNeedsLayout()
                noti.lateBtn.snp.remakeConstraints {
                    $0.left.equalTo(noti.titleL).offset(0)
                    $0.right.equalTo(noti.titleL).offset(0)
                    $0.top.equalTo(noti.applyBtn.snp.bottom).offset(12.widthScale)
                    $0.height.equalTo(50.widthScale)
                }
                UIView.animate(withDuration: 0.2) {
                    noti.layoutIfNeeded()
                } completion: { [weak self] finish in
                    if finish {
                        var noti = UserDefaultWrapper<Int?>(key: UserDefaultKeys.ifNeedNoti)
                        noti.wrappedValue = 2
                        self?.scrNext()
                    }
                }
               
            }
            
            return
        }
        
        if let library = tagView as? GameLibAuthView {
            if library.onFocusIdx == 0 {
                library.setNeedsLayout()
                library.applyBtn.snp.remakeConstraints {
                    $0.left.equalTo(library.titleL).offset(0)
                    $0.right.equalTo(library.titleL).offset(0)
                    $0.top.equalTo(library.subtitleL.snp.bottom).offset(24.widthScale)
                    $0.height.equalTo(50.widthScale)
                }
                UIView.animate(withDuration: 0.2) {
                    library.layoutIfNeeded()
                } completion: { [unowned self] finish in
                    if finish {
                        GSAuthTool.checkPhotoLibraryPermission {[unowned self] reslut in
                            var lib = UserDefaultWrapper<Int?>(key: UserDefaultKeys.ifNeedLibrary)
                            lib.wrappedValue = reslut
                            let noti = UserDefaultWrapper<Int?>(key: UserDefaultKeys.ifNeedNoti)
                            let library = UserDefaultWrapper<Int?>(key: UserDefaultKeys.ifNeedLibrary)
                            let done =  (self.tokenEffective == true)
                                        && (getBindPhoneNumber().isBlank == false)
                                        && (getAvatarPath().isBlank == false)
                                        && (getUsername().isBlank == false)
                                        && (getUserKeyPrompt() == "1")
                                        && (noti.wrappedValue != 0 && noti.wrappedValue != nil)
                                        && (library.wrappedValue != 0 && library.wrappedValue != nil )
                            
                            if done {
                                delay(interval: 0.15) {[weak self] in
                                    guard let `self` = self else { return }
                                    self.doneWithSignHandler()
                                }
                            }
                            else {
                                delay(interval: 0.15) {[weak self] in
                                    guard let `self` = self else { return }
                                    let contentOffX = Int(contentView.scr.contentOffset.x / kWidth)
                                    guard kWidth * CGFloat(contentOffX + 1) < contentView.scr.contentSize.width else {
                                        print("scr 超出内容")
                                        return
                                    }
                                    var library = UserDefaultWrapper<Int?>(key: UserDefaultKeys.ifNeedLibrary)
                                    library.wrappedValue = 2
                                    self.scrNext()
                                }
                            }
                        }
                    }
                }
            }
            else{
                
                library.setNeedsLayout()
                library.lateBtn.snp.remakeConstraints {
                    $0.left.equalTo(library.titleL).offset(0)
                    $0.right.equalTo(library.titleL).offset(0)
                    $0.top.equalTo(library.applyBtn.snp.bottom).offset(12.widthScale)
                    $0.height.equalTo(50.widthScale)
                }
                UIView.animate(withDuration: 0.2) {
                    library.layoutIfNeeded()
                } completion: { [unowned self] finish in
                    
                    let contentOffX = Int(contentView.scr.contentOffset.x / kWidth)
                    guard kWidth * CGFloat(contentOffX + 1) < contentView.scr.contentSize.width else {
                        print("scr 超出内容")
                        return
                    }
                    self.scrNext()
                }
            }
            return
        }
        
        if let shell = tagView as? GameShellView {
            shell.setNeedsLayout()
            shell.applyBtn.snp.remakeConstraints {
                $0.left.equalTo(shell.titleL).offset(8.widthScale)
                $0.right.equalTo(shell.titleL).offset(-8.widthScale)
                $0.top.equalTo(shell.subtitleL.snp.bottom).offset(24.widthScale)
                $0.height.equalTo(50.widthScale)
            }
            UIView.animate(withDuration: 0.2) {
                shell.layoutIfNeeded()
            } completion: { [weak self] finish in
                self?.scrNext()
            }
            return
        }
        
        if let shell2 = tagView as? GameShellTwoView {
            
            shell2.setNeedsLayout()
            shell2.applyBtn.snp.remakeConstraints {
                $0.left.equalTo(shell2.titleL)
                $0.right.equalTo(shell2.snp.centerX).offset(-80.widthScale)
                $0.top.equalTo(shell2.titleL.snp.bottom).offset(32.widthScale)
                $0.height.equalTo(44.widthScale)
            }
            UIView.animate(withDuration: 0.2) {
                shell2.layoutIfNeeded()
            } completion: { [weak self] finish in
                self?.scrNext()
            }
            return
        }
        
        if let shell3 = tagView as? GameShellThreeView {
            shell3.setNeedsLayout()
            shell3.applyBtn.snp.remakeConstraints {
                $0.left.equalTo(shell3.titleL).offset(0)
                $0.right.equalTo(shell3.snp.centerX).offset(-80.widthScale)
                $0.top.equalTo(shell3.subtitleL.snp.bottom).offset(32.widthScale)
                $0.height.equalTo(44.widthScale)
            }
            UIView.animate(withDuration: 0.2) {
                shell3.layoutIfNeeded()
            } completion: { [weak self] finish in
                self?.scrNext()
            }
            return
        }
       
        if let shell4 = tagView as? GameShellFourView {
            shell4.setNeedsLayout()
            shell4.applyBtn.snp.remakeConstraints {
                $0.left.equalTo(shell4.titleL)
                $0.right.equalTo(shell4.snp.centerX).offset(-80.widthScale)
                $0.top.equalTo(shell4.subtitleL.snp.bottom).offset(32.widthScale)
                $0.height.equalTo(44.widthScale)
            }
            UIView.animate(withDuration: 0.2) {
                shell4.layoutIfNeeded()
            } completion: { [weak self] finish in
                self?.scrNext()
            }
            return
        }
    }
    
    @objc func pressBIn(){
        onPressing = true
        guard let tagView = findScrollViewTagSubview() else { return }
        if let codeView = tagView as? GameMsgCodeView {
            UIView.animate(withDuration: 0.15) {
                codeView.backBtn.transform3D = CATransform3DScale(CATransform3DIdentity, Transform3DScale, Transform3DScale, Transform3DScale)
            }
            return
        }
        
        if let codeInputView = tagView as? GameMsgInputView {
            UIView.animate(withDuration: 0.15) {
                codeInputView.backBtn.transform3D = CATransform3DScale(CATransform3DIdentity, Transform3DScale, Transform3DScale, Transform3DScale)
            }
            return
        }
        
        if let shareIntroView = tagView as? GameIntroduceView {
            UIView.animate(withDuration: 0.15) {
                shareIntroView.backBtn.transform3D = CATransform3DScale(CATransform3DIdentity, Transform3DScale, Transform3DScale, Transform3DScale)
            }
            return
        }
        
        if let noti = tagView as? GameNotiAuthView {
            UIView.animate(withDuration: 0.15) {
                noti.backBtn.transform3D = CATransform3DScale(CATransform3DIdentity, Transform3DScale, Transform3DScale, Transform3DScale)
            }
            return
        }
        if let lib = tagView as? GameLibAuthView {
            UIView.animate(withDuration: 0.15) {
                lib.backBtn.transform3D = CATransform3DScale(CATransform3DIdentity, Transform3DScale, Transform3DScale, Transform3DScale)
            }
            return
        }
        
        if let shell1 = tagView as? GameShellView {
            UIView.animate(withDuration: 0.15) {
                shell1.backBtn.transform3D = CATransform3DScale(CATransform3DIdentity, Transform3DScale, Transform3DScale, Transform3DScale)
            }
            return
        }
        if let shell2 = tagView as? GameShellTwoView {
            UIView.animate(withDuration: 0.15) {
                shell2.backBtn.transform3D = CATransform3DScale(CATransform3DIdentity, Transform3DScale, Transform3DScale, Transform3DScale)
            }
            return
        }
        if let shell3 = tagView as? GameShellThreeView {
            UIView.animate(withDuration: 0.15) {
                shell3.backBtn.transform3D = CATransform3DScale(CATransform3DIdentity, Transform3DScale, Transform3DScale, Transform3DScale)
            }
            return
        }
        if let shell4 = tagView as? GameShellFourView {
            UIView.animate(withDuration: 0.15) {
                shell4.backBtn.transform3D = CATransform3DScale(CATransform3DIdentity, Transform3DScale, Transform3DScale, Transform3DScale)
            }
            return
        }
        if let shell5 = tagView as? GameShellFiveView {
            UIView.animate(withDuration: 0.15) {
                shell5.backBtn.transform3D = CATransform3DScale(CATransform3DIdentity, Transform3DScale, Transform3DScale, Transform3DScale)
            }
            return
        }
    }
    
    @objc func pressBOut(){
        onPressing = false
        guard let tagView = findScrollViewTagSubview() else { return }
        if let codeView = tagView as? GameMsgCodeView {
            UIView.animate(withDuration: 0.15) {
                codeView.backBtn.transform3D = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
            } completion: {[weak self] finish in
                if finish {
                    self?.scrBack()
                }
            }
            return
        }
        
        if let codeInputView = tagView as? GameMsgInputView {
            UIView.animate(withDuration: 0.15) {
                codeInputView.backBtn.transform3D = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
            } completion: {[weak self] finish in
                if finish {
                    self?.scrBack()
                }
            }
            return
        }
        
        if let share = tagView as? GameIntroduceView {
            if share.index == 0 {
                UIView.animate(withDuration: 0.15) {
                    share.backBtn.transform3D = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
                } completion: {[weak self] finish in
                    if finish {
                        self?.scrBack()
                    }
                }
            }
            else {
                UIView.animate(withDuration: 0.15) {
                    share.backBtn.transform3D = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
                } completion: {[weak self] finish in
                    if finish {
                        self?.scrBack()
                        // 重置
                        share.longPassView.progressView.stopAnimation()
                        share.introduceState = .stateNormal
                    }
                }
            }
            
            return
        }
        
        if let noti = tagView as? GameNotiAuthView {
            UIView.animate(withDuration: 0.15) {
                noti.backBtn.transform3D = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
            } completion: { [weak self] finish in
                self?.scrBack()
            }
            return
        }
        
        if let library = tagView as? GameLibAuthView {
            UIView.animate(withDuration: 0.15) {
                library.backBtn.transform3D = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
            } completion: { [weak self] finish in
                self?.scrBack()
            }
            return
        }
        
        if let shell1 = tagView as? GameShellView {
            UIView.animate(withDuration: 0.15) {
                shell1.backBtn.transform3D = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
            } completion: { [weak self] finish in
                self?.scrBack()
            }
            return
        }
        
        if let shell2 = tagView as? GameShellTwoView {
            UIView.animate(withDuration: 0.15) {
                shell2.backBtn.transform3D = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
            } completion: { [weak self] finish in
                self?.scrBack()
            }
            return
        }
        
        if let shell3 = tagView as? GameShellThreeView {
            UIView.animate(withDuration: 0.15) {
                shell3.backBtn.transform3D = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
            } completion: { [weak self] finish in
                self?.scrBack()
            }
            return
        }
        
        if let shell4 = tagView as? GameShellFourView {
            UIView.animate(withDuration: 0.15) {
                shell4.backBtn.transform3D = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
            } completion: { [weak self] finish in
                self?.scrBack()
            }
            return
        }
        
        if let shell5 = tagView as? GameShellFiveView {
            UIView.animate(withDuration: 0.15) {
                shell5.backBtn.transform3D = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
            } completion: { [weak self] finish in
                self?.scrBack()
            }
            return
        }
    }
    
 
    
    @objc func pressUp(){
        guard onPressing == false else {
            print("正在按紧B或A")
            return
        }
        guard let tagView = findScrollViewTagSubview() else { return }
        if let signView = tagView as? GameLoginView {
            if signView.idx == 1 {
                contentView.loginView.setFocusBtn(idx: contentView.loginView.onFocusIdx == 0 ? 1:0)
            }
        }
        if let noti = tagView as? GameNotiAuthView {
            noti.setFocusBtn(idx: noti.onFocusIdx == 0 ? 1:0)
            return
        }
        if let library = tagView as? GameLibAuthView {
            library.setFocusBtn(idx: library.onFocusIdx == 0 ? 1:0)
            return
        }
    }
    
    @objc func pressDown(){
        guard onPressing == false else {
            print("正在按紧B或A")
            return
        }
        guard let tagView = findScrollViewTagSubview() else { return }
        if let signView = tagView as? GameLoginView {
            if signView.idx == 1 {
                contentView.loginView.setFocusBtn(idx: contentView.loginView.onFocusIdx == 0 ? 1:0)
            }
        }
        if let noti = tagView as? GameNotiAuthView {
            noti.setFocusBtn(idx: noti.onFocusIdx == 0 ? 1:0)
            return
        }
        
        if let library = tagView as? GameLibAuthView {
            library.setFocusBtn(idx: library.onFocusIdx == 0 ? 1:0)
            return
        }
    }
    
    @objc func pressScreenshot(){
        guard let tagView = findScrollViewTagSubview() else { return }
       
        if let share = tagView as? GameIntroduceView {
            guard share.index == 1  else { return }
           
            if share.introduceState == .doneScreenshot {
                share.introduceState = .doneRecode
            }
            return
        }
    }
    
    @objc func pressHome(){
        guard let tagView = findScrollViewTagSubview() else { return }
        setUserKeyPromtOrGuide(keyPrompt: nil, guide: "1") { res in
            if res == true {
                delay(interval: 0.15) {
                    self.doneWithSignHandler()
                }
            }
        }
    }
    
    func findScrollViewTagSubview() -> UIView?{
        let idx:Int = Int(contentView.scr.contentOffset.x / kWidth)
        if idx < contentView.scr.subviews.count {
            return contentView.scr.subviews[idx]
        }
        return nil
    }
    
    
    @objc func pressInMenu(){

        onPressing = true
        guard let showView = findScrollViewTagSubview() as? GameIntroduceView else { return }
        
        if showView.introduceState == .stateNormal {
            // 开始计时
            showView.longPassView.progressView.animate(fromAngle: 0,
                                                       toAngle: 360,
                                                       duration: ScreenshotLongPressSpaceTime)
            { _ in
                
            }
            TimerManger.share.cancelTaskWithId(screenshotLongPressedID)
            let task = TimeTask.init(taskId: screenshotLongPressedID, interval: 10) {[weak self] in
                guard let `self` = self else {return}
                self.menuAgainFlag = true
                self.screenshotLongPressedTime -= 1.0/5.0
                if self.screenshotLongPressedTime < 0 {
                    TimerManger.share.cancelTaskWithId(self.screenshotLongPressedID)
                    self.screenshotLongPressedTime = ScreenshotLongPressSpaceTime
                    showView.introduceState = .doneScreenshot
                }
            }
            TimerManger.share.runTask(task: task)
        }
    }
    
    @objc func pressOutMenu(){
        onPressing = false
        guard let showView = findScrollViewTagSubview() as? GameIntroduceView else { return }
        if showView.introduceState == .stateNormal {
            screenshotLongPressedTime = ScreenshotLongPressSpaceTime
            TimerManger.share.cancelTaskWithId(screenshotLongPressedID)
            showView.longPassView.progressView.stopAnimation()
            return
        }
        
        if showView.introduceState == .doneScreenshot {
            if menuAgainFlag == true {
                menuAgainFlag = false
            }else {
                showView.introduceState = .doneRecode
            }
            return
        }
    }
    

}

//MARK: -----
//MARK: ----- 检查用户登录状态
extension GSWelcomeSignViewController {
    
    
    func redo(){
        /*
         1、检查是否有用户数据
            1.1、没有用户数据则显示登录
            1.2、有用户数据则请求token，更新用户模型
         */
        
        checkLocatStrong { [unowned self] locat in
            
            guard locat == true else {
                // 如果没有本地token之类，则继续
                self.contentView.loginView.removeFromSuperview()
                self.contentView.initLoginView()
                self.contentView.scr.contentSize = CGSizeMake(self.contentView.visualRect.width * CGFloat(self.contentView.scr.subviews.count), 0)
                return
            }
            
            self.checkToken { [unowned self] (used, _) in
                
                guard used == true else {
                    // 如果token已经失效，则继续
                    self.contentView.loginView.removeFromSuperview()
                    self.contentView.initLoginView()
                    self.contentView.scr.contentSize = CGSizeMake(self.contentView.visualRect.width * CGFloat(self.contentView.scr.subviews.count), 0)
                    return
                }
                
                self.refreshUserInfo {[unowned self] (refresh, data) in
                    
                    guard refresh == true else {
                        // 如果刷新用户失败，则继续
                        self.contentView.loginView.removeFromSuperview()
                        self.contentView.initLoginView()
                        self.contentView.scr.contentSize = CGSizeMake(self.contentView.visualRect.width * CGFloat(self.contentView.scr.subviews.count), 0)
                        return
                    }
                    
                    // 表示已经获取了相对应的用户数据，可以编排 contentview的scr
                    self.contentView.rebuildUI()
                }
            }
        }
        
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
                    self.tokenEffective = false
                    NotificationCenter.default.post(name: Notification.Name("UserDidLogoutNotification"), object: nil)
                    return
                }
                if code == 200 || code == 201 {
                    print("Token依然有效，仍处于登录状态")
                    self.tokenEffective = true
                    x(true,responseData)
                }
                else {
                    print("Token已过期，需重新登录", responseData["msg"]!)
                    x(false,nil)
                    self.tokenEffective = false
                }
            }
            case .failure(_): do {
                print("网络错误")
                x(false,nil)
                self.tokenEffective = false
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

