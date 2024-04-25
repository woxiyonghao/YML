//
//  GSUserInfoView.swift
//  GameSirBeyond
//
//  Created by lu on 2024/3/26.
//

import UIKit
import SnapKit
import Then
import RxSwift
class GSUserInfoView:UIView {
    
    
    var selectRow = 0
    var selectSection = 0 {
        didSet{
            defer{
                UIView.animate(withDuration: 0.2) {
                    self.layoutIfNeeded()
                }
                
            }
            setNeedsLayout()
            if selectSection == 0 {
                
                videoBtn.backgroundColor = selectRow == 0  ? .hex("#ffffff"):.hex("#3D434F")
                videoBtn.setImage(selectRow == 0  ? UIImage(named: "user_info_video_black"):UIImage(named: "user_info_video_white"), for: .normal)
                
                imgBtn.backgroundColor = selectRow == 1 ? .hex("#ffffff"):.hex("#3D434F")
                imgBtn.setImage(selectRow == 1 ? UIImage(named: "user_info_lib_black"):UIImage(named: "user_info_lib_white"), for: .normal)
                
                setterBtn.backgroundColor = selectRow == 2 ? .hex("#ffffff"):.hex("#3D434F")
                setterBtn.setImage(selectRow == 2 ? UIImage(named: "user_info_set_black"):UIImage(named: "user_info_set_white"), for: .normal)
                
                editBtn.backgroundColor = .hex("#3D434F")
                editBtn.setTitleColor(.hex("#CCCCCC"), for: .normal)
                
                editGameBtn.backgroundColor = .hex("#3D434F")
                editGameBtn.setTitleColor(.hex("#CCCCCC"), for: .normal)
                
                editGameBtn.snp.remakeConstraints {
                    $0.right.equalToSuperview().offset(-48.widthScale)
                    $0.left.equalToSuperview().offset(48.widthScale)
                    $0.bottom.equalToSuperview().offset(-48.widthScale)
                    $0.height.equalTo(44.widthScale)
                }
                
                editBtn.snp.remakeConstraints {
                    $0.left.right.height.equalTo(editGameBtn)
                    $0.bottom.equalTo(editGameBtn.snp.top).offset(-12.widthScale)
                }
            }
            else {
                
                videoBtn.backgroundColor = .hex("#3D434F")
                videoBtn.setImage(UIImage(named: "user_info_video_white"), for: .normal)
                
                imgBtn.backgroundColor = .hex("#3D434F")
                imgBtn.setImage(UIImage(named: "user_info_lib_white"), for: .normal)
                
                setterBtn.backgroundColor = .hex("#3D434F")
                setterBtn.setImage(UIImage(named: "user_info_set_white"), for: .normal)
                
                editBtn.backgroundColor = selectSection == 1 ? .hex("#ffffff"):.hex("#3D434F")
                editBtn.setTitleColor(selectSection == 1 ? .hex("#252525"):.hex("#CCCCCC"), for: .normal)
                
                editGameBtn.backgroundColor = selectSection == 2 ? .hex("#ffffff"):.hex("#3D434F")
                editGameBtn.setTitleColor(selectSection == 2 ? .hex("#252525"):.hex("#CCCCCC"), for: .normal)
                
                if selectSection == 2 {
                    editGameBtn.snp.remakeConstraints {
                        $0.right.equalToSuperview().offset(-40.widthScale)
                        $0.left.equalToSuperview().offset(40.widthScale)
                        $0.bottom.equalToSuperview().offset(-48.widthScale)
                        $0.height.equalTo(44.widthScale)
                    }
                    
                    editBtn.snp.remakeConstraints {
                        $0.right.equalToSuperview().offset(-48.widthScale)
                        $0.left.equalToSuperview().offset(48.widthScale)
                        $0.bottom.equalTo(editGameBtn.snp.top).offset(-12.widthScale)
                        $0.height.equalTo(44.widthScale)
                    }
                }
                else{
                    editGameBtn.snp.remakeConstraints {
                        $0.right.equalToSuperview().offset(-48.widthScale)
                        $0.left.equalToSuperview().offset(48.widthScale)
                        $0.bottom.equalToSuperview().offset(-48.widthScale)
                        $0.height.equalTo(44.widthScale)
                    }
                    
                    editBtn.snp.remakeConstraints {
                        $0.right.equalToSuperview().offset(-40.widthScale)
                        $0.left.equalToSuperview().offset(40.widthScale)
                        $0.bottom.equalTo(editGameBtn.snp.top).offset(-12.widthScale)
                        $0.height.equalTo(44.widthScale)
                    }
                }
            }
            
        }
    }
    let disposeBag = DisposeBag()

    // 364
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(videoBtn)
        addSubview(imgBtn)
        addSubview(setterBtn)
        addSubview(iconBg)
        iconBg.addSubview(emojiL)
        addSubview(nameL)
        addSubview(gameNameL)
        addSubview(stateL)
        addSubview(editBtn)
        addSubview(editGameBtn)
        
        let btnY:CGFloat = 24.widthScale
        let btnSpace:CGFloat = 12.widthScale
        let btnX:CGFloat = 30.widthScale
        let btnW:CGFloat = (frame.width - btnX.widthScale * 2 - btnSpace * 2 ) / 3
        let btnH:CGFloat = 48.widthScale
        videoBtn.snp.makeConstraints { make in
            make.width.equalTo(btnW)
            make.height.equalTo(btnH)
            make.left.equalToSuperview().offset(btnX)
            make.top.equalToSuperview().offset(btnY)
        }
        
        imgBtn.snp.makeConstraints { make in
            make.width.top.height.equalTo(videoBtn)
            make.left.equalTo(videoBtn.snp.right).offset(btnSpace)
        }
        
        setterBtn.snp.makeConstraints { make in
            make.width.top.height.equalTo(videoBtn)
            make.left.equalTo(imgBtn.snp.right).offset(btnSpace)
        }
        
        
        iconBg.snp.makeConstraints {
            $0.top.equalTo(videoBtn.snp.bottom).offset(38.widthScale)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(48.widthScale)
        }
        iconBg.layer.cornerRadius = 24.widthScale
        iconBg.layer.masksToBounds = true
        
        
        emojiL.snp.makeConstraints {
            $0.left.top.right.bottom.equalToSuperview()
        }
        
        
        nameL.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.top.equalTo(iconBg.snp.bottom).offset(8.widthScale)
        }
        
        
        gameNameL.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.top.equalTo(nameL.snp.bottom).offset(0)
        }
        
        
        stateL.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.top.equalTo(gameNameL.snp.bottom).offset(0)
            $0.height.equalTo(20)
        }
        
        editGameBtn.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-48.widthScale)
            $0.left.equalToSuperview().offset(48.widthScale)
            $0.bottom.equalToSuperview().offset(-48.widthScale)
            $0.height.equalTo(44.widthScale)
        }
        
        editBtn.snp.makeConstraints {
            $0.left.right.height.equalTo(editGameBtn)
            $0.bottom.equalTo(editGameBtn.snp.top).offset(-12.widthScale)
        }
        
        videoBtn.rx.tap.subscribe { [weak self] _ in
            guard let `self` = self else {return}
            if self.selectRow == 0 && self.selectSection == 0 {
                NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyAPressOut.rawValue), object: nil)
            }
            else{
                self.selectRow = 0
                self.selectSection = 0
            }
        }.disposed(by: disposeBag)
        
        imgBtn.rx.tap.subscribe { [weak self] _ in
            guard let `self` = self else {return}
            if self.selectRow == 1 && self.selectSection == 0 {
                NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyAPressOut.rawValue), object: nil)
            }
            else{
                self.selectRow = 1
                self.selectSection = 0
            }
            
        }.disposed(by: disposeBag)
        
        setterBtn.rx.tap.subscribe {[weak self] _ in
            guard let `self` = self else {return}
            if self.selectRow == 2 && self.selectSection == 0 {
                NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyAPressOut.rawValue), object: nil)
            }
            else{
                self.selectRow = 2
                self.selectSection = 0
            }
            
        }.disposed(by: disposeBag)
        
        editBtn.rx.tap.subscribe { [weak self] _ in
            guard let `self` = self else {return}
            if self.selectSection == 1 {
                NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyAPressOut.rawValue), object: nil)
            }
            else{
                self.selectSection = 1
            }
            
        }.disposed(by: disposeBag)
        
        editGameBtn.rx.tap.subscribe { [weak self] _ in
            guard let `self` = self else {return}
            if self.selectSection == 2{
                NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyAPressOut.rawValue), object: nil)
            }
            else{
                self.selectSection = 2
            }
            
        }.disposed(by: disposeBag)
        
        
    }
    
    open func refreshUserInfo(){
        var emojiColro = UserDefaultWrapper<String?>(key: UserDefaultKeys.saveEmojiColor)
        if emojiColro.wrappedValue == nil {
            emojiColro.wrappedValue = "#ADED5C"
        }
        iconBg.backgroundColor = .hex(emojiColro.wrappedValue!)
        
        var emoji = getUserEmojiString()
        emojiL.text = emoji
        
        nameL.text = getUsername()
        
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var videoBtn = UIButton().then {
        $0.backgroundColor = .hex("#3D434F")
        $0.setImage(UIImage(named: "user_info_video_white"), for: .normal)
        $0.layer.cornerRadius = 8.widthScale
        $0.layer.masksToBounds = true
    }
    lazy var imgBtn = UIButton().then {
        $0.backgroundColor = .hex("#3D434F")
        $0.setImage(UIImage(named: "user_info_lib_white"), for: .normal)
        $0.layer.cornerRadius = 8.widthScale
        $0.layer.masksToBounds = true
    }
    lazy var setterBtn = UIButton().then {
        $0.backgroundColor = .hex("#3D434F")
        $0.setImage(UIImage(named: "user_info_set_white"), for: .normal)
        $0.layer.cornerRadius = 8.widthScale
        $0.layer.masksToBounds = true
    }
    
    lazy var iconBg:UIView = {
        let view = UIView()
        var emojiColro = UserDefaultWrapper<String?>(key: UserDefaultKeys.saveEmojiColor)
        if emojiColro.wrappedValue == nil {
            emojiColro.wrappedValue = "#ADED5C"
        }
        view.backgroundColor = .hex(emojiColro.wrappedValue!)
        return view
    }()
    
    lazy var emojiL:UILabel = {
        let l = UILabel()
        l.backgroundColor = .clear
        l.textAlignment = .center
        var emoji = getUserEmojiString()
        l.text = emoji
        l.font = font_32(weight: .regular)
        return l
    }()
    
    
    lazy var nameL:UILabel = {
        let l = UILabel()
        l.backgroundColor = .clear
        l.textAlignment = .center
        //var nicname = UserDefaultWrapper<String?>(key: UserDefaultKeys.ifNeedInputNicname)
        //l.text = nicname.wrappedValue ?? ""
        l.text = getUsername()
        l.textColor = .hex("#ffffff")
        l.font = font_18(weight: .bold)
        return l
    }()
    
    lazy var gameNameL:UILabel = {
        let l = UILabel()
        l.backgroundColor = .clear
        l.textAlignment = .center
        l.text = ""
        l.textColor = .hex("#B4B4B4")
        l.font = font_16(weight: .bold)
        return l
    }()
    
    
    lazy var stateL:UILabel = {
        let l = UILabel()
        l.backgroundColor = .clear
        l.textAlignment = .center
        l.text = "手柄型号"
        l.textColor = .hex("#71F596")
        l.font = font_14(weight: .bold)
        return l
    }()
    
    
    lazy var editBtn = UIButton().then {
        $0.backgroundColor = .hex("#3D434F")
        $0.layer.cornerRadius = 8.widthScale
        $0.layer.masksToBounds = true
        $0.setTitle("编辑个人资料", for: .normal)
        $0.setTitleColor(.hex("#CCCCCC"), for: .normal)
        $0.titleLabel?.font = font_14(weight: .bold)
    }
    
    lazy var editGameBtn = UIButton().then {
        $0.backgroundColor = .hex("#3D434F")
        $0.layer.cornerRadius = 8.widthScale
        $0.layer.masksToBounds = true
        $0.setTitle("编辑游戏用户名", for: .normal)
        $0.setTitleColor(.hex("#CCCCCC"), for: .normal)
        $0.titleLabel?.font = font_14(weight: .bold)
        
    }
}
