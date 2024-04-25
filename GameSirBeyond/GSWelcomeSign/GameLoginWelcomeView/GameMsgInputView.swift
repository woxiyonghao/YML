//
//  GameMsgInputView.swift
//  GameLoginWelcome
//
//  Created by lu on 2024/3/6.
//

import UIKit
import SnapKit
import PinCodeInputView
class GameMsgInputView: UIView {
    
    open var isAgain = false {
        didSet{
            subtitleL.textColor = isAgain ? .hex("#44DE6F"):.hex("#252525")
            subtitleL.text = isAgain ? "重新传送验证码":"输入代码验证您的账户"
        }
    }
    
    init(){
        super.init(frame: .zero)
        
        addSubview(backBtn)
        backBtn.snp.remakeConstraints {
            $0.right.equalToSuperview().offset(-30.widthScale)
            $0.bottom.equalToSuperview().offset(-30.widthScale)
            $0.width.equalTo(76.widthScale)
            $0.height.equalTo(40.widthScale)
        }
        
        addSubview(titleL)
        titleL.snp.remakeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(90.widthScale)
        }
        
        setupInputView()
        
        addSubview(subtitleL)
        subtitleL.snp.remakeConstraints {
            $0.left.equalTo(pinCodeInputView)
            $0.top.equalTo(pinCodeInputView.snp.bottom).offset(10.widthScale)
        }
    }
    
    func setupInputView(){
        // 验证码输入框
        addSubview(pinCodeInputView)
        pinCodeInputView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleL.snp.bottom).offset(20.widthScale)
            make.size.equalTo(CGSize(width: 300.widthScale, height: 40.widthScale))
        }
        pinCodeInputView.set(changeTextHandler: { [weak self] text in
            guard let `self` = self else{return}
            print("已输入验证码：", text)
            if text.count == 6 {
                self.pinCodeInputView.endEditing(true)
                NotificationCenter.default.post(name: NSNotification.Name("CommitSmsCode"), object: text)
            }
        })
        pinCodeInputView.backgroundColor = .purple
        pinCodeInputView.set(
            appearance: .init(
                itemSize: CGSize(width: 50.widthScale, height: 40.widthScale),
                font: font_28(weight: .bold),
                textColor: .black,
                backgroundColor: .white,
                cursorColor: UIColor(red: 69/255, green: 108/255, blue: 1, alpha: 1),
                cornerRadius: 0
            )
        )
        
        
        // 验证码底部的横线
        for index in 0..<6 {
            let bottomLine = UILabel.init()
            bottomLine.frame = CGRect(x: 5+CGFloat(index*50), y: 38.widthScale, width: 40.widthScale, height: 2.widthScale)
            bottomLine.backgroundColor = .lightGray
            pinCodeInputView.addSubview(bottomLine)
        }
    }
    
    let pinCodeInputView: PinCodeInputView<ItemView> = .init(
        digit: 6,
        itemSpacing: 0,
        itemFactory: {
            return ItemView()
        })
    
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
    
    lazy var titleL:UILabel = {
        let label = UILabel().then {
            $0.textAlignment = .center
            $0.font = font_32(weight: .regular)
            $0.textColor = .hex("#252525")
            $0.text = "我们已传送代码给您"
        }
        return label
    }()
    
    lazy var subtitleL:UILabel = {
        let label = UILabel().then {
            $0.textAlignment = .left
            $0.font = font_14(weight: .regular)
            $0.textColor = .hex("#252525")
            $0.text = "输入代码验证您的账户"
        }
        return label
    }()
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
