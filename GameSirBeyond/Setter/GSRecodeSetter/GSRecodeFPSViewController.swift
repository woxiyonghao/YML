//
//  GSRecodeFPSViewController.swift
//  GameSirBeyond
//
//  Created by lu on 2024/4/16.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
class GSRecodeFPSViewController: UIViewController {
    fileprivate var size = CGSizeMake(0, 0)
    var onPressing = false
    var dismiss = {() in}
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.bm_colorGradientChange(with: size,direction: .upwardDiagonalLine,start: .hex("#20242F"),end: .hex("#353B49"))
        
        recodeView = GSSetterRightBaseView(frame: CGRectMake(0, 0,size.width, size.height),style: .recodeFPS)
        recodeView.scr.isScrollEnabled = true
        view.addSubview(recodeView)
        recodeView.datas = recodeFPS
        
        regisNotisWithoutPressB()
    }
    
    init(viewSize:CGSize){
        self.size = viewSize
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    lazy var recodeFPS = [
        GSSetterMenuOPModel(title: "1080P 60 FPS",id: 0),
        GSSetterMenuOPModel(title: "1080P 30 FPS",id: 1),
        GSSetterMenuOPModel(title: "720P 30 FPS",id: 2),
    ]
    var recodeView:GSSetterRightBaseView!
    
    deinit {
        print("\(self.classForCoder) ----deinit")
        unitNotis()
    }
}


// 关于手柄
extension GSRecodeFPSViewController {
    
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
        
        let last = recodeFPS.first { return $0.enter}
        guard last != nil else{
            recodeFPS[0].select = false
            recodeFPS[0].enter = true
            if let firstCell = recodeView.scrSubviews[1] as? GSSetterRightCell{
                firstCell.fullModel(model: recodeFPS[0], style: .recodeFPS)
            }
            return
        }
        recodeFPS.forEach {
            $0.enter = false
            $0.select = false
        }
        last?.enter = true
        last?.select = false
        for i in 1..<recodeView.scrSubviews.count - 1{
            if let firstCell = recodeView.scrSubviews[i] as? GSSetterRightCell{
                firstCell.fullModel(model: recodeFPS[i-1], style: .recodeFPS)
            }
        }
    }
 
    @objc func pressAOut(){
        onPressing = false
        let last = recodeFPS.first { return $0.enter}
        guard last != nil else{
            recodeFPS[0].select = true
            recodeFPS[0].enter = true
            if let firstCell = recodeView.scrSubviews[1] as? GSSetterRightCell{
                firstCell.fullModel(model: recodeFPS[0], style: .recodeFPS)
            }
            return
        }
        
        recodeFPS.forEach {
            $0.enter = false
            $0.select = false
        }
        last?.enter = true
        last?.select = true
        for i in 1..<recodeView.scrSubviews.count - 1{
            if let firstCell = recodeView.scrSubviews[i] as? GSSetterRightCell{
                firstCell.fullModel(model: recodeFPS[i-1], style: .recodeFPS)
            }
        }
    }
    
    @objc func pressUp(){
        guard onPressing == false else {
            print("正在按紧A/B键")
            return
        }
        var index = -1
        for i in 0..<recodeFPS.count {
            if recodeFPS[i].enter {
                index = i
                break
            }
        }
        if index == -1 || index == 0  {
            return
        }
        recodeFPS.forEach { $0.enter = false}
        recodeFPS[index - 1].enter = true
        for i in 1..<recodeView.scrSubviews.count-1 {
            if let cell = recodeView.scrSubviews[i] as? GSSetterRightCell{
                cell.fullModel(model: recodeFPS[i-1], style: .recodeFPS)
            }
        }
    }
    
    @objc func pressDown(){
        guard onPressing == false else {
            print("正在按紧A/B键")
            return
        }
        var index = -1
        for i in 0..<recodeFPS.count {
            if recodeFPS[i].enter {
                index = i
                break
            }
        }
        if index == recodeFPS.count - 1 {return}
        recodeFPS.forEach { $0.enter = false}
        print(index)
        recodeFPS[index + 1].enter = true
        for i in 1..<recodeView.scrSubviews.count-1 {
            if let cell = recodeView.scrSubviews[i] as? GSSetterRightCell{
                cell.fullModel(model: recodeFPS[i-1], style: .recodeFPS)
            }
        }
    }
    
}
