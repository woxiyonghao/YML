//
//  GameEditGameNameView.swift
//  GameLoginWelcome
//
//  Created by lu on 2024/3/7.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
class GameEditGameNameView: UIView {
    let disposeBag = DisposeBag()
    let cellX:CGFloat = 252.widthScale
    let cellH:CGFloat = 60.widthScale
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
    
    var datas = [String]()
    
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

    func scrLayoutSubView(){
        titleL.frame = CGRectMake(0,
                                  0,
                                  kWidth,
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
   
    lazy var views = [GameEditGameCell]()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        scr = UIScrollView(frame: CGRectMake(0, 0, frame.width, frame.height)).then({ [weak self] in
            guard let `self` = self else { return }
            self.addSubview($0)
        })
        
        scr.addSubview(titleL)
        scrAddCells()
        scr.addSubview(saveBtn)
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
        print("onFcourIndex == \(onFcousIndex)")
        if onFcousIndex == datas.count {
            NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyAPressOut.rawValue), object: nil)
        }
        else{
            onFcousIndex = datas.count
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
}

class GameEditGameCell: UIView {
    let disposeBag = DisposeBag()
    var row = 0
    /*
     action == 0 表示进入编辑
     action == 1 表示编辑编辑中
     action == 2 表示退出编辑
     */
    //var nameTFHandler = {(action:Int,row:Int,txt:String?) in}
    
    init(){
        super.init(frame: .zero)
        addSubview(icon)
        icon.snp.makeConstraints {
            $0.left.centerY.equalToSuperview()
            $0.width.height.equalTo(36)
        }
        
        addSubview(topL)
        topL.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalTo(icon.snp.right).offset(28)
            $0.height.equalTo(20)
        }
        
        addSubview(nameTF)
        nameTF.snp.makeConstraints {
            $0.bottom.equalTo(icon)
            $0.left.equalTo(topL)
            $0.height.equalTo(20)
            $0.width.equalTo(160)
        }
        
        addSubview(line)
        line.snp.makeConstraints {
            $0.bottom.equalTo(icon)
            $0.left.equalTo(topL)
            $0.height.equalTo(1)
            $0.right.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var icon:UIImageView = {
        let i = UIImageView()
        i.layer.cornerRadius = 6
        i.layer.masksToBounds = true
        i.backgroundColor = .orange
        return i
    }()
    
    lazy var topL:UILabel = {
        let l = UILabel()
        l.backgroundColor = .clear
        l.textAlignment = .left
        l.text = "游戏名称"
        l.textColor = .hex("#999999")
        l.font = font_14(weight: .medium)
        return l
    }()
    
    lazy var nameTF:UITextField = {
        let tf = UITextField()
        tf.inputAccessoryView = UIView()
        tf.backgroundColor = .clear
        tf.textAlignment = .left
        let str:NSString = "添加用户名"
        let attr = NSMutableAttributedString.init(string: str as String)
        attr.addAttribute(NSAttributedString.Key.font, value: font_16(weight: .semibold), range: NSMakeRange(0, str.length))
        attr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.hex("#B4B4B4"), range: NSMakeRange(0, str.length))
        tf.attributedPlaceholder = attr
        tf.textColor = .hex("#ffffff")
        tf.font = font_16(weight: .semibold)
        tf.returnKeyType = .done
//        tf.rx.text.orEmpty.subscribe(onNext: {[weak self] in
//            guard let `self` = self else { return }
//            print($0)
//        }).disposed(by: disposeBag)
//        
//        tf.rx.controlEvent([.editingDidBegin])
//            .asObservable()
//            .subscribe(onNext: { [weak self] _ in
//                print("编辑开始")
//                guard let `self` = self else { return }
//            })
//            .disposed(by: disposeBag)
//        
//        // 在用户名输入框中按下 return 键
//        tf.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: {
//            [weak self] _ in
//            guard let `self` = self else { return }
//            self.nameTF.endEditing(true)
//            print("编辑结束")
//        }).disposed(by: disposeBag)
        return tf
    }()
    
    lazy var line:UIView = {
        let view = UIView()
        view.backgroundColor = .hex("#ffffff")
        return view
    }()
}


