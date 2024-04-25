//
//  GameShellThreeView.swift
//  GameLoginWelcome
//
//  Created by lu on 2024/3/8.
//

import UIKit
import SnapKit
import Then
class GameShellThreeView: UIView {

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
            $0.top.equalToSuperview().offset(92.widthScale)
        }
        
       
        addSubview(subtitleL)
        subtitleL.snp.makeConstraints {
            $0.left.equalTo(titleL)
            $0.right.equalTo(self.snp.centerX).offset(0)
            $0.top.equalTo(titleL.snp.bottom).offset(24.widthScale)
        }
        
        addSubview(applyBtn)
        applyBtn.snp.makeConstraints {
            $0.left.equalTo(titleL)
            $0.right.equalTo(self.snp.centerX).offset(-80.widthScale)
            $0.top.equalTo(subtitleL.snp.bottom).offset(32.widthScale)
            $0.height.equalTo(44.widthScale)
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
            $0.text = "没有游戏主机，也没有问题"
            $0.numberOfLines = 1
        }
        return label
    }()
    lazy var subtitleL:UILabel = {
        let label = UILabel().then {
            $0.textAlignment = .left
            $0.font = font_14(weight: .regular)
            $0.textColor = .hex("#ffffff")
            $0.text = "通过 Xbox Game Pass Ultimate、GeForce Now 或\nGoogle Stadia等平台，您可以畅玩像《Hello Infinite》\n这样令人惊叹的游戏。无需游戏主机或电脑，即可尽情享\n受游戏乐趣。"
            $0.numberOfLines = 0
        }
        return label
    }()
    
    lazy var applyBtn:UIButton = {
        let btn = UIButton().then {
            $0.backgroundColor = .hex("#ffffff")
            $0.layer.cornerRadius = 8.widthScale
            $0.layer.masksToBounds = true
            
            let label = UILabel()
            label.text = "继续"
            label.font = font_14(weight: .medium)
            label.textColor = .hex("#252525")
            label.textAlignment = .center
            $0.addSubview(label)
            label.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.centerX.equalToSuperview().offset(20.widthScale)
            }
            
            let icon = UIImageView()
            icon.backgroundColor = .clear
            icon.image = UIImage(named: "ic-A")
            $0.addSubview(icon)
            icon.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.height.width.equalTo(20.widthScale)
                make.right.equalTo(label.snp.left).offset(-8.widthScale)
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
