//
//  GameKeyHomeView.swift
//  GameLoginWelcome
//
//  Created by lu on 2024/3/5.
//

import UIKit
import SnapKit
class GameKeyHomeView: UIView {
    //var handler = {(action:GameLoginWelcomeViewAction,obj:Any?) in}
    init() {
        super.init(frame: .zero)
        
        addSubview(image)
        image.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.5)
        }
        
        addSubview(titleL)
        titleL.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.5)
            $0.right.equalToSuperview()
            $0.top.equalToSuperview().offset(90)
        }
        
        addSubview(subtitleL)
        subtitleL.snp.makeConstraints {
            $0.left.equalTo(self.snp.centerX).offset(50)
            $0.right.equalToSuperview().offset(-60)
            $0.top.equalTo(titleL.snp.bottom).offset(20)
        }
        
        addSubview(applyBtn)
        applyBtn.snp.makeConstraints {
            $0.top.equalTo(subtitleL.snp.bottom).offset(20)
            $0.left.equalTo(self.snp.centerX).offset(70)
            $0.right.equalToSuperview().offset(-100)
            $0.height.equalTo(44)
        }
        
        addSubview(lateBtn)
        lateBtn.snp.makeConstraints {
            $0.left.right.height.equalTo(applyBtn)
            $0.top.equalTo(applyBtn.snp.bottom).offset(10)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleL:UILabel = {
        let label = UILabel().then {
            $0.textAlignment = .center
            $0.font = font_28(weight: .regular)
            $0.textColor = .black
            $0.text = "新用户按键引导"
        }
        return label
    }()
    
    lazy var subtitleL:UILabel = {
        let label = UILabel().then {
            $0.textAlignment = .left
            $0.font = font_14(weight: .regular)
            $0.textColor = .black
            $0.text = "请启用引导描述请启用引导描述请启用引导描\n述请启用引导描述请启用引导描述请启用引导\n描述。"
            $0.numberOfLines = 3
        }
        return label
    }()
    lazy var image:UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .orange
        return img
    }()
    
    lazy var applyBtn:UIButton = {
        let btn = UIButton().then {
            $0.backgroundColor = .black
            $0.setTitle("允许", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = font_16(weight: .regular)
            $0.layer.cornerRadius = 5
            $0.layer.masksToBounds = true
        }
        
        return btn
    }()
    
    lazy var lateBtn:UIButton = {
        let btn = UIButton().then {
            $0.backgroundColor = .black.withAlphaComponent(0.3)
            $0.setTitle("稍后处理", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = font_16(weight: .regular)
            $0.layer.cornerRadius = 5
            $0.layer.masksToBounds = true
        }
        
        return btn
    }()
}
