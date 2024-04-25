//
//  GSSetterEditGameNameViewController.swift
//  GameSirBeyond
//
//  Created by lu on 2024/4/12.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
class GSSetterEditGameNameViewController: UIViewController {
    var onPressing = false
    fileprivate var size = CGSize(width: 0, height: 0)
    fileprivate let disposeBag = DisposeBag()
    fileprivate let cellX:CGFloat = 60.widthScale
    fileprivate let cellH:CGFloat = 60.widthScale
    var datas = [String]()
    lazy var views = [GameEditGameCell]()
    public func prev(){
        guard onFcousIndex > 0 && onFcousIndex <= datas.count else {
            return
        }
        onFcousIndex -= 1
    }
    
    public func next(){
        guard onFcousIndex >= 0 else {
            onFcousIndex = 0
            return
        }
        if onFcousIndex == datas.count {
            return
        }
        onFcousIndex += 1
    }
    
    var activyCell:GameEditGameCell? {
        didSet {
            if let cell = activyCell {
                if cell.nameTF.isEditing == false {
                    cell.nameTF.becomeFirstResponder()
                }
            }
        }
    }
    var onFcousIndex = -1 {
        didSet{
            print(onFcousIndex)
            saveBtn.setTitleColor(onFcousIndex == datas.count ? .hex("#252525"):.hex("#CCCCCC"), for: .normal)
            saveBtn.backgroundColor = onFcousIndex == datas.count ? .hex("#ffffff"):.hex("#3D3D3D")
            if onFcousIndex == datas.count {
                let needAnim = self.saveBtn.width != self.scr.width - 2 * (self.cellX + 16.widthScale)
                if needAnim {
                    UIView.animate(withDuration: 0.25) {
                        self.saveBtn.x = self.cellX + 16.widthScale
                        self.saveBtn.width = self.scr.width - 2 * (self.cellX + 16.widthScale)
                    }
                }
                if activyCell != nil {
                    activyCell?.nameTF.endEditing(true)
                    activyCell = nil
                }
            }
            else{
                
                let needAnim = self.saveBtn.width != self.scr.width - 2 * (self.cellX + 32.widthScale)
                if needAnim {
                    UIView.animate(withDuration: 0.25) {
                        self.saveBtn.x = self.cellX + 32.widthScale
                        self.saveBtn.width = self.scr.width - 2 * (self.cellX + 32.widthScale)
                    }
                }
                activyCell = views[onFcousIndex]
                if onFcousIndex <= views.count - 3 {
                    scr.setContentOffset(CGPoint(x: 0, y: activyCell!.y - cellH), animated: true)
                }
            }
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .hex("#20242F")
        view.layer.cornerRadius = 8.widthScale
        view.layer.masksToBounds = true
        
        scr = UIScrollView(frame: CGRectMake(0, 0, size.width, size.height)).then({ [weak self] in
            guard let `self` = self else { return }
            self.view.addSubview($0)
        })
        
        scr.addSubview(titleL)
        scrAddCells()
        scr.addSubview(saveBtn)
        regisNotisWithoutPressB()
    }
    
    public func scrAddCells(){
        
        for view in views {
            view.removeFromSuperview()
        }
        datas.removeAll()
        
        for i in 0..<20{
            datas.append("11")
            let cell = GameEditGameCell()
            cell.topL.text = "游戏名【\(i)】"
            views.append(cell)
            scr.addSubview(cell)
            
            cell.row = i
            
            cell.nameTF.rx.text.orEmpty.subscribe(onNext: {[weak self] in
                guard let `self` = self else { return }
                print($0)
            }).disposed(by: disposeBag)
            
            cell.nameTF.rx.controlEvent([.editingDidBegin])
                .asObservable()
                .subscribe(onNext: { [weak self] _ in
                    print("编辑开始")
                    guard let `self` = self else { return }
                    self.onFcousIndex = cell.row
                })
                .disposed(by: disposeBag)
            
            // 在用户名输入框中按下 return 键
//            cell.nameTF.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: {
//                [weak self] _ in
//                guard let `self` = self else { return }
//                print("编辑结束")
//            }).disposed(by: disposeBag)
        }
        
        scrLayoutSubView()
    }
    func scrLayoutSubView(){
        titleL.frame = CGRectMake(0,
                                  0,
                                  size.width,
                                  105.widthScale)
        var last:UIView = titleL
        let titleLMaxY = CGRectGetMaxY(titleL.frame)
        for i in 0..<views.count {
            let cell = views[i]
            cell.frame = CGRectMake(cellX,
                                    titleLMaxY + CGFloat(i) * cellH,
                                    scr.width - 2 * cellX,
                                    cellH)
            last = cell
        }
        
        saveBtn.frame = CGRectMake(cellX + 32.widthScale, CGRectGetMaxY(last.frame), scr.width - 2 * (cellX + 32.widthScale), 42.widthScale)
        last = saveBtn
        scr.contentSize = CGSizeMake(0, CGRectGetMaxY(last.frame) + 30.widthScale)
    }
    lazy var saveBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("保存设置", for: .normal)
        btn.setTitleColor(.hex("#CCCCCC"), for: .normal)
        btn.titleLabel?.font = font_14(weight: .bold)
        btn.layer.cornerRadius = 8
        btn.layer.masksToBounds = true
        btn.backgroundColor = .hex("#3D3D3D")
        btn.addTarget(self, action: #selector(saveBtnAction), for: .touchUpInside)
        return btn
    }()
    
    @objc func saveBtnAction(){
        if onFcousIndex == datas.count {
            //NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyAPressOut.rawValue), object: nil)
        }
        else{
            onFcousIndex = datas.count
        }
    }
    
    lazy var titleL:UIView = {
        let t = UIView()
        t.backgroundColor = .clear
        let label = UILabel()
        t.addSubview(label)
        label.text = "我的游戏"
        label.textColor = .hex("#ffffff")
        label.font = font_18(weight: .semibold)
        label.textAlignment = .center
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20.widthScale)
        }
        return t
    }()
    
    var scr:UIScrollView!
    init(viewSize:CGSize){
        self.size = viewSize
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        unitNotis()
    }

}
// 关于手柄
extension GSSetterEditGameNameViewController {
    
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
        
        if onFcousIndex == datas.count {
            UIView.animate(withDuration: 0.15) {[weak self] in
                guard let `self` = self else {return}
                self.saveBtn.transform3D = CATransform3DScale(CATransform3DIdentity, Transform3DScale, Transform3DScale, Transform3DScale)
                
            } completion: { _ in
            }
            return
        }
    }
 
    @objc func pressAOut(){
        onPressing = false
        if onFcousIndex == datas.count {
            UIView.animate(withDuration: 0.15) {[weak self] in
                guard let `self` = self else {return}
                self.saveBtn.transform3D = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
                
            } completion: { _ in
                self.saveBtnAction()
            }
        }
        else {
            if let cell = activyCell{
                cell.nameTF.endEditing(true)
            }
        }
    }
    
    @objc func pressUp(){
        guard onPressing == false else {
            print("正在按紧A/B键")
            return
        }
        prev()
    }
    
    @objc func pressDown(){
        guard onPressing == false else {
            print("正在按紧A/B键")
            return
        }
        next()
    }
    
}
