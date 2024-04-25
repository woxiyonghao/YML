//
//  GameNotiAuthView.swift
//  GameLoginWelcome
//
//  Created by lu on 2024/3/6.
//

import UIKit
import SnapKit
class GameNotiAuthView: UIView {
    
    open var touchBtnAgain = {(onFocusIdx:Int) in }
    open var onFocusIdx = 0
    open func setFocusBtn(idx:Int){
        defer{onFocusIdx = idx}
        setNeedsLayout()
        if idx == 0 {
            
            applyBtn.snp.remakeConstraints {
                $0.left.equalTo(titleL).offset(0)
                $0.right.equalTo(titleL).offset(0)
                $0.top.equalTo(subtitleL.snp.bottom).offset(16.widthScale)
                $0.height.equalTo(50.widthScale)
            }
            applyIconA.isHidden = false
            
            lateBtn.snp.remakeConstraints {
                $0.left.equalTo(titleL).offset(8.widthScale)
                $0.right.equalTo(titleL).offset(-8.widthScale)
                $0.top.equalTo(applyBtn.snp.bottom).offset(12.widthScale)
                $0.height.equalTo(50.widthScale)
            }
            lateIconA.isHidden = true
            
            applyBtn.backgroundColor = .hex("#252525")
            applyBtn.setTitleColor(.white, for: .normal)
            
            lateBtn.backgroundColor = .hex("#E4E4E4")
            lateBtn.setTitleColor(.hex("#252525"), for: .normal)
        }
        else {
            applyBtn.snp.remakeConstraints {
                $0.left.equalTo(titleL).offset(8.widthScale)
                $0.right.equalTo(titleL).offset(-8.widthScale)
                $0.top.equalTo(subtitleL.snp.bottom).offset(16.widthScale)
                $0.height.equalTo(50.widthScale)
            }
            applyIconA.isHidden = true
            
            lateBtn.snp.remakeConstraints {
                $0.left.equalTo(titleL).offset(0)
                $0.right.equalTo(titleL).offset(0)
                $0.top.equalTo(applyBtn.snp.bottom).offset(12.widthScale)
                $0.height.equalTo(50.widthScale)
            }
            lateIconA.isHidden = false
            
            lateBtn.backgroundColor = .hex("#252525")
            lateBtn.setTitleColor(.white, for: .normal)
            
            applyBtn.backgroundColor = .hex("#E4E4E4")
            applyBtn.setTitleColor(.hex("#252525"), for: .normal)
        }
        UIView.animate(withDuration: 0.15) {[weak self] in
            guard let `self` = self else {return}
            self.layoutIfNeeded()
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
            $0.left.equalTo(self.snp.centerX).offset(70.widthScale)
            $0.right.equalToSuperview().offset(-70.widthScale)
            $0.top.equalToSuperview().offset(52.widthScale)
        }
        addSubview(subtitleL)
        subtitleL.snp.makeConstraints {
            $0.right.left.equalTo(titleL)
            $0.top.equalTo(titleL.snp.bottom).offset(12.widthScale)
        }
        
        addSubview(applyBtn)
        applyBtn.snp.makeConstraints {
            $0.left.equalTo(titleL).offset(0)
            $0.right.equalTo(titleL).offset(0)
            $0.top.equalTo(subtitleL.snp.bottom).offset(16.widthScale)
            $0.height.equalTo(50.widthScale)
        }
        applyIconA.isHidden = false
        
        addSubview(lateBtn)
        lateBtn.snp.makeConstraints {
            $0.left.equalTo(titleL).offset(8.widthScale)
            $0.right.equalTo(titleL).offset(-8.widthScale)
            $0.top.equalTo(applyBtn.snp.bottom).offset(12.widthScale)
            $0.height.equalTo(50.widthScale)
        }
        lateIconA.isHidden = true
        
        addSubview(backBtn)
        backBtn.snp.remakeConstraints {
            $0.right.equalToSuperview().offset(-30.widthScale)
            $0.bottom.equalToSuperview().offset(-30.widthScale)
            $0.width.equalTo(80.widthScale)
            $0.height.equalTo(40.widthScale)
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
            $0.textAlignment = .left
            $0.font = font_24(weight: .regular)
            $0.textColor = .hex("#252525")
            $0.text = "保持资讯更新"
            $0.numberOfLines = 1
        }
        return label
    }()
    lazy var subtitleL:UILabel = {
        let label = UILabel().then {
            $0.textAlignment = .left
            $0.font = font_14(weight: .regular)
            $0.textColor = .hex("#252525")
            $0.text = "请允许发送推送通知至您的设备，这样您就能\n实时了解新游戏发布、好友在线和其他相关新\n闻和更新。您可以在设备设置中对您的选择进\n行修改。"
            $0.numberOfLines = 4
        }
        return label
    }()
    
    lazy var applyBtn:UIButton = {
        let btn = UIButton().then {
            $0.backgroundColor = .hex("#252525")
            $0.setTitle("允许", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = font_14(weight: .regular)
            $0.layer.cornerRadius = 8.widthScale
            $0.layer.masksToBounds = true
        }
        applyIconA = UIImageView()
        applyIconA.backgroundColor = .clear
        applyIconA.isHidden = true
        applyIconA.image = UIImage(named: "ic-A-clear")
        btn.addSubview(applyIconA)
        applyIconA.snp.makeConstraints { make in
            make.width.height.equalTo(20.widthScale)
            make.right.equalTo(btn.snp.centerX).offset(-20.widthScale)
            make.centerY.equalToSuperview()
        }
        btn.addTarget(self, action: #selector(applyEnterAction), for: .touchDown)
        btn.addTarget(self, action: #selector(applyAction), for: .touchDragExit)
        btn.addTarget(self, action: #selector(applyAction), for: .touchUpInside)
        return btn
    }()
    
    @objc func applyEnterAction(){
        NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyAPressIn.rawValue), object: nil)
        
    }
    
    @objc func applyAction(){
        if onFocusIdx == 0 {
            touchBtnAgain(onFocusIdx)
        }
        else {
            setFocusBtn(idx: 0)
        }
        
    }
    
    var applyIconA:UIImageView!
    
    lazy var lateBtn:UIButton = {
        let btn = UIButton().then {
            $0.backgroundColor = .hex("#E4E4E4")
            $0.setTitle("稍后处理", for: .normal)
            $0.setTitleColor(.hex("#252525"), for: .normal)
            $0.titleLabel?.font = font_14(weight: .regular)
            $0.layer.cornerRadius = 8.widthScale
            $0.layer.masksToBounds = true
        }
        
        lateIconA = UIImageView()
        lateIconA.backgroundColor = .clear
        lateIconA.isHidden = true
        lateIconA.image = UIImage(named: "ic-A-clear")
        btn.addSubview(lateIconA)
        lateIconA.snp.makeConstraints { make in
            make.width.height.equalTo(20.widthScale)
            make.right.equalTo(btn.snp.centerX).offset(-35.widthScale)
            make.centerY.equalToSuperview()
        }
        btn.addTarget(self, action: #selector(lateEnterAction), for: .touchDown)
        btn.addTarget(self, action: #selector(lateAction), for: .touchDragExit)
        btn.addTarget(self, action: #selector(lateAction), for: .touchUpInside)
        return btn
    }()
    
    @objc func lateEnterAction(){
        NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyAPressIn.rawValue), object: nil)
    }
    @objc func lateAction(){
        if onFocusIdx == 1 {
            touchBtnAgain(onFocusIdx)
        }
        else {
            setFocusBtn(idx: 1)
        }
        
    }
    
    var lateIconA:UIImageView!
    
    var backBtn:GameBackKeyBtn = {
        let btn = GameBackKeyBtn().then {
            $0.label.textColor = .hex("#252525")
            $0.icon.image = UIImage(named: "ic-B")
            $0.btn.backgroundColor = .clear
            $0.btn.layer.cornerRadius = 20.widthScale
            $0.btn.layer.masksToBounds = true
            $0.anim = true
        }
        return btn
    }()
    
}
