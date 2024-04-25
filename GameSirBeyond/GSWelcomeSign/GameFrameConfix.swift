
import UIKit
let kWidth = UIScreen.main.bounds.width
let kHeight = UIScreen.main.bounds.height


////判断是否为iPhone
let kIs_iphone:Bool                  = (UI_USER_INTERFACE_IDIOM() == .phone)
let kIs_iPhoneX:Bool                 = (kWidth >= 375.0 && kHeight >= 812.0 && true == kIs_iphone)

let kRatio:CGFloat                   = kWidth/kHeight


///状态栏，导航栏，tabar高度
/// 状态栏高度
let kStatusBarHeight:CGFloat         = UIApplication.shared.statusBarFrame.size.height
///导航高度
let kNavBarHeight:CGFloat            = 44
///整个导航栏高度
let kTopHeight:CGFloat               = kNavBarHeight + kStatusBarHeight
///底部tabbar高度
let kTabBarHeight:CGFloat            = kStatusBarHeight > 20 ? 83:49
/// 底部安全区域远离高度
let kSafeBottomHeight:CGFloat        = kIs_iPhoneX ? 34:0

let IS_IPAD:Bool                     = (UI_USER_INTERFACE_IDIOM() == .pad)

let kFocalScale:CGFloat              = 1
let kSafeTopHeight:CGFloat           = ((kHeight>=812.0 && false == IS_IPAD) ? 44:0)



// 长按0.5秒进入截图长按
let ScreenshotLongPressBeginTime = 0.3
// 截图长按，长按世间
let ScreenshotLongPressSpaceTime:Double = 1

//let ScreenshotLongPressSpeed = 1.0/6.0

typealias Callback = (Bool) -> Void
typealias CallbackReslut = (Bool,[String: Any]?) -> Void
//func delay(interval: TimeInterval, closure: @escaping () -> Void) {
//    DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
//        closure()
//    }
//}

// 登录选项 按钮 失去焦点时的宽度，蓝湖标注
let login_btn_blur_w:CGFloat = 270.widthScale
// 登录选项 按钮 焦点时的宽度，蓝湖标注
let login_btn_focus_w:CGFloat = 286.widthScale
// 登录选项 按钮 高度
let login_btn_h = 44.widthScale

// 12 字体 css weight = [100 - 900] ,默认400
func font_12(weight: UIFont.Weight = .regular) -> UIFont{
    return UIFont.systemFont(ofSize: 12, weight: weight)
}
// 14 字体 css weight = [100 - 900] ,默认400
func font_14(weight: UIFont.Weight = .regular) -> UIFont{
    return UIFont.systemFont(ofSize: 14, weight: weight)
}
// 16 字体 css weight = [100 - 900] ,默认400
func font_16(weight: UIFont.Weight = .regular) -> UIFont{
    return UIFont.systemFont(ofSize: 16, weight: weight)
}
// 18 字体 css weight = [100 - 900] ,默认400
func font_18(weight: UIFont.Weight = .regular) -> UIFont{
    return UIFont.systemFont(ofSize: 18, weight: weight)
}
// 20 字体 css weight = [100 - 900] ,默认400
func font_20(weight: UIFont.Weight = .regular) -> UIFont{
    return UIFont.systemFont(ofSize: 20, weight: weight)
}
// 24 字体 css weight = [100 - 900] ,默认400
func font_24(weight: UIFont.Weight = .regular) -> UIFont{
    return UIFont.systemFont(ofSize: 24, weight: weight)
}
// 24 字体 css weight = [100 - 900] ,默认400
func font_28(weight: UIFont.Weight = .regular) -> UIFont{
    return UIFont.systemFont(ofSize: 28, weight: weight)
}
// 32f 字体 css weight = [100 - 900] ,默认400
func font_32(weight: UIFont.Weight = .regular) -> UIFont{
    return UIFont.systemFont(ofSize: 32, weight: weight)
}
// 44f 字体 css weight = [100 - 900] ,默认400
func font_44(weight: UIFont.Weight = .regular) -> UIFont{
    return UIFont.systemFont(ofSize: 44, weight: weight)
}

//enum ControllerNotificationName: String {
//    case LeftJoystickMoveLeft   = "LeftJoystickMoveLeft"
//    case LeftJoystickMoveRight  = "LeftJoystickMoveRight"
//    case LeftJoystickMoveUp     = "LeftJoystickMoveUp"
//    case LeftJoystickMoveDown   = "LeftJoystickMoveDown"
//    case KeyAPressed            = "KeyAPressed"
//    case KeyBPressed            = "KeyBPressed"
//    case KeyXPressed            = "KeyXPressed"
//    case KeyYPressed            = "KeyYPressed"
//    case KeyMenuPressed         = "KeyMenuPressed"
//    
//    case KeyScreenshotPressed   = "KeyScreenshotPressed"
//    case KeyHomePressed   = "KeyHomePressed"
//    case KeyScreenshotLongPressedBegin   = "KeyScreenshotLongPressedBegin"
//    case KeyScreenshotLongPressedEnd   = "KeyScreenshotLongPressedEnd"
//}

/// 除了手柄的noti之外的点击事件
enum GameLoginWelcomeViewAction {
    /// 苹果登录
    //case onAppleLogin
    /// google登录
    //case onGoogleLogin
    /// 点击这里提交反馈
    case onCommitLoginIssue
    /// 条款与条例
    case onOrdinance
    /// 隐私政策
    case onPrivacy
    /// 个人信息收集通知
    case onCollect
}


extension String{
    /// 通过高阶函数allSatisfy，判断字符串是否为空串
    var isBlank:Bool{
        /// 字符串中的所有字符都符合block中的条件，则返回true
        let _blank = self.allSatisfy{
            let _blank = $0.isWhitespace
            //print("字符：\($0) \(_blank)")
            return _blank
        }
        return _blank
    }
    ///通过裁剪字符串中的空格和换行符，将得到的结过进行isEmpty
    var isReBlank:Bool{
        let str = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return str.isEmpty
    }
}

extension CGFloat {
    var widthScale:CGFloat {
        get{
            return self * kWidth / 852.0
        }
    }
}

extension Int {
    /// 如果不用缩放比,修改此处！！！！
    var widthScale:CGFloat {
        get{
            return CGFloat(self) * kWidth / 852.0
            //return CGFloat(self)
        }
    }
}



import Contacts

typealias CheckContactsCallback = (CNAuthorizationStatus) -> Void

func checkContactsPermissionStatus(x:@escaping CheckContactsCallback) {
    let status = CNContactStore.authorizationStatus(for: .contacts)
    
    switch status {
    case .authorized:
        print("已授权访问通讯录")
        x(status)
    case .denied, .restricted:
        print("未授权访问通讯录或受限")
        x(status)
    case .notDetermined:
        print("尚未确定是否授权")
        // 此时可以请求权限
        requestContactsPermission()
        x(status)
    @unknown default:
        fatalError("未知的通讯录权限状态")
    }
}

func _checkContactsPermissionStatus() -> Bool {
    let status = CNContactStore.authorizationStatus(for: .contacts)
    
    switch status {
    case .authorized:
        print("已授权访问通讯录")
        
    case .denied, .restricted:
        print("未授权访问通讯录或受限")
        
    case .notDetermined:
        print("尚未确定是否授权")
        // 此时可以请求权限
        requestContactsPermission()
        
    @unknown default:
        fatalError("未知的通讯录权限状态")
    }
    
    return status == .authorized
}

func requestContactsPermission() {
    let store = CNContactStore()
    store.requestAccess(for: .contacts) { (granted, error) in
        if let error = error {
            print("请求通讯录权限时发生错误: \(error.localizedDescription)")
        } else {
            print("通讯录权限请求结果: \(granted)")
        }
    }
}

@propertyWrapper
struct Atomic<Value> {

    private var value: Value
    private let lock = NSLock()

    init(wrappedValue value: Value) {
        self.value = value
    }

    var wrappedValue: Value {
      get { return load() }
      set { store(newValue: newValue) }
    }

    func load() -> Value {
        lock.lock()
        defer { lock.unlock() }
        return value
    }

    mutating func store(newValue: Value) {
        lock.lock()
        defer { lock.unlock() }
        value = newValue
    }
}

//extension UIColor {
//    // 16进制颜色
//    class func hex(_ string: String, alpha: CGFloat = 1.0) -> UIColor {
//        let hexString = string.trimmingCharacters(in: .whitespacesAndNewlines)
//        let scanner = Scanner(string: hexString)
//        
//        if hexString.hasPrefix("#") {
//            scanner.scanLocation = 1
//        } else if hexString.hasPrefix("0x") {
//            scanner.scanLocation = 2
//        }
//        var color: UInt32 = 0
//        scanner.scanHexInt32(&color)
//        
//        let mask = 0x0000_00FF
//        let r = Int(color >> 16) & mask
//        let g = Int(color >> 8) & mask
//        let b = Int(color) & mask
//        
//        let red = CGFloat(r) / 255.0
//        let green = CGFloat(g) / 255.0
//        let blue = CGFloat(b) / 255.0
//        
//        return self.init(red: red, green: green, blue: blue, alpha: alpha)
//    }
//    
//    /// 颜色16进制字符串
//    var hexString: String {
//        var r: CGFloat = 0
//        var g: CGFloat = 0
//        var b: CGFloat = 0
//        var a: CGFloat = 0
//        getRed(&r, green: &g, blue: &b, alpha: &a)
//        if a == 1.0 {
//            return String(format: "%0.2X%0.2X%0.2X", UInt(r * 255), UInt(g * 255), UInt(b * 255))
//        } else {
//            return String(format: "%0.2X%0.2X%0.2X%0.2X", UInt(r * 255), UInt(g * 255), UInt(b * 255), UInt(a * 255))
//        }
//    }
//    
//    /// 主题色
//    @objc class var themeColor: UIColor {
//        return hex("2DD178")
//    }
//    
//    /// 随机色
//    class var randomColor: UIColor {
//        let red = CGFloat(arc4random() % 256) / 255.0
//        let green = CGFloat(arc4random() % 256) / 255.0
//        let blue = CGFloat(arc4random() % 256) / 255.0
//        return UIColor(red: red, green: green, blue: blue, alpha: 0.35)
//    }
//    
//    // 获取反色(补色)
//    var invertColor: UIColor {
//        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0
//        getRed(&r, green: &g, blue: &b, alpha: nil)
//        return UIColor(red: 1.0 - r, green: 1.0 - g, blue: 1.0 - b, alpha: 1)
//    }
//}


extension UIView{
    
    // 扩展 x 的 set get 方法
    var x: CGFloat{
        get{
            return frame.origin.x
        }
        set(newX){
            var tmpFrame: CGRect = frame
            tmpFrame.origin.x = newX
            frame = tmpFrame
        }
    }
    
    // 扩展 y 的 set get 方法
    var y: CGFloat{
        get{
            return frame.origin.y
        }
        set(newY){
            var tmpFrame: CGRect = frame
            tmpFrame.origin.y = newY
            frame = tmpFrame
        }
    }
    
    // 扩展 width 的 set get 方法
    var width: CGFloat{
        get{
            return frame.size.width
        }
        set(newWidth){
            var tmpFrameWidth: CGRect = frame
            tmpFrameWidth.size.width = newWidth
            frame = tmpFrameWidth
        }
    }
    
    // 扩展 height 的 set get 方法
    var height: CGFloat{
        get{
            return frame.size.height
        }
        set(newHeight){
            var tmpFrameHeight: CGRect = frame
            tmpFrameHeight.size.height = newHeight
            frame = tmpFrameHeight
        }
    }
    
    // 扩展 centerX 的 set get 方法
    var centerX: CGFloat{
        get{
            return center.x
        }
        set(newCenterX){
            center = CGPoint(x: newCenterX, y: center.y)
        }
    }
    
    // 扩展 centerY 的 set get 方法
    var centerY: CGFloat{
        get{
            return center.y
        }
        set(newCenterY){
            center = CGPoint(x: center.x, y: newCenterY)
        }
    }
    
    // 扩展 origin 的 set get 方法
    var origin: CGPoint{
        get{
            return CGPoint(x: x, y: y)
        }
        set(newOrigin){
            x = newOrigin.x
            y = newOrigin.y
        }
    }
    
    // 扩展 size 的 set get 方法
    var size: CGSize{
        get{
            return CGSize(width: width, height: height)
        }
        set(newSize){
            width = newSize.width
            height = newSize.height
        }
    }
    
    // 扩展 left 的 set get 方法
    var left: CGFloat{
        get{
            return x
        }
        set(newLeft){
            x = newLeft
        }
    }
    
    // 扩展 right 的 set get 方法
    var right: CGFloat{
        get{
            return x + width
        }
        set(newNight){
            x = newNight - width
        }
    }
    
    // 扩展 top 的 set get 方法
    var top: CGFloat{
        get{
            return y
        }
        set(newTop){
            y = newTop
        }
    }
    
    // 扩展 bottom 的 set get 方法
    var bottom: CGFloat{
        get{
            return  y + height
        }
        set(newBottom){
            y = newBottom - height
        }
    }
    
    
    @discardableResult
    func addGradient(colors: [UIColor],
                     point: (CGPoint, CGPoint) = (CGPoint(x: 0.5, y: 0), CGPoint(x: 0.5, y: 1)),
                     locations: [NSNumber] = [0, 1],
                     frame: CGRect = CGRect.zero,
                     radius: CGFloat = 0,
                     at: UInt32 = 0) -> CAGradientLayer {
        let bgLayer1 = CAGradientLayer()
        bgLayer1.colors = colors.map { $0.cgColor }
        bgLayer1.locations = locations
        if frame == .zero {
            bgLayer1.frame = self.bounds
        } else {
            bgLayer1.frame = frame
        }
        bgLayer1.startPoint = point.0
        bgLayer1.endPoint = point.1
        bgLayer1.cornerRadius = radius
        self.layer.insertSublayer(bgLayer1, at: at)
        return bgLayer1
    }
    
    func addGradient(start: CGPoint = CGPoint(x: 0.5, y: 0),
                     end: CGPoint = CGPoint(x: 0.5, y: 1),
                     colors: [UIColor],
                     locations: [NSNumber] = [0, 1],
                     frame: CGRect = CGRect.zero,
                     radius: CGFloat = 0,
                     at: UInt32 = 0) {
        let bgLayer1 = CAGradientLayer()
        bgLayer1.colors = colors.map { $0.cgColor }
        bgLayer1.locations = locations
        bgLayer1.frame = frame
        bgLayer1.startPoint = start
        bgLayer1.endPoint = end
        bgLayer1.cornerRadius = radius
        self.layer.insertSublayer(bgLayer1, at: at)
    }
    
    func addGradient(start_color:String,end_color : String,frame : CGRect?=nil,cornerRadius : CGFloat?=0, at: UInt32 = 0){
        var bounds : CGRect = self.bounds
        if let frame = frame {
            bounds = frame
        }
        let bgLayer1 = CAGradientLayer()
        bgLayer1.colors = [UIColor.hex(start_color).cgColor, UIColor.hex(end_color).cgColor,]
        bgLayer1.locations = [0, 1]
        bgLayer1.frame = bounds
        bgLayer1.startPoint = CGPoint(x: 0, y: 0.61)
        bgLayer1.endPoint = CGPoint(x: 0.61, y: 0.61)
        bgLayer1.cornerRadius = cornerRadius ?? 0
        self.layer.insertSublayer(bgLayer1, at: at)
    }
    
    func addGradient(start_color:String,
                     end_color : String,
                     frame : CGRect?=nil,
                     borader: CGFloat = 0,
                     boraderColor: UIColor = .clear,
                     at: UInt32 = 0,
                     corners: UIRectCorner?,
                     radius: CGFloat = 0) {
        var bounds : CGRect = self.bounds
        if let frame = frame {
            bounds = frame
        }
        let bgLayer1 = CAGradientLayer()
        bgLayer1.colors = [UIColor.hex(start_color).cgColor, UIColor.hex(end_color).cgColor]
        bgLayer1.locations = [0, 1]
        bgLayer1.frame = bounds
        bgLayer1.startPoint = CGPoint(x: 0, y: 0.61)
        bgLayer1.endPoint = CGPoint(x: 0.61, y: 0.61)
        bgLayer1.borderColor = boraderColor.cgColor
        bgLayer1.borderWidth = borader
        if corners != nil {
            let cornerPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners!, cornerRadii: CGSize(width: radius, height: radius))
            let radiusLayer = CAShapeLayer()
            radiusLayer.frame = bounds
            radiusLayer.path = cornerPath.cgPath
            bgLayer1.mask = radiusLayer
        }
        self.layer.insertSublayer(bgLayer1, at: at)
    }
    
    func addGradient(startPoint: CGPoint = CGPoint(x: 0, y: 0.5),
                     start_color:String,
                     endPoint: CGPoint = CGPoint(x: 1, y: 0.5),
                     end_color : String,
                     frame : CGRect? = nil,
                     cornerRadius : CGFloat?=0){
        var bounds : CGRect = self.bounds
        if let frame = frame {
            bounds = frame
        }
        let bgLayer1 = CAGradientLayer()
        bgLayer1.frame = bounds
        bgLayer1.startPoint = startPoint
        bgLayer1.endPoint = endPoint
        bgLayer1.colors = [UIColor.hex(start_color).cgColor, UIColor.hex(end_color).cgColor]
        bgLayer1.locations = [0, 1]
        bgLayer1.cornerRadius = cornerRadius ?? 0
        self.layer.addSublayer(bgLayer1)
    }
    
    func addVerticalGradient(start_color:String,end_color : String,frame : CGRect?=nil,cornerRadius : CGFloat?=0){
        var bounds : CGRect = self.bounds
        if let frame = frame {
            bounds = frame
        }
        let bgLayer1 = CAGradientLayer()
        bgLayer1.colors = [UIColor.hex(start_color).cgColor, UIColor.hex(end_color).cgColor]
        bgLayer1.locations = [0, 1]
        bgLayer1.frame = bounds
        bgLayer1.startPoint = CGPoint(x: 0.5, y: 0)
        bgLayer1.endPoint = CGPoint(x: 1, y: 1)
        bgLayer1.cornerRadius = cornerRadius ?? 0
        self.layer.insertSublayer(bgLayer1, at: 0)
    }
    
//    //将当前视图转为UIImage
//    func asImage() -> UIImage {
//        let renderer = UIGraphicsImageRenderer(bounds: bounds)
//        return renderer.image { rendererContext in
//            layer.render(in: rendererContext.cgContext)
//        }
//    }
}





extension String{
    /// 判断是不是Emoji
    ///
    /// - Returns: true false
    func containsEmoji()->Bool{
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F,
                0x1F300...0x1F5FF,
                0x1F680...0x1F6FF,
                0x2600...0x26FF,
                0x2700...0x27BF,
                0xFE00...0xFE0F:
                return true
            default:
                continue
            }
        }
        
        return false
    }
    
    /// 判断是不是Emoji
    ///
    /// - Returns: true false
    func hasEmoji()->Bool {
        
        let pattern = "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"
        let pred = NSPredicate(format: "SELF MATCHES %@",pattern)
        return pred.evaluate(with: self)
    }
    
    //验证邮箱
    static func validateEmail(email: String) -> Bool {
        if email.count == 0 {
            return false
        }
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    //验证手机号
    static func isPhoneNumber(phoneNumber:String) -> Bool {
        if phoneNumber.count == 0 {
            return false
        }
        let mobile = "^1([358][0-9]|4[579]|66|7[0135678]|9[89])[0-9]{8}$"
        let regexMobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        if regexMobile.evaluate(with: phoneNumber) == true {
            return true
        }else
        {
            return false
        }
    }
    
    //密码正则  6-8位字母和数字组合
    static func isPasswordRuler(password:String) -> Bool {
        let passwordRule = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,8}$"
        let regexPassword = NSPredicate(format: "SELF MATCHES %@",passwordRule)
        if regexPassword.evaluate(with: password) == true {
            return true
        }else
        {
            return false
        }
    }
    
//    //验证身份证号
//    static func isTrueIDNumber(text:String) -> Bool{
//        var value = text
//        value = value.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
//        var length : Int = 0
//        length = value.count
//        if length != 15 && length != 18{
//            //不满足15位和18位，即身份证错误
//            return false
//        }
//        // 省份代码
//        let areasArray = ["11","12", "13","14", "15","21", "22","23", "31","32", "33","34", "35","36", "37","41", "42","43", "44","45", "46","50", "51","52", "53","54", "61","62", "63","64", "65","71", "81","82", "91"]
//        // 检测省份身份行政区代码
//        let index = value.index(value.startIndex, offsetBy: 2)
//        let valueStart2 = value.substring(to: index)
//        //标识省份代码是否正确
//        var areaFlag = false
//        for areaCode in areasArray {
//            if areaCode == valueStart2 {
//                areaFlag = true
//                break
//            }
//        }
//        if !areaFlag {
//            return false
//        }
//        var regularExpression : NSRegularExpression?
//        var numberofMatch : Int?
//        var year = 0
//        switch length {
//        case 15:
//            //获取年份对应的数字
//            let valueNSStr = value as NSString
//            let yearStr = valueNSStr.substring(with: NSRange.init(location: 6, length: 2)) as NSString
//            year = yearStr.integerValue + 1900
//            if year % 4 == 0 || (year % 100 == 0 && year % 4 == 0) {
//                //创建正则表达式 NSRegularExpressionCaseInsensitive：不区分字母大小写的模式
//                //测试出生日期的合法性
//                regularExpression = try! NSRegularExpression.init(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$", options: NSRegularExpression.Options.caseInsensitive)
//            }else{
//                //测试出生日期的合法性
//                regularExpression = try! NSRegularExpression.init(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$", options: NSRegularExpression.Options.caseInsensitive)
//            }
//            numberofMatch = regularExpression?.numberOfMatches(in: value, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange.init(location: 0, length: value.count))
//            if numberofMatch! > 0 {
//                return true
//            }else{
//                return false
//            }
//        case 18:
//            let valueNSStr = value as NSString
//            let yearStr = valueNSStr.substring(with: NSRange.init(location: 6, length: 4)) as NSString
//            year = yearStr.integerValue
//            if year % 4 == 0 || (year % 100 == 0 && year % 4 == 0) {
//                //测试出生日期的合法性
//                regularExpression = try! NSRegularExpression.init(pattern: "^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}(((19|20)\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|((19|20)\\d{2}(0[13578]|1[02])31)|((19|20)\\d{2}02(0[1-9]|1\\d|2[0-8]))|((19|20)([13579][26]|[2468][048]|0[048])0229))\\d{3}(\\d|X|x)?$", options: NSRegularExpression.Options.caseInsensitive)
//                
//            }else{
//                //测试出生日期的合法性
//                regularExpression = try! NSRegularExpression.init(pattern: "^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}(((19|20)\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|((19|20)\\d{2}(0[13578]|1[02])31)|((19|20)\\d{2}02(0[1-9]|1\\d|2[0-8]))|((19|20)([13579][26]|[2468][048]|0[048])0229))\\d{3}(\\d|X|x)?$", options: NSRegularExpression.Options.caseInsensitive)
//                
//            }
//            numberofMatch = regularExpression?.numberOfMatches(in: value, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange.init(location: 0, length: value.count))
//            
//            if numberofMatch! > 0 {
//                let a = getStringByRangeIntValue(Str: valueNSStr, location: 0, length: 1) * 7
//                let b = getStringByRangeIntValue(Str: valueNSStr, location: 10, length: 1) * 7
//                let c = getStringByRangeIntValue(Str: valueNSStr, location: 1, length: 1) * 9
//                let d = getStringByRangeIntValue(Str: valueNSStr, location: 11, length: 1) * 9
//                let e = getStringByRangeIntValue(Str: valueNSStr, location: 2, length: 1) * 10
//                let f = getStringByRangeIntValue(Str: valueNSStr, location: 12, length: 1) * 10
//                let g = getStringByRangeIntValue(Str: valueNSStr, location: 3, length: 1) * 5
//                let h = getStringByRangeIntValue(Str: valueNSStr, location: 13, length: 1) * 5
//                let i = getStringByRangeIntValue(Str: valueNSStr, location: 4, length: 1) * 8
//                let j = getStringByRangeIntValue(Str: valueNSStr, location: 14, length: 1) * 8
//                let k = getStringByRangeIntValue(Str: valueNSStr, location: 5, length: 1) * 4
//                let l = getStringByRangeIntValue(Str: valueNSStr, location: 15, length: 1) * 4
//                let m = getStringByRangeIntValue(Str: valueNSStr, location: 6, length: 1) * 2
//                let n = getStringByRangeIntValue(Str: valueNSStr, location: 16, length: 1) * 2
//                let o = getStringByRangeIntValue(Str: valueNSStr, location: 7, length: 1) * 1
//                let p = getStringByRangeIntValue(Str: valueNSStr, location: 8, length: 1) * 6
//                let q = getStringByRangeIntValue(Str: valueNSStr, location: 9, length: 1) * 3
//                let S = a + b + c + d + e + f + g + h + i + j + k + l + m + n + o + p + q
//                
//                let Y = S % 11
//                
//                var M = "F"
//                
//                let JYM = "10X98765432"
//                
//                M = (JYM as NSString).substring(with: NSRange.init(location: Y, length: 1))
//                
//                let lastStr = valueNSStr.substring(with: NSRange.init(location: 17, length: 1))
//                
//                if lastStr == "x" {
//                    if M == "X" {
//                        return true
//                    }else{
//                        return false
//                    }
//                }else{
//                    if M == lastStr {
//                        return true
//                    }else{
//                        return false
//                    }
//                }
//                
//            }else{
//                return false
//            }
//        default:
//            return false
//        }
//    }
}
