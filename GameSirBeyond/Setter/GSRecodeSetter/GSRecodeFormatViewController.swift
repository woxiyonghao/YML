//
//  GSRecodeFormatViewController.swift
//  GameSirBeyond
//
//  Created by lu on 2024/4/16.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
class GSRecodeFormatViewController: UIViewController {
    var dismiss = {() in}
    var onPressing = false
    fileprivate var size = CGSizeMake(0, 0)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.bm_colorGradientChange(with: size,direction: .upwardDiagonalLine,start: .hex("#20242F"),end: .hex("#353B49"))
        
        formatView = GSSetterRightBaseView(frame: CGRectMake(0, 0,size.width, size.height),style: .recodeFormat)
        view.addSubview(formatView)
        formatView.datas = datas
        
        regisNotisWithoutPressB()
    }
    lazy var datas = [
        GSSetterMenuOPModel(title: "高效（HEVC）",id: 0),
        GSSetterMenuOPModel(title: "兼容性最好（H.264）",id: 1),
    ]
    init(viewSize:CGSize){
        self.size = viewSize
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   

    deinit {
        unitNotis()
        print("\(self.classForCoder) --- deinit")
    }
    var formatView:GSSetterRightBaseView!
}
// 关于手柄
extension GSRecodeFormatViewController {
    
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
        
        let last = datas.first { return $0.enter}
        guard last != nil else{
            datas[0].select = false
            datas[0].enter = true
            if let firstCell = formatView.scrSubviews[1] as? GSSetterRightCell{
                firstCell.fullModel(model: datas[0], style: .recodeFormat)
            }
            return
        }
        datas.forEach {
            $0.enter = false
            $0.select = false
        }
        last?.enter = true
        last?.select = false
        for i in 1..<formatView.scrSubviews.count - 1{
            if let firstCell = formatView.scrSubviews[i] as? GSSetterRightCell{
                firstCell.fullModel(model: datas[i-1], style: .recodeFormat)
            }
        }
    }
 
    @objc func pressAOut(){
        onPressing = false
        let last = datas.first { return $0.enter}
        guard last != nil else{
            datas[0].select = true
            datas[0].enter = true
            if let firstCell = formatView.scrSubviews[1] as? GSSetterRightCell{
                firstCell.fullModel(model: datas[0], style: .recodeFormat)
            }
            return
        }
        
        datas.forEach {
            $0.enter = false
            $0.select = false
        }
        last?.enter = true
        last?.select = true
        for i in 1..<formatView.scrSubviews.count - 1{
            if let firstCell = formatView.scrSubviews[i] as? GSSetterRightCell{
                firstCell.fullModel(model: datas[i-1], style: .recodeFormat)
            }
        }
    }
    
    @objc func pressUp(){
        guard onPressing == false else {
            print("正在按紧A/B键")
            return
        }
        var index = -1
        for i in 0..<datas.count {
            if datas[i].enter {
                index = i
                break
            }
        }
        if index == -1 || index == 0  {
            return
        }
        datas.forEach { $0.enter = false}
        datas[index - 1].enter = true
        for i in 1..<formatView.scrSubviews.count-1 {
            if let cell = formatView.scrSubviews[i] as? GSSetterRightCell{
                cell.fullModel(model: datas[i-1], style: .recodeFormat)
            }
        }
    }
    
    @objc func pressDown(){
        guard onPressing == false else {
            print("正在按紧A/B键")
            return
        }
        var index = -1
        for i in 0..<datas.count {
            if datas[i].enter {
                index = i
                break
            }
        }
        if index == datas.count - 1 {return}
        datas.forEach { $0.enter = false}
        print(index)
        datas[index + 1].enter = true
        for i in 1..<formatView.scrSubviews.count-1 {
            if let cell = formatView.scrSubviews[i] as? GSSetterRightCell{
                cell.fullModel(model: datas[i-1], style: .recodeFormat)
            }
        }
    }
    
}
