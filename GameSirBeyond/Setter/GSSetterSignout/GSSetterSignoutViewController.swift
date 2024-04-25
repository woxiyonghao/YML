//
//  GSSetterSignoutViewController.swift
//  GameSirBeyond
//
//  Created by lu on 2024/4/11.
//

import UIKit
import RxSwift
import RxCocoa
enum GSSetterActionStyle {
    case signout
    case factorySettings
}

class GSSetterSignoutViewController: UIViewController {
    
    var dismiss = {() in}
    var onPressing = false
    fileprivate let disposeBag = DisposeBag()
    fileprivate var size = CGSize(width: 0, height: 0)
    fileprivate var style:GSSetterActionStyle!
    fileprivate var onFcousIndex = 0{
        didSet{
            if onFcousIndex == 0 {
                sureBtn.setTitleColor(.hex("#252525"), for: .normal)
                sureBtn.backgroundColor = .hex("ffffff")
                cancleBtn.setTitleColor(.hex("#ffffff"), for: .normal)
                cancleBtn.backgroundColor = .hex("#565D6B")
                UIView.animate(withDuration: 0.2) {[weak self] in
                    guard let `self` = self else { return  }
                    self.sureBtn.frame =  CGRectMake(96.widthScale - 8.widthScale,
                                                     self.cancleBtn.y - 12.widthScale - 44.widthScale,
                                                     self.size.width - (96.widthScale - 8.widthScale) * 2,
                                                     44.widthScale)
                    self.cancleBtn.frame =  CGRectMake(96.widthScale ,
                                                       self.size.height - 24.widthScale - 44.widthScale,
                                                       self.size.width - 96.widthScale * 2,
                                                       44.widthScale)
                }
            }
            else {
                sureBtn.setTitleColor(.hex("#ffffff"), for: .normal)
                sureBtn.backgroundColor = .hex("#565D6B")
                cancleBtn.setTitleColor(.hex("#252525"), for: .normal)
                cancleBtn.backgroundColor = .hex("ffffff")
                UIView.animate(withDuration: 0.2) {[weak self] in
                    guard let `self` = self else { return  }
                    self.cancleBtn.frame =  CGRectMake(96.widthScale - 8.widthScale,
                                                       self.size.height - 24.widthScale - 44.widthScale,
                                                       self.size.width - (96.widthScale - 8.widthScale) * 2,
                                                       44.widthScale)
                    self.sureBtn.frame =  CGRectMake(96.widthScale ,
                                                     self.cancleBtn.y - 12.widthScale - 44.widthScale,
                                                     self.size.width - 96.widthScale * 2,
                                                     44.widthScale)
                }
            }
        }
    }
    init(viewSize:CGSize,initStyle:GSSetterActionStyle){
        self.size = viewSize
        self.style = initStyle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .hex("#20242F")
        view.layer.cornerRadius = 8.widthScale
        view.layer.masksToBounds = true
        
        var titleTxt = ""
        switch style {
        case .signout:
            titleTxt = "您确定要退出登录吗？"
        case .factorySettings:
            titleTxt = "您确定要重置为出厂设置吗？"
        case .none:
            return
        }
        _ = UILabel(frame: CGRectMake(0, 30.widthScale, size.width, 40)).then {[weak self] in
            guard let `self` = self else {return}
            self.view.addSubview($0)
            $0.text = titleTxt
            $0.textAlignment = .center
            $0.font = font_28(weight: .regular)
            $0.textColor = .hex("#ffffff")
        }
        
        cancleBtn = UIButton(frame: CGRectMake(96.widthScale, size.height - 24.widthScale - 44.widthScale, size.width - 96.widthScale*2, 44.widthScale)).then({[weak self] in
            guard let `self` = self else {return}
            self.view.addSubview($0)
            $0.setTitle("取消", for: .normal)
            $0.setTitleColor(.hex("#ffffff"), for: .normal)
            $0.titleLabel?.font = font_14(weight: .semibold)
            $0.backgroundColor = .hex("#565D6B")
            $0.layer.cornerRadius = 8.widthScale
            $0.layer.masksToBounds = true
        })
        
        sureBtn = UIButton(frame: CGRectMake(cancleBtn.x, cancleBtn.y - 12.widthScale - cancleBtn.height, cancleBtn.width, cancleBtn.height)).then({[weak self] in
            guard let `self` = self else {return}
            self.view.addSubview($0)
            $0.setTitle("确定", for: .normal)
            $0.setTitleColor(.hex("#ffffff"), for: .normal)
            $0.titleLabel?.font = font_14(weight: .semibold)
            $0.backgroundColor = .hex("#565D6B")
            $0.layer.cornerRadius = 8.widthScale
            $0.layer.masksToBounds = true
        })
        
        cancleBtn.rx.tap.subscribe {[weak self]_  in
            guard let `self` = self else {return}
            if self.onFcousIndex == 1 {
                self.dismiss()
            }else {
                self.onFcousIndex = 1
            }
        }.disposed(by: disposeBag)
        
        
        sureBtn.rx.tap.subscribe {[weak self]_  in
            guard let `self` = self else {return}
            if self.onFcousIndex == 0 {
                switch self.style {
                case .signout:
                    print("退出登录！！！！")
                case .factorySettings:
                    print("出厂设置！！！！")
                case .none:
                    return
                }
                
            }else {
                self.onFcousIndex = 0
            }
        }.disposed(by: disposeBag)
        
        onFcousIndex = 0
        
        regisNotisWithoutPressB()
    }
    
    var sureBtn:UIButton!
    var cancleBtn:UIButton!
    
    
    deinit {
        print("------")
        unitNotis()
    }
}
// 关于手柄
extension GSSetterSignoutViewController {
    
    public func unitNotis(){
        NotificationCenter.default.removeObserver(self)
    }
 
    public func regisNotisWithoutPressB(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onPressingA),
                                               name: NSNotification.Name(ControllerNotificationName.KeyAPressIn.rawValue),
                                               object: nil)
        
     
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressAOut),
                                               name: NSNotification.Name(ControllerNotificationName.KeyAPressOut.rawValue),
                                               object: nil)
   
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressUp),
                                               name: NSNotification.Name(ControllerNotificationName.LeftJoystickMoveUp.rawValue),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressDown),
                                               name: NSNotification.Name(ControllerNotificationName.LeftJoystickMoveDown.rawValue),
                                               object: nil)
        
      
    }

    func signoutAction(){
        print("退出登录！！！！！")
        NotificationCenter.default.post(name: Notification.Name("UserDidLogoutNotification"), object: nil)
    }
    
    func resetJoycon(){
        print("恢复出厂设置！！！！！")
    }
    
    @objc func onPressingA(){
        onPressing = true
        
        if onFcousIndex == 0 {
            UIView.animate(withDuration: 0.2) {[weak self] in
                guard let `self` = self else { return  }
                self.sureBtn.frame =  CGRectMake(96.widthScale,
                                                 self.cancleBtn.y - 12.widthScale - 44.widthScale,
                                                 self.size.width - 96.widthScale * 2,
                                                 44.widthScale)
            }
            switch style {
            case .signout:
                signoutAction()
            case .factorySettings:
                resetJoycon()
            case .none:
                return
            }
            return
        }
        
        if onFcousIndex == 1 {
            UIView.animate(withDuration: 0.2) {[weak self] in
                guard let `self` = self else { return  }
                self.cancleBtn.frame =  CGRectMake(96.widthScale ,
                                                   self.size.height - 24.widthScale - 44.widthScale,
                                                   self.size.width - 96.widthScale  * 2,
                                                   44.widthScale)
            }
            return
        }
    }
 
    @objc func pressAOut(){
        onPressing = false
        if onFcousIndex == 0 {
            UIView.animate(withDuration: 0.2) {[weak self] in
                guard let `self` = self else { return  }
                self.sureBtn.frame =  CGRectMake(96.widthScale - 8.widthScale,
                                                 self.cancleBtn.y - 12.widthScale - 44.widthScale,
                                                 self.size.width - (96.widthScale - 8.widthScale) * 2,
                                                 44.widthScale)
            }
            return
        }
        
        if onFcousIndex == 1 {
            UIView.animate(withDuration: 0.2) {[weak self] in
                guard let `self` = self else { return  }
                self.cancleBtn.frame =  CGRectMake(96.widthScale - 8.widthScale,
                                                   self.size.height - 24.widthScale - 44.widthScale,
                                                   self.size.width - (96.widthScale - 8.widthScale) * 2,
                                                   44.widthScale)
            }
            dismiss()
            return
        }
    }
    
    @objc func pressUp(){
        guard onPressing == false else {
            print("正在按紧A/B键")
            return
        }
        if onFcousIndex != 0 {
            onFcousIndex = 0
        }
    }
    
    @objc func pressDown(){
        guard onPressing == false else {
            print("正在按紧A/B键")
            return
        }
        if onFcousIndex != 1 {
            onFcousIndex = 1
        }
    }
    
}
