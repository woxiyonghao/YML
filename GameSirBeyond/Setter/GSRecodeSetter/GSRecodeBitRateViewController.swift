//
//  GSRecodeBitRateViewController.swift
//  GameSirBeyond
//
//  Created by lu on 2024/4/16.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
class GSRecodeBitRateViewController: UIViewController {

    var dismiss = {() in}
    var onPressing = false
    fileprivate var size = CGSizeMake(0, 0)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.bm_colorGradientChange(with: size,direction: .upwardDiagonalLine,start: .hex("#20242F"),end: .hex("#353B49"))
        
        bitRateView = GSSetterRightBaseView(frame: CGRectMake(0, 0,size.width, size.height),style: .recodeBitRate)
        view.addSubview(bitRateView)
        bitRateView.datas = datas
        regisNotisWithoutPressB()
    }
    
    init(viewSize:CGSize){
        self.size = viewSize
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   

    var bitRateView:GSSetterRightBaseView!
    
    
    lazy var datas = [
        GSSetterMenuOPModel(title: "自动（推荐)",id: 0),
        GSSetterMenuOPModel(title: "30 Mbps" ,id: 1),
        GSSetterMenuOPModel(title: "24 Mbps" ,id: 2),
        GSSetterMenuOPModel(title: "20 Mbps" ,id: 3),
        GSSetterMenuOPModel(title: "16 Mbps" ,id: 4),
        GSSetterMenuOPModel(title: "10 Mbps" ,id: 5),
    ]

    
    deinit {
        print("\(self.classForCoder) --- deinit")
        unitNotis()
    }
}
// 关于手柄
extension GSRecodeBitRateViewController {
    
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
            if let firstCell = bitRateView.scrSubviews[1] as? GSSetterRightCell{
                firstCell.fullModel(model: datas[0], style: .recodeBitRate)
            }
            return
        }
        datas.forEach {
            $0.enter = false
            $0.select = false
        }
        last?.enter = true
        last?.select = false
        for i in 1..<bitRateView.scrSubviews.count - 1{
            if let firstCell = bitRateView.scrSubviews[i] as? GSSetterRightCell{
                firstCell.fullModel(model: datas[i-1], style: .recodeBitRate)
            }
        }
    }
 
    @objc func pressAOut(){
        onPressing = false
        let last = datas.first { return $0.enter}
        guard last != nil else{
            datas[0].select = true
            datas[0].enter = true
            if let firstCell = bitRateView.scrSubviews[1] as? GSSetterRightCell{
                firstCell.fullModel(model: datas[0], style: .recodeBitRate)
            }
            return
        }
        
        datas.forEach {
            $0.enter = false
            $0.select = false
        }
        last?.enter = true
        last?.select = true
        for i in 1..<bitRateView.scrSubviews.count - 1{
            if let firstCell = bitRateView.scrSubviews[i] as? GSSetterRightCell{
                firstCell.fullModel(model: datas[i-1], style: .recodeBitRate)
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
        for i in 1..<bitRateView.scrSubviews.count-1 {
            if let cell = bitRateView.scrSubviews[i] as? GSSetterRightCell{
                cell.fullModel(model: datas[i-1], style: .recodeBitRate)
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
        for i in 1..<bitRateView.scrSubviews.count-1 {
            if let cell = bitRateView.scrSubviews[i] as? GSSetterRightCell{
                cell.fullModel(model: datas[i-1], style: .recodeBitRate)
            }
        }
    }
    
}
