//
//  GSJoyconDetailViewController.swift
//  GameSirBeyond
//
//  Created by lu on 2024/4/15.
//

import UIKit
import RxSwift
import RxCocoa
class GSJoyconDetailViewController: UIViewController {

    var onPressing = false
    private var size = CGSize(width: 0, height: 0)
    var dismiss = {() in}
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.bm_colorGradientChange(with: size,direction: .upwardDiagonalLine,start: .hex("#20242F"),end: .hex("#353B49"))
        
        joyconDetailView = GSSetterRightBaseView(frame: CGRectMake(0, 0,size.width, size.height),style: .joyconDetail)
        view.addSubview(joyconDetailView)
        
        joyconDetailView.datas = jonconDetailDatas
        
        regisNotisWithoutPressB()
    }
    
    lazy var jonconDetailDatas = [
        GSSetterMenuOPModel(title: "名称",subtitle: UserDefaults.standard.value(forKey: gamepadNameKey) as? String ?? "",id: 0),
        GSSetterMenuOPModel(title: "型号",subtitle: "BB-02-W-S",id: 1),
        GSSetterMenuOPModel(title: "序列号",subtitle: "HJ64738HJK",id: 2),
        GSSetterMenuOPModel(title: "固件版本",subtitle: "",id: 3),
    ]
    
    init(viewSize:CGSize){
        self.size = viewSize
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var joyconDetailView:GSSetterRightBaseView!
    
    deinit {
        print("\(self.classForCoder) ---  deinit")
        unitNotis()
    }
}
// 关于手柄
extension GSJoyconDetailViewController {
    
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
        
        let last = jonconDetailDatas.first { return $0.enter && $0.select}
        guard last != nil else{
            jonconDetailDatas[0].select = true
            jonconDetailDatas[0].enter = false
            if let firstCell = joyconDetailView.scrSubviews[1] as? GSSetterRightCell{
                firstCell.fullModel(model: jonconDetailDatas[0], style: .joyconDetail)
            }
            return
        }
        last!.select = false
        last!.enter = true
        guard let lastIndex = jonconDetailDatas.firstIndex(of: last!) else { return }
        if let firstCell = joyconDetailView.scrSubviews[lastIndex + 1] as? GSSetterRightCell{
            firstCell.fullModel(model: last!, style: .joyconDetail)
        }
    }
 
    @objc func pressAOut(){
        onPressing = false
        let last = jonconDetailDatas.first { return $0.enter}
        guard last != nil else{
            jonconDetailDatas[0].select = true
            jonconDetailDatas[0].enter = true
            if let firstCell = joyconDetailView.scrSubviews[1] as? GSSetterRightCell{
                firstCell.fullModel(model: jonconDetailDatas[0], style: .joyconDetail)
            }
            return
        }
        last!.select = true
        last!.enter = true
        guard let lastIndex = jonconDetailDatas.firstIndex(of: last!) else { return }
        if let firstCell = joyconDetailView.scrSubviews[lastIndex + 1] as? GSSetterRightCell{
            firstCell.fullModel(model: last!, style: .joyconDetail)
        }
    }
    
    @objc func pressUp(){
        guard onPressing == false else {
            print("正在按紧A/B键")
            return
        }
       
        let last = jonconDetailDatas.first { return $0.select && $0.enter }
        guard last != nil else{ 
            jonconDetailDatas[0].select = true
            jonconDetailDatas[0].enter = true
            if let firstCell = joyconDetailView.scrSubviews[1] as? GSSetterRightCell{
                firstCell.fullModel(model: jonconDetailDatas[0], style: .joyconDetail)
            }
            return
        }
        guard let lastIndex = jonconDetailDatas.firstIndex(of: last!) else { return }
        guard lastIndex != 0 else { return }
        last!.enter = false
        last!.select = false
        let nextIndex  = lastIndex - 1 < 0 ? 0 : lastIndex - 1
        jonconDetailDatas[nextIndex].select = true
        jonconDetailDatas[nextIndex].enter = true
        
        if let lastCell = joyconDetailView.scrSubviews[lastIndex + 1] as? GSSetterRightCell,
           let nextCell = joyconDetailView.scrSubviews[nextIndex + 1] as? GSSetterRightCell{
            lastCell.fullModel(model: last!, style: .joyconDetail)
            nextCell.fullModel(model: jonconDetailDatas[nextIndex], style: .joyconDetail)
        }
        
    }
    
    @objc func pressDown(){
        guard onPressing == false else {
            print("正在按紧A/B键")
            return
        }
        let last = jonconDetailDatas.first { return $0.select && $0.enter }
        guard last != nil else{
            jonconDetailDatas[0].select = true
            jonconDetailDatas[0].enter = true
            if let firstCell = joyconDetailView.scrSubviews[1] as? GSSetterRightCell{
                firstCell.fullModel(model: jonconDetailDatas[0], style: .joyconDetail)
            }
            return
        }
        guard let lastIndex = jonconDetailDatas.firstIndex(of: last!) else { return }
        guard lastIndex != jonconDetailDatas.count - 1 else { return }
        last!.enter = false
        last!.select = false
        let nextIndex  = lastIndex + 1 > jonconDetailDatas.count - 1 ? jonconDetailDatas.count - 1 : lastIndex + 1
        jonconDetailDatas[nextIndex].select = true
        jonconDetailDatas[nextIndex].enter = true
        
        if let lastCell = joyconDetailView.scrSubviews[lastIndex + 1] as? GSSetterRightCell,
           let nextCell = joyconDetailView.scrSubviews[nextIndex + 1] as? GSSetterRightCell{
            lastCell.fullModel(model: last!, style: .joyconDetail)
            nextCell.fullModel(model: jonconDetailDatas[nextIndex], style: .joyconDetail)
        }
    }
    
}
