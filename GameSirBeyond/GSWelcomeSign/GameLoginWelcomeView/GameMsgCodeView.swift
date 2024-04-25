//
//  GameMsgCodeView.swift
//  GameLoginWelcome
//
//  Created by lu on 2024/3/5.
//

import UIKit
import SnapKit
class GameMsgCodeView: UIView {
    open var sendAgain = 0
    let codeID = "code.id"
    //var handler = {(action:GameLoginWelcomeViewAction,obj:Any?) in}
    let maxLength = 11
    var time = 60
    var canGetCode = true
    let codeBtnUnable = UIColor.hex("#CCCCCC")
    let codeBtnAble = UIColor.hex("#252525")
    
    var sendCodeCallBack:Callback = {(result:Bool) in}
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        phoneTF.endEditing(true)
    }
    init(){
        super.init(frame: .zero)
        
        addSubview(backBtn)
        backBtn.snp.remakeConstraints {
            //$0.centerX.equalToSuperview()
            $0.right.equalToSuperview().offset(-30.widthScale)
            $0.bottom.equalToSuperview().offset(-30.widthScale)
            $0.width.equalTo(80.widthScale)
            $0.height.equalTo(40.widthScale)
        }
        
        addSubview(bottomL)
        bottomL.snp.makeConstraints {
            $0.top.equalTo(self.snp.centerY).offset(10.widthScale)
            $0.centerX.equalToSuperview()
            
        }
        
        addSubview(line)
        line.snp.makeConstraints {
            $0.left.right.equalTo(bottomL)
            $0.height.equalTo(1.5)
            $0.centerY.equalToSuperview()
        }
        
        addSubview(areaL)
        areaL.snp.makeConstraints {
            $0.left.equalTo(bottomL)
            $0.bottom.equalTo(line.snp.top).offset(-10.widthScale)
        }
        
        addSubview(phoneTF)
        phoneTF.snp.makeConstraints{
            $0.left.equalTo(areaL.snp.right).offset(6.widthScale)
            $0.centerY.equalTo(areaL)
            $0.width.lessThanOrEqualTo(160.widthScale)
            $0.height.equalTo(24.widthScale)
        }
        
        addSubview(getCodeBtn)
        getCodeBtn.snp.makeConstraints {
            $0.right.equalTo(line)
            $0.centerY.equalTo(areaL)
            $0.width.equalTo(136.widthScale)
            $0.height.equalTo(30.widthScale)
        }
        
        addSubview(titleL)
        titleL.snp.makeConstraints {
            $0.left.equalTo(bottomL)
            $0.top.equalToSuperview().offset(90.widthScale)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var backBtn:GameBackKeyBtn = {
        let btn = GameBackKeyBtn().then {
            $0.label.textColor = .hex("#252525")
            $0.icon.image = UIImage(named: "ic-B")
            $0.btn.backgroundColor = .hex("#ffffff")
            $0.btn.layer.cornerRadius = 20.widthScale
            $0.btn.layer.masksToBounds = true
            $0.anim = true
        }
        return btn
    }()
    
    
    
    lazy var bottomL:UILabel = {
        let l = UILabel()
        l.textAlignment = .left
        l.textColor = .hex("#3D3D3D")
        l.font = font_14(weight: .regular)
        l.numberOfLines = 2
        l.text = "要完成账号注册，您必须通过回复上方手机号收到的短信来验证您的身份。请\n注意，可能会收取短信资费。"
        return l
    }()
    
    lazy var line:UIView = {
        let v = UIView()
        v.backgroundColor = .hex("#B4B4B4")
        return v
    }()
    
    lazy var areaL:UILabel = {
        let l = UILabel()
        l.text = "+ 86"
        l.font = font_18(weight: .regular)
        l.textAlignment = .left
        l.textColor = .hex("#252525")
        return l
    }()
    
    lazy var phoneTF:UITextField = {
        let tf = UITextField()
        tf.font = font_18(weight: .regular)
        tf.placeholder = "请输入您的手机号"
        tf.textAlignment = .left
        tf.textColor = .hex("#252525")
        tf.keyboardType = .numberPad
        tf.delegate = self
        return tf
    }()
    
    var getCodeL:UILabel!
    lazy var getCodeBtn:UIButton = {
        let btn = UIButton().then {[weak self] in
            guard let `self` = self else {return}
            $0.backgroundColor = self.codeBtnUnable
            $0.layer.cornerRadius = 8
            $0.layer.masksToBounds = true
        }
        let icon = UIImageView()
        icon.backgroundColor = .clear
        icon.image = UIImage(named: "ic-A-clear")
        btn.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.centerY.equalTo(btn)
            make.left.equalTo(btn).offset(12.widthScale)
            make.size.equalTo(CGSizeMake(20.widthScale, 20.widthScale))
        }
        
        getCodeL = UILabel()
        getCodeL.text = "发送短信"
        getCodeL.textColor = .white
        getCodeL.font = font_14(weight: .regular)
        getCodeL.textAlignment = .center
        btn.addSubview(getCodeL)
        getCodeL.snp.makeConstraints { make in
            make.centerY.equalTo(btn)
            make.left.equalTo(icon.snp.right).offset(6.widthScale)
        }
        btn.addTarget(self, action: #selector(enterSendCode), for: .touchDown)
        btn.addTarget(self, action: #selector(sendCode), for: .touchDragExit)
        btn.addTarget(self, action: #selector(sendCode), for: .touchUpInside)
        
        let arrow = UIImageView()
        arrow.backgroundColor = .clear
        arrow.image = UIImage(named: "code_arrow")
        btn.addSubview(arrow)
        arrow.snp.makeConstraints { make in
            make.centerY.equalTo(btn)
            make.right.equalTo(btn).offset(-12.widthScale)
            make.size.equalTo(CGSizeMake(18.widthScale, 18.widthScale))
        }
        return btn
    }()
    
    @objc func enterSendCode(){
        UIView.animate(withDuration: 0.15) {
            self.getCodeBtn.transform3D = CATransform3DScale(CATransform3DIdentity, Transform3DScale, Transform3DScale, Transform3DScale)
        }
    }
    
    @objc func sendCode(){
        
        UIView.animate(withDuration: 0.15) {
            self.getCodeBtn.transform3D = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
        }
        guard String.isPhoneNumber(phoneNumber: phoneTF.text ?? "") == true else {
            print("请输入正确的手机号码")
            return
        }
        
        if let str = phoneTF.text as? NSString {
            if str.length == 11 && canGetCode{
                phoneTF.endEditing(true)
                timerStart()
                sendCodeCallBack(true)
            }
        }
    }
    
    
    
    
    func timerStart(){
        TimerManger.share.cancelTaskWithId(codeID)
        let task = TimeTask.init(taskId: codeID, interval: 60) {[weak self] in
            guard let `self` = self else {return}
            self.timerCountDown()
        }
        TimerManger.share.runTask(task: task)
    }
    
    func timerCountDown(){
        if time == 0 || time < 0{
            time = 59
            TimerManger.share.cancelTaskWithId(codeID)
            getCodeBtn.backgroundColor = phoneTF.text?.count == 11 ? codeBtnAble:codeBtnUnable
            getCodeL.text = "发送短信"
            canGetCode = true
            sendAgain += 1
        }
        else{
            time -= 1
            getCodeBtn.backgroundColor = codeBtnAble
            getCodeL.text = "\(time)s重发"
            canGetCode = false
            
        }
    }
    
    lazy var titleL:UILabel = {
        let label = UILabel().then {
            $0.textAlignment = .left
            $0.font = font_24(weight: .regular)
            $0.textColor = .hex("#252525")
            $0.text = "验证您是真人 (搜寻好友)"
        }
        return label
    }()
    
    deinit{
        TimerManger.share.cancelTaskWithId(codeID)
    }
}

extension GameMsgCodeView : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        if count < maxLength {
            getCodeBtn.backgroundColor = codeBtnUnable
        }
        else{
            getCodeBtn.backgroundColor = codeBtnAble
        }
        return count <= maxLength
    }
}



