//
//  GSTectKeyViewController.swift
//  GameSirBeyond
//
//  Created by lu on 2024/4/16.
//

import UIKit
import Then
import KDCircularProgress
class GSTectKeyViewController: UIViewController {

    let longPressedID = "longPressed.id"
    fileprivate var screenshotLongPressedTime = ScreenshotLongPressSpaceTime
    var dismiss = {() in}
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.bm_colorGradientChange(with: CGSize(width: kWidth, height: kHeight),direction: .upwardDiagonalLine,start: .hex("#20242F"),end: .hex("#353B49"))
        
        let titleL = UILabel().then({ [weak self] in
            guard let `self` = self else {return}
            self.view.addSubview($0)
            $0.text = "按下的按钮的符号将出现在这里"
            $0.font = font_16(weight: .semibold)
            $0.textAlignment = .center
            $0.textColor = .white
            $0.frame = CGRectMake(0, 128.widthScale, kWidth, 20.widthScale)
        })
        
        let line = UIView().then({[weak self] in
            guard let `self` = self else {return}
            self.view.addSubview($0)
            $0.frame = CGRect(x: kWidth * 0.5 - 270.widthScale * 0.5, y: CGRectGetMaxY(titleL.frame) + 72.widthScale, width: 270.widthScale, height: 1)
            $0.backgroundColor = .white
        })
        
        let bottomV = UIView().then({[weak self] in
            guard let `self` = self else {return}
            self.view.addSubview($0)
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 8.widthScale
            $0.layer.masksToBounds = true
            $0.frame = CGRectMake(line.x, CGRectGetMaxY(line.frame) + 26.widthScale, line.width, 44.widthScale)
            
            let longPressL = UILabel()
            $0.addSubview(longPressL)
            longPressL.text = "长按"
            longPressL.font = font_14(weight: .medium)
            longPressL.textAlignment = .right
            longPressL.textColor = .hex("#252525")
            longPressL.sizeToFit()
            longPressL.frame = CGRectMake(60.widthScale, $0.height * 0.5 - longPressL.height * 0.5, longPressL.width, longPressL.height)
            
            let icon = UIImageView()
            icon.backgroundColor = .hex("#D9D9D9")
            $0.addSubview(icon)
            icon.frame = CGRectMake(CGRectGetMaxX(longPressL.frame) + 10.widthScale, $0.height * 0.5 - 14.widthScale, 28.widthScale, 28.widthScale)
            icon.layer.cornerRadius = 14.widthScale
            icon.layer.masksToBounds = true
            icon.image = UIImage(named: keyMenu)
            
            let keyL = UILabel()
            $0.addSubview(keyL)
            keyL.text = "键以结束测试"
            keyL.font = font_14(weight: .medium)
            keyL.textAlignment = .left
            keyL.textColor = .hex("#252525")
            keyL.sizeToFit()
            keyL.frame = CGRectMake(CGRectGetMaxX(icon.frame) + 10.widthScale, $0.height * 0.5 - longPressL.height * 0.5, keyL.width, keyL.height)
            
            $0.addSubview(self.progressView)
            self.progressView.frame = CGRectMake(icon.x - 6.widthScale, icon.y - 6.widthScale, 40.widthScale, 40.widthScale)
            $0.bringSubviewToFront(icon)
        })
        
        let flowLayout = UICollectionViewFlowLayout().then { [weak self] in
            guard let `self` = self else {return}
            $0.itemSize = CGSize(width: 40.widthScale, height: 30.widthScale)
            $0.minimumLineSpacing = 0
            $0.minimumInteritemSpacing = 0
            $0.scrollDirection = .horizontal
        }
        let collFrame = CGRectMake(line.x, CGRectGetMaxY(line.frame) - 40.widthScale - 6.widthScale, line.width, 40.widthScale)
        coll = UICollectionView.init(frame: collFrame, collectionViewLayout: flowLayout).then({ [weak self] in
            guard let `self` = self else {return}
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.delegate = self
            $0.dataSource = self
            $0.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "GSTectKeyViewController");
            if #available(iOS 10.0, *) {
                // 11.预加载
                $0.isPrefetchingEnabled = true
            }
            $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            $0.isPagingEnabled = false
            $0.isScrollEnabled = false
            self.view.addSubview($0)
        })
        
        
//        delay(interval: 1) {
//            self.progressView.animate(fromAngle: 0, toAngle: 360, duration: ScreenshotLongPressSpaceTime) { _ in
//                
//            }
//        }
        
        regisNotis()
    }
    
    deinit {
        print("\(self.classForCoder)  ---- unit")
        unitNotis()
    }
    
    lazy var progressView: KDCircularProgress! = {
         let progress = KDCircularProgress()
         progress.startAngle = -90                          // 开始位置
         progress.progressThickness = 0.35                  // 进度条的粗细
         progress.clockwise = true                         // 顺/逆时针
         progress.gradientRotateSpeed = 1                  // 彩灯闪烁进度
         progress.roundedCorners = true                    // 进度条头尾 圆 / 直
         progress.glowMode = .forward                      // 彩灯的方式
         progress.glowAmount = 0.0                         // 发光的强度
         progress.set(colors: .hex("#71F596"))// 设置进度条颜色
         progress.trackColor = .hex("#000000").withAlphaComponent(0.2) // 背景颜色
         progress.trackThickness = 0.4                    // 背景粗细
         return progress
     }()
     
    var coll:UICollectionView!
    
    let keyA = "set_tect_A"
    let keyB = "set_tect_B"
    let keyX = "set_tect_X"
    let keyY = "set_tect_Y"
    
    let keyLeft = "set_tect_Left"
    let keyRight = "set_tect_Right"
    let keyUp = "set_tect_Up"
    let keyDown = "set_tect_Down"
    
    let keyLT = "set_tect_LT"
    let keyLB = "set_tect_LB"
    let keyRT = "set_tect_RT"
    let keyRB = "set_tect_RB"
    
    let keyL3 = "set_tect_L3"
    let keyR3 = "set_tect_R3"
    
    
    let keyMenu = "set_tect_Menu"
    let keyOP = "set_tect_OP"
    
    // 这两个键目前未捕获
    let keyHome = "set_tect_Home"
    let keyScreenShot = "set_tect_Screenshot"
    
    lazy var keys = [String]()
    
}

extension GSTectKeyViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GSTectKeyViewController", for: indexPath)
        cell.backgroundColor = .clear
        var icon = cell.contentView.viewWithTag(888) as? UIImageView
        if icon == nil {
            icon = UIImageView()
            icon!.tag = 888
            icon!.backgroundColor = .clear
            cell.contentView.addSubview(icon!)
            icon!.snp.makeConstraints { make in
                make.width.height.equalTo(20.widthScale)
                make.center.equalToSuperview()
            }
        }
        icon?.image = UIImage(named: keys[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keys.count
    }
    
}
// 关于手柄
extension GSTectKeyViewController {
    
    public func unitNotis(){
        NotificationCenter.default.removeObserver(self)
    }
    
    public func regisNotis(){
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressX),
                                               name: NSNotification.Name(ControllerNotificationName.KeyXPressed.rawValue),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressY),
                                               name: NSNotification.Name(ControllerNotificationName.KeyYPressed.rawValue),
                                               object: nil)
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressA),
                                               name: NSNotification.Name(ControllerNotificationName.KeyAPressed.rawValue),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressB),
                                               name: NSNotification.Name(ControllerNotificationName.KeyBPressed.rawValue),
                                               object: nil)
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressLeft),
                                               name: NSNotification.Name(ControllerNotificationName.LeftJoystickMoveLeft.rawValue),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressRight),
                                               name: NSNotification.Name(ControllerNotificationName.LeftJoystickMoveRight.rawValue),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressUp),
                                               name: NSNotification.Name(ControllerNotificationName.LeftJoystickMoveUp.rawValue),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressDown),
                                               name: NSNotification.Name(ControllerNotificationName.LeftJoystickMoveDown.rawValue),
                                               object: nil)
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressInMenu),
                                               name: NSNotification.Name(ControllerNotificationName.KeyMenuPressIn.rawValue),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressOutMenu),
                                               name: NSNotification.Name(ControllerNotificationName.KeyMenuPressOut.rawValue),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressOption),
                                               name: NSNotification.Name(ControllerNotificationName.KeyOPPressed.rawValue),
                                               object: nil)
        
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(pressHome),
//                                               name: NSNotification.Name(ControllerNotificationName.KeyHomePressed.rawValue),
//                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressLT),
                                               name: NSNotification.Name(ControllerNotificationName.KeyLTPressed.rawValue),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressLB),
                                               name: NSNotification.Name(ControllerNotificationName.KeyLBPressed.rawValue),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressL3),
                                               name: NSNotification.Name(ControllerNotificationName.KeyL3Pressed.rawValue),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressRT),
                                               name: NSNotification.Name(ControllerNotificationName.KeyRTPressed.rawValue),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressRB),
                                               name: NSNotification.Name(ControllerNotificationName.KeyRBPressed.rawValue),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressR3),
                                               name: NSNotification.Name(ControllerNotificationName.KeyR3Pressed.rawValue),
                                               object: nil)
    }
    
    @objc func pressR3(){
        keys.append(keyR3)
        coll.reloadData()
        coll.scrollToItem(at: IndexPath(row: keys.count-1, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    @objc func pressRB(){
        keys.append(keyRB)
        coll.reloadData()
        coll.scrollToItem(at: IndexPath(row: keys.count-1, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    @objc func pressRT(){
        keys.append(keyRT)
        coll.reloadData()
        coll.scrollToItem(at: IndexPath(row: keys.count-1, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    @objc func pressL3(){
        keys.append(keyL3)
        coll.reloadData()
        coll.scrollToItem(at: IndexPath(row: keys.count-1, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    @objc func pressLB(){
        keys.append(keyLB)
        coll.reloadData()
        coll.scrollToItem(at: IndexPath(row: keys.count-1, section: 0), at: .centeredHorizontally, animated: false)
        
    }
    @objc func pressLT(){
        keys.append(keyLT)
        coll.reloadData()
        coll.scrollToItem(at: IndexPath(row: keys.count-1, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    
//    @objc func pressHome(){
//        
//        
//    }
    
    @objc func pressOption(){
        keys.append(keyOP)
        coll.reloadData()
        coll.scrollToItem(at: IndexPath(row: keys.count-1, section: 0), at: .centeredHorizontally, animated: false)
        
    }
    
    @objc func pressX(){
        keys.append(keyX)
        coll.reloadData()
        coll.scrollToItem(at: IndexPath(row: keys.count-1, section: 0), at: .centeredHorizontally, animated: false)
        
    }
    
    @objc func pressY(){
        keys.append(keyY)
        coll.reloadData()
        coll.scrollToItem(at: IndexPath(row: keys.count-1, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    
    @objc func pressA(){
        keys.append(keyA)
        coll.reloadData()
        coll.scrollToItem(at: IndexPath(row: keys.count-1, section: 0), at: .centeredHorizontally, animated: false)
    }
  
    
    
    @objc func pressB(){
        keys.append(keyB)
        coll.reloadData()
        let collW = coll.frame.width
        coll.scrollToItem(at: IndexPath(row: keys.count-1, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    @objc func pressLeft(){
        keys.append(keyLeft)
        coll.reloadData()
        coll.scrollToItem(at: IndexPath(row: keys.count-1, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    @objc func pressRight(){
        keys.append(keyRight)
        coll.reloadData()
        coll.scrollToItem(at: IndexPath(row: keys.count-1, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    @objc func pressUp(){
        keys.append(keyUp)
        coll.reloadData()
        coll.scrollToItem(at: IndexPath(row: keys.count-1, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    @objc func pressDown(){
        keys.append(keyDown)
        coll.reloadData()
        coll.scrollToItem(at: IndexPath(row: keys.count-1, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    @objc func pressInMenu(){
        // 开始计时
        progressView.animate(fromAngle: 0, toAngle: 360, duration: ScreenshotLongPressSpaceTime) { _ in
            
        }
        TimerManger.share.cancelTaskWithId(longPressedID)
        let task = TimeTask.init(taskId: longPressedID, interval: 10) {[weak self] in
            guard let `self` = self else {return}
            self.screenshotLongPressedTime -= 1.0/5.0
            if self.screenshotLongPressedTime < 0 {
                delay(interval: 0.2) { // 延迟一下，进度条刚好还没跑完
                    TimerManger.share.cancelTaskWithId(self.longPressedID)
                    self.screenshotLongPressedTime = ScreenshotLongPressSpaceTime
                    self.dismiss()
                }
            }
        }
        TimerManger.share.runTask(task: task)
    }
    
    @objc func pressOutMenu(){
        keys.append(keyMenu)
        coll.reloadData()
        coll.scrollToItem(at: IndexPath(row: keys.count-1, section: 0), at: .centeredHorizontally, animated: false)
        screenshotLongPressedTime = ScreenshotLongPressSpaceTime
        TimerManger.share.cancelTaskWithId(longPressedID)
        progressView.stopAnimation()
    }
}
