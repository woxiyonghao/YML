//
//  NetworkService.swift
//  EggShell
//
//  Created by 刘富铭 on 2021/12/13.
//

import Foundation
import Moya
import SwiftyJSON

enum ThirdLoginPlatform: String {
    case apple = "apple"
    case google = "google"
}

// MARK: 用户
enum UserService {
    // 注释的方法暂时用不到
    //    case checkPhoneRegistrationStatus(phoneNumber: String)// 检测手机账号是否注册，接口2.2
    //    case login(phoneNumber: String, zone: String, smsCode: String, smsSign: String)// 手机号登录，接口2.3
    case getUserInfo// 获取用户信息，接口2.5
    case uploadAvatar(image: UIImage)
    case uploadEmoji(emoji: String)
    case setNickname(name: String)//  设置昵称， 接口2.7
    case checkTokenEnabled// 检测token，接口2.8
    case refreshToken// 刷新token，接口2.9
    case registerAndLogin(phoneNumber: String, zone: String, smsCode: String)// 手机号注册登录（接口文档叫“快速登录”），接口2.10
    case loginFromThirdPlatform(platform: ThirdLoginPlatform.RawValue, openID: String, unionID: String, nickname: String, email: String)// 第三方登录，接口2.11
    case bindPhoneNumber(phoneNumber: String, zone: String, smsCode: String)// 绑定手机号，接口2.12
    case logout //2.13退出登录
    case uploadDeviceTokenForUserNotification(token: String,language:String)// 上传设备token信息，接口2.16，用于消息推送
    case likeOrUnlikeVideo(id: Int)// 接口3.4，点赞/取消点赞视频
    
    
    case refreshYUNXINToken //2.14获取云信Token
    case searchUser(keyWord:String)  //2.17搜索用户
    case friendsNum(userID:String)  //2.18获取好友数量
    
    // App
    case uploadAppInReviewInfo(appVersion: String, build: Int)
    case getAppInReviewInfo
    
    // event 备注：bindmobile绑定手机号、changemobile修改手机号
    case getSmsCode(mobile: String, event: String,zone:String)
    
    // nickname 是授权第三方要带过来的,项目可修改的是username
    case setApiUsername(name: String)
    
    // 需要全部信息。username，avater，bio。
    case setApiBio(bio: String,name:String,avatar:String)
    
    /// 是否进行过 keyPrompt = 按键教程，guide = 指引页
    case setKeyPromptOrGuide(keyPrompt:String?,guide:String?)
}

extension UserService: TargetType {
    
    // 服务器地址
    public var baseURL: URL {
        //return URL(string: "https://apieggshell.vgabc.com")!
        return URL(string: "https://landscape-api.vgabc.com")!
    }
    
    // 路径
    public var path: String {
        switch self {
            //        case .checkPhoneRegistrationStatus(_):
            //            return "/validate/check_mobile_exist/"
            //        case .login(_, _, _, _):
            //            return "/mobile/login/"
        case .getUserInfo:
            return "/user/info/"
        case .uploadAvatar(_):
            return "/profile/avatar/"
        case .checkTokenEnabled:
            return "/token/check/"
        case .refreshToken:
            return "/token/refresh/"
        case .registerAndLogin(_, _, _):
            return "/mobile/quick_login/"
        case .setNickname(_):
            return "/profile/"
        case .loginFromThirdPlatform(_, _, _, _, _):
            return "/third/login/"
        case .bindPhoneNumber(_, _, _):
            return "/bind/mobile/"
        case .refreshYUNXINToken:
            return "/yunxin/refresh/"
        case .uploadDeviceTokenForUserNotification(_,_):
            return "/apple/token"
        case .searchUser(_):
            return "/user/search/"
        case .friendsNum(_):
            return "/friend/num/"
        case .logout:
            return "/user/logout/"
        case .uploadAppInReviewInfo(_, _):
            return "/appversion/upload/"
        case .getAppInReviewInfo:
            return "/appversion/info/"
        case .likeOrUnlikeVideo(_):
            return "/appstore/video/like/"
        case .getSmsCode(_,_,_):
            return "/sms/send"
        case .uploadEmoji(emoji: _):
            return "/profile/avatar/"
        case .setApiUsername(_):
            return "/profile/username/"
        case .setApiBio(_,_,_):
            return "/profile/"
        case .setKeyPromptOrGuide(_, guide: _):
            return "/profile/verify/"
        }
        
    }
    
    // 请求方式：.post / .get
    public var method: Moya.Method {
        return .post
    }
    
    // 参数
    public var task: Task {
        var param: [String: Any] = [:]
        switch self {
            //        case .checkPhoneRegistrationStatus(let phoneNumber):
            //            param["clientparams"] = clientParams()
            //            param["time"] = 0
            //            param["mobile"] = phoneNumber
            //
            //        case .login(let phoneNumber, let zone, let smsCode, let smsSign):
            //            param["clientparams"] = clientParams()
            //            param["time"] = 0
            //            param["mobile"] = phoneNumber
            //            param["captcha"] = smsCode
            //            param["zone"] = zone
            //            param["sms_sign"] = smsSign
            
        case .getUserInfo:
            param["clientparams"] = clientParams()
            param["time"] = Date().timestamp
            param["token"] = getToken()
            
        case .uploadAvatar(let image):
            param["clientparams"] = clientParams()
            param["time"] = Date().timestamp
            param["token"] = getToken()
            param["sign"] = getAPISignWith(params: param)
            
            var formDatas: [MultipartFormData] = []
            let data = image.pngData()!
            let formData = MultipartFormData(provider: .data(data), name: "file", fileName: "avatar.png", mimeType: "image/png")
            formDatas.append(formData)
            
            return .uploadCompositeMultipart(formDatas, urlParameters: param)
            
        case .checkTokenEnabled:
            param["clientparams"] = clientParams()
            param["time"] = Date().timestamp
            param["token"] = getToken()
            
        case .refreshToken:
            param["clientparams"] = clientParams()
            param["time"] = Date().timestamp
            param["token"] = getToken()
            
        case .registerAndLogin(let phoneNumber, let zone, let smsCode):
            param["clientparams"] = clientParams()
            param["time"] = Date().timestamp
            param["mobile"] = phoneNumber
            param["captcha"] = smsCode
            param["zone"] = zone
            
        case .setNickname(let name):
            param["clientparams"] = clientParams()
            param["time"] = Date().timestamp
            param["token"] = getToken()
            param["nickname"] = name
            
        case .loginFromThirdPlatform(let platform, let openID, let unionID, let nickname, let email):
            param["clientparams"] = clientParams()
            param["time"] = Date().timestamp
            param["platform"] = platform
            param["unionid"] = unionID
            param["openid"] = openID
            param["openkey"] = ""
            param["extinfo"] = ["email": email,"nickname": nickname].string()
            
        case .bindPhoneNumber(let phoneNumber, let zone, let smsCode):
            param["clientparams"] = clientParams()
            param["time"] = Date().timestamp
            param["token"] = getToken()
            param["mobile"] = phoneNumber
            param["captcha"] = smsCode
            param["zone"] = zone
            
        case.refreshYUNXINToken:
            param["clientparams"] = clientParams()
            param["time"] = Date().timestamp
            param["token"] = getToken()
            
        case .uploadDeviceTokenForUserNotification(token: let token,language:let language):
            param["clientparams"] = clientParams()
            param["time"] = Date().timestamp
            param["token"] = getToken()
            param["grant_token"] = token
            param["sys_language"] = language
        case.searchUser(let keyword):
            param["clientparams"] = clientParams()
            param["time"] = Date().timestamp
            param["token"] = getToken()
            param["keyword"] = keyword
            
            
        case .friendsNum(let userID):
            param["clientparams"] = clientParams()
            param["time"] = Date().timestamp
            param["token"] = getToken()
            param["user_id"] = userID
            
        case .logout:
            param["clientparams"] = clientParams()
            param["time"] = Date().timestamp
            param["token"] = getToken()
            
        case .uploadAppInReviewInfo(let appVersion, let build):
            param["clientparams"] = clientParams()
            param["time"] = Date().timestamp
            param["token"] = getToken()
            param["appversion"] = appVersion
            param["build"] = build
            
        case .getAppInReviewInfo:
            param["clientparams"] = clientParams()
            param["time"] = Date().timestamp
            param["token"] = getToken()
            
        case .likeOrUnlikeVideo(let videoId):
            param["clientparams"] = clientParams()
            param["time"] = Date().timestamp
            param["token"] = getToken()
            param["video_id"] = videoId
        case .getSmsCode(mobile: let mobile, event: let event, zone: let zone):
            param["clientparams"] = clientParams()
            param["time"] = Date().timestamp
            param["token"] = getToken()
            param["mobile"] = mobile
            param["event"] = event
            param["zone"] = zone
        case .uploadEmoji(emoji: let emoji):
            param["clientparams"] = clientParams()
            param["time"] = Date().timestamp
            param["token"] = getToken()
            param["avatar"] = emoji
            
        case .setApiUsername(name: let name):
            param["clientparams"] = clientParams()
            param["time"] = Date().timestamp
            param["token"] = getToken()
            param["username"] = name
            
        case .setApiBio(bio: let bio, name: let name, avatar: let avatar):
            param["clientparams"] = clientParams()
            param["time"] = Date().timestamp
            param["token"] = getToken()
            param["username"] = name
            param["avatar"] = avatar
            param["bio"] = bio
            
        case .setKeyPromptOrGuide(keyPrompt: let keyPrompt, guide: let guide):
           
            if keyPrompt?.isBlank == false {
                param["keyPrompt"] = keyPrompt!
            }
            if guide?.isBlank == false {
                param["guide"] = guide!
            }
            param["clientparams"] = clientParams()
            param["time"] = Date().timestamp
            param["token"] = getToken()
        }
        
        
        let sign = getAPISignWith(params: param)
        param["sign"] = sign
        print("最终参数：", param.string() as Any)
        
        return .requestParameters(parameters: param, encoding: URLEncoding.default)
    }
    
    // 是否执行Alamofire验证
    public var validate: Bool {
        return false
    }
    
    // 单元测试数据，只在单元测试中有效
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8, allowLossyConversion: true)!
    }
    
    // 请求头
    public var headers: [String : String]? {
        return nil
    }
}

// MARK: 游戏
enum GameService {
//    case getGamePlatformList// 接口3.1，获取游戏平台列表
    case getGameList(platformID: String?, categoryID: String?, keyword: String?)// 接口3.2，获取游戏列表/搜索游戏。参数均为可选
    case getGameDetail(gameID: String)// 接口3.3，获取游戏详情
//    case getGameTopics// 接口3.5，获取首页游戏（游戏专题）数据
    case shareGameVideo(gameID: String, title: String, videoData: Data, coverImageData: Data)// 接口3.6，分享视频
    case getSharedGameVideos// 接口3.7，获取我分享的视频
    case deleteGameVideo(id: String)// 接口3.9，删除我分享的视频
    case getVideoDetail(videoId: Int)// 3.10 获取视频详情
    
     //横版启动器接口
    case getIndexList // 首页所有栏目数据
    case getGamePlatformList // 获取游戏平台列表
    case getSearchGameList(page: String?, categoryID: String?, keyword: String?)// 搜索游戏。参数均为可选
}

extension GameService: TargetType {
    
    // 服务器地址
    public var baseURL: URL {
//        return URL(string: "https://apieggshell.vgabc.com")!
        return URL(string: "https://landscape-api.vgabc.com")!
    }
    
    // 路径
    public var path: String {
        switch self {
        case .getGameList(_, _, _):
            return "/appstore/list/"
        case .getGameDetail(_):
            return "/appstore/info/"
        case .shareGameVideo(_, _, _, _):
            return "/appstore/video/add/"
        case .getSharedGameVideos:
            return "/appstore/video/list/"
        case .deleteGameVideo(_):
            return "/appstore/video/del/"
        case .getVideoDetail(_):
            return "/appstore/video/info/"
            
            //横版启动器接口
        case .getGamePlatformList:
            return "/game/searchCategoryList/"
        case .getIndexList:
            return "/game/getIndexList/"
        case .getSearchGameList(_, _, _):
            return "/game/searchGameList/"
        }
    }
    
    // 请求方式：.post / .get
    public var method: Moya.Method {
        return .post
    }
    
    // 参数
    public var task: Task {
        var param: [String: Any] = [:]
        switch self {
        case .getGamePlatformList:
            param["clientparams"] = clientParams()
            param["time"] = Date().timestamp
            param["token"] = getToken()
            
        case .getGameList(let platformID, let categoryID, let keyword):
            param["clientparams"] = clientParams()
            param["time"] = Date().timestamp
            param["token"] = getToken()
            param["page"] = "1"
            param["page_size"] = "10000"
            if platformID != nil {
                param["platform_id"] = Int(platformID!) ?? 0
            }
            if categoryID != nil {
                param["category_id"] = Int(categoryID!) ?? 0
            }
            if keyword != nil {
                param["keywords"] = keyword
            }
            
        case .getGameDetail(let gameID):
            param["clientparams"] = clientParams()
            param["time"] = Date().timestamp
            param["token"] = getToken()
            param["appstore_id"] = gameID
            
            
        case .shareGameVideo(let gameID, let title, let videoData, let coverImageData):
            param["clientparams"] = clientParams()
            param["time"] = Date().timestamp
            param["token"] = getToken()
            param["appstore_id"] = Int(gameID)
            param["title"] = title
            param["sign"] = getAPISignWith(params: param)
            
            var formDatas: [MultipartFormData] = []
            let videoData = MultipartFormData(provider: .data(videoData), name: "file", fileName: "video.mp4", mimeType: "video/mp4")
            formDatas.append(videoData)
            let coverData = MultipartFormData(provider: .data(coverImageData), name: "cover_img", fileName: "image.png", mimeType: "image/png")
            formDatas.append(coverData)
            // 这2个参数也要通过formDatas上传，否则后台拿不到数据，返回“No Results were found”
            formDatas.append(Moya.MultipartFormData(provider: .data(title.data(using: .utf8)!), name: "title"))
            if gameID != "" {// ID为空则不提交，否则提示签名错误
                formDatas.append(Moya.MultipartFormData(provider: .data(gameID.data(using: .utf8)!), name: "appstore_id"))
            }
            print(formDatas)
            print(param)
            return .uploadCompositeMultipart(formDatas, urlParameters: param)
            
        case .getSharedGameVideos:
            param["clientparams"] = clientParams()
            param["time"] = Date().timestamp
            param["token"] = getToken()
            param["page"] = "1"
            param["page_size"] = "100"
        case .deleteGameVideo(let id):
            param["clientparams"] = clientParams()
            param["time"] = Date().timestamp
            param["token"] = getToken()
            param["video_id"] = id
            
        case .getVideoDetail(let videoId):
            param["clientparams"] = clientParams()
            param["time"] = Date().timestamp
            param["token"] = getToken()
            param["video_id"] = videoId
            
        case .getIndexList:
            param["clientparams"] = clientParams()
            param["time"] = Date().timestamp
            param["token"] = getToken()
            
        case .getSearchGameList(let page, let categoryID, let keyword):
            param["clientparams"] = clientParams()
            param["time"] = Date().timestamp
            param["token"] = getToken()
            param["page"] = "1"
//            param["page_size"] = "200"
            if page != nil {
                param["page"] = Int(page!) ?? 200
            }
            if categoryID != nil {
                param["category_id"] = Int(categoryID!) ?? 0
            }
            if keyword != nil {
                param["keywords"] = keyword
            }
        }
        
        let sign = getAPISignWith(params: param)
        param["sign"] = sign
//        print("接口参数：", param.string() as Any)
        
        return .requestParameters(parameters: param, encoding: URLEncoding.default)
    }
    
    // 是否执行Alamofire验证
    public var validate: Bool {
        return false
    }
    
    // 单元测试数据，只在单元测试中有效
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8, allowLossyConversion: true)!
    }
    
    // 请求头
    public var headers: [String : String]? {
        return nil
    }
}

// MARK: 手柄
enum ControllerService {
    case getControllerFirmwares(gamepadName: String)// 获取手柄的最新固件
}

extension ControllerService: TargetType {
    
    // 服务器地址
    public var baseURL: URL {
        return URL(string: "http://www.xiaoji.com")!
    }
    
    // 路径
    public var path: String {
        switch self {
        case .getControllerFirmwares(_):
            return "/firmware/update/x1/"
        }
    }
    
    // 请求方式：.post / .get
    public var method: Moya.Method {
        return .get
    }
    
    // 参数
    public var task: Task {
        var param: [String: Any] = [:]
        switch self {
        case .getControllerFirmwares(let gamepadName):
            param["ver"] = "0"
            param["beta"] = "0"
            param["name"] = gamepadName
            let appVersion = (Bundle.main.infoDictionary!["CFBundleShortVersionString"]) as! String
            param["appver"] = appVersion
            let appLang = Bundle.init().currentLanguage()
            param["lang"] = appLang
            param["agreement"] = "2"
        }
        
//        print("接口参数：", param.string() as Any)
        
        return .requestParameters(parameters: param, encoding: URLEncoding.default)
    }
    
    // 是否执行Alamofire验证
    public var validate: Bool {
        return false
    }
    
    // 单元测试数据，只在单元测试中有效
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8, allowLossyConversion: true)!
    }
    
    // 请求头
    public var headers: [String : String]? {
        return nil
    }
}

// MARK: 接口参数
func getAPISignWith(params: [String: Any]) -> String {
    
    var willMD5String = ""
    let allKeys = params.keys.sorted(by: <)// 增序
    for key in allKeys {
        var valueString = ""
        if let value = params[key] as? Int {// 判断数据类型为Int，再转为String，防止出现Optional("xxx")的情况
            valueString = String(value)
        }
        else if let value = params[key] as? String {
            valueString = value
        }
        else if let value = params[key] as? [String: Any] {
            valueString = value.string()!// 使用字符串形式
            /**
             {"email":"xxx","nickname":"yyy"}
             */
            //            var subValueString = "{"
            //            for subKey in value.keys {
            //                if let subValue = value[subKey] as? String {
            //                    subValueString = subValueString + "\"" + subKey + "\":\"" + subValue + "\","
            //                }
            //            }
            //            subValueString.removeLast()// 删除末尾的逗号
            //            valueString = subValueString + "}"
        }// TODO: 处理其他类型的数据
        
        let eachString = key + "=" + valueString + "&"
        //print("eachString == \(eachString)")
        willMD5String = willMD5String.appending(eachString)
    }
    
    //willMD5String = willMD5String.appending("ios-egg-shell-y7ZatUDk")// 末尾加上固定字符串
    willMD5String = willMD5String.appending("all-egg-shell-y7ZatUDk")// 末尾加上固定字符串
    //    print("sign参数：", willMD5String)
    //    print(willMD5String.md5())
    
    return willMD5String.md5()
}

// 客户端参数
func clientParams() -> String {
    let appVersion = (Bundle.main.infoDictionary!["CFBundleShortVersionString"]) as! String
    let systemVersion = UIDevice.current.systemVersion
    let appLang = Bundle.init().currentLanguage()
    let mobileType = "iPhone"// TODO: 获取正确的设备类型
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    let resolution = String.init(format: "%.0f", screenWidth) + "*" + String.init(format: "%.0f", screenHeight)// 分辨率
    var gamepadName = getControllerName()
    let gamepadFirmwareVersion = "1.0"// TODO: 获取正确的手柄固件版本号
    let bundleId = Bundle.main.bundleIdentifier!
    
    let param = appVersion + "|" + systemVersion + "|" + appLang + "|" + mobileType + "|" + resolution + "|" + "IOSEGGSHELL" + "|" + "0" + "|" + "0" + "|" + "0" + "|" + "0" + "|" + "0" + "|" + "0" + "|" + gamepadName + "|" + "0" + "|" + "0" + "|" + gamepadFirmwareVersion + "|" + bundleId
    //print("parma = \(param)")
    return param
}

/** 用户数据
 ▿ 11 elements
 ▿ 0 : 2 elements
 - key : "expiretime"
 - value : 1669963552
 ▿ 1 : 2 elements
 - key : "createtime"
 - value : 1667371552
 ▿ 2 : 2 elements
 - key : "token"
 - value : 5c16b7c0-c820-4059-b746-7258ce19bdcd
 ▿ 3 : 2 elements
 - key : "username"
 - value : admin
 ▿ 4 : 2 elements
 - key : "nickname"
 - value : 新昵称
 ▿ 5 : 2 elements
 - key : "expires_in"
 - value : 2592000
 ▿ 6 : 2 elements
 - key : "user_id"
 - value : 1
 ▿ 7 : 2 elements
 - key : "id"
 - value : 1
 ▿ 8 : 2 elements
 - key : "score"
 - value : 0
 ▿ 9 : 2 elements
 - key : "mobile"
 - value : 13888888888
 ▿ 10 : 2 elements
 - key : "avatar"
 - value : /uploads/image/avatar/1/20220922/425737c41d03d1bab6e390976622308b.png
 */
let userInfoKey = "UserInfoKey"
func saveUserInfo(info: [String: Any]) {
    UserDefaults.standard.set(info, forKey: userInfoKey)
    
    print("info == \(info)")
    // 单独保存Token
    if info.keys.contains("token") {
        let token = info["token"] as? String
        if token != nil {
            saveToken(token: token!)
        }
    }
    
    saveUserId(userId: getUserID())
}

// MARK: 用户数据
func getUserInfo() -> [String: Any] {
    let userInfo = UserDefaults.standard.object(forKey: userInfoKey) ?? [:]
    return userInfo as! [String: Any]
}

func removeUserInfo() {
    UserDefaults.standard.removeObject(forKey: userInfoKey)
//    var emoji = UserDefaultWrapper<String?>(key: UserDefaultKeys.ifNeedInputEmoji)
//    emoji.wrappedValue = ""
}

func getBindPhoneNumber() -> String {
    return getContent(key: "mobile")
}
// -------------新增:lu
func setBindPhoneNumber(moblie:String?){
    guard moblie?.isBlank == false else {return}
    if var userInfo = UserDefaults.standard.object(forKey: userInfoKey) as? [String: Any]{
        userInfo["mobile"] = moblie
        saveUserInfo(info: userInfo)
    }
}

func getUserEmojiString() -> String{
    guard getContent(key: "avatar").isBlank == true else {
        // 存疑，这个方法并不能获取到avater的emoji
        return getContent(key: "avatar")
    }
    return ""
//    let emoji = UserDefaultWrapper<String?>(key: UserDefaultKeys.ifNeedInputEmoji)
//    return emoji.wrappedValue ?? ""
}

func setUserEmojiString(emoji:String?){
    guard emoji?.isBlank == false else {return}
    if var userInfo = UserDefaults.standard.object(forKey: userInfoKey) as? [String: Any]{
        userInfo["avatar"] = emoji
        saveUserInfo(info: userInfo)
    }
//    var emo = UserDefaultWrapper<String?>(key: UserDefaultKeys.ifNeedInputEmoji)
//    emo.wrappedValue = emoji ?? ""
}

//nickname 是授权第三方要带过来的
func setInfoUsername(nicname:String?) {
    guard nicname?.isBlank == false else {return}
    if var userInfo = UserDefaults.standard.object(forKey: userInfoKey) as? [String: Any]{
        userInfo["username"] = nicname
        saveUserInfo(info: userInfo)
    }
}

func getUserKeyPrompt() -> String{
    guard getContent(key: "keyPrompt").isBlank == true else {
        // 存疑，这个方法并不能获取到avater的emoji
        return getContent(key: "keyPrompt")
    }
    
    return ""
}

func setUserKeyPrompt(keyPrompt:String?){
    guard keyPrompt?.isBlank == false else {return}
    if var userInfo = UserDefaults.standard.object(forKey: userInfoKey) as? [String: Any]{
        userInfo["keyPrompt"] = keyPrompt
        saveUserInfo(info: userInfo)
    }
}

func getUserFristLogin() -> String{
    guard getContent(key: "firstLogin").isBlank == true else {
        // 存疑，这个方法并不能获取到avater的emoji
        return getContent(key: "firstLogin")
    }
    
    return ""
}

func setUserFristLogin(firstLogin:String?){
    guard firstLogin?.isBlank == false else {return}
    if var userInfo = UserDefaults.standard.object(forKey: userInfoKey) as? [String: Any]{
        userInfo["firstLogin"] = firstLogin
        saveUserInfo(info: userInfo)
    }
}

func getUserGuide() -> String{
    guard getContent(key: "guide").isBlank == true else {
        // 存疑，这个方法并不能获取到avater的emoji
        return getContent(key: "guide")
    }
    return ""
}

func setUserGuide(guide:String?){
    guard guide?.isBlank == false else {return}
    if var userInfo = UserDefaults.standard.object(forKey: userInfoKey) as? [String: Any]{
        userInfo["guide"] = guide
        saveUserInfo(info: userInfo)
    }
}

// -------------
func getNickname() -> String {
    return getContent(key: "nickname")
}

func getUsername() -> String {
    return getContent(key: "username")
}

func getAvatarPath() -> String {
    return getContent(key: "avatar")
}
func getUserID() -> String {
    return getContent(key: "user_id")
}
private func getContent(key: String) -> String {
    let userInfo = getUserInfo()
    if userInfo.count == 0 { return "" }
    
    var desContent = ""
    if userInfo.keys.contains(key) {
        let content = userInfo[key] as? String
        if content != nil {
            desContent = content!
        }
        let contentNum = userInfo[key] as? NSNumber
        if contentNum != nil {
            desContent = contentNum?.stringValue ?? ""
        }
    }
    
    return desContent
}

// Token
let tokenKey = "TokenKey"
func saveToken(token: String) {
    UserDefaults.standard.set(token, forKey: tokenKey)
}
let userIdKey = "UserIdKey"
func saveUserId(userId: String) {
    UserDefaults.standard.set(userId, forKey: userIdKey)
}
func getToken() -> String {
    let token = UserDefaults.standard.object(forKey: tokenKey) ?? ""
    return token as! String
}

func removeToken() {
    UserDefaults.standard.removeObject(forKey: tokenKey)
}

func removeUserData() {
    removeUserInfo()
    removeToken()
}


let loginFromThirdPlatformKey = "LoginFromThirdPlatformKey"
func saveLoginPlatform(isThirdPlatform: Bool) {
    UserDefaults.standard.set(isThirdPlatform, forKey: loginFromThirdPlatformKey)
}

func isLoginFromThirdPlatform() -> Bool {
    let isThirdPlatform = UserDefaults.standard.object(forKey: loginFromThirdPlatformKey) ?? false
    return isThirdPlatform as! Bool
}

// MARK: 游戏数据
let gamePlatformsKey = "GamePlatformsKey"
func save(gamePlatforms: [[String: Any]]) {
    UserDefaults.standard.set(gamePlatforms, forKey: gamePlatformsKey)
}

func getGamePlatforms() -> [[String: Any]]? {
    let gamePlatforms = UserDefaults.standard.object(forKey: gamePlatformsKey)
    return gamePlatforms as? [[String : Any]]
}

func getGamePlatformModels() -> [PlatformModel] {
    var models: [PlatformModel] = []
    let gamePlatforms = UserDefaults.standard.object(forKey: gamePlatformsKey) ?? [[:]]
    print("gamePlatforms \(gamePlatforms)")
    if (gamePlatforms as! [[String: Any]]).count > 0 {
        for platform in (gamePlatforms as! [[String: Any]]) {
            let model = PlatformModel(JSON: platform)!
            models.append(model)
        }
    }
    return models
    
}

// MARK: 推送相关接口
enum PushNetWork {
    case messagePush(userId:String,msgId:String,content:String)//4.1消息推送
}

extension PushNetWork: TargetType {
    
    // 服务器地址
    public var baseURL: URL {
        return URL(string: "https://apieggshell.vgabc.com")!
    }
    
    // 路径
    public var path: String {
        switch self {
        case .messagePush(_, _, _):
            return "/message/push/"
        }
    }
    
    // 请求方式：.post / .get
    public var method: Moya.Method {
        return .post
    }
    
    // 参数
    public var task: Task {
        var param: [String: Any] = [:]
        switch self {
        case .messagePush(userId: let userId, msgId: let msgId, content: let content):
            param["clientparams"] = clientParams()
            param["time"] = Date().timestamp
            param["token"] = getToken()
            param["user_id"] = userId
            param["content"] = content
            param["msg_id"] = msgId
            param["type"] = NSNumber(value: 0)
            
        }
        let sign = getAPISignWith(params: param)
        param["sign"] = sign
        print(param)
        return .requestParameters(parameters: param, encoding: URLEncoding.default)
    }
    
    // 是否执行Alamofire验证
    public var validate: Bool {
        return false
    }
    
    // 单元测试数据，只在单元测试中有效
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8, allowLossyConversion: true)!
    }
    
    // 请求头
    public var headers: [String : String]? {
        return nil
    }
}



enum UserDefaultKeys {
    /// 是否首次打开 app【控制首页，每次都有，所以不需要改false】
    static let isFirstLaunch = "isFirstLaunch"
    
    //static let tokenKey = "TokenKey"
    //static let ifNeedSign = "TokenKey"
    
    /// 为对接项目准备的key，不使用于检验用户
    //static let thirdSignName = "thirdSignName"
    
    /// 是否需要绑定手机，绑定手机与验证码是同一个key
    //static let ifNeedBindPhone = "mobile"
    /// 是否需要输入emoji
    //static let ifNeedInputEmoji = "ifNeedInputEmoji"
    /// 是否需要输入nicname
    //static let ifNeedInputNicname = "ifNeedInputNicname"
    /// 是否需要展示【分享高光时刻】
    //static let ifNeedShareGuide = "ifNeedShareGuide"
    /// 是否需要展示【让你可以向大家炫耀】
    //static let ifNeedScreenshot = "ifNeedScreenshot"
    /// 是否需要展示【保持软件更新】0表示没有访问过，1表示同意，2表示否定
    static let ifNeedNoti = "ifNeedNoti"
    /// 是否需要展示【保存影片剪辑】0表示没有访问过，1表示同意，2表示否定
    static let ifNeedLibrary = "ifNeedLibrary"
    /// 是否需要展示【五个壳的展示】
    //static let ifNeedShowShell = "ifNeedShowShell"
    
    /// 个人信息编辑，关于您
    //static let aboutYour = "aboutYour"
    
    /// 保存的用户头像背景颜色
    static let saveEmojiColor = "saveEmojiColor"
    
}

@propertyWrapper struct UserDefaultWrapper<T> {
    
    var key: String
    
    var defaultValue: T
    
    var storage: UserDefaults
    
    var wrappedValue: T {
        
        get {
            let result = storage.value(forKey: key) as? T
            return result ?? defaultValue
        }
        
        set {
            if let optional = newValue as? AnyOptional {
                if let value = optional.getRootWrapped() {
                    print("value = \(value) key = \(key)")
                    storage.setValue(value, forKey: key)
                } else {
                    storage.removeObject(forKey: key)
                }
            } else {
                storage.setValue(newValue, forKey: key)
            }
        }
    }
    
    init(wrappedValue defaultValue: T,
         key: String,
         storage: UserDefaults = UserDefaults.standard) {
        print("--------defaultValue == \(defaultValue)")
        self.defaultValue = defaultValue
        self.key = key
        self.storage = storage
    }
}

extension UserDefaultWrapper where T: ExpressibleByNilLiteral {
    init(key: String,
         storage: UserDefaults = UserDefaults.standard) {
        self.defaultValue = nil
        self.key = key
        self.storage = storage
    }
}

protocol AnyOptional {
    func getRootWrapped() -> Any?
}

extension Optional: AnyOptional {
    func getRootWrapped() -> Any? {
        switch self {
        case .some(let wrapped as AnyOptional):
            return wrapped.getRootWrapped()
        case .some(let wrapped):
            return wrapped
        case .none:
            return nil
        }
    }
}
