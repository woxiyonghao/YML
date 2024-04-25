
//
//  GSUserInfoViewController.swift
//  GameSirBeyond
//
//  Created by lu on 2024/3/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import Moya
import SwiftyJSON
//import IQKeyboardManager
enum GSUserInfoViewControllerShowItem {
    //case none
    case info
    case editGameName
    case editUserInfo
    //case setting
}

let Transform3DScale = 0.9
class GSUserInfoViewController: UIViewController {
    
    var showItem:GSUserInfoViewControllerShowItem = .info
    
    open var dismissHandler = {() in}
    
    var onFcousView:UIView?
    
    /// 是否正在按 A 或 B -----
    var onPressing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .hex("#20242F").withAlphaComponent(0.6)
        
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        view.addSubview(infoView)
        
        view.addSubview(editGameNameView)
        
        view.addSubview(editUserInfoView)
        editUserInfoView.frame = CGRect(x: view.centerX, y: 0, width: 0, height: view.height)
        
        
        view.addSubview(backBtn)
        backBtn.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-30.widthScale)
            $0.bottom.equalToSuperview().offset(-30.widthScale)
            $0.width.equalTo(74.widthScale)
            $0.height.equalTo(40.widthScale)
        }
        
        backBtn.backHandler = {() in
            NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyBPressOut.rawValue), object: nil)
        }
        
        showInfoView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        infoView.refreshUserInfo()
    }
    
    
    
    func addTectView(){
        tectView = TectView(frame: CGRectMake(kWidth - 240, 0, 240, kHeight))
        view.addSubview(tectView)
        tectView.backgroundColor = .blue
        tectView.alpha = 0.3
    }
    
    func dismissInfoView(){
        UIView.animate(withDuration: AntiShakeTime) {[weak self] in
            guard let `self` = self else {return}
            self.infoView.x = -self.infoView.width
        }
    }
    
    func showInfoView(){
        
        UIView.animate(withDuration: AntiShakeTime) {[weak self] in
            guard let `self` = self else {return}
            self.infoView.x = 0
        }
    }
    
    func showEditGameNameView(){
        UIView.animate(withDuration: AntiShakeTime) {[weak self] in
            guard let `self` = self else {return}
            self.editGameNameView.x = 0
            self.editGameNameView.width = kWidth
            self.editGameNameView.alpha = 1
        } completion: { _ in
            
        }
    }
    
    func dismissEditGameNameView(){
        UIView.animate(withDuration: AntiShakeTime) {[weak self] in
            guard let `self` = self else {return}
            self.editGameNameView.x = self.view.centerX
            self.editGameNameView.width = 0
            self.editGameNameView.alpha = 0
        } completion: { _ in
            
        }
    }
    
    func showEditUserInfoView(){
        UIView.animate(withDuration: AntiShakeTime) {[weak self] in
            guard let `self` = self else {return}
            self.editUserInfoView.x = 0
            self.editUserInfoView.width = kWidth
            self.editUserInfoView.alpha = 1
        } completion: { _ in
            
        }
    }
    
    func dismissEditUserInfoView(){
        UIView.animate(withDuration: AntiShakeTime) {[weak self] in
            guard let `self` = self else {return}
            self.editUserInfoView.x = self.view.centerX
            self.editUserInfoView.width = 0
            self.editUserInfoView.alpha = 0
        } completion: { _ in
            self.editUserInfoView.dismissEmojiChooseView()
        }
    }
    
    func showSettingView(){
        /*
        self.unitNotis()
        let setter = GSSetterViewController().then {
            $0.regisNotis()
        }
        navigationController?.pushViewController(setter, animated: true)
        setter.popHandler = {[weak self] in
            guard let `self` = self else { return }
            self.regisNotis()
            $0.regisNotis()
        }
         */
        
        self.unitNotis()
        let setter = GSSetViewController().then {
            $0.regisNotis()
        }
        navigationController?.pushViewController(setter, animated: true)
        setter.popHandler = {[weak self] in
            guard let `self` = self else { return }
            self.regisNotis()
            $0.unitNotis()
            $0.navigationController?.popViewController(animated: true)
        }
    }
    
    
    lazy var editUserInfoView:GameEditUserInfoView = {
        let view = GameEditUserInfoView().then {
            $0.backgroundColor = .hex("#20242F")
            $0.alpha = 0
        }
        return view
    }()
    
    
    lazy var editGameNameView:GameEditGameNameView = {
        let view = GameEditGameNameView(frame: CGRectMake(0, 0, kWidth, kHeight)).then {
            $0.backgroundColor = .hex("#20242F")
            $0.alpha = 0
        }
        return view
    }()
    
    
    var backBtn:GameBackKeyBtn = {
        let btn = GameBackKeyBtn().then {
            $0.label.textColor = .hex("#ffffff")
            $0.icon.image = UIImage(named: "ic-B-clear")
            $0.btn.backgroundColor = .clear
            $0.btn.layer.cornerRadius = 20.widthScale
            $0.btn.layer.masksToBounds = true
            $0.anim = true
            //$0.backgroundColor = .hex("#000000")
            //$0.isHidden = true
        }
        return btn
    }()
    
    
    var tectView:TectView!
    
    deinit {
        unitNotis()
    }
    
    lazy var infoView = GSUserInfoView(frame: CGRect(x: -364.widthScale, y: 0, width: 364.widthScale, height: kHeight)).then {
        $0.selectSection = 0
        $0.backgroundColor = .hex("#22262E").withAlphaComponent(1)
    }
    
    func setApiUsername(bio:String?,name:String!,avatar:String!,x: @escaping Callback){
        
        let networker = MoyaProvider<UserService>()
        networker.request(.setApiBio(bio: bio ?? "", name: name, avatar: avatar)) { [weak self] result in
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
                    print("设置用户信息成功")
                    
                    delay(interval: 0.1) {
                        refreshUserInfo()
                        x(true)
                    }
                }
                else {
                    //MBProgressHUD.showMsgWithtext(responseData["msg"] as! String)
                    print("设置用户信息失败", responseData["msg"]!)
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

// 关于手柄
extension GSUserInfoViewController {
    
    public func unitNotis(){
        NotificationCenter.default.removeObserver(self)
    }
    
    public func regisNotis(){
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressX),
                                               name: NSNotification.Name(ControllerNotificationName.KeyXPressed.rawValue),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressY),
                                               name: NSNotification.Name(ControllerNotificationName.KeyYPressed.rawValue),
                                               object: nil)
        
        /*
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressA),
                                               name: NSNotification.Name(ControllerNotificationName.KeyAPressed.rawValue),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressB),
                                               name: NSNotification.Name(ControllerNotificationName.KeyBPressed.rawValue),
                                               object: nil)
        */
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onPressingA),
                                               name: NSNotification.Name(ControllerNotificationName.KeyAPressIn.rawValue),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onPressingB),
                                               name: NSNotification.Name(ControllerNotificationName.KeyBPressIn.rawValue),
                                               object: nil)
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressAOut),
                                               name: NSNotification.Name(ControllerNotificationName.KeyAPressOut.rawValue),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressB),
                                               name: NSNotification.Name(ControllerNotificationName.KeyBPressOut.rawValue),
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
        
        
    }
   
    @objc func pressX(){
        
        
    }
    
    @objc func pressY(){
    }
    
    
    @objc func onPressingA(){
        guard let onFcousView = findOnFcousView() else { 
            onPressing = false
            return
        }
        onPressing = true
        UIView.animate(withDuration: 0.15) {[weak self] in
            guard let `self` = self else {return}
            self.onFcousView = onFcousView
            onFcousView.transform3D = CATransform3DScale(CATransform3DIdentity, Transform3DScale, Transform3DScale, Transform3DScale)
        }
    }
    
    @objc func onPressingB(){
        guard let onFcousView = findOnFcousView() else {
            onPressing = false
            return
        }
        onPressing = true
        UIView.animate(withDuration: 0.15) {[weak self] in
            guard let `self` = self else {return}
            self.backBtn.transform3D = CATransform3DScale(CATransform3DIdentity, Transform3DScale, Transform3DScale, Transform3DScale)
        }
    }
    
    @objc func pressAOut(){
        onPressing = false
        guard let view = self.onFcousView else {
            _pressA()
            return
        }
        UIView.animate(withDuration: 0.2) {
            view.transform3D = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
        } completion: {[weak self]  in
            guard let `self` = self else { return }
            if $0 == true {
                self._pressA()
            }
        }

    }
    
    @objc func _pressA(){
        if self.showItem == .info {
            let row = infoView.selectRow
            let section = infoView.selectSection
            if section == 0 {
                if row == 0 {
                    print("进入录像")
                }
                else if row == 1 {
                    print("进入图片")
                }
                else {
                    print("进入设置")
                    showSettingView()
                }
            }
            else if section == 1 {
                self.dismissInfoView()
                self.showEditUserInfoView()
                self.showItem = .editUserInfo
            }
            else {
                self.dismissInfoView()
                self.showEditGameNameView()
                self.showItem = .editGameName
            }
            
            return
        }
        
        if self.showItem == .editUserInfo {
            guard editUserInfoView.onFcousIndex != -1 else {
                return
            }
            if editUserInfoView.onFcousIndex == 0 {
                /*
                editUserInfoView.iconBg.backgroundColor = editUserInfoView.emojiChooseView.colors[3]
                infoView.iconBg.backgroundColor = editUserInfoView.iconBg.backgroundColor
                if var hex = editUserInfoView.iconBg.backgroundColor?.hexString as? String{
                    if hex.hasPrefix("#") == false {
                        hex = "#" + hex
                    }
                    var emojiColro = UserDefaultWrapper<String?>(key: UserDefaultKeys.saveEmojiColor)
                    emojiColro.wrappedValue = hex
                }
                 */
                editUserInfoView.emojiChooseView.emojiL.endEditing(true)
                
                return
            }
            
            if editUserInfoView.onFcousIndex == 1 {
                if editUserInfoView.secondTF.inputTF.isFirstResponder {
                    editUserInfoView.secondTF.inputTF.endEditing(true)
                }
                else{
                    editUserInfoView.secondTF.inputTF.becomeFirstResponder()
                }
                
                return
            }
            
            if editUserInfoView.onFcousIndex == 2 {
                
                if editUserInfoView.thirdTF.inputTV.isEditable == true {
                    editUserInfoView.thirdTF.inputTV.becomeFirstResponder()
                }
                else{
                    editUserInfoView.thirdTF.inputTV.endEditing(true)
                }
                return
            }
            if editUserInfoView.onFcousIndex == 3 {
                
                guard let emoji = editUserInfoView.emojiL.text else {
                    print("输入emoji")
                    return
                }
                guard editUserInfoView.secondTxt.isBlank == false  else {
                    print("输入nicname")
                    return
                }
                
                editUserInfoView.iconBg.backgroundColor = editUserInfoView.emojiChooseView.colors[3]
                infoView.iconBg.backgroundColor = editUserInfoView.iconBg.backgroundColor
                if var hex = editUserInfoView.iconBg.backgroundColor?.hexString as? String{
                    if hex.hasPrefix("#") == false {
                        hex = "#" + hex
                    }
                    var emojiColro = UserDefaultWrapper<String?>(key: UserDefaultKeys.saveEmojiColor)
                    emojiColro.wrappedValue = hex
                }
                let about = editUserInfoView.thirdTxt
               
                
                setApiUsername(bio: about, name: editUserInfoView.secondTxt, avatar: emoji) { [weak self] res in
                    guard let `self` = self else { return }
                    if res == true  {
                        self.infoView.emojiL.text = emoji
                        self.infoView.nameL.text = self.editUserInfoView.secondTxt
                        self.pressB()
                    }else{
                        print("注意:setApiUsername 错误")
                    }
                }
                return
            }
            return
        }
    }
    
    
    
    @objc func pressB(){
        onPressing = false
        self.view.endEditing(true)
        print("松开 B")
        UIView.animate(withDuration: 0.2) {[weak self] in
            guard let `self` = self else {return}
            self.backBtn.transform3D = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
        } completion: { [weak self]_ in
            guard let `self` = self else {return}
            if self.showItem == .info {
                dismissHandler()
                // 重设为第一位
                self.infoView.selectRow = 0
                self.infoView.selectSection = 0
                //self.showItem = .none
                return
            }
            if self.showItem == .editGameName {
                self.dismissEditGameNameView()
                self.showInfoView()
                self.showItem = .info
                return
            }
            
            if self.showItem == .editUserInfo {
                self.editUserInfoView.onFcousIndex = -1
                self.dismissEditUserInfoView()
                self.showInfoView()
                self.showItem = .info
                return
            }
            
//            if self.showItem == .setting {
//                self.dismissEditUserInfoView()
//                self.showInfoView()
//                self.showItem = .info
//                self.dismissSettingView()
//            }
        }
    }
    
    @objc func pressLeft(){
        guard onPressing == false else {
            print("正在按紧A或B")
            return
        }
        if self.showItem == .info {
            guard infoView.selectSection == 0 else { return }
            guard infoView.selectRow != 0 else { return }
            infoView.selectRow -= 1
            infoView.selectSection = infoView.selectSection
            return
        }
        if self.showItem == .editUserInfo {
            guard editUserInfoView.emojiChooseView.alpha == 1 else { return }
            editUserInfoView.emojiChooseView.prev()
            //editUserInfoView.iconBg.backgroundColor = editUserInfoView.emojiChooseView.colors[3]
            return
        }
    }
    
    @objc func pressRight(){
        guard onPressing == false else {
            print("正在按紧A或B")
            return
        }
        if self.showItem == .info {
            guard infoView.selectSection == 0 else { return }
            guard infoView.selectRow != 2 else { return }
            
            infoView.selectRow += 1
            infoView.selectSection = infoView.selectSection
            return
        }
        
        if self.showItem == .editUserInfo {
            guard editUserInfoView.emojiChooseView.alpha == 1  else { return }
            editUserInfoView.emojiChooseView.next()
            //editUserInfoView.iconBg.backgroundColor = editUserInfoView.emojiChooseView.colors[3]
            return
        }
    }
    
    @objc func pressUp(){
        guard onPressing == false else {
            print("正在按紧A或B")
            return
        }
        if self.showItem == .info {
            guard infoView.selectSection != 0 else { return }
            infoView.selectSection -= 1
            return
        }
        
        if self.showItem == .editUserInfo {
            guard editUserInfoView.onFcousIndex != -1 else { return }
            editUserInfoView.onFcousIndex -= 1
            if editUserInfoView.onFcousIndex < 0  {
                editUserInfoView.onFcousIndex = 0
            }
            return
        }
        
        if self.showItem == .editGameName {
            editGameNameView.prev()
            return
        }
    }
    
    @objc func pressDown(){
        guard onPressing == false else {
            print("正在按紧A或B")
            return
        }
        if self.showItem == .info {
            guard infoView.selectSection != 2 else { return }
            infoView.selectSection += 1
            return
        }
        
        if self.showItem == .editUserInfo {
            editUserInfoView.onFcousIndex += 1
            if editUserInfoView.onFcousIndex > 3 {
                editUserInfoView.onFcousIndex = 3
            }
            return
        }
        
        if self.showItem == .editGameName {
            editGameNameView.next()
            return
        }
    }
    
    @objc func pressScreenshot(){
        
    }
    
    @objc func pressHome(){
        //        if self.showItem == .none {
        //            self.showInfoView()
        //            infoView.selectRow = 0
        //            infoView.selectSection = 0
        //            self.showItem = .info
        //        }
    }
    
    func antiShakeNoti(name:String,aSelector: Selector){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(name), object: nil)
        delay(interval: AntiShakeTime) {[weak self] in
            guard let `self` = self else {return}
            NotificationCenter.default.addObserver(self, selector: aSelector, name: NSNotification.Name(name), object: nil)
        }
    }
    
    
    func findOnFcousView() -> UIView?{
        var fcous:UIView?
        if showItem == .info {
            if infoView.selectSection == 1 {
                return infoView.editBtn
            }
            else if infoView.selectSection == 2 {
                return infoView.editGameBtn
            }
            else {
                if infoView.selectRow == 0 {
                    return infoView.videoBtn
                }
                else if infoView.selectRow == 1 {
                    return infoView.imgBtn
                }
                else {
                    return infoView.setterBtn
                }
            }
        }
        
        
        if showItem == .editUserInfo {
            if editUserInfoView.onFcousIndex == 3 {
                return editUserInfoView.saveBtn
            }
        }
        
        if showItem == .editGameName {
            if editGameNameView.onFcousIndex == editGameNameView.datas.count {
                return editGameNameView.saveBtn
            }
        }
        
        return fcous
    }
}






////
////  GSUserInfoViewController.swift
////  GameSirBeyond
////
////  Created by lu on 2024/3/25.
////
//
//import UIKit
//import SnapKit
//import Then
//import RxSwift
//import Moya
//import SwiftyJSON
////import IQKeyboardManager
//enum GSUserInfoViewControllerShowItem {
//    //case none
//    case info
//    case editGameName
//    case editUserInfo
//    case setting
//}
//
//
//class GSUserInfoViewController: UIViewController {
//    
//    var showItem:GSUserInfoViewControllerShowItem = .info{
//        didSet{
//            /*
//             if showItem == .editGameName || showItem == .editUserInfo {
//             backBtn.isHidden = false
//             }else{
//             backBtn.isHidden = true
//             }
//             */
//        }
//    }
//    
//    open var dismissHandler = {() in}
//    
//    var settingView:SettingsView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        view.backgroundColor = .hex("#20242F").withAlphaComponent(0.6)
//        
//        IQKeyboardManager.shared.enableAutoToolbar = false
//        
//        view.addSubview(infoView)
//        
//        view.addSubview(editGameNameView)
//        
//        view.addSubview(editUserInfoView)
//        editUserInfoView.frame = CGRect(x: view.centerX, y: 0, width: 0, height: view.height)
//        
////        settingView = SettingsView.init(frame: CGRect(x: view.centerX, y: 0, width: 0, height: view.height))
////        settingView.alpha = 0
////        self.view.addSubview(settingView)
//        
//        view.addSubview(backBtn)
//        backBtn.snp.makeConstraints {
//            $0.right.equalToSuperview().offset(-30.widthScale)
//            $0.bottom.equalToSuperview().offset(-30.widthScale)
//            $0.width.equalTo(74.widthScale)
//            $0.height.equalTo(40.widthScale)
//        }
//        
//        backBtn.backHandler = {() in
//            NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyBPressed.rawValue), object: nil)
//        }
//        
//        showInfoView()
//        
//    }
//    
//    
//    
//    func addTectView(){
//        tectView = TectView(frame: CGRectMake(kWidth - 240, 0, 240, kHeight))
//        view.addSubview(tectView)
//        tectView.backgroundColor = .blue
//        tectView.alpha = 0.3
//    }
//    
//    func dismissInfoView(){
//        UIView.animate(withDuration: AntiShakeTime) {[weak self] in
//            guard let `self` = self else {return}
//            self.infoView.x = -self.infoView.width
//        }
//    }
//    
//    func showInfoView(){
//        
//        UIView.animate(withDuration: AntiShakeTime) {[weak self] in
//            guard let `self` = self else {return}
//            self.infoView.x = 0
//        }
//    }
//    
//    func showEditGameNameView(){
//        UIView.animate(withDuration: AntiShakeTime) {[weak self] in
//            guard let `self` = self else {return}
//            self.editGameNameView.x = 0
//            self.editGameNameView.width = kWidth
//            self.editGameNameView.alpha = 1
//        } completion: { _ in
//            
//        }
//    }
//    
//    func dismissEditGameNameView(){
//        UIView.animate(withDuration: AntiShakeTime) {[weak self] in
//            guard let `self` = self else {return}
//            self.editGameNameView.x = self.view.centerX
//            self.editGameNameView.width = 0
//            self.editGameNameView.alpha = 0
//        } completion: { _ in
//            
//        }
//    }
//    
//    func showEditUserInfoView(){
//        UIView.animate(withDuration: AntiShakeTime) {[weak self] in
//            guard let `self` = self else {return}
//            self.editUserInfoView.x = 0
//            self.editUserInfoView.width = kWidth
//            self.editUserInfoView.alpha = 1
//        } completion: { _ in
//            
//        }
//    }
//    
//    func dismissEditUserInfoView(){
//        UIView.animate(withDuration: AntiShakeTime) {[weak self] in
//            guard let `self` = self else {return}
//            self.editUserInfoView.x = self.view.centerX
//            self.editUserInfoView.width = 0
//            self.editUserInfoView.alpha = 0
//        } completion: { _ in
//            self.editUserInfoView.dismissEmojiChooseView()
//        }
//    }
//    
//    func showSettingView(){
//        UIView.animate(withDuration: AntiShakeTime) {[weak self] in
//            guard let `self` = self else {return}
//            self.settingView.x = 0
//            self.settingView.width = kWidth
//            self.settingView.alpha = 1
//        } completion: { _ in
//            
//        }
//    }
//    
//    func dismissSettingView(){
//        UIView.animate(withDuration: AntiShakeTime) {[weak self] in
//            guard let `self` = self else {return}
//            self.settingView.x = self.view.centerX
//            self.settingView.width = 0
//            self.settingView.alpha = 0
//        } completion: { _ in
//            
//        }
//    }
//    
//    lazy var editUserInfoView:GameEditUserInfoView = {
//        let view = GameEditUserInfoView().then {
//            $0.backgroundColor = .hex("#20242F")
//            $0.alpha = 0
//        }
//        return view
//    }()
//    
//    
//    lazy var editGameNameView:GameEditGameNameView = {
//        let view = GameEditGameNameView(frame: CGRectMake(0, 0, kWidth, kHeight)).then {
//            $0.backgroundColor = .hex("#20242F")
//            $0.alpha = 0
//        }
//        return view
//    }()
//    
//    
//    var backBtn:GameBackKeyBtn = {
//        let btn = GameBackKeyBtn().then {
//            $0.label.textColor = .hex("#ffffff")
//            $0.icon.image = UIImage(named: "ic-B-clear")
//            $0.btn.backgroundColor = .clear
//            $0.btn.layer.cornerRadius = 20.widthScale
//            $0.btn.layer.masksToBounds = true
//            $0.anim = true
//            //$0.backgroundColor = .hex("#000000")
//            //$0.isHidden = true
//        }
//        return btn
//    }()
//    
//    
//    var tectView:TectView!
//    
//    deinit {
//        unitNotis()
//    }
//    
//    lazy var infoView = GSUserInfoView(frame: CGRect(x: -364.widthScale, y: 0, width: 364.widthScale, height: kHeight)).then {
//        $0.selectSection = 0
//        $0.backgroundColor = .hex("#22262E").withAlphaComponent(1)
//    }
//    
//    func setApiUsername(bio:String?,name:String!,avatar:String!,x: @escaping Callback){
//        
//        let networker = MoyaProvider<UserService>()
//        networker.request(.setApiBio(bio: bio ?? "", name: name, avatar: avatar)) { [weak self] result in
//            guard let `self` = self else {return}
//            switch result {
//            case let .success(response): do {
//                let data = try? response.mapJSON()
//                let json = JSON(data!)
//                let responseData = json.dictionaryObject!
//                let code = responseData["code"] as! Int
//                if code == NetworkErrorType.NeedLogin.rawValue {
//                    NotificationCenter.default.post(name: Notification.Name("UserDidLogoutNotification"), object: nil)
//                    x(false)
//                    return
//                }
//                if code == 200 {
//                    print("设置用户信息成功")
//                    
//                    delay(interval: 0.1) {
//                        refreshUserInfo()
//                        x(true)
//                    }
//                }
//                else {
//                    //MBProgressHUD.showMsgWithtext(responseData["msg"] as! String)
//                    print("设置用户信息失败", responseData["msg"]!)
//                    x(false)
//                }
//            }
//            case .failure(_): do {
//                print("网络错误")
//                x(false)
//            }
//                break
//            }
//        }
//    }
//}
//
//// 关于手柄
//extension GSUserInfoViewController {
//    
//    public func unitNotis(){
//        NotificationCenter.default.removeObserver(self)
//    }
//    
//    public func regisNotis(){
//        
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(pressX),
//                                               name: NSNotification.Name(ControllerNotificationName.KeyXPressed.rawValue),
//                                               object: nil)
//        
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(pressY),
//                                               name: NSNotification.Name(ControllerNotificationName.KeyYPressed.rawValue),
//                                               object: nil)
//        
//        
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(pressA),
//                                               name: NSNotification.Name(ControllerNotificationName.KeyAPressed.rawValue),
//                                               object: nil)
//        
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(pressB),
//                                               name: NSNotification.Name(ControllerNotificationName.KeyBPressed.rawValue),
//                                               object: nil)
//        
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(pressLeft),
//                                               name: NSNotification.Name(ControllerNotificationName.LeftJoystickMoveLeft.rawValue),
//                                               object: nil)
//        
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(pressRight),
//                                               name: NSNotification.Name(ControllerNotificationName.LeftJoystickMoveRight.rawValue),
//                                               object: nil)
//        
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(pressUp),
//                                               name: NSNotification.Name(ControllerNotificationName.LeftJoystickMoveUp.rawValue),
//                                               object: nil)
//        
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(pressDown),
//                                               name: NSNotification.Name(ControllerNotificationName.LeftJoystickMoveDown.rawValue),
//                                               object: nil)
//        
//        
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(pressScreenshot),
//                                               name: NSNotification.Name(ControllerNotificationName.KeyScreenshotPressed.rawValue),
//                                               object: nil)
//        
//        
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(pressHome),
//                                               name: NSNotification.Name(ControllerNotificationName.KeyHomePressed.rawValue),
//                                               object: nil)
//        
//    }
//    
//    @objc func pressX(){
//        
//        
//    }
//    
//    @objc func pressY(){
//    }
//    
//    @objc func pressA(){
//        print(self.showItem)
//        print(infoView.selectRow)
//        print(infoView.selectSection)
//        if self.showItem == .info {
//            let row = infoView.selectRow
//            let section = infoView.selectSection
//            if section == 0 {
//                if row == 0 {
//                    print("进入录像")
//                }
//                else if row == 1 {
//                    print("进入图片")
//                }
//                else {
//                    print("进入设置")
////                    self.dismissInfoView()
////                    self.showSettingView()
////                    self.showItem = .setting
//                }
//            }
//            else if section == 1 {
//                self.dismissInfoView()
//                self.showEditUserInfoView()
//                self.showItem = .editUserInfo
//                print("编辑游戏别名")
//                print("编辑个人信息")
//            }
//            else {
//                self.dismissInfoView()
//                self.showEditGameNameView()
//                self.showItem = .editGameName
//                print("编辑游戏别名")
//            }
//            
//            return
//        }
//        
//        if self.showItem == .editUserInfo {
//            guard editUserInfoView.onFcousIndex != -1 else {
//                return
//            }
//            if editUserInfoView.onFcousIndex == 0 {
//                print("已选中了颜色")
//                editUserInfoView.iconBg.backgroundColor = editUserInfoView.emojiChooseView.colors[3]
//                editUserInfoView.emojiChooseView.emojiL.endEditing(true)
//                
//                return
//            }
//            
//            if editUserInfoView.onFcousIndex == 1 {
//                if editUserInfoView.secondTF.inputTF.isFirstResponder {
//                    editUserInfoView.secondTF.inputTF.endEditing(true)
//                }
//                else{
//                    editUserInfoView.secondTF.inputTF.becomeFirstResponder()
//                }
//                
//                return
//            }
//            
//            if editUserInfoView.onFcousIndex == 2 {
//                
//                if editUserInfoView.thirdTF.inputTV.isEditable == true {
//                    editUserInfoView.thirdTF.inputTV.becomeFirstResponder()
//                }
//                else{
//                    editUserInfoView.thirdTF.inputTV.endEditing(true)
//                }
//                return
//            }
//            if editUserInfoView.onFcousIndex == 3 {
//                print("保存设置")
//                let about = editUserInfoView.thirdTxt
//                guard let emoji = editUserInfoView.emojiL.text else {
//                    print("输入emoji")
//                    return
//                }
//                guard editUserInfoView.secondTxt.isBlank == false  else {
//                    print("输入nicname")
//                    return
//                }
//                
//                setApiUsername(bio: about, name: editUserInfoView.secondTxt, avatar: emoji) { [weak self] res in
//                    guard let `self` = self else { return }
//                    if res == true  {
//                        self.infoView.emojiL.text = emoji
//                        self.infoView.nameL.text = self.editUserInfoView.secondTxt
//                        self.pressB()
//                    }else{
//                        print("注意:setApiUsername 错误")
//                    }
//                }
//                return
//            }
//            return
//        }
//    }
//    
//    @objc func pressB(){
//        self.view.endEditing(true)
//        antiShakeNoti(name: ControllerNotificationName.KeyBPressed.rawValue, aSelector: #selector(pressB))
//        backBtn.runAnim()
//        if self.showItem == .info {
//            dismissHandler()
//            // 重设为第一位
//            infoView.selectRow = 0
//            infoView.selectSection = 0
//            //self.showItem = .none
//            return
//        }
//        if self.showItem == .editGameName {
//            dismissEditGameNameView()
//            showInfoView()
//            self.showItem = .info
//            return
//        }
//        
//        if self.showItem == .editUserInfo {
//            editUserInfoView.onFcousIndex = -1
//            dismissEditUserInfoView()
//            showInfoView()
//            self.showItem = .info
//            return
//        }
//        
//        if self.showItem == .setting {
//            dismissEditUserInfoView()
//            showInfoView()
//            self.showItem = .info
//            dismissSettingView()
//        }
//    }
//    
//    @objc func pressLeft(){
//        if self.showItem == .info {
//            guard infoView.selectSection == 0 else { return }
//            guard infoView.selectRow != 0 else { return }
//            infoView.selectRow -= 1
//            infoView.selectSection = infoView.selectSection
//            return
//        }
//        if self.showItem == .editUserInfo {
//            guard editUserInfoView.emojiChooseView.alpha == 1 else { return }
//            editUserInfoView.emojiChooseView.prev()
//            editUserInfoView.iconBg.backgroundColor = editUserInfoView.emojiChooseView.colors[3]
//            return
//        }
//    }
//    
//    @objc func pressRight(){
//        if self.showItem == .info {
//            guard infoView.selectSection == 0 else { return }
//            guard infoView.selectRow != 2 else { return }
//            
//            infoView.selectRow += 1
//            infoView.selectSection = infoView.selectSection
//            return
//        }
//        
//        if self.showItem == .editUserInfo {
//            guard editUserInfoView.emojiChooseView.alpha == 1  else { return }
//            editUserInfoView.emojiChooseView.next()
//            editUserInfoView.iconBg.backgroundColor = editUserInfoView.emojiChooseView.colors[3]
//            return
//        }
//    }
//    
//    @objc func pressUp(){
//        if self.showItem == .info {
//            guard infoView.selectSection != 0 else { return }
//            infoView.selectSection -= 1
//            return
//        }
//        
//        if self.showItem == .editUserInfo {
//            guard editUserInfoView.onFcousIndex != -1 else { return }
//            editUserInfoView.onFcousIndex -= 1
//            if editUserInfoView.onFcousIndex < 0  {
//                editUserInfoView.onFcousIndex = 0
//            }
//            return
//        }
//        
//        if self.showItem == .editGameName {
//            editGameNameView.prev()
//            return
//        }
//    }
//    
//    @objc func pressDown(){
//        if self.showItem == .info {
//            guard infoView.selectSection != 2 else { return }
//            infoView.selectSection += 1
//            return
//        }
//        
//        if self.showItem == .editUserInfo {
//            editUserInfoView.onFcousIndex += 1
//            if editUserInfoView.onFcousIndex > 3 {
//                editUserInfoView.onFcousIndex = 3
//            }
//            return
//        }
//        
//        if self.showItem == .editGameName {
//            editGameNameView.next()
//            return
//        }
//    }
//    
//    @objc func pressScreenshot(){
//        
//    }
//    
//    @objc func pressHome(){
//        //        if self.showItem == .none {
//        //            self.showInfoView()
//        //            infoView.selectRow = 0
//        //            infoView.selectSection = 0
//        //            self.showItem = .info
//        //        }
//    }
//    
//    func antiShakeNoti(name:String,aSelector: Selector){
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(name), object: nil)
//        delay(interval: AntiShakeTime) {[weak self] in
//            guard let `self` = self else {return}
//            NotificationCenter.default.addObserver(self, selector: aSelector, name: NSNotification.Name(name), object: nil)
//        }
//    }
//}
//
