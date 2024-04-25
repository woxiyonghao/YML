//
//  GameIntroduceView.swift
//  GameLoginWelcome
//
//  Created by lu on 2024/3/5.
//

import UIKit
import SnapKit

enum GameIntroduceViewState {
    case stateNormal
    case doneScreenshot
    case doneRecode
}

class GameIntroduceView: UIView {
    var index = 0
    var introduceState:GameIntroduceViewState = .stateNormal{
        didSet{
            if introduceState == .stateNormal {
                longPassView.state = false
                recordView.state = false
            }
            else if introduceState == .doneScreenshot{
                longPassView.state = true
                recordView.state = false
            }
            else{
                longPassView.state = true
                recordView.state = true
            }
            setSnp()
        }
    }
    init(idx:Int){
        
        super.init(frame: .zero)
        
        index = idx
        addSubview(projectImage)
        addSubview(titleL)
        addSubview(detailL)
        addSubview(continueBtn)
        addSubview(screenshotIcon)
        addSubview(backBtn)
        addSubview(longPassView)
        addSubview(recordView)
        setSnp()
    }
    
    func setSnp(){
        setNeedsLayout()
        backBtn.snp.remakeConstraints {
            $0.right.equalToSuperview().offset(-30.widthScale)
            $0.bottom.equalToSuperview().offset(-30.widthScale)
            $0.width.equalTo(80.widthScale)
            $0.height.equalTo(40.widthScale)
        }
        
        screenshotIcon.isHidden = index != 0
        
        if index == 0 { // 分享高光时刻
            
            shareSnp()
            
        }
        else{// 让你可以炫耀
            
            switch introduceState {
            case .stateNormal:
                stateNormalUI()
                break
            case .doneScreenshot:
                doneScreenshot()
                break
                
            case .doneRecode:
                doneRecordUI()
                break
                
            }
        }
        bringSubviewToFront(backBtn)
        
        UIView.animate(withDuration: 0.15) {[weak self] in
            guard let `self` = self else {return}
            self.layoutIfNeeded()
        }
        
    }
    
    func doneRecordUI(){
        
        projectImage.snp.remakeConstraints {
            $0.top.bottom.right.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.4)
        }
        projectImage.layer.masksToBounds = true
        projectImage.layer.cornerRadius = 0
        
        titleL.text = "让您可以向大家炫耀"
        titleL.snp.remakeConstraints {
            $0.left.equalToSuperview().offset(72.widthScale)
            $0.bottom.equalTo(self.snp.centerY).offset(-80.widthScale)
        }
        
        longPassView.isHidden = false
        longPassView.snp.remakeConstraints {
            $0.left.equalTo(titleL)
            $0.top.equalTo(titleL.snp.bottom).offset(40.widthScale)
            $0.height.equalTo(40.widthScale)
            //$0.right.equalTo(self.snp.centerX).offset(-40)
            $0.width.equalToSuperview().multipliedBy(0.36)
        }
        
        recordView.snp.remakeConstraints {
            $0.left.right.height.equalTo(longPassView)
            $0.top.equalTo(longPassView.snp.bottom).offset(20.widthScale)
        }
        recordView.isHidden = false
        
        continueBtn.isHidden = false
        continueBtn.snp.remakeConstraints{
            $0.left.equalTo(longPassView)
            $0.top.equalTo(recordView.snp.bottom).offset(20.widthScale)
            $0.right.equalTo(recordView).offset(-10.widthScale)
            $0.height.equalTo(40.widthScale)
        }
    }
    
    func doneScreenshot(){
        projectImage.snp.remakeConstraints {
            $0.top.bottom.right.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.4)
        }
        projectImage.layer.masksToBounds = true
        projectImage.layer.cornerRadius = 0
        
        titleL.text = "让您可以向大家炫耀"
        titleL.snp.remakeConstraints {
            $0.left.equalToSuperview().offset(72.widthScale)
            $0.bottom.equalTo(self.snp.centerY).offset(-50.widthScale)
        }
        
        longPassView.isHidden = false
        longPassView.snp.remakeConstraints {
            $0.left.equalTo(titleL)
            $0.top.equalTo(titleL.snp.bottom).offset(40.widthScale)
            $0.height.equalTo(40)
            //$0.right.equalTo(self.snp.centerX).offset(-40)
            $0.width.equalToSuperview().multipliedBy(0.36)
        }
        
        recordView.snp.remakeConstraints {
            $0.left.right.height.equalTo(longPassView)
            $0.top.equalTo(longPassView.snp.bottom).offset(20.widthScale)
        }
        recordView.isHidden = false
        
        continueBtn.isHidden = true
        continueBtn.snp.remakeConstraints{
            $0.left.equalTo(longPassView)
            $0.top.equalTo(recordView.snp.bottom).offset(20.widthScale)
            $0.right.equalTo(recordView).offset(-10.widthScale)
            $0.height.equalTo(40.widthScale)
        }
    }
    
    func stateNormalUI(){
        
        projectImage.snp.remakeConstraints {
            $0.top.bottom.right.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.4)
           
        }
        projectImage.layer.masksToBounds = true
        projectImage.layer.cornerRadius = 0
        
        titleL.text = "让您可以向大家炫耀"
        titleL.snp.remakeConstraints {
            $0.left.equalToSuperview().offset(72.widthScale)
            $0.bottom.equalTo(self.snp.centerY).offset(-20.widthScale)
        }
        
        longPassView.isHidden = false
        longPassView.snp.remakeConstraints {
            $0.left.equalTo(titleL)
            $0.top.equalTo(titleL.snp.bottom).offset(40.widthScale)
            $0.height.equalTo(40.widthScale)
            //$0.right.equalTo(self.snp.centerX).offset(-40)
            $0.width.equalToSuperview().multipliedBy(0.36)
        }
        
        recordView.snp.remakeConstraints {
            $0.left.right.height.equalTo(longPassView)
            $0.top.equalTo(longPassView.snp.bottom).offset(20)
        }
        recordView.isHidden = true
    }
    
    func shareSnp(){
        projectImage.snp.remakeConstraints {
            $0.centerY.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.4)
            //$0.left.equalTo(self.snp.centerX).offset(40)
            $0.width.equalToSuperview().multipliedBy(0.4)
            $0.right.equalToSuperview().offset(-60.widthScale)
        }
        projectImage.layer.masksToBounds = true
        projectImage.layer.cornerRadius = 8
        
        titleL.text = "分享高光时刻"
        titleL.snp.remakeConstraints {
            $0.left.equalToSuperview().offset(72.widthScale)
            $0.top.equalTo(projectImage)
        }
        
        detailL.snp.remakeConstraints {
            $0.left.equalTo(titleL)
            $0.top.equalTo(titleL.snp.bottom).offset(20.widthScale)
        }
        
        continueBtn.snp.remakeConstraints{
            $0.left.equalTo(titleL)
            $0.bottom.equalTo(projectImage)
            $0.right.equalTo(detailL)
            $0.height.equalTo(40.widthScale)
        }
        
        screenshotIcon.snp.remakeConstraints{
            $0.centerX.equalTo(projectImage.snp.left)
            $0.centerY.equalTo(projectImage.snp.bottom)
            $0.width.height.equalTo(40.widthScale)
        }
        
        longPassView.snp.remakeConstraints {
            $0.left.top.equalToSuperview()
            $0.width.height.equalTo(0)
        }
        longPassView.isHidden = true
        
        recordView.snp.remakeConstraints {
            $0.left.top.equalToSuperview()
            $0.width.height.equalTo(0)
        }
        recordView.isHidden = true
    }
    
    lazy var projectImage:UIImageView = {
        let img = UIImageView().then {
            $0.backgroundColor = .orange
        }
        return img
    }()
    
    lazy var screenshotIcon:UIImageView = {
        let img = UIImageView().then {
            $0.image = UIImage(named: "home_screenshot")
            $0.backgroundColor = .clear
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 20
        }
        return img
    }()
    
    lazy var titleL:UILabel = {
        let label = UILabel().then {
            $0.textAlignment = .left
            $0.font = font_24(weight: .regular)
            $0.textColor = .white
        }
        return label
    }()
    
    lazy var detailL:UILabel = {
        let label = UILabel().then {
            $0.text = "以 1080P 30 FPS 的格式录制任何游戏过程。您可以\n使用 Backbone 的录制设置来优化您的体验。"
            $0.textAlignment = .left
            $0.font = font_14(weight: .regular)
            $0.textColor = .white
            $0.numberOfLines = 2
        }
        return label
    }()
    
    lazy var continueBtn:UIButton = {
        let btn = UIButton().then {[weak self] in
            guard let `self` = self else {return}
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 4
            $0.layer.masksToBounds = true
        }
        let icon = UIImageView()
        icon.backgroundColor = .clear
        icon.image = UIImage(named: "ic-A")
        btn.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.centerY.equalTo(btn)
            make.right.equalTo(btn.snp.centerX).offset(-8)
            make.size.equalTo(CGSizeMake(20, 20))
        }
        
        let label = UILabel()
        label.text = "继续"
        label.textColor = .hex("#252525")
        label.font = font_14(weight: .regular)
        label.textAlignment = .left
        btn.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalTo(btn)
            make.left.equalTo(btn.snp.centerX)
        }
        btn.addTarget(self, action: #selector(continueBtnEnterClicked), for: .touchDown)
        btn.addTarget(self, action: #selector(continueBtnDidClicked), for: .touchDragExit)
        btn.addTarget(self, action: #selector(continueBtnDidClicked), for: .touchUpInside)
        return btn
    }()
    
    @objc func continueBtnDidClicked(){
        NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyAPressOut.rawValue), object: nil)
    }
    @objc func continueBtnEnterClicked(){
        NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyAPressIn.rawValue), object: nil)
    }
    var backBtn:GameBackKeyBtn = {
        let btn = GameBackKeyBtn().then {
            $0.label.textColor = .hex("#ffffff")
            $0.icon.image = UIImage(named: "ic-B-clear")
            $0.btn.backgroundColor = .clear
            $0.btn.layer.cornerRadius = 20.widthScale
            $0.btn.layer.masksToBounds = true
            $0.anim = true
        }
        return btn
    }()
    
    
    // 长按 进行截图
    lazy var longPassView:GameShowItem = {
        let v = GameShowItem(needProgress: true).then {
            $0.state = false
            $0.titleL.text = "长按"
            $0.titleR.text = "进行截图"
            $0.icon.image = UIImage(named: "ic-screenshot")
        }
        v.tag = 1
        return v
    }()
    
    lazy var recordView:GameShowItem = {
        let v = GameShowItem(needProgress: false).then {
            $0.state = false
            $0.titleL.text = "按下"
            $0.titleR.text = "录制游戏过程"
            $0.icon.image = UIImage(named: "ic-screenshot")
        }
        v.tag = 2
        return v
    }()
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
