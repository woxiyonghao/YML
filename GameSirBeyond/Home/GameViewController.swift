//
//  GameViewController.swift
//  Eggshell
//
//  Created by 刘富铭 on 2022/10/11.
//

import UIKit
import Moya
import SwiftyJSON
import ReplayKit
//#if !DEBUG
//import NIMSDK
//#endif
import SnapKit
class GameViewController: UIViewController, UIScrollViewDelegate {
    
    let gameScrollView = GameScrollView(frame: .zero)
    let controllerAlertView = ConnectControllerAlertView(frame: .zero)
    var homeCollectionView:HomeCollectionView!
    let menuButton = AnimatedButton.init(type: .custom)// 顶部菜单按钮
    let searchButton = AnimatedButton.init(type: .custom)// 顶部搜索按钮
    let friendsButton = AnimatedButton.init(type: .custom)// 顶部添加好友按钮
    
    // lu
    @Atomic fileprivate var showingUserInfoVC = false /// 是否正在显示userInfoVC
      
    
    fileprivate lazy var userInfoVC = GSUserInfoViewController()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 重新让AppDelegate监听手柄按键
        eggshellAppDelegate().unobserveGamepadKey()
        eggshellAppDelegate().observeGamepadKey()
        
        unObserveGamepadNotification()
        observeGamepadNotification()
        
        observeConnectNotification()// 注意：如果放在viewDidLoad()，监听不到通知
        
        delay(interval: 2) {
            self.checkIfConnectedController()
            _ = checkIfInMFiMode()
            eggshellAppDelegate().checkIfForceToUpdateFirmware()
        }
        
    
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        unObserveGamepadNotification()
    }
    
    func observeConnectNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(didConnectGamepad), name: Notification.Name("DidConnectControllerNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didDisconnectGamepad), name: Notification.Name("DidDisconnectControllerNotification"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        commonInit()
        
        initUserInfoVC()
    }
    
   
    
    
    override func viewSafeAreaInsetsDidChange() {
        initTopButtons()
        homeCollectionView.configureCollectionView(safeAreaInsets: self.view.safeAreaInsets)
    }
    
    func checkIfConnectedController() {
//        controllerAlertView.isHidden = getControllerName() != ""
//        searchButton.isHidden = !controllerAlertView.isHidden
    }
    
    func commonInit() {
        setupRecording()
        setupIM()
        
        initBackgroundImageView()
        initScrollView()
        initAlertView()
      
//        addFrontMask()
    }
    
    // MARK: 提示连接手柄
    func showAlertView() {
        MainThread {
            appDisablePlayingVideo()
            self.searchButton.isHidden = true
            self.controllerAlertView.isHidden = false
        }
    }
    
    func hideAlertView() {
        MainThread {
            appEnablePlayingVideo()
            self.searchButton.isHidden = false
            self.controllerAlertView.isHidden = true
        }
    }
    
    @objc func didConnectGamepad() {
        hideAlertView()
    }
    
    @objc func didDisconnectGamepad() {
        showAlertView()
    }
    
    func initAlertView() {
        controllerAlertView.frame = view.frame
//        view.addSubview(controllerAlertView)
    }
    
    func initScrollView() {
//        gameScrollView.frame = view.bounds
//        view.addSubview(gameScrollView)
//        gameScrollView.backgroundColor = .black.withAlphaComponent(0.5)
        homeCollectionView = HomeCollectionView(frame: self.view.bounds)
        view.addSubview(homeCollectionView)
        
        stopDownloadingImage()
//        requestTopicsData()
    }
    
    func requestTopicsData() {
//        if GameManager.shared.topicModels.count > 0 {
//            loadTopicsData()
//            return
//        }
//        
//        let networker = MoyaProvider<GameService>()
//        networker.request(.getGameTopics) { result in
//            switch result {
//            case let .success(response): do {
//                let data = try? response.mapJSON()
//                if data == nil {return}
//                let json = JSON(data!)
//                let responseData = json.dictionaryObject!
//                let code = responseData["code"] as! Int
//                if code == NetworkErrorType.NeedLogin.rawValue {
//                    NotificationCenter.default.post(name: Notification.Name("UserDidLogoutNotification"), object: nil)
//                    return
//                }
//                if code == 200 {
//                    let gameTopics = (responseData["data"] as! [String: Any])["result"] as! [[String: Any]]
//                    print("主题数据：", gameTopics)
//                    var topicModels: [TopicModel] = []
//                    for topic in gameTopics {
//                        let model = TopicModel(JSON: topic, context: nil)!
//                        topicModels.append(model)
//                    }
//                    GameManager.shared.topicModels = topicModels
//                    self.loadTopicsData()
//                }
//                else {
//                    //print("获取首页数据失败：", responseData["msg"]!)
//                    delay(interval: 2) {
//                        self.requestTopicsData()
//                    }
//                }
//            }
//            case .failure(_): do {
//                //print("获取首页数据失败：网络错误")
//                delay(interval: 2) {
//                    self.requestTopicsData()
//                }
//            }
//                break
//            }
//        }
    }
    
    func loadTopicsData() {
        if GameManager.shared.topicModels.count <= 0 {
            return
        }
        
        self.gameScrollView.topicModels = GameManager.shared.topicModels
    }
    
    func setupIM() {
        NotificationCenter.default.addObserver(forName: Notification.Name("NotificationCenterDidReceive"), object: nil, queue: OperationQueue.main) { notification in
            //点击推送通知
            self.showChatView(userInfo: notification.userInfo!)
        }
    }
    
    func setupRecording() {

    }
    
    // 在顶部和底部加上2个遮罩，用于减少视野焦点
    func addFrontMask() {

    }
    
    // MARK: 背景图片
    var bgImageView: UIImageView!
    func initBackgroundImageView() {
        bgImageView = UIImageView(frame: view.bounds)
        view.addSubview(bgImageView)
        view.sendSubviewToBack(bgImageView)
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.addBlurEffect(style: .dark, alpha: 0.2)// 初始给点模糊度
        bgImageView.image = UIImage(named: "full_bg")
    }
    
    func setBackground(imageUrl: String) {
        if imageUrl.isEmpty {
            return
        }
        bgImageView.sd_setImage(with: URL(string: imageUrl)!, placeholderImage: UIImage(named: "full_bg"))
    }
    
    func updateBackgroundTransparency(alpha: CGFloat) {
        bgImageView.updateBlurEffect(alpha: alpha)
    }
    
    func initTopButtons() {
        // MARK: 菜单按钮
        let size = CGSize(width: 38, height: 38)
        menuButton.frame = CGRect(x: view.safeAreaInsets.left, y: 13, width: size.width, height: size.height)
        view.addSubview(menuButton)
        setup(button: menuButton, imageName: "menu", selectedImageName: "menu_selected")
        menuButton.tapAction = {[weak self] in
            guard let `self` = self else { return }
            self.showUserInfoVC()
            DispatchQueue.once {
                eggshellAppDelegate().requestNotificationAuthorization()
            }
        }
        
        // MARK: 好友按钮
        view.addSubview(friendsButton)
        friendsButton.frame = CGRect(x: CGRectGetMaxX(menuButton.frame) + 13, y: CGRectGetMinY(menuButton.frame), width: size.width, height: size.height)
        setup(button: friendsButton, imageName: "addFriends", selectedImageName: "addFriends_selected")
        friendsButton.tapAction = {
#if !DEBUG
//            let searchFriendView = SearchFriendView.init(frame: self.view.bounds)
//            self.view.addSubview(searchFriendView)
//            
//            self.selectTopGamepadActionLine()
//            self.menuButton.isSelected = false
//            self.searchButton.isSelected = false
//            self.friendsButton.isSelected = true
#else
            print("📢注意：模拟器下禁用此功能")
#endif
        }
        
        // MARK: 搜索按钮
        view.addSubview(searchButton)
        searchButton.frame = CGRect(x: CGRectGetMaxX(friendsButton.frame) + 13, y: CGRectGetMinY(menuButton.frame), width: size.width, height: size.height)
        setup(button: searchButton, imageName: "search", selectedImageName: "search_selected")
        searchButton.tapAction = {
            let searchView = GameSearchView(frame: self.view.bounds)
            self.view.addSubview(searchView)
            searchView.didSelectGame = { model in
                self.displayGameDetailView(gameModel: model)
            }
            searchView.didTapCloseButton = {
                searchView.removeFromSuperview()
            }
            
            self.selectTopGamepadActionLine()
            self.menuButton.isSelected = false
            self.searchButton.isSelected = true
            self.friendsButton.isSelected = false
        }
        
        
        topButtons = [menuButton, friendsButton, searchButton]
    }
    
    func showChatView(userInfo:[AnyHashable:Any]) {
#if !DEBUG
//        let info = userInfo as? [String: Any]
//        let content = info?["aps"] as? [String: Any]
//        let alertContent = content?["alert"] as! [String: Any]
//        let user =  NIMSDK.shared().userManager.userInfo(alertContent["accid"] as? String ?? "")
//        if (user != nil){
//            var chatView:ChatView?
//            for view in self.view.subviews{
//                if (view is ChatView) {
//                    chatView = view as? ChatView
//                    chatView!.setUser(user: user!)
//                    chatView!.closure = {
//                        chatView!.removeFromSuperview()
//                    }
//                    self.view?.addSubview(chatView!)
//                    return
//                }
//            }
//            chatView = ChatView.init(frame: self.view.frame, user: user!)
//            chatView!.closure = {
//                chatView!.removeFromSuperview()
//            }
//            self.view?.addSubview(chatView!)
//        }
#endif
    }
    
    func selectTopGamepadActionLine() {
        self.gamepadActionLine = -1
        self.gameScrollView.updateCollectionView(lineIndex: 0, scale: 1, animated: true)
        self.gameScrollView.updateFocusingStatus(line: -1)
    }
    
    func setup(button: AnimatedButton, imageName: String, selectedImageName: String) {
        button.setImage(UIImage.init(named: imageName)!, for: .normal)
        button.setBackgroundImage(UIImage.from(color: UIColor(named: "color_gamepad_button_bg")!, size: button.frame.size), for: .normal)
        button.setImage(UIImage.init(named: imageName)!, for: .highlighted)
        button.setBackgroundImage(UIImage.from(color: UIColor(named: "color_gamepad_button_bg")!, size: button.frame.size), for: .highlighted)
        button.setImage(UIImage.init(named: selectedImageName)!, for: .selected)
        button.setBackgroundImage(UIImage.from(color: .white, size: button.frame.size), for: .selected)
        
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.cornerRadius = button.frame.size.height/2.0
        button.layer.masksToBounds = true
    }
    
    func displayGameDetailView(gameModel: SearchGameModel) {
        let detailView = GameDetailView.init(frame: UIScreen.main.bounds)
        view.addSubview(detailView)
        detailView.scrollView.collectionModels = [gameModel]
        detailView.scrollView.focusIndexPath = IndexPath(row: 0, section: 0)
        detailView.scrollView.gameCollectionView.isHidden = false
        detailView.backCallback = {
            detailView.removeFromSuperview()
        }
    }
    
    var gamepadActionLine = 0// 手柄操控行，顶部的菜单按钮和搜索按钮是-1行，主题列表的首行是0行，默认是0行
    var topButtons: [UIButton] = []// 顶部可点击按钮
    func observeGamepadNotification() {
#if !DEBUG
//        NotificationCenter.default.addObserver(self, selector: #selector(pressGamepadKeyLeft), name: Notification.Name(ControllerNotificationName.LeftJoystickMoveLeft.rawValue), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(pressGamepadKeyRight), name: Notification.Name(ControllerNotificationName.LeftJoystickMoveRight.rawValue), object: nil)
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(pressGamepadKeyUp), name: Notification.Name(ControllerNotificationName.LeftJoystickMoveUp.rawValue), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(pressGamepadKeyDown), name: Notification.Name(ControllerNotificationName.LeftJoystickMoveDown.rawValue), object: nil)
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(pressGamepadKeyA), name: Notification.Name(ControllerNotificationName.KeyAPressed.rawValue), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(pressGamepadKeyB), name: Notification.Name(ControllerNotificationName.KeyBPressed.rawValue), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(pressGamepadKeyX), name: Notification.Name(ControllerNotificationName.KeyXPressed.rawValue), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(pressGamepadKeyY), name: Notification.Name(ControllerNotificationName.KeyYPressed.rawValue), object: nil)
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(pressGamepadKeyMenu), name: Notification.Name(ControllerNotificationName.KeyMenuPressed.rawValue), object: nil)
#endif
    }
    
    func unObserveGamepadNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
//#if !DEBUG
    var gamepadActionIntervalTime = 0.25// 此数据可微调，0~0.25较合适
    
//    // MARK: 手柄操控
//    // 左右移动 卡片
//    var isJoystickMoveToLeft = false
//    @objc func pressGamepadKeyLeft() {
//        if isJoystickMoveToLeft { return }
////        isJoystickMoveToLeft = true
////        delay(interval: gamepadActionIntervalTime) {
////            self.isJoystickMoveToLeft = false
////        }
////        
////        // 每个页面的手柄操作单独处理
////        let frontView = getFrontView()// 最顶层视图
////        if frontView is GameScrollView {
////            if gamepadActionLine == -1 {
////                highlightLeftButton()
////            }
////            else {
////                gameScrollView.gamepadKeyLeftAction()
////            }
////        }
////        else if frontView is GameDetailView {
////            (frontView as! GameDetailView).scrollView.gamepadKeyLeftAction()
////        }
////        else if frontView is MenuView {
////            (frontView as! MenuView).gamepadKeyLeftAction()
////        }
////        else if frontView is GameSearchView {
////            (frontView as! GameSearchView).gamepadKeyLeftAction()
////        }
////        else if frontView is CapturesView {
////            (frontView as! CapturesView).gamepadKeyLeftAction()
////        }
////        else if frontView is HighlightTagGameView {
////            (frontView as! HighlightTagGameView).gamepadKeyLeftAction()
////        }
////        else if frontView is SettingsView {
////            (frontView as! SettingsView).gamepadKeyLeftAction()
////        }
////    }
////    
////    var isJoystickMoveToRight = false
////    @objc func pressGamepadKeyRight() {
////        if isJoystickMoveToRight { return }
////        isJoystickMoveToRight = true
////        delay(interval: gamepadActionIntervalTime) {
////            self.isJoystickMoveToRight = false
////        }
////        
////        // 每个页面的手柄操作单独处理
////        let frontView = getFrontView()// 最顶层视图
////        if frontView is GameScrollView {
////            if gamepadActionLine == -1 {
////                highlightRightButton()
////            }
////            else {
////                gameScrollView.gamepadKeyRightAction()
////            }
////        }
////        else if frontView is GameDetailView {
////            (frontView as! GameDetailView).scrollView.gamepadKeyRightAction()
////        }
////        else if frontView is MenuView {
////            (frontView as! MenuView).gamepadKeyRightAction()
////        }
////        else if frontView is GameSearchView {
////            (frontView as! GameSearchView).gamepadKeyRightAction()
////        }
////        else if frontView is CapturesView {
////            (frontView as! CapturesView).gamepadKeyRightAction()
////        }
////        else if frontView is HighlightTagGameView {
////            (frontView as! HighlightTagGameView).gamepadKeyRightAction()
////        }
////        else if frontView is SettingsView {
////            (frontView as! SettingsView).gamepadKeyRightAction()
////        }
////    }
////    
////    // 上下移动 行
////    var isJoystickMoveToUp = false
////    @objc func pressGamepadKeyUp() {
////        if isJoystickMoveToUp { return }
////        isJoystickMoveToUp = true
////        delay(interval: gamepadActionIntervalTime) {
////            self.isJoystickMoveToUp = false
////        }
////        
////        // 每个页面的手柄操作单独处理
////        let frontView = getFrontView()// 最顶层视图
////        if frontView is GameScrollView {
////            if gamepadActionLine == -1 {
////                appPlayIneffectiveSound()
////                return
////            }
////            
////            gamepadActionLine = gamepadActionLine-1 < -1 ? -1 : gamepadActionLine-1
////            if gamepadActionLine == -1 {
////                appPlayScrollSound()
////                menuButton.isSelected = true
////                menuButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
////                
////                gameScrollView.updateFocusingStatus(line: -1)
////                gameScrollView.updateCollectionView(lineIndex: 0, scale: 1, animated: true)
////            }
////            else {
////                appPlayScrollSound()
////                gamepadActionLine = gameScrollView.scrollTo(line: gamepadActionLine)
////                unhighlightButtons()
////            }
////        }
////        else if frontView is GameDetailView {
////            (frontView as! GameDetailView).scrollView.gamepadKeyUpAction()
////        }
////        else if frontView is MenuView {
////            (frontView as! MenuView).gamepadKeyUpAction()
////        }
////        else if frontView is GameSearchView {
////            (frontView as! GameSearchView).gamepadKeyUpAction()
////        }
////        else if frontView is CapturesView {
////            (frontView as! CapturesView).gamepadKeyUpAction()
////        }
////        else if frontView is HighlightTagGameView {
////            (frontView as! HighlightTagGameView).gamepadKeyUpAction()
////        }
////        else if frontView is QuitAccountView {
////            (frontView as! QuitAccountView).gamepadKeyUpAction()
////        }
////        else if frontView is SettingsView {
////            (frontView as! SettingsView).gamepadKeyUpAction()
////        }
//////        else if frontView is MessageView {
//////            (frontView as! MessageView).gamepadKeyUpAction()
//////        }
////        else if frontView is ControllerSettingsView {
////            (frontView as! ControllerSettingsView).gamepadKeyUpAction()
////        }
////    }
////    
////    var isJoystickMoveToDown = false
////    @objc func pressGamepadKeyDown() {
////        if isJoystickMoveToDown { return }
////        isJoystickMoveToDown = true
////        delay(interval: gamepadActionIntervalTime) {
////            self.isJoystickMoveToDown = false
////        }
////        
////        // 每个页面的手柄操作单独处理
////        let frontView = getFrontView()// 最顶层视图
////        if frontView is GameScrollView {
////            gamepadActionLine = gamepadActionLine+1 < -1 ? -1 : gamepadActionLine+1
////            if gamepadActionLine == -1 {
////                menuButton.isSelected = true
////                menuButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
////                appPlayScrollSound()
////            }
////            else if gamepadActionLine == 0 {
////                appPlayScrollSound()
////                gameScrollView.updateFocusingStatus(line: 0)
////                gameScrollView.updateCollectionView(lineIndex: 0, scale: 1.2, animated: true)
////                unhighlightButtons()
////            }
////            else {
////                appPlayScrollSound()
////                gamepadActionLine = gameScrollView.scrollTo(line: gamepadActionLine)
////            }
////        }
////        else if frontView is GameDetailView {
////            (frontView as! GameDetailView).scrollView.gamepadKeyDownAction()
////        }
////        else if frontView is MenuView {
////            (frontView as! MenuView).gamepadKeyDownAction()
////        }
////        else if frontView is GameSearchView {
////            (frontView as! GameSearchView).gamepadKeyDownAction()
////        }
////        else if frontView is CapturesView {
////            (frontView as! CapturesView).gamepadKeyDownAction()
////        }
////        else if frontView is HighlightTagGameView {
////            (frontView as! HighlightTagGameView).gamepadKeyDownAction()
////        }
////        else if frontView is QuitAccountView {
////            (frontView as! QuitAccountView).gamepadKeyDownAction()
////        }
////        else if frontView is SettingsView {
////            (frontView as! SettingsView).gamepadKeyDownAction()
////        }
//////        else if frontView is MessageView {
//////            (frontView as! MessageView).gamepadKeyDownAction()
//////        }
////        else if frontView is ControllerSettingsView {
////            (frontView as! ControllerSettingsView).gamepadKeyDownAction()
////        }
////    }
////    
////    @objc func pressGamepadKeyA() {
////        // 每个页面的手柄操作单独处理
////        let frontView = getFrontView()// 最顶层视图
////        if frontView is GameDetailView {
////        }
////        else if frontView is MenuView {
////            (frontView as! MenuView).gamepadKeyAAction()
////        }
////        else if frontView is GameSearchView {
////            (frontView as! GameSearchView).gamepadKeyAAction()
////        }
////        else if frontView is GameScrollView {
////            if gamepadActionLine == -1 {
////                clickHighlightButton()
////            }
////            else {
////                gameScrollView.gamepadKeyAAction()
////            }
////        }
////        else if frontView is CapturesView {
////            (frontView as! CapturesView).gamepadKeyAAction()
////        }
////        else if frontView is HighlightNameView {
////            (frontView as! HighlightNameView).gamepadKeyAAction()
////        }
////        else if frontView is HighlightTagGameView {
////            (frontView as! HighlightTagGameView).gamepadKeyAAction()
////        }
////        else if frontView is HighlightPreviewView {
////            (frontView as! HighlightPreviewView).gamepadKeyAAction()
////        }
////        else if frontView is HighlightConfirmGameView {
////            (frontView as! HighlightConfirmGameView).gamepadKeyAAction()
////        }
////        else if frontView is QuitAccountView {
////            (frontView as! QuitAccountView).gamepadKeyAAction()
////        }
////        else if frontView is SettingsView {
////            (frontView as! SettingsView).gamepadKeyAAction()
////        }
//////        else if frontView is MessageView {
//////            (frontView as! MessageView).gamepadKeyAAction()
//////        }
//////        else if frontView is ChatView {
//////            (frontView as! ChatView).gamepadKeyAAction()
//////        }
////    }
////    
////    @objc func pressGamepadKeyB() {
////        let frontView = getFrontView()// 最顶层视图
////        if frontView is GameDetailView {
////            (frontView as! GameDetailView).gamepadKeyBAction()
////        }
////        else if frontView is MenuView {
////            (frontView as! MenuView).gamepadKeyBAction()
////        }
////        else if frontView is GameSearchView {
////            (frontView as! GameSearchView).gamepadKeyBAction()
////        }
////        else if frontView is CapturesView {
////            (frontView as! CapturesView).gamepadKeyBAction()
////        }
////        else if frontView is HighlightNameView {
////            (frontView as! HighlightNameView).gamepadKeyBAction()
////        }
////        else if frontView is HighlightTagGameView {
////            (frontView as! HighlightTagGameView).gamepadKeyBAction()
////        }
////        else if frontView is HighlightPreviewView {
////            (frontView as! HighlightPreviewView).gamepadKeyBAction()
////        }
////        else if frontView is HighlightConfirmGameView {
////            (frontView as! HighlightConfirmGameView).gamepadKeyBAction()
////        }
////        else if frontView is QuitAccountView {
////            (frontView as! QuitAccountView).gamepadKeyBAction()
////        }
////        else if frontView is FullPhotoView {
////            (frontView as! FullPhotoView).gamepadKeyBAction()
////        }
////        else if frontView is FullHighlightView {
////            (frontView as! FullHighlightView).gamepadKeyBAction()
////        }
////        else if frontView is EditUserInformationView {
////            (frontView as! EditUserInformationView).gamepadKeyBAction()
////        }
////        else if frontView is SettingsView {
////            (frontView as! SettingsView).gamepadKeyBAction()
////        }
////        else if frontView is CancelAccountView {
////            (frontView as! CancelAccountView).gamepadKeyBAction()
////        }
////        else if frontView is HighlightDetailView {
////            (frontView as! HighlightDetailView).gamepadKeyBAction()
////        }
////        else if frontView is SearchFriendView {
////            (frontView as! SearchFriendView).gamepadKeyBAction()
////        }
//////        else if frontView is ChatView {
//////            (frontView as! ChatView).gamepadKeyBAction()
//////        }
//////        else if frontView is UserInfoView {
//////            (frontView as! UserInfoView).gamepadKeyBAction()
//////        }
//////        else if frontView is ChatMoreView {
//////            (frontView as! ChatMoreView).gamepadKeyBAction()
//////        }
//////        else if frontView is MessageView {
//////            (frontView as! MessageView).gamepadKeyBAction()
//////        }
////        else if frontView is SimpleWebView {
////            (frontView as! SimpleWebView).gamepadKeyBAction()
////        }
////        else if frontView is GamePopView {
////            (frontView as! GamePopView).gamepadKeyBAction()
////        }
////        else if frontView is RecordingDetailView {
////            (frontView as! RecordingDetailView).gamepadKeyBAction()
////        }
////        else if frontView is ControllerSettingsView {
////            (frontView as! ControllerSettingsView).gamepadKeyBAction()
////        }
////        else if frontView is UpdateFirmwareView {
////            (frontView as! UpdateFirmwareView).gamepadKeyBAction()
////        }
////        else if frontView is SwitchMFiAlertView {
////            (frontView as! SwitchMFiAlertView).gamepadKeyBAction()
////        }
////    }
////    
////    @objc func pressGamepadKeyX() {
////        
////        let frontView = getFrontView()
////        if frontView is GameDetailView {
////            (frontView as! GameDetailView).gamepadKeyXAction()
////        }
////        else if frontView is HighlightTagGameView {
////            (frontView as! HighlightTagGameView).gamepadKeyXAction()
////        }
////        else if frontView is HighlightPreviewView {
////            (frontView as! HighlightPreviewView).gamepadKeyXAction()
////        }
////        else if frontView is HighlightConfirmGameView {
////            (frontView as! HighlightConfirmGameView).gamepadKeyXAction()
////        }
////        else if frontView is CapturesView {
////            (frontView as! CapturesView).gamepadKeyXAction()
////        }
////        else if frontView is HighlightDetailView {
////            (frontView as! HighlightDetailView).gamepadKeyXAction()
////        }
////    }
////    
////    @objc func pressGamepadKeyY() {
////        
////        let frontView = getFrontView()
////        if frontView is CapturesView {
////            (frontView as! CapturesView).gamepadKeyYAction()
////        }
////        else if frontView is HighlightTagGameView {
////            (frontView as! HighlightTagGameView).gamepadKeyYAction()
////        }
////        else if frontView is HighlightConfirmGameView {
////            (frontView as! HighlightConfirmGameView).gamepadKeyYAction()
////        }
////        else if frontView is GameDetailView {
////            (frontView as! GameDetailView).gamepadKeyYAction()
////        }
////        else if frontView is FullPhotoView {
////            (frontView as! FullPhotoView).gamepadKeyYAction()
////        }
////        else if frontView is FullHighlightView {
////            (frontView as! FullHighlightView).gamepadKeyYAction()
////        }
////        else if frontView is RecordingDetailView {
////            (frontView as! RecordingDetailView).gamepadKeyYAction()
////        }
////    }
////    
////    @objc func pressGamepadKeyMenu() {
////        
////        let frontView = getFrontView()
////        if frontView is GameScrollView {
////            appPlaySelectSound()
////            menuButton.sendActions(for: .touchUpInside)
////        }
////        else if frontView is CapturesView {
////            (frontView as! CapturesView).gamepadKeyMenuAction()
////        }
////    }
////#endif
//    
//    // 获取最顶层View
//    func getFrontView() -> UIView? {
//        if view.subviews.count == 0 { return nil }
//        
//        var frontView = view.subviews.last
//        if frontView is UIButton {
//            for subview in view.subviews.reversed() {
//                //                print("查询到Subview：", subview)
//                if subview is UIButton == false && subview.isHidden == false {
//                    frontView = subview
//                    break
//                }
//            }
//        }
//        //        print("当前最顶层View：", frontView!)
//        return frontView
//    }
//    
//    func highlightLeftButton() {
//        for index in 0..<topButtons.count {
//            let button = topButtons[index]
//            if button.isSelected == true {
//                let destIndex = index - 1
//                if destIndex < 0 {
//                    appPlayIneffectiveSound()
//                }
//                else if destIndex >= 0 {
//                    appPlayScrollSound()
//                    let destButton = topButtons[destIndex]
//                    destButton.isSelected = true
//                    destButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
//                    button.isSelected = false
//                    button.transform = CGAffineTransform(scaleX: 1, y: 1)
//                }
//                return
//            }
//        }
//    }
//    
//    func highlightRightButton() {
//        for index in 0..<topButtons.count {
//            let button = topButtons[index]
//            if button.isSelected == true {
//                let destIndex = index + 1
//                if destIndex >= topButtons.count {
//                    appPlayIneffectiveSound()
//                }
//                else if destIndex < topButtons.count {
//                    appPlayScrollSound()
//                    let destButton = topButtons[destIndex]
//                    destButton.isSelected = true
//                    destButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
//                    button.isSelected = false
//                    button.transform = CGAffineTransform(scaleX: 1, y: 1)
//                }
//                return
//            }
//        }
//    }
//    
//    func unhighlightButtons() {
//        for button in topButtons {
//            button.isSelected = false
//            button.transform = CGAffineTransform(scaleX: 1, y: 1)
//        }
//    }
//    
//    func clickHighlightButton() {
//        for button in topButtons {
//            if button.isSelected {
//                appPlaySelectSound()
//                button.sendActions(for: .touchUpInside)
//                return
//            }
//        }
//    }
//    
//    //MARK: - 合成视频相关方法
//    func setupAssetWriter() {
//        self.assetWriter = initAssetWriter()
//        self.videoInput = initVideoInput()
//        if (self.assetWriter!.canAdd(self.videoInput!)) {
//            self.assetWriter!.add(self.videoInput!)
//            print("主APP录屏开始2")
//        }else{
//            print("主APP录屏开始2 添加视频写入失败")
//        }
//        
//    }
//    
//    func stopWriting() {
//        if (self.assetWriter?.status == AVAssetWriter.Status.writing) {
//            self.videoInput?.markAsFinished()
////            self.audioAppInput?.markAsFinished()
////            self.audioMicInput?.markAsFinished()
//            self.assetWriter?.finishWriting(completionHandler: {
//                self.videoInput = nil;
////                self.audioAppInput = nil;
////                self.audioMicInput = nil;
//                self.assetWriter = nil;
//            });
//        }
//        
//#if !DEBUG
////        let sharedDefaults = UserDefaults.init(suiteName: ScreenRecSharePathKey.GroupIDKey)
////        let videoName:String  = sharedDefaults?.object(forKey: ScreenRecSharePathKey.FileKey) as? String ?? ""
////        let videoPath = ScreenRecSharePath.filePathUrlWithFileName(videoName)
////        let audioName:String  = sharedDefaults?.object(forKey: ScreenRecSharePathKey.AudioFileKey) as? String ?? ""
////        let audioPath =  ScreenRecSharePath.filePathUrlWithAppGroupFileName(audioName, "mp4")
////        
////        ScreenRecSynthesis.shared.SynthesiVideo(videoPath: videoPath, audioPath: audioPath) 
////        if (!fileName.isEmpty){
////            let newFileName  = ""
////            sharedDefaults?.set(newFileName, forKey: ScreenRecSharePathKey.FileKey)
////            sharedDefaults?.synchronize()
////            print("清空了 fileName")
////        }
//#endif
//    }
//    
//    //MARK: - lazy
//    //使用以下保存mp4
//
//    lazy var assetWriter: AVAssetWriter? = {
//          return initAssetWriter()
//    }()
//    
//    func initAssetWriter() -> AVAssetWriter? {
////#if !DEBUG
////        let sharedDefaults = UserDefaults.init(suiteName: ScreenRecSharePathKey.GroupIDKey)
////        var fileName:String = sharedDefaults?.object(forKey: ScreenRecSharePathKey.FileKey) as? String ?? ""
////        if (fileName != ""){
////            let oldFilePathURL:URL = ScreenRecSharePath.filePathUrlWithFileName(fileName)
////            do{
////               try FileManager.default.removeItem(at: oldFilePathURL)
////            }catch{
////                print("删除失败")
////            }
////        }
//////        if (fileName == "" ){
////            let newFileName  = Date.timestamp()
////            sharedDefaults?.set(newFileName, forKey: ScreenRecSharePathKey.FileKey)
////            sharedDefaults?.synchronize()
////            print("创建 新的assetWriter fileName:\(newFileName)")
////            fileName = newFileName
//////        }
////        let filePathURL:URL = ScreenRecSharePath.filePathUrlWithFileName(fileName)
//////        print("创建 assetWriter filePathURL:\(filePathURL)")
////        do {
////            let input = try AVAssetWriter.init(url: filePathURL, fileType: AVFileType.mp4)
////            print(input)
////            return input
////        }catch{
////            assert(false, "assetWriter初始化失败")
////            return nil
////        }
////#else
////        return nil
////#endif
//        return nil
//    }
//    
//    lazy var videoInput: AVAssetWriterInput? = {
//        return initVideoInput()
//    }()
//    
//    func initVideoInput() -> AVAssetWriterInput {
//        let size  = UIScreen.main.bounds.size
//        //写入视频大小
//        let numPixels:CGFloat =  size.width  * size.height
//        //每像素比特
//        let bitsPerPixel:CGFloat = 20
//        let bitsPerSecond = numPixels * bitsPerPixel
//        // 码率和帧率设置
//        let compressionProperties:[String : Any] = [
//            AVVideoAverageBitRateKey: NSNumber(value:bitsPerSecond), //码率(平均每秒的比特率)
//            AVVideoExpectedSourceFrameRateKey :NSNumber(value:60),//帧率（如果使用了AVVideoProfileLevelKey则该值应该被设置，否则可能会丢弃帧以满足比特流的要求）
//            AVVideoMaxKeyFrameIntervalKey : NSNumber(value:5),//关键帧最大间隔
//            AVVideoProfileLevelKey : AVVideoProfileLevelH264BaselineAutoLevel
//        ]
//        let videoOutputSettings:[String : Any] = [
//            AVVideoCodecKey : AVVideoCodecType.h264,  // AVVideoCodecTypeH264
//            AVVideoScalingModeKey : AVVideoScalingModeResizeAspect,
//            AVVideoWidthKey : NSNumber(value:size.width * 2 ),
//            AVVideoHeightKey : NSNumber(value:size.height * 2 ),
//            AVVideoCompressionPropertiesKey : compressionProperties
//        ]
//        print("videoOutputSettings \(videoOutputSettings)")
//        let input =  AVAssetWriterInput.init(mediaType: AVMediaType.video, outputSettings: videoOutputSettings)
//        input.expectsMediaDataInRealTime = true
//        return input
//    }
//   // 👆保存视频相关结束
}

//MARK: - 注册全局通知 接受Extension的消息
let onDarwinReplayKit2PushFinish:CFNotificationCallback = {_,_,_,_,_ in
#if !DEBUG
//    //转到cocoa层框架处理
//    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: ScreenRecSharePathKey.ScreenRecordFinishNotif), object: nil)
//    print("接受Extension的消息ScreenRecordFinishNotif")
#endif
}

let onDarwinReplayKit2PushStart:CFNotificationCallback = {_,_,_,_,_ in
#if !DEBUG
    //转到cocoa层框架处理
//    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: ScreenRecSharePathKey.ScreenRecordStartNotif), object: nil)
//    print("接受Extension的消息ScreenRecordStartNotif")
#endif
}

// MARK: ----
// MARK: ---- 个人菜单
extension GameViewController{
    
    
    func initUserInfoVC(){
        self.addChild(userInfoVC)
        self.view.addSubview(userInfoVC.view)
        userInfoVC.view.snp.makeConstraints {
            $0.width.top.height.equalToSuperview()
            $0.left.equalToSuperview().offset(-kWidth)
        }
        userInfoVC.dismissHandler = {[weak self] in
            guard let `self` = self else { return }
            self.dismissUserInfoVC()
        }
    }
    // lu
    func showUserInfoVC(){
        showingUserInfoVC = !showingUserInfoVC
        
        showingUserInfoVC ? _showUserInfoVC() : dismissUserInfoVC()
    }
    // lu
    func _showUserInfoVC(){
        self.userInfoVC.regisNotis()// 显示userInfoVC前，先注册通知。为防止内部响应手柄事件
        self.view.setNeedsLayout()
        self.userInfoVC.view.snp.remakeConstraints {
            $0.width.top.height.equalToSuperview()
            $0.left.equalToSuperview()
        }
        UIView.animate(withDuration: 0.2) {[weak self] in
            guard let `self` = self else { return }
            self.view.layoutIfNeeded()
        }
    }
    // lu
    func dismissUserInfoVC(){
        showingUserInfoVC = false
        self.userInfoVC.unitNotis()// 隐藏userInfoVC前，先注销通知。为防止多次添加
        self.view.setNeedsLayout()
        self.userInfoVC.view.snp.remakeConstraints {
            $0.width.top.height.equalToSuperview()
            $0.left.equalToSuperview().offset(-kWidth)
        }
        UIView.animate(withDuration: 0.2) {[weak self] in
            guard let `self` = self else { return }
            self.view.layoutIfNeeded()
        }
    }
}
