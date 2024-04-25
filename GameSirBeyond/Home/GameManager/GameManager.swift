//
//  GameManager.swift
//  Eggshell
//
//  Created by 刘富铭 on 2022/12/7.
//

import UIKit
import StoreKit

class GameManager: NSObject, SKOverlayDelegate, SKStoreProductViewControllerDelegate {

    var allGames: [SearchGameModel] = []
    var topicModels: [TopicModel] = []
    var gameListModels: [GameListModel] = []
    
    static var shared: GameManager = {
        let instance = GameManager.init()
        return instance
    }()
    
    /// 打开游戏。如果没有下载游戏，如弹出下载窗口
    var isWaitingDownloadPageFinish = false
    func openGame(urlSchemes: [String], platforms: [PlatformModel]) {
        if isWaitingDownloadPageFinish { return }
        
        // 1. App已下载，跳转到App
        if urlSchemes != [] {
            for scheme in urlSchemes {
                let openUrl = URL.init(string: scheme + "://")!
                if UIApplication.shared.canOpenURL(openUrl) {
                    UIApplication.shared.open(openUrl)
                    return
                }
            }
        }
        
        // 获取App下载地址
        var appStoreId = ""
        var downloadUrl = ""
//        for platform in platforms {
//            if platform.name.lowercased().contains("App Store".lowercased()) {
//                downloadUrl = platform.downloadUrl
//            }
//        }
        if downloadUrl.contains("/id") {
            let separates = downloadUrl.components(separatedBy: "/id")
            appStoreId = separates.last!
        }
//        print("appStoreId：", appStoreId)
        if appStoreId == "" {
            MBProgressHUD.showMsgWithtext(i18n(string: "The game ID is missing and cannot be downloaded"))
            return
        }
        
        // 2. App未下载，弹出游戏下载页面
        var isLimitedToPresentDownloadPage = false
        if appStoreId != "" && appStoreId != "0" {
            if #available(iOS 14.0, *) {// 简洁版下载页面
                guard let scene = currentWindow()?.windowScene else { return }
                let config = SKOverlay.AppConfiguration(appIdentifier: appStoreId, position: .bottom)
                let overlay = SKOverlay(configuration: config)
                overlay.delegate = self
                overlay.present(in: scene)
            }
            else {// 完整版下载页面
                var isDisplayingDownloadPage = false
                let storePage = SKStoreProductViewController.init()
                storePage.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier: appStoreId]) { finish, error in
                    self.isWaitingDownloadPageFinish = false
                    if isLimitedToPresentDownloadPage { return }
                    if finish {
                        UIViewController.current()!.present(storePage, animated: true)
                        isDisplayingDownloadPage = true
                    }
                    else {
                        MBProgressHUD.showMsgWithtext(i18n(string: "This app is currently not available in your country or region"))
                    }
                }
                isWaitingDownloadPageFinish = true
                
                delay(interval: 2) {// 如果超过一段时间还未加载结束，则报错
                    if isDisplayingDownloadPage { return }
                    isLimitedToPresentDownloadPage = true
                    MBProgressHUD.showMsgWithtext(i18n(string: "This app is currently not available in your country or region"))
                    self.isWaitingDownloadPageFinish = false
                }
            }
            
            return
        }
    }
    
    @available(iOS 14.0, *)
    func storeOverlayDidFailToLoad(_ overlay: SKOverlay, error: Error) {
        switch (error as NSError).code {
        case 0:
            MBProgressHUD.showMsgWithtext(i18n(string: "This app is currently not available in your country or region"))
        default:
            MBProgressHUD.showMsgWithtext(i18n(string: "This app is currently not available in your country or region"))
        }
    }
    
    
    func getDownloadUrlString(fromModel: SimpleGameModel) -> String {
        // App下载地址从App Store平台数据获取
        var appStoreId = ""
        var downloadUrl = ""
        let platforms = fromModel.platforms
//        for platform in platforms {
//            if platform.name == "App Store" {
//                downloadUrl = platform.downloadUrl
//            }
//        }
        
        if downloadUrl.contains("/id") {
            let separates = downloadUrl.components(separatedBy: "/id")
            appStoreId = separates.last!
            downloadUrl = "https://itunes.apple.com/app/id".appending(appStoreId)
        }
        
        return downloadUrl
    }
    
    // tencentmsdk16283、tencent1106838536、wxc933ffba7d9de4dc、codmcn
    // MARK: 检查是否可以跳转到其他App
    func checkGameCanOpen(urlSchemes: [String]) -> Bool {
        // 测试
//        let schemes = ["tencentmsdk16283", "tencent1106838536", "wxc933ffba7d9de4dc", "codmcn"]// 使命召唤手游（腾讯版）的URL Schemes
//        let schemes = ["scepsapp", "steamlink", "msgamepass"]// PlayStation App、Steam Link、Xbox Game Pass
//        for scheme in schemes {
//            let openUrl = URL.init(string: scheme + "://")!
//            if UIApplication.shared.canOpenURL(openUrl) {
//                return true
//            }
//        }
//        return false
        
        if urlSchemes != [] {
            for scheme in urlSchemes {
                let openUrl = URL.init(string: scheme + "://")!
                if UIApplication.shared.canOpenURL(openUrl) {
                    return true
                }
            }
        }
        
        return false
    }
}
