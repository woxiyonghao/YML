//
//  GSSetterDeallocViewController.swift
//  GameSirBeyond
//
//  Created by lu on 2024/4/12.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
class GSSetterDeallocViewController: UIViewController {
    var onPressing = false
    var dismiss = {() in}
    fileprivate let disposeBag = DisposeBag()
    fileprivate var size = CGSize(width: 0, height: 0   )
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
    init(viewSize:CGSize){
        self.size = viewSize
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
        
        
        let titleL = UILabel(frame: CGRectMake(0, 20.widthScale, size.width, 30.widthScale)).then {[weak self] in
            guard let `self` = self else {return}
            self.view.addSubview($0)
            $0.text = "您确定要删除您的数据吗？"
            $0.textAlignment = .center
            $0.font = font_24(weight: .regular)
            $0.textColor = .hex("#ffffff")
        }
        
        _ = UILabel(frame: CGRectMake(60.widthScale, CGRectGetMaxY(titleL.frame) + 0.widthScale, size.width - 60.widthScale * 2, 120.widthScale)).then {[weak self] in
            guard let `self` = self else {return}
            self.view.addSubview($0)
            $0.text = "如果继续操作，与您的账户相关的数据，包括好友、聊天记录和精彩瞬间，将会被永久删除，并无法恢复。若需取消Backbone+会员资格，请前往您设备的设置并进行操作。"
            $0.numberOfLines = 0
            $0.textAlignment = .left
            $0.font = font_16(weight: .regular)
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
                self.deleteUser()
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
        print("\(self.classForCoder)   --- unit")
        unitNotis()
    }
    
    func deleteUser(){
        print("删除用户！！！！")
    }
}
// 关于手柄
extension GSSetterDeallocViewController {
    
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
            deleteUser()
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
