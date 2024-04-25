//
//  GameInputNameView.swift
//  GameLoginWelcome
//
//  Created by lu on 2024/3/6.
//

import UIKit
import SnapKit
class GameInputNameView: UIView {
    let nextBtnUnable = UIColor.hex("#CCCCCC")
    let nextBtnAble = UIColor.hex("#252525")
    open var nameAble = true {
        didSet {
            bottomL.text = nameAble ? "输入用户名，其他 Backbone 用户将能看到此用\n户名":"已有其他用户使用该名称"
            bottomL.textColor = nameAble ? .hex("252525"):.hex("#FA3131")
        }
    }
    init(){
        super.init(frame: .zero)
        
        addSubview(leftImg)
        leftImg.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.5)
        }
        
        addSubview(titleL)
        titleL.snp.makeConstraints {
            $0.left.equalTo(self.snp.centerX)
            $0.right.equalToSuperview().offset(0)
            $0.top.equalToSuperview().offset(124)
        }
        
        addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalTo(self.snp.centerX).offset(56)
            $0.right.equalToSuperview().offset(-56)
            $0.top.equalTo(titleL.snp.bottom).offset(78)
            $0.height.equalTo(1.5)
        }
        
        addSubview(atLabel)
        atLabel.snp.makeConstraints {
            $0.left.equalTo(line)
            $0.bottom.equalTo((line).snp.top).offset(-4)
            $0.width.equalTo(30)
        }
        
        addSubview(nextBtn)
        nextBtn.snp.makeConstraints {
            $0.right.equalTo(line)
            $0.bottom.equalTo(atLabel)
            $0.height.equalTo(32)
            $0.width.equalTo(68)
        }
        
        addSubview(bottomL)
        bottomL.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom).offset(16)
            make.left.right.equalTo(line)
        }
        
        addSubview(nameTF)
        nameTF.snp.makeConstraints { make in
            make.left.equalTo(atLabel.snp.right).offset(0)
            make.top.bottom.equalTo(atLabel)
            make.right.equalTo(nextBtn.snp.left).offset(-20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var leftImg:UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .hex("#121212")
        return img
    }()
    lazy var titleL:UILabel = {
        let label = UILabel().then {
            $0.textAlignment = .center
            $0.font = font_24(weight: .regular)
            $0.textColor = .hex("#252525")
            $0.text = "选择您的 Backbone显示名称"
        }
        return label
    }()
    
    lazy var line:UIView = {
        let view = UIView()
        view.backgroundColor = .hex("#B4B4B4")
        return view
    }()
    
    lazy var atLabel:UILabel = {
        let label = UILabel().then {
            $0.textAlignment = .left
            $0.font = font_24(weight: .regular)
            $0.textColor = .hex("#252525")
            $0.text = "@"
        }
        return label
    }()
    
    lazy var nextBtn:UIButton = {
        let btn = UIButton().then {[weak self] in
            guard let `self` = self else {return}
            $0.backgroundColor = self.nextBtnUnable
            $0.layer.cornerRadius = 8
            $0.layer.masksToBounds = true
        }
        let icon = UIImageView()
        icon.backgroundColor = .clear
        icon.image = UIImage(named: "ic-A-clear")
        btn.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.centerY.equalTo(btn)
            make.left.equalTo(btn).offset(8)
            make.size.equalTo(CGSizeMake(20, 20))
        }
        btn.addTarget(self, action: #selector(nextBtnEnterAction), for: .touchDown)
        btn.addTarget(self, action: #selector(nextBtnAction), for: .touchDragExit)
        btn.addTarget(self, action: #selector(nextBtnAction), for: .touchUpInside)
        
        let arrow = UIImageView()
        arrow.backgroundColor = .clear
        arrow.image = UIImage(named: "code_arrow")
        btn.addSubview(arrow)
        arrow.snp.makeConstraints { make in
            make.centerY.equalTo(btn)
            make.right.equalTo(btn).offset(-16.widthScale)
            make.size.equalTo(CGSizeMake(18.widthScale, 18.widthScale))
        }
        return btn
    }()
    
    @objc func nextBtnEnterAction(){
        NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyAPressIn.rawValue), object: nil)
    }
    
    @objc func nextBtnAction(){
        NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyAPressOut.rawValue), object: nil)
    }
    
    lazy var bottomL:UILabel = {
        let label = UILabel().then {
            $0.textAlignment = .left
            $0.font = font_14(weight: .regular)
            $0.textColor = .hex("#252525")
            $0.text = "输入用户名，其他 Backbone 用户将能看到此用\n户名"
            $0.numberOfLines = 2
        }
        return label
    }()
    
    lazy var nameTF:UITextField = {
        let tf = UITextField()
        tf.font = font_24(weight: .regular)
        tf.textAlignment = .left
        tf.textColor = .hex("#252525")
        tf.keyboardType = .asciiCapable
        tf.delegate = self
        tf.backgroundColor = .clear
        tf.returnKeyType = .done
        tf.addTarget(self, action: #selector(tfDidChangeValue), for: .editingChanged)
        return tf
    }()
    
    @objc func tfDidChangeValue(){
//        print("tfDidChangeValue")
        if let txt = nameTF.text {
            if txt.count == 0 {
                nextBtn.backgroundColor = nextBtnUnable
            }
            else{
                nextBtn.backgroundColor = nextBtnAble
            }
        }else{
            nextBtn.backgroundColor = nextBtnUnable
        }
    }
}

extension GameInputNameView : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("hello")
        textField.endEditing(true)
        return true
    }
    
}
