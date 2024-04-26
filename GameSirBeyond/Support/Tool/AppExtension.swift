//
//  Category.swift
//  EggShell
//
//  Created by 刘富铭 on 2021/12/21.
//

import Foundation
import QuartzCore
import UIKit
import CommonCrypto
//import SwiftGifOrigin

// MARK: 实现xib设置边框颜色。注意：在xib中，设置边框颜色的Key Path是layer.borderUIColor，而不是layer.borderColor
@IBDesignable extension CALayer {
    
    @IBInspectable var borderUIColor: UIColor {
        get {
            return UIColor(cgColor: self.borderColor!)
        }
        set {
            self.borderColor = newValue.cgColor
        }
    }
}


@IBDesignable extension CALayer {
    
    @IBInspectable var shadowUIColor: UIColor {
        get {
            return UIColor(cgColor: self.shadowColor!)
        }
        set {
            self.shadowColor = newValue.cgColor
        }
    }
}

extension UIImage {
    
    /// 用颜色生成图片
    static func from(color: UIColor, size: CGSize) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }

}

extension UIViewController {
    
    /// 当前Controller
    static func current() -> UIViewController? {
        
        var window: UIWindow
        for scene in UIApplication.shared.connectedScenes {
            if scene.activationState == UIScene.ActivationState.foregroundActive {
                let windowScene = scene as! UIWindowScene
                window = (windowScene.windows.first)!
                return window.rootViewController?.top()
            }
        }
        return nil
    }
    
    func top() -> UIViewController? {
        
        if let navigationController = self as? UINavigationController {
            return navigationController.topViewController?.top()
        }
        else if let tabBarController = self as? UITabBarController {
            if let selectedViewController = tabBarController.selectedViewController {
                return selectedViewController.top()
            }
            return tabBarController.top()
        }
            
        else if let presentedViewController = self.presentedViewController {
            return presentedViewController.top()
        }
        
        else {
            return self
        }
    }
}

// Label文字的本地化 in Xib
class I18nLabel: UILabel {
    
}

@IBDesignable extension I18nLabel {
    
    @IBInspectable var i18nText: String {
        set {
            self.text = i18n(string: newValue)
        }
        get {
            return self.text!
        }
    }
}

// MARK: 便于XIB按钮标题的翻译
class I18nButton: UIButton {
    
}

@IBDesignable extension I18nButton {
    
    @IBInspectable var i18nTextNormal: String {
        set {
            self.setTitle(i18n(string: newValue), for: UIControl.State.normal)
        }
        get {
            return (self.titleLabel?.text)!
        }
    }
    
    @IBInspectable var i18nTextSelected: String {
        set {
            self.setTitle(i18n(string: newValue), for: UIControl.State.selected)
        }
        get {
            return (self.titleLabel?.text)!
        }
    }
}

// MARK: 设置TextField文字与左侧距离
class i18nTextField: UITextField {
}

@IBDesignable extension i18nTextField {
    
    @IBInspectable var i18Placeholder: String {
        set {
            self.placeholder = i18n(string: newValue)
        }
        get {
            return self.placeholder ?? ""
        }
    }
    
    @IBInspectable var addLeftPadding: Bool {
        set {
            if newValue == true {
                let paddingView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 18, height: self.frame.size.height))
                self.leftView = paddingView
                self.leftViewMode = UITextField.ViewMode.always
            }
            else {
                self.leftViewMode = UITextField.ViewMode.never
            }
        }
        get {
            return false
        }
    }
    
    @IBInspectable var showLeftImage: UIImage {
        set {
            if newValue.isKind(of: UIImage.self) {
                let bgView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 35, height: self.frame.size.height))
                let imageView = UIImageView.init(image: newValue)
                imageView.frame = CGRect.init(x: 15, y: 0, width: 14, height: self.frame.size.height)
                imageView.contentMode = UIView.ContentMode.scaleAspectFit
                bgView.addSubview(imageView)
                
                self.leftView = bgView
                self.leftViewMode = UITextField.ViewMode.always
            }
        }
        get {
            return UIImage.init(named: "input_icon_search")!
        }
    }
}

// MARK: 设置文字边距
class InsetLabel: UILabel {
    
    // 1.定义一个接受间距的属性
    var textInsets = UIEdgeInsets.zero
    
    //2. 返回 label 重新计算过 text 的 rectangle
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        guard text != nil else {
            return super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        }
        
        let insetRect = bounds.inset(by: textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                                          left: -textInsets.left,
                                          bottom: -textInsets.bottom,
                                          right: -textInsets.right)
        return textRect.inset(by: invertedInsets)
    }
    
    //3. 绘制文本时，对当前 rectangle 添加间距
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
}

@IBDesignable extension InsetLabel {
    
    @IBInspectable
    var leftTextInset: CGFloat {
        set { textInsets.left = newValue }
        get { return textInsets.left}
    }
    
    @IBInspectable
    var rightTextInset: CGFloat {
        set { textInsets.right = newValue }
        get { return textInsets.right}
    }
    
    @IBInspectable
    var topTextInset: CGFloat {
        set { textInsets.top = newValue }
        get { return textInsets.top}
    }
    
    @IBInspectable
    var bottomTextInset: CGFloat {
        set { textInsets.bottom = newValue }
        get { return textInsets.bottom}
    }
}

func md5File(url: URL) -> String? {
    
    let bufferSize = 1024 * 1024
    
    do {
        // 打开文件
        let file = try FileHandle(forReadingFrom: url)
        defer {
            file.closeFile()
        }
        
        // 初始化内容
        var context = CC_MD5_CTX()
        CC_MD5_Init(&context)
        
        // 读取文件信息
        while case let data = file.readData(ofLength: bufferSize), data.count > 0 {
            data.withUnsafeBytes {
                _ = CC_MD5_Update(&context, $0, CC_LONG(data.count))
            }
        }
        
        // 计算Md5摘要
        var digest = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        digest.withUnsafeMutableBytes {
            _ = CC_MD5_Final($0, &context)
        }
        
        return digest.map { String(format: "%02hhx", $0) }.joined()
        
    } catch {
        print("Cannot open file:", error.localizedDescription)
        return nil
    }
}

extension String {
    
    func md5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        return String(format: hash as String)
    }
    
    func localized() -> String {
       return Bundle.main.localizedString(forKey: self, value: nil, table: nil)
     }
}

// MARK: - 字符串截取
extension String {
    func hexValue() -> Int {
        let intValue = Int(self, radix: 16)
        return intValue ?? 0
    }
    
    /// String使用下标截取字符串
    /// string[index] 例如："abcdefg"[3] // c
    subscript (i:Int)->String{
        let startIndex = self.index(self.startIndex, offsetBy: i)
        let endIndex = self.index(startIndex, offsetBy: 1)
        return String(self[startIndex..<endIndex])
    }
    /// String使用下标截取字符串
    /// string[index..<index] 例如："abcdefg"[3..<4] // d
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
            return String(self[startIndex..<endIndex])
        }
    }
    /// String使用下标截取字符串
    /// string[index,length] 例如："abcdefg"[3,2] // de
    subscript (index:Int , length:Int) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let endIndex = self.index(startIndex, offsetBy: length)
            return String(self[startIndex..<endIndex])
        }
    }
    // 截取 从头到i位置
    func substring(to:Int) -> String{
        return self[0..<to]
    }
    // 截取 从i到尾部
    func substring(from:Int) -> String{
        return self[from..<self.count]
    }
}


public extension DispatchQueue {
    
    private static var _onceTracker = [String]()

    class func once(file: String = #file,
                           function: String = #function,
                           line: Int = #line,
                           block: () -> Void) {
        let token = "\(file):\(function):\(line)"
        once(token: token, block: block)
    }

    class func once(token: String,
                           block: () -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }

        guard !_onceTracker.contains(token) else { return }

        _onceTracker.append(token)
        block()
    }
}

extension UIView {
    
    func viewController() -> UIViewController? {
        var next: UIResponder?
        next = self.next!
        repeat {
            if ((next as? UIViewController) != nil) {
                return (next as! UIViewController)
            }
            else {
                next = next?.next
            }
        } while next != nil
        
        return UIViewController()
    }
}

extension Date {
    
    /// 获取时间戳（秒级） 10位
    var timestamp : Int {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timestamp = Int(timeInterval)
        return timestamp
    }
    
    var string: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
}

// MARK: 字典转字符串
extension Dictionary {
    
    func string() -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self,
                                                     options: []) else {
            return nil
        }
        guard let string = String(data: data, encoding: .utf8) else {
            return nil
        }
        return string
     }
    
}

extension UIButton {
    
    typealias callback = () -> Void
    func pressAnimation(callback: @escaping callback) {
        UIView.animate(withDuration: 0.1, delay: 0) {
            self.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        } completion: { _ in
            UIView.animate(withDuration: 0.1, delay: 0) {
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
            } completion: { _ in
                callback()
            }
        }
    }
    
    func pressAnimationForSelected(callback: @escaping callback) {
        UIView.animate(withDuration: 0.1, delay: 0) {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        } completion: { _ in
            UIView.animate(withDuration: 0.1, delay: 0) {
                self.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
            } completion: { _ in
                callback()
            }
        }
    }
}

extension UIView {
    /// 屏幕转截图
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    /// 添加高斯模糊效果
    func addBlurEffect(style: UIBlurEffect.Style, alpha: CGFloat) {
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.alpha = alpha
        addSubview(blurView)
    }
    
    func updateBlurEffect(alpha: CGFloat) {
        for subview in subviews {
            if subview is UIVisualEffectView {
                (subview as! UIVisualEffectView).alpha = alpha
                break
            }
        }
    }
}

extension Date {
    // 转成当前时区的日期
    static func dateFromGMT(_ date: Date) -> Date {
        let secondFromGMT: TimeInterval = TimeInterval(TimeZone.current.secondsFromGMT(for: date))
        return date.addingTimeInterval(secondFromGMT)
    }
}

extension UIApplication {
    var keyWindow: UIWindow? {
        self.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }.first?.windows
            .filter { $0.isKeyWindow }.first
    }
}

@IBDesignable extension UIImageView {
    
    @IBInspectable var gifName: String {
        set {
            let gifImage = UIImage.gif(name: newValue)
            self.image = gifImage
        }
        get {
            return ""
        }
    }
}

extension NSMutableAttributedString {
    
    convenience init(contents: [Any], imageSize: CGSize = CGSizeMake(25, 25), imageY: CGFloat = -10) {
        self.init()
        
        for (index, content) in contents.enumerated() {
            if let strContent = content as? String {
                let atbString = NSAttributedString(string: "\(strContent)")
                self.append(atbString)
            }
            else if let atbContent = content as? NSAttributedString {
                self.append(atbContent)
            }
            else if let imageContent = content as? UIImage {
                let attachment = NSTextAttachment()
                attachment.image = imageContent
                attachment.bounds = CGRect(x: 0, y: imageY, width: imageSize.width, height: imageSize.height)
                let atbString = NSAttributedString(attachment: attachment)
                self.append(atbString)
            }
            
            if index < contents.count - 1 {
                let atbString = NSAttributedString(string: " ")
                self.append(atbString)
            }
        }
    }
}




enum ControllerKeyType: Int {
    case a
    case b
    case x
    case y
    case menu
}

extension UIButton {
    
    func setControllerImage(type: ControllerKeyType, whiteStyle: Bool = true) {
        setImage(getControllerImage(type: type, whiteStyle: whiteStyle), for: .normal)
        
        // 注释原因：不需要根据ABXY布局的变更而更改图片
//        NotificationCenter.default.addObserver(forName: Notification.Name("DidGetABXYLayoutNotification"), object: nil, queue: .main) { notification in
//            print("UIButton收到通知：DidGetABXYLayoutNotification")
//            self.setImage(getControllerImage(type: type, whiteStyle: whiteStyle), for: .normal)
//        }
    }
}

extension UIImageView {
    
    func setControllerImage(type: ControllerKeyType, whiteStyle: Bool = true) {
        image = getControllerImage(type: type, whiteStyle: whiteStyle)
        
        // 注释原因：不需要根据ABXY布局的变更而更改图片
//        NotificationCenter.default.addObserver(forName: Notification.Name("DidGetABXYLayoutNotification"), object: nil, queue: .main) { notification in
//            print("UIImageView收到通知：DidGetABXYLayoutNotification")
//            self.image = getControllerImage(type: type, whiteStyle: whiteStyle)
//        }
    }
}

func getControllerImage(type: ControllerKeyType, whiteStyle: Bool = true) -> UIImage {
    
//    if abxyLayout() == ABXYLayout.MFi.rawValue {
        if isConnectedLeadJoyM1Controller() {
            var imageName = ""
            switch type {
            case .a:
                imageName = "m1c_a"
            case .b:
                imageName = "m1c_b"
            case .x:
                imageName = "m1c_x"
            case .y:
                imageName = "m1c_y"
            case .menu:
                imageName = "m1c_menu"
            }
            if whiteStyle == false {
                if type != .menu {// 这张图片没有_black版本
                    imageName = imageName + "_black"
                }
            }
            return UIImage(named: imageName)!
        }
        else {
            var imageName = ""
            switch type {
            case .a:
                imageName = "gamepad_key_a"
            case .b:
                imageName = "gamepad_key_b"
            case .x:
                imageName = "gamepad_key_x"
            case .y:
                imageName = "gamepad_key_y"
            case .menu:
                imageName = "gamepad_key_menu"
            }
            if whiteStyle == false {
                if type != .menu {// 这张图片没有_black版本
                    imageName = imageName + "_black"
                }
            }
            return UIImage(named: imageName)!
        }
//    }
//    else {
//        if isConnectedLeadJoyM1Controller() {
//            var imageName = ""
//            switch type {
//            case .a:
//                imageName = "m1c_b"
//            case .b:
//                imageName = "m1c_a"
//            case .x:
//                imageName = "m1c_y"
//            case .y:
//                imageName = "m1c_x"
//            case .menu:
//                imageName = "m1c_menu"
//            }
//            if whiteStyle == false {
//                if type != .menu {// 这张图片没有_black版本
//                    imageName = imageName + "_black"
//                }
//            }
//            return UIImage(named: imageName)!
//        }
//        else {
//            var imageName = ""
//            switch type {
//            case .a:
//                imageName = "gamepad_key_b"
//            case .b:
//                imageName = "gamepad_key_a"
//            case .x:
//                imageName = "gamepad_key_y"
//            case .y:
//                imageName = "gamepad_key_x"
//            case .menu:
//                imageName = "gamepad_key_menu"
//            }
//            if whiteStyle == false {
//                if type != .menu {// 这张图片没有_black版本
//                    imageName = imageName + "_black"
//                }
//            }
//            return UIImage(named: imageName)!
//        }
//    }
}
