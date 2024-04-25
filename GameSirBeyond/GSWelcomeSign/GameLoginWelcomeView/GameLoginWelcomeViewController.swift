//
//  GameLoginWelcomeViewController.swift
//  GameLoginWelcome
//
//  Created by lu on 2024/3/18.
//

import UIKit

/// 已经废弃
class GameLoginWelcomeViewController: UIViewController {
    
    /// 通讯录是否授权
    var addressbookAuth = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        loiginAndWelcome()
        
        regisNotis()
        
    }
    
    
    func loiginAndWelcome(){
        loginWelcomeView = GameLoginWelcomeView(visual: CGSizeMake(kWidth, kHeight)).then {_ in }
        
        view.addSubview(loginWelcomeView)
        loginWelcomeView.snp.makeConstraints {
            $0.left.right.top.bottom.equalTo(view)
        }
        loginWelcomeView.backgroundColor = .white
        
        loginWelcomeView.handler = {[weak self]  (action:GameLoginWelcomeViewAction,obj:Any?) in
            guard let `self` = self else { return }
            print("action == \(action)")
            
        }
        
        loginWelcomeView.codeView.backBtn.backHandler = {[weak self] in
            guard let `self` = self else { return }
            loginWelcomeView.codeView.backBtn.runAnim()
            delay(interval: AntiShakeTime) {[weak self] in
                guard let `self` = self else { return }
                self.scrBack()
            }
        }
        
        loginWelcomeView.codeInputView.backBtn.backHandler = {[weak self] in
            guard let `self` = self else { return }
            loginWelcomeView.codeInputView.backBtn.runAnim()
            delay(interval: AntiShakeTime) {[weak self] in
                guard let `self` = self else { return }
                self.scrBack()
            }
        }
        
        loginWelcomeView.shareIntroView.backBtn.backHandler = {[weak self] in
            guard let `self` = self else { return }
            loginWelcomeView.shareIntroView.backBtn.runAnim()
            delay(interval: AntiShakeTime) {[weak self] in
                guard let `self` = self else { return }
                self.scrBack()
            }
        }
        
        loginWelcomeView.showView.backBtn.backHandler = {[weak self] in
            guard let `self` = self else { return }
            loginWelcomeView.showView.backBtn.runAnim()
            delay(interval: AntiShakeTime) {[weak self] in
                guard let `self` = self else { return }
                self.scrBack()
            }
        }
        
        loginWelcomeView.addressBookView.backBtn.backHandler = {[weak self] in
            guard let `self` = self else { return }
            loginWelcomeView.addressBookView.backBtn.runAnim()
            delay(interval: AntiShakeTime) {[weak self] in
                guard let `self` = self else { return }
                self.scrBack()
            }
        }
        
        loginWelcomeView.searchFriendView.backBtn.backHandler = {[weak self] in
            guard let `self` = self else { return }
            loginWelcomeView.searchFriendView.backBtn.runAnim()
            delay(interval: AntiShakeTime) {[weak self] in
                guard let `self` = self else { return }
                self.scrBack()
            }
        }
        
        loginWelcomeView.notiAuthView.backBtn.backHandler = {[weak self] in
            guard let `self` = self else { return }
            loginWelcomeView.notiAuthView.backBtn.runAnim()
            delay(interval: AntiShakeTime) {[weak self] in
                guard let `self` = self else { return }
                self.scrBack()
            }
        }
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    var loginWelcomeView:GameLoginWelcomeView!
    
    @objc func scrNext(){
        loginWelcomeView.endEditing(false)
        let contentOffX = Int(loginWelcomeView.scr.contentOffset.x / kWidth)
        guard kWidth * CGFloat(contentOffX + 1) < loginWelcomeView.scr.contentSize.width else {
            print("scr 超出内容")
            return
        }
        loginWelcomeView.scr.isPagingEnabled = true
        loginWelcomeView.scr.setContentOffset(CGPointMake(kWidth * CGFloat(contentOffX + 1), 0), animated: true)
        loginWelcomeView.scr.isPagingEnabled = false
        
        if contentOffX + 1 == 2 {
            loginWelcomeView.codeView.phoneTF.becomeFirstResponder()
            return
        }
        
        if contentOffX + 1 == 3 {
            loginWelcomeView.codeInputView.pinCodeInputView.becomeFirstResponder()
            return
        }
        
        if contentOffX + 1 == 4 {
            //loginWelcomeView.emojiInputView.emojiTF.becomeFirstResponder()
            return
        }
    }
    
    @objc func scrBack(){
        loginWelcomeView.endEditing(false)
        let contentOffX = Int(loginWelcomeView.scr.contentOffset.x / kWidth)
        guard contentOffX - 1 >= 0 else {
            print("scr 超出内容")
            return
        }
        loginWelcomeView.scr.isPagingEnabled = true
        loginWelcomeView.scr.setContentOffset(CGPointMake(kWidth * CGFloat(contentOffX - 1), 0), animated: true)
        loginWelcomeView.scr.isPagingEnabled = false
        
        
    }
}

// 关于手柄
extension GameLoginWelcomeViewController {
    func regisNotis(){
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressX),
                                               name: NSNotification.Name(ControllerNotificationName.KeyXPressed.rawValue),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressY),
                                               name: NSNotification.Name(ControllerNotificationName.KeyYPressed.rawValue),
                                               object: nil)
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressA),
                                               name: NSNotification.Name(ControllerNotificationName.KeyAPressed.rawValue),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressB),
                                               name: NSNotification.Name(ControllerNotificationName.KeyBPressed.rawValue),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressLeft),
                                               name: NSNotification.Name(ControllerNotificationName.LeftJoystickMoveLeft.rawValue),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressRight),
                                               name: NSNotification.Name(ControllerNotificationName.LeftJoystickMoveRight.rawValue),
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
                                               selector: #selector(scrNext),
                                               name: NSNotification.Name("CommitSmsCode"),
                                               object: nil)
        
    }
    
    @objc func pressX(){
        let idx:Int = Int(loginWelcomeView.scr.contentOffset.x / kWidth)
        
        if idx == 9 && addressbookAuth == true &&  loginWelcomeView.searchFriendView.results.count == 0{
            loginWelcomeView.searchFriendView.continueXBtn.backBtnDidClicked()
            antiShakeNoti(name: ControllerNotificationName.KeyXPressed.rawValue, aSelector: #selector(pressX))
            delay(interval: AntiShakeTime) {[weak self] in
                guard let `self` = self else { return }
                self.scrNext()
            }
            
        }
    }
    
    @objc func pressY(){
        
    }
    
    @objc func pressA(){
        
        let idx:Int = Int(loginWelcomeView.scr.contentOffset.x / kWidth)
        
        if idx == 0  {
            print("首页跳过")
            scrNext()
            return
        }
        if idx == 1  {
            let appleSignIn = loginWelcomeView.loginView.onFocusIdx == 0 ? true:false
            print( appleSignIn ? "apple" : "google" + "登录")
            scrNext()
            return
        }
        
        if idx == 2 {
            guard case loginWelcomeView.codeView.phoneTF.text?.count = 11 else { return }
            
            loginWelcomeView.codeView.sendCode()
            delay(interval: AntiShakeTime) {[weak self] in
                guard let `self` = self else { return }
                self.scrNext()
                self.loginWelcomeView.codeInputView.isAgain = self.loginWelcomeView.codeView.sendAgain > 1
                
            }
        }
        
        if idx == 4 {
            guard case loginWelcomeView.emojiInputView.emojiTF.text?.count = 1 else { return }
            scrNext()
            return
        }
        
        if idx == 5 {
            scrNext()
            return
        }
        
        if idx == 6 {
            scrNext()
            return
        }
        
        if idx == 7 {
            guard loginWelcomeView.showView.introduceState == .doneRecode  else { return }
            scrNext()
            return
        }
        
        if idx == 8 {
            addressbookAuth = loginWelcomeView.addressBookView.onFocusIdx == 0 ? true : false
            //loginWelcomeView.addLastSubViews(addressbookAuth: addressbookAuth)
            scrNext()
            if addressbookAuth == true {
                loginWelcomeView.searchFriendView.isSearching = true
            }
            return
        }
        
        // -----------------------------------搜索好友-----------------------
        if addressbookAuth == true && idx == 9 {
            if loginWelcomeView.searchFriendView.results.count > 0 {
                // 1.点击点是否在collection上,取出该item，设置成add
                if loginWelcomeView.searchFriendView.focusOnColl {
                    var model:GameSearchFriendReslut?
                    loginWelcomeView.searchFriendView.results.forEach { tmp in
                        if tmp.isSelect && tmp.isAdd == false{
                            model = tmp
                        }
                    }
                    if let _model = model {
                        _model.isAdd = true
                        loginWelcomeView.searchFriendView.reslutColl.reloadData()
                    }
                } else {
                    // 2.判断点击点是在添加，还是继续上面
                    if loginWelcomeView.searchFriendView.btnFocusOnAddAll {
                        loginWelcomeView.searchFriendView.results.forEach { model in
                            model.isAdd = true
                        }
                        loginWelcomeView.searchFriendView.reslutColl.reloadData()
                        delay(interval: 0.3) {[weak self] in
                            guard let `self` = self else { return }
                            self.scrNext()
                        }
                    }else {
                        scrNext()
                    }
                }
            }
            // 没有数据的情况下，直接进入下一个
            else{
                scrNext()
            }
            return
        }
        // -----------------------------------保持资讯更新-----------------------
        if addressbookAuth == false && idx == 9 {
            scrNext()
            return
        }
        if addressbookAuth == true && idx == 10 {
            scrNext()
            return
        }
        
        
        if addressbookAuth == false && idx == 10 {
            scrNext()
            return
        }
        if addressbookAuth == true && idx == 11 {
            scrNext()
            return
        }
        
        if addressbookAuth == false && idx == 11 {
            scrNext()
            return
        }
        if addressbookAuth == true && idx == 12 {
            scrNext()
            return
        }
        
        if addressbookAuth == false && idx == 12 {
            scrNext()
            return
        }
        if addressbookAuth == true && idx == 13 {
            scrNext()
            return
        }
        
        if addressbookAuth == false && idx == 13 {
            scrNext()
            return
        }
        if addressbookAuth == true && idx == 14 {
            scrNext()
            return
        }
        
        if addressbookAuth == false && idx == 14 {
            scrNext()
            return
        }
        if addressbookAuth == true && idx == 15 {
            scrNext()
            return
        }
    }
    
    
    
    
    @objc func pressB(){
        let idx:Int = Int(loginWelcomeView.scr.contentOffset.x / kWidth)
        if idx == 2 {
            loginWelcomeView.codeView.backBtn.backBtnDidClicked()
            antiShakeNoti(name: ControllerNotificationName.KeyBPressed.rawValue, aSelector: #selector(pressB))
            delay(interval: AntiShakeTime) {[weak self] in
                guard let `self` = self else { return }
                self.scrBack()
            }
            return
        }
        
        if idx == 3 {
            loginWelcomeView.codeInputView.backBtn.backBtnDidClicked()
            antiShakeNoti(name: ControllerNotificationName.KeyBPressed.rawValue, aSelector: #selector(pressB))
            delay(interval: AntiShakeTime) {[weak self] in
                guard let `self` = self else { return }
                self.scrBack()
            }
            return
        }
        
        if idx == 6 {
            loginWelcomeView.shareIntroView.backBtn.backBtnDidClicked()
            antiShakeNoti(name: ControllerNotificationName.KeyBPressed.rawValue, aSelector: #selector(pressB))
            delay(interval: AntiShakeTime) {[weak self] in
                guard let `self` = self else { return }
                self.scrBack()
            }
            return
        }
        
        if idx == 7 {
            
            loginWelcomeView.showView.backBtn.backBtnDidClicked()
            antiShakeNoti(name: ControllerNotificationName.KeyBPressed.rawValue, aSelector: #selector(pressB))
            delay(interval: AntiShakeTime) {[weak self] in
                guard let `self` = self else { return }
                self.scrBack()
            }
            return
        }
        
        if idx == 8 {
            loginWelcomeView.addressBookView.backBtn.backBtnDidClicked()
            antiShakeNoti(name: ControllerNotificationName.KeyBPressed.rawValue, aSelector: #selector(pressB))
            delay(interval: AntiShakeTime) {[weak self] in
                guard let `self` = self else { return }
                self.scrBack()
            }
            return
        }
        
        if idx == 9 && addressbookAuth == true{
            loginWelcomeView.searchFriendView.backBtn.backBtnDidClicked()
            antiShakeNoti(name: ControllerNotificationName.KeyBPressed.rawValue, aSelector: #selector(pressB))
            delay(interval: AntiShakeTime) {[weak self] in
                guard let `self` = self else { return }
                self.scrBack()
            }
            return
        }
        
        // -----------------------------------保持资讯更新-----------------------
        if idx == 9 && addressbookAuth == false{
            loginWelcomeView.notiAuthView.backBtn.backBtnDidClicked()
            antiShakeNoti(name: ControllerNotificationName.KeyBPressed.rawValue, aSelector: #selector(pressB))
            delay(interval: AntiShakeTime) {[weak self] in
                guard let `self` = self else { return }
                self.scrBack()
            }
            return
        }
        if idx == 10 && addressbookAuth == true {
            loginWelcomeView.notiAuthView.backBtn.backBtnDidClicked()
            antiShakeNoti(name: ControllerNotificationName.KeyBPressed.rawValue, aSelector: #selector(pressB))
            delay(interval: AntiShakeTime) {[weak self] in
                guard let `self` = self else { return }
                self.scrBack()
            }
            return
        }
        
        
        // -----------------------------------保存影片剪辑-----------------------
        if idx == 10 && addressbookAuth == false{
            loginWelcomeView.libAuthView.backBtn.backBtnDidClicked()
            antiShakeNoti(name: ControllerNotificationName.KeyBPressed.rawValue, aSelector: #selector(pressB))
            delay(interval: AntiShakeTime) {[weak self] in
                guard let `self` = self else { return }
                self.scrBack()
            }
            return
        }
        if idx == 11 && addressbookAuth == true {
            loginWelcomeView.libAuthView.backBtn.backBtnDidClicked()
            antiShakeNoti(name: ControllerNotificationName.KeyBPressed.rawValue, aSelector: #selector(pressB))
            delay(interval: AntiShakeTime) {[weak self] in
                guard let `self` = self else { return }
                self.scrBack()
            }
            return
        }
        
        
        if idx == 11 && addressbookAuth == false{
            loginWelcomeView.shellView.backBtn.backBtnDidClicked()
            antiShakeNoti(name: ControllerNotificationName.KeyBPressed.rawValue, aSelector: #selector(pressB))
            delay(interval: AntiShakeTime) {[weak self] in
                guard let `self` = self else { return }
                self.scrBack()
            }
            return
        }
        if idx == 12 && addressbookAuth == true {
            loginWelcomeView.shellView.backBtn.backBtnDidClicked()
            antiShakeNoti(name: ControllerNotificationName.KeyBPressed.rawValue, aSelector: #selector(pressB))
            delay(interval: AntiShakeTime) {[weak self] in
                guard let `self` = self else { return }
                self.scrBack()
            }
            return
        }
        
        
        if idx == 12 && addressbookAuth == false{
            loginWelcomeView.shellTwoView.backBtn.backBtnDidClicked()
            antiShakeNoti(name: ControllerNotificationName.KeyBPressed.rawValue, aSelector: #selector(pressB))
            delay(interval: AntiShakeTime) {[weak self] in
                guard let `self` = self else { return }
                self.scrBack()
            }
            return
        }
        if idx == 13 && addressbookAuth == true {
            loginWelcomeView.shellTwoView.backBtn.backBtnDidClicked()
            antiShakeNoti(name: ControllerNotificationName.KeyBPressed.rawValue, aSelector: #selector(pressB))
            delay(interval: AntiShakeTime) {[weak self] in
                guard let `self` = self else { return }
                self.scrBack()
            }
            return
        }
        
        if idx == 13 && addressbookAuth == false{
            loginWelcomeView.shellThreeView.backBtn.backBtnDidClicked()
            antiShakeNoti(name: ControllerNotificationName.KeyBPressed.rawValue, aSelector: #selector(pressB))
            delay(interval: AntiShakeTime) {[weak self] in
                guard let `self` = self else { return }
                self.scrBack()
            }
            return
        }
        
        if idx == 14 && addressbookAuth == true {
            loginWelcomeView.shellThreeView.backBtn.backBtnDidClicked()
            antiShakeNoti(name: ControllerNotificationName.KeyBPressed.rawValue, aSelector: #selector(pressB))
            delay(interval: AntiShakeTime) {[weak self] in
                guard let `self` = self else { return }
                self.scrBack()
            }
            return
        }
        
        if idx == 14 && addressbookAuth == false{
            loginWelcomeView.shellFourView.backBtn.backBtnDidClicked()
            antiShakeNoti(name: ControllerNotificationName.KeyBPressed.rawValue, aSelector: #selector(pressB))
            delay(interval: AntiShakeTime) {[weak self] in
                guard let `self` = self else { return }
                self.scrBack()
            }
            return
        }
        
        if idx == 15 && addressbookAuth == true {
            loginWelcomeView.shellFourView.backBtn.backBtnDidClicked()
            antiShakeNoti(name: ControllerNotificationName.KeyBPressed.rawValue, aSelector: #selector(pressB))
            delay(interval: AntiShakeTime) {[weak self] in
                guard let `self` = self else { return }
                self.scrBack()
            }
            return
        }
        
        if idx == 15 && addressbookAuth == false{
            loginWelcomeView.shellFiveView.backBtn.backBtnDidClicked()
            antiShakeNoti(name: ControllerNotificationName.KeyBPressed.rawValue, aSelector: #selector(pressB))
            delay(interval: AntiShakeTime) {[weak self] in
                guard let `self` = self else { return }
                self.scrBack()
            }
            return
        }
        
        if idx == 16 && addressbookAuth == true {
            loginWelcomeView.shellFiveView.backBtn.backBtnDidClicked()
            antiShakeNoti(name: ControllerNotificationName.KeyBPressed.rawValue, aSelector: #selector(pressB))
            delay(interval: AntiShakeTime) {[weak self] in
                guard let `self` = self else { return }
                self.scrBack()
            }
            return
        }
    }
    
    @objc func pressLeft(){
        let idx:Int = Int(loginWelcomeView.scr.contentOffset.x / kWidth)
        if addressbookAuth == true && idx == 9 && loginWelcomeView.searchFriendView.results.count > 0{
            print("pressLeft")
            // 找出选中状态的item
            if loginWelcomeView.searchFriendView.focusOnColl == true {
                var selectIndex = 0
                for i in 0..<loginWelcomeView.searchFriendView.results.count{
                    if loginWelcomeView.searchFriendView.results[i].isSelect == true {
                        selectIndex = i
                    }
                }
                if selectIndex == 0 {
                    
                }
                else{
                    selectIndex -= 1
                    if selectIndex < 0  {
                        selectIndex = 0
                    }
                }
                loginWelcomeView.searchFriendView.collectionView(loginWelcomeView.searchFriendView.reslutColl, didSelectItemAt: IndexPath(row: selectIndex, section: 0))
                loginWelcomeView.searchFriendView.reslutColl.scrollToItem(at: IndexPath(row: selectIndex,section: 0), at: .centeredHorizontally, animated: true)
            }
            else{
                loginWelcomeView.searchFriendView.btnFocusOnAddAll = true
            }
            
            return
        }
    }
    
    @objc func pressRight(){
        let idx:Int = Int(loginWelcomeView.scr.contentOffset.x / kWidth)
        if addressbookAuth == true && idx == 9 && loginWelcomeView.searchFriendView.results.count > 0{
            print("pressRight")
            // 找出选中状态的item
            if loginWelcomeView.searchFriendView.focusOnColl == true {
                var selectIndex = 0
                for i in 0..<loginWelcomeView.searchFriendView.results.count{
                    if loginWelcomeView.searchFriendView.results[i].isSelect == true {
                        selectIndex = i
                    }
                }
                if selectIndex == loginWelcomeView.searchFriendView.results.count - 1 {
                    
                }
                else{
                    selectIndex += 1
                    if selectIndex > loginWelcomeView.searchFriendView.results.count - 1 {
                        selectIndex = loginWelcomeView.searchFriendView.results.count - 1
                    }
                    
                }
                loginWelcomeView.searchFriendView.collectionView(loginWelcomeView.searchFriendView.reslutColl, didSelectItemAt: IndexPath(row: selectIndex, section: 0))
                loginWelcomeView.searchFriendView.reslutColl.scrollToItem(at: IndexPath(row: selectIndex,section: 0), at: .centeredHorizontally, animated: true)
            }
            else{
                loginWelcomeView.searchFriendView.btnFocusOnAddAll = false
            }
            return
        }
    }
    
    @objc func pressUp(){
        let idx:Int = Int(loginWelcomeView.scr.contentOffset.x / kWidth)
        if idx == 1 {
            loginWelcomeView.loginView.setFocusBtn(idx: loginWelcomeView.loginView.onFocusIdx == 0 ? 1:0)
            return
        }
        
        if idx == 8 {
            loginWelcomeView.addressBookView.setFocusBtn(idx: loginWelcomeView.addressBookView.onFocusIdx == 0 ? 1:0)
            return
        }
        
        if addressbookAuth == true && idx == 9 && loginWelcomeView.searchFriendView.results.count > 0 {
            loginWelcomeView.searchFriendView.focusOnColl = true
            return
        }
        
        
        if addressbookAuth == false && idx == 9 {
            loginWelcomeView.notiAuthView.setFocusBtn(idx: loginWelcomeView.notiAuthView.onFocusIdx == 0 ? 1:0)
            return
        }
        if addressbookAuth == true && idx == 10 {
            loginWelcomeView.notiAuthView.setFocusBtn(idx: loginWelcomeView.notiAuthView.onFocusIdx == 0 ? 1:0)
            return
        }
        
        if addressbookAuth == false && idx == 10 {
            loginWelcomeView.libAuthView.setFocusBtn(idx: loginWelcomeView.libAuthView.onFocusIdx == 0 ? 1:0)
            return
        }
        if addressbookAuth == true && idx == 11 {
            loginWelcomeView.libAuthView.setFocusBtn(idx: loginWelcomeView.libAuthView.onFocusIdx == 0 ? 1:0)
            return
        }
        
    }
    
    @objc func pressDown(){
        let idx:Int = Int(loginWelcomeView.scr.contentOffset.x / kWidth)
        if idx == 1 {
            loginWelcomeView.loginView.setFocusBtn(idx: loginWelcomeView.loginView.onFocusIdx == 0 ? 1:0)
            return
        }
        if idx == 8 {
            loginWelcomeView.addressBookView.setFocusBtn(idx: loginWelcomeView.addressBookView.onFocusIdx == 0 ? 1:0)
            return
        }
        
        if addressbookAuth == true && idx == 9 && loginWelcomeView.searchFriendView.results.count > 0{
            loginWelcomeView.searchFriendView.focusOnColl = false
            return
        }
        
        if addressbookAuth == false && idx == 9 {
            loginWelcomeView.notiAuthView.setFocusBtn(idx: loginWelcomeView.notiAuthView.onFocusIdx == 0 ? 1:0)
            return
        }
        if addressbookAuth == true && idx == 10 {
            loginWelcomeView.notiAuthView.setFocusBtn(idx: loginWelcomeView.notiAuthView.onFocusIdx == 0 ? 1:0)
            return
        }
        
        if addressbookAuth == false && idx == 10 {
            loginWelcomeView.libAuthView.setFocusBtn(idx: loginWelcomeView.libAuthView.onFocusIdx == 0 ? 1:0)
            return
        }
        if addressbookAuth == true && idx == 11 {
            loginWelcomeView.libAuthView.setFocusBtn(idx: loginWelcomeView.libAuthView.onFocusIdx == 0 ? 1:0)
            return
        }
    }
    
    @objc func pressScreenshot(){
        let idx:Int = Int(loginWelcomeView.scr.contentOffset.x / kWidth)
        if idx == 7 {
            if loginWelcomeView.showView.introduceState == .stateNormal {
                loginWelcomeView.showView.introduceState = .doneScreenshot
            }
            else if loginWelcomeView.showView.introduceState == .doneScreenshot {
                loginWelcomeView.showView.introduceState = .doneRecode
            }
        }
    }
    
    @objc func pressHome(){
        print("首页")
        let idx:Int = Int(loginWelcomeView.scr.contentOffset.x / kWidth)
        if idx == 15 && addressbookAuth == false{
//            let vc = GameUserInfoDrawerViewController()
//            
//            let app = UIApplication.shared.delegate?.window??.rootViewController
//            print("app == \(app)")
            return
        }
        
        if idx == 16 && addressbookAuth == true {
//            let vc = GameUserInfoDrawerViewController()
//            let app = UIApplication.shared.delegate?.window??.rootViewController
//            print("app == \(app)")
            return
        }
    }
    
    func antiShakeNoti(name:String,aSelector: Selector){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(name), object: nil)
        delay(interval: AntiShakeTime) {[weak self] in
            guard let `self` = self else {return}
            NotificationCenter.default.addObserver(self, selector: aSelector, name: NSNotification.Name(name), object: nil)
        }
    }
    
}
