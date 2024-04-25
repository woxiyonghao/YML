//
//  GameInputEmojiView.swift
//  GameLoginWelcome
//
//  Created by lu on 2024/3/6.
//

import UIKit
import SnapKit
class GameInputEmojiView: UIView {

    init(){
        super.init(frame: .zero)
        
        addSubview(emojiBg)
        emojiBg.snp.makeConstraints {
            $0.width.height.equalTo(110.widthScale)
            $0.left.equalToSuperview().offset(72.widthScale)
            $0.centerY.equalToSuperview()
        }
        emojiBg.layer.cornerRadius = 55.widthScale
        emojiBg.layer.masksToBounds = true
        
        emojiBg.addSubview(emojiTF)
        emojiTF.snp.makeConstraints {
            //$0.left.right.top.bottom.equalToSuperview().priority(.high)
            $0.center.equalToSuperview()
            $0.height.equalTo(50).priority(.high)
            $0.width.equalTo(50).priority(.high)
        }
        
        addSubview(titleL)
        titleL.snp.makeConstraints {
            $0.bottom.equalTo(emojiBg.snp.centerY)
            $0.left.equalTo(emojiBg.snp.right).offset(40.widthScale)
        }
        
        addSubview(continueBtn)
        continueBtn.snp.makeConstraints {
            $0.left.equalTo(titleL)
            $0.width.equalTo(60.widthScale)
            $0.height.equalTo(30.widthScale)
            $0.top.equalTo(titleL.snp.bottom).offset(0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var emojiBg:UIView = {
        let view = UIView().then {
            $0.backgroundColor = .hex("#D9D9D9")
        }
        return view
    }()
    
    
    lazy var emojiTF:UITextField = {
        let tf = UITextField().then {
            $0.textAlignment = .center
            $0.font = font_44(weight: .regular)
            $0.textColor = .black
            $0.backgroundColor = .clear
            $0.text = ""
            $0.returnKeyType = .done
            $0.delegate = self
        }
        return tf
    }()
    
    lazy var titleL:UILabel = {
        let label = UILabel().then {
            $0.textAlignment = .center
            $0.font = font_32(weight: .regular)
            $0.textColor = .hex("#252525")
            $0.text = "为您的个人资料选择一个表情符号"
        }
        return label
    }()
    
    lazy var continueBtn:UIButton = {
        let btn = UIButton().then {[weak self] in
            guard let `self` = self else {return}
            $0.backgroundColor = .clear
        }
        let icon = UIImageView()
        icon.backgroundColor = .clear
        icon.image = UIImage(named: "ic-A")
        btn.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.centerY.equalTo(btn)
            make.right.equalTo(btn.snp.centerX).offset(-10)
            make.size.equalTo(CGSizeMake(20, 20))
        }
        
        let label = UILabel()
        label.text = "继续"
        label.textColor = .hex("#252525")
        label.font = font_12(weight: .regular)
        label.textAlignment = .left
        btn.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalTo(btn)
            make.left.equalTo(btn.snp.centerX)
        }
        btn.addTarget(self, action: #selector(backBtnDidClicked), for: .touchUpInside)
        return btn
    }()
    
    @objc func backBtnDidClicked(){
        NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyAPressed.rawValue),
                                        object: nil)
    }

}


extension GameInputEmojiView:UITextFieldDelegate,UIKeyInput{
   
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            textField.endEditing(true)
            return false
        }
        if string == "" {
            return true
        }
        let text = textField.text ?? ""
        return string.containsEmoji() && text.count < 1
    }
    
    var hasText: Bool {
        return true
    }
    
    func insertText(_ text: String) {}
    
    func deleteBackward() { }
    
    override var textInputMode: UITextInputMode?{
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" {
                return mode
            }
        }
        return nil
    }
}
