//
//  GSSetterEditInfoViewController.swift
//  GameSirBeyond
//
//  Created by lu on 2024/4/11.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import Moya
import SwiftyJSON
class GSSetterEditInfoViewController: UIViewController {
    var onPressing = false
    var dismiss = {() in}
    var onFcousIndex:Int = -1{
        didSet{
            onFcousIndex == 0 ? showEmojiChooseView():dismissEmojiChooseView()
            
            if onFcousIndex == 1 {
                secondTF.inputTF.becomeFirstResponder()
            }
            else{
                secondTF.inputTF.endEditing(true)
            }
            if onFcousIndex == 2 {
                thirdTF.inputTV.becomeFirstResponder()
            }
            else{
                thirdTF.inputTV.endEditing(true)
                
            }
            saveBtn.setTitleColor(onFcousIndex == 3 ? .hex("#252525"):.hex("#CCCCCC"), for: .normal)
            saveBtn.backgroundColor = onFcousIndex == 3 ? .hex("#ffffff"):.hex("#3D3D3D")
            
            if onFcousIndex == 3 {
                UIView.animate(withDuration: 0.2) {[unowned self] in
                    self.saveBtn.frame = CGRectMake((size.width - tabW) * 0.5, CGRectGetMaxY(thirdTF.frame) + 24.widthScale, tabW , 42.widthScale)
                }
            }
            else{
                UIView.animate(withDuration: 0.2) {[unowned self] in
                    self.saveBtn.frame = CGRectMake((size.width - tabW + 16.widthScale) * 0.5, CGRectGetMaxY(thirdTF.frame) + 24.widthScale, tabW - 8.widthScale, 42.widthScale)
                }
                
            }
        }
    }
    fileprivate let tabW:CGFloat =  284.widthScale
    fileprivate let disposeBag = DisposeBag()
    fileprivate var size = CGSize(width: 0, height: 0)
    var firstTxt:String = getUserInfo()["nicname"] as? String ?? ""
    var secondTxt:String  = getUserInfo()["username"] as? String ?? ""
    var thirdTxt:String = getUserInfo()["bio"] as? String ?? ""
    var inputTFDefineH:CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .hex("#20242F")
        view.layer.cornerRadius = 8.widthScale
        view.layer.masksToBounds = true
        
        view.addSubview(scr)
        scr.addSubview(tabHeader)
        scr.addSubview(firstTF)
        scr.addSubview(secondTF)
        scr.addSubview(thirdTF)
        scr.addSubview(saveBtn)
        
        /// 名字不能改
        firstTF.inputTF.isUserInteractionEnabled = false
        let signName = getNickname()
        firstTF.inputTF.text = signName
        //TODO: 获取登录的用户名【apple ， google】
        firstTF.inputTF.rx.text.orEmpty.subscribe(onNext: {[weak self] in
            guard let `self` = self else { return  }
            print("inputTF 您输入的值是:\($0)")
            self.firstTxt = $0
        }).disposed(by: disposeBag)
        
        secondTF.topL.text = "用户名"
        secondTF.inputTF.text = getUsername()
        secondTF.inputTF.rx.text.orEmpty.subscribe(onNext: {_ in
           
        }).disposed(by: disposeBag)
        
        // 去除所有的\n
        secondTF.inputTF.rx.controlEvent([.editingDidEnd]).subscribe { [weak self] _ in
            guard let `self` = self  else {return}
            self.secondTF.inputTF.text = self.secondTF.inputTF.text?.replacingOccurrences(of: "\n", with: "")
            self.secondTxt = self.secondTF.inputTF.text ?? ""
        }.disposed(by: disposeBag)
        
        thirdTF.topL.text = "关于您"
        if let bio = getUserInfo()["bio"] as? String {
            thirdTF.inputTV.text = bio
        }
        
        thirdTF.inputTV.rx.text.orEmpty.subscribe(onNext: {[weak self] in
            guard let `self` = self else { return  }
            print("编辑中")
            
            // 去除所有的\n
            if $0.last == "\n" {
                self.thirdTF.inputTV.endEditing(true)
                self.thirdTF.inputTV.text = $0.replacingOccurrences(of: "\n", with: "")
                self.thirdTxt = self.thirdTF.inputTV.text
                return
            }
            
            if $0.count > 100 {
                let selectedRange = self.thirdTF.inputTV.markedTextRange
                //没有在拼写状态再判断
                if selectedRange == nil {
                    //通过字符串截取实现限制100字符长度
                    self.thirdTF.inputTV.text = ($0 as NSString).substring(to: 100)
                }
            }
            // 预设textView的大小，宽度设为固定宽度，高度设为CGFloat的最大值
            let presetSize = CGSize(width: self.thirdTF.inputTV.frame.size.width, height: CGFloat.greatestFiniteMagnitude)
            // 重新计算textView的大小
            let newSize =  self.thirdTF.inputTV.sizeThatFits(presetSize)
            let tfFrame = CGRectMake(self.thirdTF.inputTV.frame.origin.x, self.thirdTF.inputTV.frame.origin.y, self.thirdTF.inputTV.frame.width, newSize.height)
            if tfFrame.height > self.inputTFDefineH {
                let h = tfFrame.height - self.thirdTF.inputTV.frame.height
                self.thirdTF.frame = CGRectMake(self.thirdTF.frame.origin.x, self.thirdTF.frame.origin.y, self.thirdTF.frame.width, self.thirdTF.frame.height + h)
                self.saveBtn.frame = CGRectMake((self.size.width - tabW + 16.widthScale) * 0.5, CGRectGetMaxY(self.thirdTF.frame) + 24.widthScale, tabW - 8.widthScale, 42.widthScale)
            }
            else{
                self.thirdTF.frame = CGRectMake((self.size.width - tabW) * 0.5, CGRectGetMaxY(secondTF.frame), tabW, 75.widthScale)
                self.saveBtn.frame = CGRectMake((self.size.width - tabW + 16.widthScale) * 0.5, CGRectGetMaxY(self.thirdTF.frame) + 24.widthScale, tabW - 8.widthScale, 42.widthScale)
            }
            self.thirdTF.limitL.text = "\($0.count)/100"
            self.scrSetContentSize()
        }).disposed(by: disposeBag)
       
        updataFrame()
        scrSetContentSize()
        regisNotisWithoutPressB()
    }
    
    func updataFrame(){
        scr.frame = CGRectMake(0, 0, size.width, size.height)
        tabHeader.frame = CGRectMake(0, 0, size.width, 102.widthScale - 16.widthScale)
        iconBg.frame = CGRectMake(tabHeader.width * 0.5 - 56.widthScale * 0.5, 24.widthScale, 56.widthScale, 56.widthScale)
        emojiL.frame = iconBg.bounds
        firstTF.frame = CGRectMake((size.width - tabW) * 0.5, CGRectGetMaxY(tabHeader.frame), tabW, 75.widthScale)
        secondTF.frame = CGRectMake((size.width - tabW) * 0.5, CGRectGetMaxY(firstTF.frame), tabW, 75.widthScale)
        thirdTF.frame = CGRectMake((size.width - tabW) * 0.5, CGRectGetMaxY(secondTF.frame), tabW, 75.widthScale)
        
        saveBtn.frame = CGRectMake((size.width - tabW + 16.widthScale) * 0.5, CGRectGetMaxY(thirdTF.frame) + 24.widthScale, tabW - 8.widthScale, 42.widthScale)
    }
    
    func scrSetContentSize(){
        let bottom = CGRectGetMaxY(saveBtn.frame)
        scr.contentSize = CGSizeMake(0, bottom + 40.widthScale)
    }
    
    init(viewSize:CGSize){
        self.size = viewSize
        super.init(nibName: nil, bundle: nil)
    }
    
    lazy var scr:UIScrollView = {
        let s = UIScrollView()
        s.showsHorizontalScrollIndicator = false
        s.showsVerticalScrollIndicator = false
        return s
    }()
    
    lazy var tabHeader:UIView = {
        // 202 - 16
        let view = UIView()
        view.backgroundColor = .clear
        
        view.addSubview(iconBg)
        iconBg.layer.cornerRadius = 28.widthScale
        iconBg.layer.masksToBounds = true
        iconBg.addSubview(emojiL)
        
        emojiChooseView = GSEmojiBGChooseView(frame: CGRectMake(0, 0, size.width, 102.widthScale - 16.widthScale))
        emojiChooseView.sortColors(color: iconBg.backgroundColor!)
        emojiChooseView.alpha = 0
        emojiChooseView.emojiL.text = emojiL.text
        view.addSubview(emojiChooseView)
        emojiChooseView.tfChangeHandler = {[weak self](str:String) in
            guard let `self` = self else {return}
            self.emojiL.text = str
        }
        return view
    }()
    
    lazy var emojiL:UILabel = {
        let l = UILabel()
        l.backgroundColor = .clear
        l.textAlignment = .center
        l.text = getUserEmojiString()
        l.font = font_44(weight: .regular)
        return l
    }()
    lazy var iconBg:UIView = {
        let view = UIView()
        var emojiColro = UserDefaultWrapper<String?>(key: UserDefaultKeys.saveEmojiColor)
        if emojiColro.wrappedValue == nil {
            emojiColro.wrappedValue = "#ADED5C"
        }
        view.backgroundColor = .hex(emojiColro.wrappedValue!)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(iconBgAction)))
        return view
    }()
    var emojiChooseView:GSEmojiBGChooseView!
    @objc open func iconBgAction(){
        onFcousIndex = 0
    }
    @objc open func showEmojiChooseView(){
        UIView.animate(withDuration: 0.15) {
            self.iconBg.alpha = 0
            self.emojiL.alpha = 0
            self.emojiChooseView.alpha = 1
        }
        emojiChooseView.emojiL.becomeFirstResponder()
    }
    
    @objc open func dismissEmojiChooseView(){
        UIView.animate(withDuration: 0.15) {
            self.iconBg.alpha = 1
            self.emojiL.alpha = 1
            self.emojiChooseView.alpha = 0
        }
        emojiChooseView.emojiL.endEditing(true)
    }
    lazy var firstTF:GameEditWithInputField = {
        let tf = GameEditWithInputField()
        tf.backgroundColor = .clear
        return tf
    }()
    
    lazy var secondTF:GameEditWithInputField = {
        let tf = GameEditWithInputField()
        tf.backgroundColor = .clear
        return tf
    }()
    
    lazy var thirdTF:GameEditWithInputView = {
        let tf = GameEditWithInputView()
        tf.backgroundColor = .clear
        return tf
    }()
    
    lazy var saveBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("保存设置", for: .normal)
        btn.setTitleColor(.hex("#CCCCCC"), for: .normal)
        btn.titleLabel?.font = font_14(weight: .bold)
        btn.layer.cornerRadius = 8
        btn.layer.masksToBounds = true
        btn.backgroundColor = .hex("#3D3D3D")
        btn.addTarget(self, action: #selector(saveBtnAction), for: .touchUpInside)
        return btn
    }()
    
    @objc open func saveBtnAction(){
        print("saveBtnAction")
        if onFcousIndex == 3 {
            guard let emoji = emojiL.text else {
                print("输入emoji")
                return
            }
            guard secondTxt.isBlank == false  else {
                print("输入nicname")
                return
            }
            
            iconBg.backgroundColor = emojiChooseView.colors[3]
            if var hex = iconBg.backgroundColor?.hexString as? String{
                if hex.hasPrefix("#") == false {
                    hex = "#" + hex
                }
                var emojiColro = UserDefaultWrapper<String?>(key: UserDefaultKeys.saveEmojiColor)
                emojiColro.wrappedValue = hex
            }
            let about = thirdTxt
           
            setApiUsername(bio: about, name: secondTxt, avatar: emoji) { [weak self] res in
                guard let `self` = self else { return }
                if res == true  {
                    self.emojiL.text = emoji
                    self.dismiss()
                }else{
                    print("注意:setApiUsername 错误")
                }
            }
        }
        else{
            onFcousIndex = 3
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    deinit{
        unitNotis()
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
extension GSSetterEditInfoViewController {
    
    public func unitNotis(){
        NotificationCenter.default.removeObserver(self)
    }
 
    public func regisNotisWithoutPressB(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onPressingA),
                                               name: NSNotification.Name(ControllerNotificationName.KeyAPressIn.rawValue),
                                               object: nil)
        
     
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressAOut),
                                               name: NSNotification.Name(ControllerNotificationName.KeyAPressOut.rawValue),
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
                                               selector: #selector(pressLeft),
                                               name: NSNotification.Name(ControllerNotificationName.LeftJoystickMoveLeft.rawValue),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressRight),
                                               name: NSNotification.Name(ControllerNotificationName.LeftJoystickMoveRight.rawValue),
                                               object: nil)
        
    }
  
    @objc func pressLeft(){
        guard onFcousIndex == 0 else {
            return
        }
        emojiChooseView.prev()
    }
    @objc func pressRight(){
        guard onFcousIndex == 0 else {
            return
        }
        emojiChooseView.next()
    }
    
    @objc func onPressingA(){
        onPressing = true
        
        if onFcousIndex == 3 {
            UIView.animate(withDuration: 0.15) {[weak self] in
                guard let `self` = self else {return}
                self.saveBtn.transform3D = CATransform3DScale(CATransform3DIdentity, Transform3DScale, Transform3DScale, Transform3DScale)
            }
            return
        }
    }
 
    @objc func pressAOut(){
        onPressing = false
        if onFcousIndex == 3 {
            UIView.animate(withDuration: 0.15) {[weak self] in
                guard let `self` = self else {return}
                self.saveBtn.transform3D = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
                
            } completion: { _ in
                self.saveBtnAction()
            }
            return
        }
        
        if onFcousIndex == -1 {
            onFcousIndex = 0
            return
        }
        
        if onFcousIndex == 0 {
            iconBg.backgroundColor = emojiChooseView.colors[3]
            emojiChooseView.emojiL.endEditing(true)
            return
        }
        
        if onFcousIndex == 1 {
            secondTF.inputTF.endEditing(true)
            return
        }
        
        if onFcousIndex == 2 {
            thirdTF.inputTV.endEditing(true)
            return
        }
    }
    
    @objc func pressUp(){
        guard onPressing == false else {
            print("正在按紧A/B键")
            return
        }
        if onFcousIndex == 0 || onFcousIndex == -1{
            return
        }
        onFcousIndex -= 1
    }
    
    @objc func pressDown(){
        guard onPressing == false else {
            print("正在按紧A/B键")
            return
        }
        if onFcousIndex == 3{
            return
        }
        onFcousIndex += 1
    }
    
}
