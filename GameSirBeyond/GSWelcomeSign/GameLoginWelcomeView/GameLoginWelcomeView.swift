//
//  GameLoginWelcomeView.swift
//  GameLoginWelcome
//
//  Created by lu on 2024/3/4.
//

import UIKit
import SnapKit
import Then

class GameLoginWelcomeView: UIView {
   
    
    open func rebuildUI(){
        defer {
            scr.contentSize = CGSizeMake(visualRect.width * CGFloat(scr.subviews.count), 0)
        }
        
        loginView.removeFromSuperview()
        codeView.removeFromSuperview()
        codeInputView.removeFromSuperview()
        emojiInputView.removeFromSuperview()
        inputNameView.removeFromSuperview()
        shareIntroView.removeFromSuperview()
        showView.removeFromSuperview()
        notiAuthView.removeFromSuperview()
        libAuthView.removeFromSuperview()
        shellView.removeFromSuperview()
        shellTwoView.removeFromSuperview()
        shellThreeView.removeFromSuperview()
        shellFourView.removeFromSuperview()
        shellFiveView.removeFromSuperview()
        
        let userinfo = getUserInfo()
        
        // firstLogin == 1 是已经登录过了
        getToken().isBlank == true ? initLoginView() : nil
        loginViewFade(fade: getUserFristLogin() != "1")
        
        getBindPhoneNumber().isBlank == true ? initCodeView():nil
        getBindPhoneNumber().isBlank == true ? initCodeInputView():nil
        getAvatarPath().isBlank == true ? initEmojiInputView():nil
        getUsername().isBlank == true ? initInputNameView():nil
        getUserKeyPrompt() == "1" ? nil : initShareIntroView()
        getUserKeyPrompt() == "1" ? nil : initShowView()
        
        let noti = UserDefaultWrapper<Int?>(key: UserDefaultKeys.ifNeedNoti).wrappedValue ?? 0
        noti == 0 ? initNotiAuthView():nil
        
        let library = UserDefaultWrapper<Int?>(key: UserDefaultKeys.ifNeedLibrary).wrappedValue ?? 0
        library == 0 ? initLibAuthView():nil
        
        print("noti == \(noti)")
        print("library == \(library)")
        if getUserGuide() != "1" {
            initShellView()
            initShellTwoView()
            initShellThreeView()
            initShellFourView()
            initShellFiveView()
        }
    }
    
    func loginViewFade(fade:Bool){
        print(fade == true ? "以【xxxx】继续" : "下一步")
        loginView.fade = fade
        if loginView.fade {
            loginView.setFocusBtn(idx: 0)
        }
    }
    
    // default UI
    
    open func defaultUI(){
        /*
         1、欢迎，登录界面一定有，后续接入 手柄序列号，会使用序列号，不会进入登录界面，直接去首页的
         
         */
        
        defer {
            scr.contentSize = CGSizeMake(visualRect.width * CGFloat(scr.subviews.count), 0)
        }
        
        self.welcomeView.removeFromSuperview()
        initWelcomeView()
        
    }
    

    
 
    
    var handler = {(action:GameLoginWelcomeViewAction,obj:Any?) in}{
        didSet{
            loginView.handler = handler
        }
    }
    
    var visualRect = CGSizeMake(kWidth, kHeight)
    
    //【设计有改动】
    init(visual:CGSize) {
        super.init(frame: .zero)
        visualRect = visual
        
        initScr()

    }
    
    // MARK: --
    // MARK: -- UI
    func initScr(){
        addSubview(scr)
        scr.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(visualRect)
        }
    }
    
    func initWelcomeView(){
        scr.addSubview(welcomeView)
        welcomeView.snp.remakeConstraints {
            $0.left.top.width.height.equalTo(scr)
        }
    }
    
    func initLoginView(){
        scr.addSubview(loginView)
        loginView.snp.remakeConstraints {
            $0.top.width.height.equalTo(scr)
            $0.left.equalToSuperview().offset(visualRect.width * CGFloat(scr.subviews.count-1))
        }
    }
    
    func initShareIntroView(){
        scr.addSubview(shareIntroView)
        shareIntroView.snp.remakeConstraints {
            $0.top.width.height.equalTo(scr)
            $0.left.equalToSuperview().offset(visualRect.width * CGFloat(scr.subviews.count-1))
        }
    }
    
    func initShowView(){
        scr.addSubview(showView)
        showView.snp.remakeConstraints {
            $0.top.width.height.equalTo(scr)
            $0.left.equalToSuperview().offset(visualRect.width  * CGFloat(scr.subviews.count-1))
        }
    }
    
    func initCodeView(){
        scr.addSubview(codeView)
        codeView.snp.remakeConstraints {
            $0.top.width.height.equalTo(scr)
            $0.left.equalToSuperview().offset(visualRect.width  * CGFloat(scr.subviews.count-1))
        }
    }
    
    func initCodeInputView(){
        scr.addSubview(codeInputView)
        codeInputView.snp.remakeConstraints {
            $0.top.width.height.equalTo(scr)
            $0.left.equalToSuperview().offset(visualRect.width  * CGFloat(scr.subviews.count-1))
        }
    }
    
    func initEmojiInputView(){
        scr.addSubview(emojiInputView)
        emojiInputView.snp.remakeConstraints {
            $0.top.width.height.equalTo(scr)
            $0.left.equalToSuperview().offset(visualRect.width  * CGFloat(scr.subviews.count-1))
        }
    }
    
    func initInputNameView(){
        scr.addSubview(inputNameView)
        inputNameView.snp.remakeConstraints {
            $0.top.width.height.equalTo(scr)
            $0.left.equalToSuperview().offset(visualRect.width  * CGFloat(scr.subviews.count-1))
        }
    }
    
    func initAddressBookView(){
        scr.addSubview(addressBookView)
        addressBookView.snp.remakeConstraints {
            $0.top.width.height.equalTo(scr)
            $0.left.equalToSuperview().offset(visualRect.width  * CGFloat(scr.subviews.count-1))
        }
    }
    
    func initSearchFriendView(){
        scr.addSubview(searchFriendView)
        searchFriendView.snp.remakeConstraints {
            $0.top.width.height.equalTo(scr)
            $0.left.equalToSuperview().offset(visualRect.width  * CGFloat(scr.subviews.count-1))
        }
    }
    
    func initNotiAuthView(){
        scr.addSubview(notiAuthView)
        notiAuthView.snp.remakeConstraints {
            $0.top.width.height.equalTo(scr)
            $0.left.equalToSuperview().offset(visualRect.width  * CGFloat(scr.subviews.count-1))
        }
    }
    
    func initLibAuthView(){
        scr.addSubview(libAuthView)
        libAuthView.snp.remakeConstraints {
            $0.top.width.height.equalTo(scr)
            $0.left.equalToSuperview().offset(visualRect.width  * CGFloat(scr.subviews.count-1))
        }
    }
    
    func initShellView(){
        scr.addSubview(shellView)
        shellView.snp.remakeConstraints {
            $0.top.width.height.equalTo(scr)
            $0.left.equalToSuperview().offset(visualRect.width  * CGFloat(scr.subviews.count-1))
        }
    }
    
    func initShellTwoView(){
        scr.addSubview(shellTwoView)
        shellTwoView.snp.remakeConstraints {
            $0.top.width.height.equalTo(scr)
            $0.left.equalToSuperview().offset(visualRect.width  * CGFloat(scr.subviews.count-1))
        }
    }
    func initShellThreeView(){
        scr.addSubview(shellThreeView)
        shellThreeView.snp.remakeConstraints {
            $0.top.width.height.equalTo(scr)
            $0.left.equalToSuperview().offset(visualRect.width  * CGFloat(scr.subviews.count-1))
        }
    }
    
    func initShellFourView(){
        scr.addSubview(shellFourView)
        shellFourView.snp.remakeConstraints {
            $0.top.width.height.equalTo(scr)
            $0.left.equalToSuperview().offset(visualRect.width  * CGFloat(scr.subviews.count-1))
        }
    }
    
    func initShellFiveView(){
        scr.addSubview(shellFiveView)
        shellFiveView.snp.remakeConstraints {
            $0.top.width.height.equalTo(scr)
            $0.left.equalToSuperview().offset(visualRect.width  * CGFloat(scr.subviews.count-1))
        }
    }
    
    
//    func initKeyHomeView(){
//        scr.addSubview(keyHomeView)
//        keyHomeView.snp.makeConstraints {
//            $0.top.width.height.equalTo(scr)
//            $0.left.equalToSuperview().offset(visualRect.width  * CGFloat(scr.subviews.count-1))
//        }
//    }
    
    // MARK: --
    // MARK: -- lazy
    lazy var scr:UIScrollView = {
        let s = UIScrollView().then {
            $0.isScrollEnabled = false
            $0.backgroundColor = .white
            $0.isPagingEnabled = true
            $0.contentInsetAdjustmentBehavior = .never
            $0.bounces = false
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
        }
        return s
    }()
    
    lazy var welcomeView:GameLoginView = {
        let welcome = GameLoginView(index: 0).then {
            $0.backgroundColor = .white
        }
        return welcome
    }()
    
    lazy var loginView:GameLoginView = {
        let welcome = GameLoginView(index: 1).then {
            $0.backgroundColor = .white
        }
        return welcome
    }()
    
    // 分享高光时刻
    lazy var shareIntroView:GameIntroduceView = {
        let view = GameIntroduceView(idx: 0).then {
            $0.backgroundColor = .black
            
        }
        return view
    }()
    
    // 您可以向大家炫耀
    lazy var showView:GameIntroduceView = {
        let view = GameIntroduceView(idx: 1).then {
            $0.backgroundColor = .black
        }
        return view
    }()
    
    // 手机获取验证码
    lazy var codeView:GameMsgCodeView = {
        let view = GameMsgCodeView().then {
            $0.backgroundColor = .white
        }
        return view
    }()
    
    // 输入手机验证摸
    lazy var codeInputView:GameMsgInputView = {
        let view = GameMsgInputView().then {
            $0.backgroundColor = .white
        }
        return view
    }()
    
    lazy var emojiInputView:GameInputEmojiView = {
        let view = GameInputEmojiView().then {
            $0.backgroundColor = .white
        }
        return view
    }()
    
    
    lazy var inputNameView:GameInputNameView = {
        let view = GameInputNameView().then {
            $0.backgroundColor = .white
        }
        return view
    }()
    
    lazy var addressBookView:GameAdressBookView = {
        let view = GameAdressBookView().then {
            $0.backgroundColor = .white
        }
        return view
    }()
    
    lazy var searchFriendView:GameSearchFriendView = {
        let view = GameSearchFriendView().then {
            $0.backgroundColor = .white
        }
        return view
    }()
    
    
    lazy var notiAuthView:GameNotiAuthView = {
        let view = GameNotiAuthView().then {
            $0.backgroundColor = .white
        }
        return view
    }()
    
    lazy var libAuthView:GameLibAuthView = {
        let view = GameLibAuthView().then {
            $0.backgroundColor = .white
        }
        return view
    }()
    
    lazy var shellView:GameShellView = {
        let view = GameShellView().then {
            $0.backgroundColor = .hex("#252525")
        }
        return view
    }()
    
    lazy var shellTwoView:GameShellTwoView = {
        let view = GameShellTwoView().then {
            $0.backgroundColor = .hex("#252525")
        }
        return view
    }()
    lazy var shellThreeView:GameShellThreeView = {
        let view = GameShellThreeView().then {
            $0.backgroundColor = .hex("#252525")
        }
        return view
    }()
    
    lazy var shellFourView:GameShellFourView = {
        let view = GameShellFourView().then {
            $0.backgroundColor = .hex("#252525")
        }
        return view
    }()
    
    lazy var shellFiveView:GameShellFiveView = {
        let view = GameShellFiveView().then {
            $0.backgroundColor = .hex("#252525")
        }
        return view
    }()
    
    
    
//    lazy var keyHomeView:GameKeyHomeView = {
//        let view = GameKeyHomeView().then {
//            $0.backgroundColor = .white
//        }
//        return view
//    }()
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
