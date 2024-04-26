//
//  GameLoginView.swift
//  GameLoginWelcome
//
//  Created by lu on 2024/3/4.
//

import UIKit
import SnapKit
import YYText
class GameLoginView: UIView {
    
    open var onFocusIdx = 0
    
    open var fade = false {
        didSet{
            if fade {
                appleLoginBtn.setTitle("以\(getNickname())的身份继续", for: .normal)
                googleLoginBtn.setTitle("这不是我", for: .normal)
                appleLogo.isHidden = true
                googleLogo.isHidden = true
                emojiL.isHidden = false
                emojiL.text = getAvatarPath()
            }
            else{
                appleLoginBtn.setTitle("使用Apple账号登录", for: .normal)
                googleLoginBtn.setTitle("使用Goole账号登录", for: .normal)
                appleLogo.isHidden = false
                googleLogo.isHidden = false
                emojiL.isHidden = true
            }
        }
    }
    
    var handler = {(action:GameLoginWelcomeViewAction,obj:Any?) in}
    var idx = 0
    init(index:Int){
        super.init(frame: .zero)
        idx = index
        // 由于外部是init的，如果不是init，则需要重新写ui的显示隐藏
        idx == 0 ? initWelcomeUI():initLoginUI()
        
        delay(interval: 0.25) {[weak self] in
            guard let `self` = self else {return}
            self.idx == 0 ? nil : self.setFocusBtn(idx: 0)
        }
        
    }
    
    
    func initLoginUI(){
        
        addSubview(projectImage)
        projectImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(75.widthScale).priority(.high)
            $0.bottom.equalToSuperview().offset(-75.widthScale).priority(.high)
            $0.left.equalToSuperview().offset(30.widthScale).priority(.high)
            $0.right.equalTo(self.snp.centerX)
        }
        addSubview(welcomeLabel)
        welcomeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(70.widthScale)
            $0.left.equalTo(self.snp.centerX)
            $0.right.equalToSuperview()
        }
        
        addSubview(passAView)
        passAView.snp.makeConstraints {
            $0.top.equalTo(welcomeLabel.snp.bottom).offset(10.widthScale)
            $0.left.equalTo(self.snp.centerX)
            $0.right.equalToSuperview()
            $0.height.equalTo(24.widthScale)
        }
        
        addSubview(appleLoginBtn)
        appleLoginBtn.snp.makeConstraints {
            $0.height.equalTo(login_btn_h)
            $0.width.equalTo(login_btn_blur_w)
            $0.centerX.equalTo(welcomeLabel)
            $0.top.equalTo(passAView.snp.bottom).offset(10.widthScale)
        }
        
        addSubview(googleLoginBtn)
        googleLoginBtn.snp.makeConstraints {
            $0.height.equalTo(login_btn_h)
            $0.width.equalTo(login_btn_blur_w)
            $0.centerX.equalTo(welcomeLabel)
            $0.top.equalTo(appleLoginBtn.snp.bottom).offset(10.widthScale)
        }
        
        addSubview(problemLabel)
        problemLabel.snp.makeConstraints {
            $0.left.right.equalTo(welcomeLabel)
            $0.top.equalTo(googleLoginBtn.snp.bottom).offset(10.widthScale)
        }
        
        addSubview(tipLabel)
        tipLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-30.widthScale)
        }
        
        passALeftL.text = "全新一代手游设备触手可及。"
        passALeftL.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        passALeftL.textAlignment = .center
        passALeftL.textColor = .hex("#3D3D3D")
    }
    
    func initWelcomeUI(){
        
        
        addSubview(projectImage)
        projectImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(75.widthScale).priority(.high)
            $0.bottom.equalToSuperview().offset(-75.widthScale).priority(.high)
            $0.left.equalToSuperview().offset(30.widthScale)
            $0.right.equalTo(self.snp.centerX)
        }
        
        addSubview(welcomeLabel)
        welcomeLabel.snp.remakeConstraints {
            $0.bottom.equalTo(self.snp.centerY).offset(-20.widthScale)
            $0.left.equalTo(self.snp.centerX)
            $0.right.equalToSuperview()
        }
        
        addSubview(passAView)
        passAView.snp.remakeConstraints {
            $0.top.equalTo(self.snp.centerY).offset(0)
            $0.left.equalTo(self.snp.centerX)
            $0.right.equalToSuperview()
            $0.height.equalTo(24.widthScale)
        }
        
        passAIcon.image = UIImage(named: "ic-A")
        passAIcon.snp.makeConstraints {
            $0.width.height.equalTo(20.widthScale)
            $0.center.equalToSuperview()
        }
        passAIcon.isHidden = false
        
        passALeftL.text = "按"
        passALeftL.snp.makeConstraints {
            $0.right.equalTo(passAIcon.snp.left).offset(-2.widthScale)
            $0.centerY.equalToSuperview()
        }
        passALeftL.textAlignment = .right
        
        passARightL.text = "继续"
        passARightL.snp.makeConstraints {
            $0.left.equalTo(passAIcon.snp.right).offset(2.widthScale)
            $0.centerY.equalToSuperview()
        }
        passARightL.isHidden = false
        passARightL.textAlignment = .left
    }
    
    open func setFocusBtn(idx:Int){
        
        defer{onFocusIdx = idx}
        
        setNeedsLayout()
        if idx == 0 {
            appleLoginBtn.snp.remakeConstraints {
                $0.height.equalTo(login_btn_h)
                $0.width.equalTo(login_btn_focus_w).priority(.high)
                $0.centerX.equalTo(welcomeLabel)
                $0.top.equalTo(passAView.snp.bottom).offset(10.widthScale)
            }
            
            googleLoginBtn.snp.makeConstraints {
                $0.height.equalTo(login_btn_h)
                $0.width.equalTo(login_btn_blur_w).priority(.high)
                $0.centerX.equalTo(welcomeLabel)
                $0.top.equalTo(appleLoginBtn.snp.bottom).offset(10.widthScale)
            }
            
            appleA.isHidden = false
            googleA.isHidden = true
            
            appleLogo.isHidden = fade
            googleLogo.isHidden = fade
            
            appleLogo.image = UIImage(named: "apple_login_white")
            googleLogo.image = UIImage(named: "google_logo_black")
            
            appleLoginBtn.setTitleColor(.hex("#ffffff"), for: .normal)
            appleLoginBtn.backgroundColor = .hex("#252525")
            
            googleLoginBtn.setTitleColor(.hex("#252525"), for: .normal)
            googleLoginBtn.backgroundColor = .hex("#E4E4E4")
            
        }
        else {
            appleLoginBtn.snp.remakeConstraints {
                $0.height.equalTo(login_btn_h)
                $0.width.equalTo(login_btn_blur_w).priority(.high)
                $0.centerX.equalTo(welcomeLabel)
                $0.top.equalTo(passAView.snp.bottom).offset(10.widthScale)
            }
            
            googleLoginBtn.snp.remakeConstraints {
                $0.height.equalTo(login_btn_h)
                $0.width.equalTo(login_btn_focus_w).priority(.high)
                $0.centerX.equalTo(welcomeLabel)
                $0.top.equalTo(appleLoginBtn.snp.bottom).offset(10.widthScale)
            }
            
            appleA.isHidden = true
            googleA.isHidden = false
            
            appleLogo.isHidden = fade
            googleLogo.isHidden = fade
            
            appleLogo.image = UIImage(named: "apple_logo_black")
            googleLogo.image = UIImage(named: "google_logo_white")
            
            appleLoginBtn.setTitleColor(.hex("#252525"), for: .normal)
            appleLoginBtn.backgroundColor = .hex("#E4E4E4")
            
            googleLoginBtn.setTitleColor(.hex("#ffffff"), for: .normal)
            googleLoginBtn.backgroundColor = .hex("#252525")
            
        }
        UIView.animate(withDuration: 0.15) {[weak self] in
            guard let `self` = self else {return}
            self.layoutIfNeeded()
        }
    }
    
    
    lazy var projectImage:UIImageView = {
        let img = UIImageView().then {
            $0.backgroundColor = .clear
            $0.image = UIImage(named: "home_page_0")
        }
        return img
    }()
    
    lazy var welcomeLabel:UILabel = {
        let label = UILabel().then {
            $0.text = "欢迎来到 Backbone"
            $0.textAlignment = .center
            $0.font = font_28(weight: .regular)
            $0.textColor = .hex("#252525")
        }
        return label
    }()
    
    lazy var passAView:UIView = {
        let view = UIView().then {
            $0.backgroundColor = .clear
        }
        passALeftL = UILabel().then({
            $0.textColor = .hex("#999999")
            $0.font = font_16(weight: .regular)
        })
        passAIcon = UIImageView()
        passARightL = UILabel().then({
            $0.textColor = .hex("#999999")
            $0.font = font_16(weight: .regular)
        })
        view.addSubview(passALeftL)
        view.addSubview(passAIcon)
        view.addSubview(passARightL)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(passAViewTap)))
        return view
    }()
    
    @objc func passAViewTap(){
        print("999999")
        NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyAPressOut.rawValue), object: nil)
        
    }
    
    var passALeftL:UILabel!
    var passAIcon:UIImageView!
    var passARightL:UILabel!
    
    // 需替代成系统的
    lazy var appleLoginBtn:UIButton = {
        let btn = UIButton().then { [weak self] in
            guard let `self` = self else {return}
            $0.setTitle("使用Apple账号登录", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = font_14(weight: .regular)
            $0.backgroundColor = .hex("#252525")
            $0.layer.cornerRadius = 8.widthScale
            $0.layer.masksToBounds = true
            $0.addTarget(self, action: #selector(appleEnterAction), for: .touchDown)
            $0.addTarget(self, action: #selector(appleAction), for: .touchDragExit)
            $0.addTarget(self, action: #selector(appleAction), for: .touchUpInside)
        }
        appleA = UIImageView()
        appleA.backgroundColor = .clear
        appleA.isHidden = true
        appleA.image = UIImage(named: "ic-A-clear")
        btn.addSubview(appleA)
        appleA.snp.makeConstraints { make in
            make.width.height.equalTo(20.widthScale)
            make.right.equalToSuperview().offset(-24.widthScale)
            make.centerY.equalToSuperview()
        }
        
        appleLogo = UIImageView()
        appleLogo.backgroundColor = .clear
        appleLogo.image = UIImage(named: "apple_login_white")
        btn.addSubview(appleLogo)
        appleLogo.snp.makeConstraints { make in
            make.width.height.equalTo(20.widthScale)
            make.left.equalToSuperview().offset(24.widthScale)
            make.centerY.equalToSuperview()
        }
        
        emojiL = UILabel()
        emojiL.backgroundColor = .hex("#D9D9D9")
        emojiL.textAlignment = .center
        emojiL.font = font_14()
        btn.addSubview(emojiL)
        emojiL.snp.makeConstraints { make in
            make.width.height.equalTo(24.widthScale)
            make.left.equalToSuperview().offset(24.widthScale)
            make.centerY.equalToSuperview()
        }
        emojiL.layer.cornerRadius = 12.widthScale
        emojiL.layer.masksToBounds = true
        emojiL.isHidden = true
        return btn
    }()
    
    var appleLogo:UIImageView!
    var appleA:UIImageView!
    var emojiL:UILabel!
    
    @objc func appleEnterAction(){
        self.setNeedsLayout()
        appleLoginBtn.snp.remakeConstraints {
            $0.height.equalTo(login_btn_h)
            $0.width.equalTo(login_btn_blur_w).priority(.high)
            $0.centerX.equalTo(welcomeLabel)
            $0.top.equalTo(passAView.snp.bottom).offset(10.widthScale)
        }
        UIView.animate(withDuration: 0.15) {
            self.layoutIfNeeded()
        }
    }
    
    @objc func appleAction(){
        self.setNeedsLayout()
        guard onFocusIdx == 0 else {
            setFocusBtn(idx: 0)
            return
        }
        
        if fade {
            NotificationCenter.default.post(name: NSNotification.Name("SureToSign"), object: nil)
            return
        }
        NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyAPressOut.rawValue), object: nil)
    }
    
    lazy var googleLoginBtn:UIButton = {
        let btn = UIButton().then { [weak self] in
            guard let `self` = self else {return}
            $0.setTitle("使用Goole账号登录", for: .normal)
            $0.setTitleColor(.hex("#252525"), for: .normal)
            $0.titleLabel?.font = font_14(weight: .regular)
            $0.backgroundColor = .hex("#E4E4E4")
            $0.layer.cornerRadius = 8.widthScale
            $0.layer.masksToBounds = true
            $0.addTarget(self, action: #selector(googleEnterAction), for: .touchDown)
            $0.addTarget(self, action: #selector(googleAction), for: .touchDragExit)
            $0.addTarget(self, action: #selector(googleAction), for: .touchUpInside)
        }
        
        googleA = UIImageView()
        googleA.backgroundColor = .clear
        googleA.isHidden = true
        googleA.image = UIImage(named: "ic-A-clear")
        btn.addSubview(googleA)
        googleA.snp.makeConstraints { make in
            make.width.height.equalTo(20.widthScale)
            make.right.equalToSuperview().offset(-24.widthScale)
            make.centerY.equalToSuperview()
        }
        
        
        
        googleLogo = UIImageView()
        googleLogo.backgroundColor = .clear
        googleLogo.image = UIImage(named: "google_logo_black")
        btn.addSubview(googleLogo)
        googleLogo.snp.makeConstraints { make in
            make.width.height.equalTo(20.widthScale)
            make.left.equalToSuperview().offset(24.widthScale)
            make.centerY.equalToSuperview()
        }
        
        
        return btn
    }()
    var googleLogo:UIImageView!
    var googleA:UIImageView!
    
    @objc func googleEnterAction(){
        self.setNeedsLayout()
        googleLoginBtn.snp.makeConstraints {
            $0.height.equalTo(login_btn_h)
            $0.width.equalTo(login_btn_blur_w)
            $0.centerX.equalTo(welcomeLabel)
            $0.top.equalTo(appleLoginBtn.snp.bottom).offset(10.widthScale)
        }
        UIView.animate(withDuration: 0.15) {
            self.layoutIfNeeded()
        }
    }
    
    @objc func googleAction(){
        guard onFocusIdx == 1 else {
            setFocusBtn(idx: 1)
            return
        }
        if fade == true  {
            // 这不是我，移除用户信息。重设
            removeUserInfo()
            fade = false
            return
        }
        NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyAPressOut.rawValue), object: nil)
    }
    
    lazy var problemLabel:YYLabel = {
        let label = YYLabel().then {[weak self] in
            guard let `self` = self else {return}
            $0.isUserInteractionEnabled = true
            let str:NSString = "遇到问题了吗? 点击这里提交反馈"
            let text = NSMutableAttributedString.init(string: str as String)
            text.addAttribute(NSAttributedString.Key.font, value: font_12(weight: .regular), range: NSMakeRange(0, str.length))
            text.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.hex("#999999"), range: str.range(of: "遇到问题了吗? "))
            text.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.hex("#FF7553"), range: str.range(of: "点击这里提交反馈"))
            text.yy_setTextHighlight(str.range(of: "点击这里提交反馈"), color: UIColor.hex("#FF7553"), backgroundColor: .clear) { [weak self] _, _, _, _ in
                //print("点击这里提交反馈")
                guard let `self` = self else {return}
                self.handler(.onCommitLoginIssue,nil)
            }
            // NSMutableAttributedString 字体居中
            let para = NSMutableParagraphStyle()
            para.alignment = .center
            text.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, str.length))
            $0.attributedText = text
        }
        
        return label
    }()
    
    lazy var tipLabel:YYLabel = {
        let label = YYLabel().then {[weak self] in
            guard let `self` = self else {return}
            $0.numberOfLines = 2
            let str:NSString = "通过注册并创建账户，您统一遵循我们的条款与条件并理解收集的\n信息将按照个人信息收集通知和隐私政策中的描述来使用"
            let tag0 = "条款与条件"
            let tag1 = "个人信息收集通知"
            let tag2 = "隐私政策中"
            $0.isUserInteractionEnabled = true
            let text = NSMutableAttributedString.init(string: str as String)
            text.addAttribute(NSAttributedString.Key.font, value: font_12(weight: .regular), range: NSMakeRange(0, str.length))
            text.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.hex("#999999"), range: NSMakeRange(0, str.length))
            text.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.hex("#FF7553"), range: str.range(of: tag0))
            text.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.hex("#FF7553"), range: str.range(of: tag1))
            text.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.hex("#FF7553"), range: str.range(of: tag2))
            text.yy_setTextHighlight(str.range(of: tag0), color: .orange, backgroundColor: .clear) {[weak self] _, attr, _, _ in
                //print("\(tag0)")
                guard let `self` = self else {return}
                self.handler(.onOrdinance,nil)
            }
            text.yy_setTextHighlight(str.range(of: tag1), color: .orange, backgroundColor: .clear) {[weak self] _, attr, _, _ in
                //print("\(tag1)")
                guard let `self` = self else {return}
                self.handler(.onCollect,nil)
            }
            text.yy_setTextHighlight(str.range(of: tag2), color: .orange, backgroundColor: .clear) {[weak self] _, attr, _, rang in
                //print("\(tag2)")
                guard let `self` = self else {return}
                self.handler(.onPrivacy,nil)
            }
            
            // NSMutableAttributedString 字体居中
            let para = NSMutableParagraphStyle()
            para.alignment = .center
            text.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, str.length))
            $0.attributedText = text
        }
        
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
