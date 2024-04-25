//
//  GameShellTwoView.swift
//  GameLoginWelcome
//
//  Created by lu on 2024/3/8.
//

import UIKit
import SnapKit
import Then
class GameShellTwoView: UIView {
    
    init(){
        super.init(frame: .zero)
        addSubview(icon)
        icon.snp.makeConstraints {
            $0.right.top.bottom.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.5)
        }
        
        addSubview(titleL)
        titleL.snp.makeConstraints {
            $0.left.equalToSuperview().offset(52.widthScale)
            $0.right.equalTo(self.snp.centerX).offset(-52.widthScale)
            $0.top.equalToSuperview().offset(88.widthScale)
        }
        
        addSubview(applyBtn)
        applyBtn.snp.makeConstraints {
            $0.left.equalTo(titleL)
            $0.right.equalTo(self.snp.centerX).offset(-80.widthScale)
            $0.top.equalTo(titleL.snp.bottom).offset(32.widthScale)
            $0.height.equalTo(44.widthScale)
        }
        addSubview(subtitleL)
        subtitleL.snp.makeConstraints {
            $0.left.equalTo(titleL)
            $0.right.equalTo(self.snp.centerX).offset(0.widthScale)
            $0.top.equalTo(applyBtn.snp.bottom).offset(32.widthScale)
        }
        addSubview(backBtn)
        backBtn.snp.remakeConstraints {
            $0.right.equalToSuperview().offset(-30.widthScale)
            $0.bottom.equalToSuperview().offset(-30.widthScale)
            $0.width.equalTo(76.widthScale)
            $0.height.equalTo(40.widthScale)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var icon:UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .orange
        return img
    }()
    lazy var titleL:UILabel = {
        let label = UILabel().then {
            $0.textAlignment = .left
            $0.font = font_24(weight: .semibold)
            $0.textColor = .hex("#ffffff")
            $0.text = "在 Backbone App 中找到支持\n该游戏手柄的最好的游戏"
            $0.numberOfLines = 2
        }
        return label
    }()
    lazy var subtitleL:UILabel = {
        let label = UILabel().then {
            $0.textAlignment = .left
            $0.font = font_12(weight: .regular)
            $0.textColor = .hex("#ffffff")
            $0.text = "Backbone 会评估设备上安装的应用程序，从而提供增强的游戏启\n动功能和基于配件兼容性的游戏建议*"
            $0.numberOfLines = 2
        }
        return label
    }()
    
    lazy var applyBtn:UIButton = {
        let btn = UIButton().then {
            $0.backgroundColor = .hex("#ffffff")
            $0.layer.cornerRadius = 8
            $0.layer.masksToBounds = true
            
            let label = UILabel()
            label.text = "继续"
            label.font = font_14(weight: .medium)
            label.textColor = .hex("#252525")
            label.textAlignment = .center
            $0.addSubview(label)
            label.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.centerX.equalToSuperview().offset(20)
            }
            
            let icon = UIImageView()
            icon.backgroundColor = .clear
            icon.image = UIImage(named: "ic-A")
            $0.addSubview(icon)
            icon.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.height.width.equalTo(20)
                make.right.equalTo(label.snp.left).offset(-8)
            }
        }
        
        btn.addTarget(self, action: #selector(enter), for: .touchDown)
        btn.addTarget(self, action: #selector(ok), for: .touchDragExit)
        btn.addTarget(self, action: #selector(ok), for: .touchUpInside)
        return btn
    }()
    
    @objc func ok(){
        NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyAPressOut.rawValue), object: nil)
    }
    
    @objc func enter(){
        NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyAPressIn.rawValue), object: nil)
    }
    lazy var backBtn:GameBackKeyBtn = {
        let btn = GameBackKeyBtn().then {
            $0.backgroundColor = .clear
            $0.label.textColor = .hex("#ffffff")
            $0.icon.image = UIImage(named: "ic-B-clear")
            $0.btn.layer.cornerRadius = 20.widthScale
            $0.btn.layer.masksToBounds = true
            //$0.tag = 1
            $0.anim = true
        }
        return btn
    }()
    
}
