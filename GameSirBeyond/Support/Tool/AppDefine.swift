//
//  Header.swift
//  EggShell
//
//  Created by 刘富铭 on 2021/12/16.
//

import Foundation
import UIKit

let thisAppAppleId = "1208031597"

func isIPhoneXOrLaterDevice() -> Bool {
    if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
        if (UIApplication.shared.keyWindow?.safeAreaInsets.bottom)! > 0.0 {
            return true
        }
    }
    return false
}

// MARK: 字体
func pingFang(size: CGFloat) -> UIFont {
    guard let font = UIFont(name: "PingFangSC-Regular", size: size) else {
        return UIFont.systemFont(ofSize: size)
    }
    return font
}

func pingFangM(size: CGFloat) -> UIFont {
    guard let font = UIFont(name: "PingFangSC-Medium", size: size) else {
        return UIFont.systemFont(ofSize: size)
    }
    return font
}

// MARK: 颜色
func color(r:CGFloat, g:CGFloat, b:CGFloat) -> UIColor {
    return color(r: r, g: g, b: b, alpha: 1.0)
}

func color(r:CGFloat, g:CGFloat, b:CGFloat, alpha:CGFloat) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alpha)
}

func color(hex:Int) -> UIColor {
    return color(hex: hex, alpha: 1.0)
}

func color(hex:Int, alpha:CGFloat) -> UIColor {
    return color(r: CGFloat(((hex & 0xFF0000) >> 16)), g: CGFloat(((hex & 0x00FF00) >> 8)), b: CGFloat(((hex & 0x0000FF) >> 0)), alpha: alpha)
}

// 主色
func mainColor() -> UIColor {
    return color(hex: 0xfece02)
}

func i18n(string: String) -> String {
    return NSLocalizedString(string, comment: "")
}

func delay(interval: TimeInterval, closure: @escaping () -> Void) {
     DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
          closure()
     }
}

func MainThread(closure: @escaping () -> Void) {
    if Thread.current.isMainThread {
        closure()
    } else {
        DispatchQueue.main.async {
            MainThread(closure: closure)
            return
        }
    }
}

func currentWindow() -> UIWindow? {
    var window: UIWindow
    for scene in UIApplication.shared.connectedScenes {
        if scene.activationState == UIScene.ActivationState.foregroundActive {
            let windowScene = scene as! UIWindowScene
            window = (windowScene.windows.first)!
            return window
        }
    }
    return nil
}

// MARK: 设置RootViewController
func setGameViewControllerToRoot() {
    if UIViewController.current() is GameViewController {
        return
    }
    
    MainThread {
        let window = UIApplication.shared.windows.first// 用currentWindow()不起作用
        let homePage = GameViewController.init()
        let naviPage = UINavigationController.init(rootViewController: homePage)
        window?.backgroundColor = .white
        window?.rootViewController = naviPage
    }
}

// MARK: 截屏的文件夹
func screenshotsPath() -> String {
    let fileManager = FileManager.default
    let path = NSHomeDirectory().appending("/Documents/Screenshots/" + getUserID() + "/")   //路径加入userid 区分不同用户的截屏
    if fileManager.isExecutableFile(atPath: path) == false {
        do {
            try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true)
        }
        catch {
            print("创建截屏文件夹失败", error)
        }
    }
    return path
}

// MARK: 录屏的文件夹
func recordingsPath() -> String {
    let fileManager = FileManager.default
    let str = "/Documents/Recordings/" + getUserID() + "/"    //路径加入userid 区分不同用户的录屏
    let path = NSHomeDirectory().appending(str)
    if fileManager.isExecutableFile(atPath: path) == false {
        do {
            try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true)
        }
        catch {
            print("创建录屏文件夹失败", error)
        }
    }
    return path
}

// MARK: 高光时刻视频的文件夹
func highlightsPath() -> String {
    let fileManager = FileManager.default
    let path = NSHomeDirectory().appending("/Documents/Highlights/" + getUserID() + "/") //路径加入userid 区分不同用户的高光时刻
    if fileManager.isExecutableFile(atPath: path) == false {
        do {
            try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true)
        }
        catch {
            print("创建高光时刻文件夹失败", error)
        }
    }
    print(path)
    return path
}


// 日期 转 字符串
func stringFrom(date: Date) -> String {
    let formatter = DateFormatter.init()
    formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"// 加_原因：图片名称包含空格会报错，无法保存图片
    let dateString = formatter.string(from: date)
    return dateString
}

// 字符串 转 日期
func dateFrom(dateString: String) -> Date {
    let formatter = DateFormatter.init()
    formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
    var date = formatter.date(from: dateString)
    date = Date.dateFromGMT(date ?? Date())
    return date ?? Date()
}


// 保存图片至沙盒
func save(image: UIImage, name: String) {
    if let imageData = image.pngData() {
        // 保存图片到指定路径
        let savedPath = "file://" + screenshotsPath().appending(name).appending(".png")
        do {
            try imageData.write(to: URL.init(string: savedPath)!)
            print("图片已保存，路径：\(savedPath)")
            
            // 发送通知给Captures页面
            NotificationCenter.default.post(name: Notification.Name("GetScreenshotNotification"), object: nil)
        }
        catch {
            print("图片保存错误：", error)
        }
    }
}

// MARK: 获取本地保存的截图
func getScreenshots() -> [String] {
    
    var imagePaths: [String] = []
    let path = screenshotsPath()
    let manager = FileManager.default
    do {
        // fileNames：["2022-11-22_16-12-09.png", "2022-11-22_16-01-09.png", ...]
        var fileNames = try manager.contentsOfDirectory(atPath: path)
        fileNames = fileNames.sorted(by: >)// 降序
        for name in fileNames {
            imagePaths.append(screenshotsPath() + name)
        }
    }
    catch {
        print("获取截图失败", error)
    }
    
    return imagePaths
}

// MARK: 获取本地保存的录屏
func getRecordings() -> [String] {
//    print(ScreenRecSharePath.fetechAllResourceToString())
//    return ScreenRecSharePath.fetechAllEXResourceToString()
    var paths: [String] = []
    let path = recordingsPath()
    let manager = FileManager.default
    do {
        // fileNames：["2022-11-22_16-12-09.png", "2022-11-22_16-01-09.png", ...]
        var fileNames = try manager.contentsOfDirectory(atPath: path)
        fileNames = fileNames.sorted(by: >)// 降序
        for name in fileNames {
            if name.hasSuffix("mp4") {// 该文件夹包含视频和视频的封面，需过滤掉封面
                paths.append(recordingsPath() + name)
            }
        }
    }
    catch {
        print("获取录屏文件失败", error)
    }

    return paths
}

// MARK: 获取本地保存的高光时刻视频
func getHighlights() -> [String] {
    var highlightsPaths: [String] = []
    let path = highlightsPath()
    let manager = FileManager.default
    do {
        // fileNames：["2022-11-22_16-12-09.png", "2022-11-22_16-01-09.png", ...]
        var fileNames = try manager.contentsOfDirectory(atPath: path)
        fileNames = fileNames.sorted(by: >)// 降序
        for name in fileNames {
            if(name.contains("mp4")){
                highlightsPaths.append(highlightsPath() + name)
            }
        }
    }
    catch {
        print("获取高光时刻视频文件失败", error)
    }

    return highlightsPaths
}

func eggshellAppDelegate() -> AppDelegate {
    var delegate: AppDelegate!
    MainThread {
        delegate = UIApplication.shared.delegate as? AppDelegate
    }
    return delegate
}

// MARK: 卡片大小，数据来自Backbone，经过微调
func smallCardWidth() -> CGFloat { return 245.0 }
func smallCardHeight() -> CGFloat { return ((smallCardWidth()/16.0)*9)}
func bigCardWidth() -> CGFloat { return 320.0 }
func bigCardHeight() -> CGFloat { return 180.0 }
func superBigCardWidth() -> CGFloat { return 390.0 }
func superBigCardHeight() -> CGFloat { return 220.0 }

// MARK: 动画时长
func animationDuration() -> CGFloat { return 0.25 }
