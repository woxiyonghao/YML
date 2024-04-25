//
//  GSNewGuideViewController.swift
//  GameSirBeyond
//
//  Created by lu on 2024/4/16.
//

import UIKit
import Then
/*
 * backbone的顺序是
 * 壳 1
 * 炫耀1-2
 * 分享高光时刻
 * 在AppStore
 * 在任何地方藏玩
 * 没有主机
 * 您准备好了
 */
class GSNewGuideViewController: UIViewController {

    fileprivate let longPressedID = "longPressed.id"
    fileprivate var screenshotLongPressedTime = ScreenshotLongPressSpaceTime
    var dismiss = {() in}
    var onPressing = false
    var menuAgainFlag = false // flag:解决长按截图，松开时的bug。
    fileprivate var scrIndex:Int {
        return Int(scr.contentOffset.y / kHeight)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.bm_colorGradientChange(with: CGSize(width: kWidth, height: kHeight),direction: .upwardDiagonalLine,start: .hex("#20242F"),end: .hex("#353B49"))
        
        scr = UIScrollView().then({[weak self] in
            guard let `self` = self else {return}
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            self.view.addSubview($0)
            $0.frame = CGRectMake(0, 0, kWidth, kHeight)
            $0.contentInsetAdjustmentBehavior = .never
            $0.isPagingEnabled = true
            $0.bounces = false
        })
        
        initScrSubviews()
        
        regisNotis()
    }
    
    var scr:UIScrollView!
    func initScrSubviews(){
        scr.addSubview(shellView)
        shellView.frame = CGRectMake(0, 0, scr.width, scr.height)
        
        scr.addSubview(showView)
        showView.frame = CGRectMake(0, scr.height, scr.width, scr.height)
        
        scr.addSubview(shareIntroView)
        shareIntroView.frame = CGRectMake(0, scr.height * 2, scr.width, scr.height)
        
        scr.addSubview(appStoreView)
        appStoreView.frame = CGRectMake(0, scr.height * 3, scr.width, scr.height)
        
        scr.addSubview(shellFourView)
        shellFourView.frame = CGRectMake(0, scr.height * 4, scr.width, scr.height)
        
        scr.addSubview(shellThreeView)
        shellThreeView.frame = CGRectMake(0, scr.height * 5, scr.width, scr.height)
        
        scr.addSubview(shellFiveView)
        shellFiveView.frame = CGRectMake(0, scr.height * 6, scr.width, scr.height)
        
        scr.contentSize = CGSizeMake(0, 7 * scr.height)
        
        
        shellView.backBtn.backEnterHandler = {[weak self] in
            guard let `self` = self else { return }
            self.onPressingB()
        }
        shellView.backBtn.backHandler = {[weak self] in
            guard let `self` = self else { return }
            self.pressBOut()
        }
        
        showView.backBtn.backEnterHandler = {[weak self] in
            guard let `self` = self else { return }
            self.onPressingB()
        }
        showView.backBtn.backHandler = {[weak self] in
            guard let `self` = self else { return }
            self.pressBOut()
        }
        
        shareIntroView.backBtn.backEnterHandler = {[weak self] in
            guard let `self` = self else { return }
            self.onPressingB()
        }
        shareIntroView.backBtn.backHandler = {[weak self] in
            guard let `self` = self else { return }
            self.pressBOut()
        }
        
        
        appStoreView.backBtn.backEnterHandler = {[weak self] in
            guard let `self` = self else { return }
            self.onPressingB()
        }
        appStoreView.backBtn.backHandler = {[weak self] in
            guard let `self` = self else { return }
            self.pressBOut()
        }
        
        
        shellFourView.backBtn.backEnterHandler = {[weak self] in
            guard let `self` = self else { return }
            self.onPressingB()
        }
        shellFourView.backBtn.backHandler = {[weak self] in
            guard let `self` = self else { return }
            self.pressBOut()
        }
        
        shellThreeView.backBtn.backEnterHandler = {[weak self] in
            guard let `self` = self else { return }
            self.onPressingB()
        }
        shellThreeView.backBtn.backHandler = {[weak self] in
            guard let `self` = self else { return }
            self.pressBOut()
        }
    }
    
    lazy var shellView:GameShellView = {
        let view = GameShellView().then {
            $0.backgroundColor = .hex("#252525")
            //$0.backBtn.isHidden = true
            $0.backBtn.anim = false
        }
        return view
    }()
 
    // 您可以向大家炫耀
    lazy var showView:GameIntroduceView = {
        let view = GameIntroduceView(idx: 1).then {
            $0.backgroundColor = .black
            //$0.backBtn.isHidden = true
            $0.backBtn.anim = false
        }
        return view
    }()
    
    
    // 分享高光时刻
    lazy var shareIntroView:GameIntroduceView = {
        let view = GameIntroduceView(idx: 0).then {
            $0.backgroundColor = .black
            //$0.backBtn.isHidden = true
            $0.backBtn.anim = false
        }
        return view
    }()
    
    // 在AppStore
    lazy var appStoreView:GSGuideAppStoreView = {
        let view = GSGuideAppStoreView()
        view.backgroundColor = .hex("#252525")
        view.backBtn.anim = false
        return view
    }()
    
    // 在任何地方藏玩
    lazy var shellFourView:GameShellFourView = {
        let view = GameShellFourView().then {
            $0.backgroundColor = .hex("#252525")
            //$0.backBtn.isHidden = true
            $0.backBtn.anim = false
        }
        return view
    }()
    
    // 没有游戏主机
    lazy var shellThreeView:GameShellThreeView = {
        let view = GameShellThreeView().then {
            $0.backgroundColor = .hex("#252525")
            //$0.backBtn.isHidden = true
            $0.backBtn.anim = false
        }
        return view
    }()
    
    //您准备好了
    lazy var shellFiveView:GameShellFiveView = {
        let view = GameShellFiveView().then {
            $0.backgroundColor = .hex("#252525")
            $0.backBtn.isHidden = true
        }
        return view
    }()
    
    deinit {
        print("\(self.classForCoder)  --- deinit")
        unitNotis()
    }
    
    class GSGuideAppStoreView:UIView {
         init(){
             super.init(frame: .zero)
             addSubview(icon)
             icon.snp.makeConstraints {
                 $0.right.top.bottom.equalToSuperview()
                 $0.width.equalToSuperview().multipliedBy(0.5)
             }
             
             addSubview(titleL)
             titleL.snp.makeConstraints {
                 $0.left.equalToSuperview().offset(52.widthScale)
                 $0.right.equalTo(self.snp.centerX).offset(-52.widthScale)
                 $0.top.equalToSuperview().offset(98.widthScale)
             }
             addSubview(applyBtn)
             applyBtn.snp.makeConstraints {
                 $0.left.equalTo(titleL)
                 $0.right.equalTo(self.snp.centerX).offset(-80.widthScale)
                 $0.top.equalTo(titleL.snp.bottom).offset(16.widthScale)
                 $0.height.equalTo(44.widthScale)
             }
             addSubview(backBtn)
             backBtn.snp.remakeConstraints {
                 $0.right.equalToSuperview().offset(-30.widthScale)
                 $0.bottom.equalToSuperview().offset(-30.widthScale)
                 $0.width.equalTo(76.widthScale)
                 $0.height.equalTo(40.widthScale)
             }
         }
        
        lazy var backBtn:GameBackKeyBtn = {
            let btn = GameBackKeyBtn().then {
                $0.label.textColor = .hex("#ffffff")
                $0.icon.image = UIImage(named: "ic-B-clear")
                $0.btn.layer.cornerRadius = 20.widthScale
                $0.btn.layer.masksToBounds = true
                $0.anim = true
            }
            return btn
        }()
        
         required init?(coder: NSCoder) {
             fatalError("init(coder:) has not been implemented")
         }
         
         
         lazy var icon:UIImageView = {
             let img = UIImageView()
             img.backgroundColor = .orange
             return img
         }()
         lazy var titleL:UILabel = {
             let label = UILabel().then {
                 $0.textAlignment = .left
                 $0.font = font_24(weight: .semibold)
                 $0.textColor = .hex("#ffffff")
                 $0.text = "在App Store 的游戏标签中\n查找支持该游戏手柄的游\n戏。这些游戏会显示这个图\n标。"
                 $0.numberOfLines = 4
             }
             return label
         }()
      
         
         lazy var applyBtn:UIButton = {
             let btn = UIButton().then {
                 $0.backgroundColor = .hex("#ffffff")
                 $0.layer.cornerRadius = 8.widthScale
                 $0.layer.masksToBounds = true
                 
                 let label = UILabel()
                 label.text = "ok,明白了!"
                 label.font = font_14(weight: .medium)
                 label.textColor = .hex("#252525")
                 label.textAlignment = .center
                 $0.addSubview(label)
                 label.snp.makeConstraints { make in
                     make.centerY.equalToSuperview()
                     make.centerX.equalToSuperview().offset(20.widthScale)
                 }
                 
                 let icon = UIImageView()
                 icon.backgroundColor = .clear
                 icon.image = UIImage(named: "ic-A")
                 $0.addSubview(icon)
                 icon.snp.makeConstraints { make in
                     make.centerY.equalToSuperview()
                     make.height.width.equalTo(20.widthScale)
                     make.right.equalTo(label.snp.left).offset(-8.widthScale)
                 }
             }
             btn.addTarget(self, action: #selector(enter), for: .touchDown)
             btn.addTarget(self, action: #selector(ok), for: .touchUpInside)
             btn.addTarget(self, action: #selector(ok), for: .touchDragExit)
             return btn
         }()
        
         @objc func ok(){
             NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyAPressOut.rawValue), object: nil)
         }
        @objc func enter(){
            NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyAPressIn.rawValue), object: nil)
        }
    }

}


// 关于手柄
extension GSNewGuideViewController {
    
    public func unitNotis(){
        NotificationCenter.default.removeObserver(self)
    }
 
    public func regisNotis(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onPressingA),
                                               name: NSNotification.Name(ControllerNotificationName.KeyAPressIn.rawValue),
                                               object: nil)
        
     
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressAOut),
                                               name: NSNotification.Name(ControllerNotificationName.KeyAPressOut.rawValue),
                                               object: nil)
   
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onPressingB),
                                               name: NSNotification.Name(ControllerNotificationName.KeyBPressIn.rawValue),
                                               object: nil)
        
     
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressBOut),
                                               name: NSNotification.Name(ControllerNotificationName.KeyBPressOut.rawValue),
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
                                               selector: #selector(pressOutOption),
                                               name: NSNotification.Name(ControllerNotificationName.KeyOPPressed.rawValue),
                                               object: nil)
    }

    @objc func onPressingA(){
        onPressing = true
        print("onPressingA ---- \(scrIndex) ")
        let index = scrIndex
        if index == 0 {
            shellView.setNeedsLayout()
            shellView.applyBtn.snp.remakeConstraints {
                $0.left.equalTo(shellView.titleL).offset(16.widthScale)
                $0.right.equalTo(shellView.titleL).offset(-16.widthScale)
                $0.top.equalTo(shellView.subtitleL.snp.bottom).offset(24.widthScale)
                $0.height.equalTo(50.widthScale)
            }
            UIView.animate(withDuration: 0.15) {
                self.shellView.layoutIfNeeded()
            }
            return
        }
        
        if index == 1 {
            guard showView.introduceState == .doneRecode else {
                return
            }
            showView.setNeedsLayout()
            showView.continueBtn.snp.remakeConstraints{
                $0.left.equalTo(self.showView.longPassView).offset(8.widthScale)
                $0.top.equalTo(self.showView.recordView.snp.bottom).offset(20.widthScale)
                $0.right.equalTo(self.showView.recordView).offset(-18.widthScale)
                $0.height.equalTo(40.widthScale)
            }
            UIView.animate(withDuration: 0.15) {
                self.showView.layoutIfNeeded()
            }
            return
        }
        
        if index == 2 {
            shareIntroView.setNeedsLayout()
            shareIntroView.continueBtn.snp.remakeConstraints{
                $0.left.equalTo(self.shareIntroView.titleL).offset(8.widthScale)
                $0.bottom.equalTo(self.shareIntroView.projectImage)
                $0.right.equalTo(self.shareIntroView.detailL).offset(-8.widthScale)
                $0.height.equalTo(40.widthScale)
            }
            UIView.animate(withDuration: 0.15) {
                self.shareIntroView.layoutIfNeeded()
            }
            return
        }
        
        if index == 3 {
            appStoreView.setNeedsLayout()
            appStoreView.applyBtn.snp.remakeConstraints{
                $0.left.equalTo(self.appStoreView.titleL).offset(8.widthScale)
                $0.right.equalTo(self.appStoreView.snp.centerX).offset(-88.widthScale)
                $0.top.equalTo(self.appStoreView.titleL.snp.bottom).offset(16.widthScale)
                $0.height.equalTo(44.widthScale)
            }
            UIView.animate(withDuration: 0.15) {
                self.appStoreView.layoutIfNeeded()
            }
            return
        }
        
        if index == 4 {
            shellFourView.setNeedsLayout()
            shellFourView.applyBtn.snp.remakeConstraints{
                $0.left.equalTo(self.shellFourView.titleL).offset(8.widthScale)
                $0.right.equalTo(self.shellFourView.snp.centerX).offset(-88.widthScale)
                $0.top.equalTo(self.shellFourView.subtitleL.snp.bottom).offset(32.widthScale)
                $0.height.equalTo(44.widthScale)
            }
            UIView.animate(withDuration: 0.15) {
                self.shellFourView.layoutIfNeeded()
            }
           return
        }
        
        
        if index == 5 {
            shellThreeView.setNeedsLayout()
            shellThreeView.applyBtn.snp.remakeConstraints{
                $0.left.equalTo(self.shellThreeView.titleL).offset(8.widthScale)
                $0.right.equalTo(self.shellThreeView.snp.centerX).offset(-88.widthScale)
                $0.top.equalTo(self.shellThreeView.subtitleL.snp.bottom).offset(32.widthScale)
                $0.height.equalTo(44.widthScale)
            }
            UIView.animate(withDuration: 0.15) {
                self.shellThreeView.layoutIfNeeded()
            }
           return
        }
    }
 
    @objc func pressAOut(){
        onPressing = false
        print("pressAOut ---- \(scrIndex)")
        let index = scrIndex
        guard index < scr.subviews.count - 1 else {
            print("scr index 超出 scr的范围")
            return
        }
        
        if index == 0 {
            shellView.setNeedsLayout()
            shellView.applyBtn.snp.remakeConstraints {
                $0.left.equalTo(shellView.titleL).offset(8.widthScale)
                $0.right.equalTo(shellView.titleL).offset(-8.widthScale)
                $0.top.equalTo(shellView.subtitleL.snp.bottom).offset(24.widthScale)
                $0.height.equalTo(50.widthScale)
            }
            UIView.animate(withDuration: 0.15) {
                self.shellView.layoutIfNeeded()
            } completion: { finish in
                if finish {
                    self.scr.setContentOffset(CGPointMake(0, CGFloat(index + 1 ) * kHeight), animated: true)
                }
            }
            return
        }
        
        if index == 1 {
            guard showView.introduceState == .doneRecode else {
                return
            }
            showView.setNeedsLayout()
            showView.continueBtn.snp.remakeConstraints{
                $0.left.equalTo(self.showView.longPassView).offset(0)
                $0.top.equalTo(self.showView.recordView.snp.bottom).offset(20.widthScale)
                $0.right.equalTo(self.showView.recordView).offset(-10.widthScale)
                $0.height.equalTo(40.widthScale)
            }
            UIView.animate(withDuration: 0.15) {
                self.showView.layoutIfNeeded()
            } completion: { finish in
                if finish {
                    self.scr.setContentOffset(CGPointMake(0, CGFloat(index + 1 ) * kHeight), animated: true)
                }
            }
            return
        }
        
        if index == 2 {
            shareIntroView.setNeedsLayout()
            shareIntroView.continueBtn.snp.remakeConstraints{
                $0.left.equalTo(self.shareIntroView.titleL)
                $0.bottom.equalTo(self.shareIntroView.projectImage)
                $0.right.equalTo(self.shareIntroView.detailL)
                $0.height.equalTo(40.widthScale)
            }
            UIView.animate(withDuration: 0.15) {
                self.shareIntroView.layoutIfNeeded()
            } completion: { finish in
                if finish {
                    self.scr.setContentOffset(CGPointMake(0, CGFloat(index + 1 ) * kHeight), animated: true)
                }
            }
            return
        }
        
        if index == 3 {
            appStoreView.setNeedsLayout()
            appStoreView.applyBtn.snp.remakeConstraints{
                $0.left.equalTo(self.appStoreView.titleL)
                $0.right.equalTo(self.appStoreView.snp.centerX).offset(-80.widthScale)
                $0.top.equalTo(self.appStoreView.titleL.snp.bottom).offset(16.widthScale)
                $0.height.equalTo(44.widthScale)
            }
            UIView.animate(withDuration: 0.15) {
                self.appStoreView.layoutIfNeeded()
            } completion: { finish in
                if finish {
                    self.scr.setContentOffset(CGPointMake(0, CGFloat(index + 1 ) * kHeight), animated: true)
                }
            }
            return
        }
        
        if index == 4 {
            shellFourView.setNeedsLayout()
            shellFourView.applyBtn.snp.remakeConstraints{
                $0.left.equalTo(self.shellFourView.titleL).offset(0)
                $0.right.equalTo(self.shellFourView.snp.centerX).offset(-80.widthScale)
                $0.top.equalTo(self.shellFourView.subtitleL.snp.bottom).offset(32.widthScale)
                $0.height.equalTo(44.widthScale)
            }
            UIView.animate(withDuration: 0.15) {
                self.shellFourView.layoutIfNeeded()
            } completion: { finish in
                if finish {
                    self.scr.setContentOffset(CGPointMake(0, CGFloat(index + 1 ) * kHeight), animated: true)
                }
            }
            return
        }
        
        if index == 5 {
            shellThreeView.setNeedsLayout()
            shellThreeView.applyBtn.snp.remakeConstraints{
                $0.left.equalTo(self.shellThreeView.titleL).offset(0)
                $0.right.equalTo(self.shellThreeView.snp.centerX).offset(-80.widthScale)
                $0.top.equalTo(self.shellThreeView.subtitleL.snp.bottom).offset(32.widthScale)
                $0.height.equalTo(44.widthScale)
            }
            UIView.animate(withDuration: 0.15) {
                self.shellThreeView.layoutIfNeeded()
            } completion: { finish in
                if finish {
                    self.scr.setContentOffset(CGPointMake(0, CGFloat(index + 1 ) * kHeight), animated: true)
                }
            }
            return
        }
    }
    
    @objc func onPressingB(){
        onPressing = true
        print("onPressingB ---- \(scrIndex)")
        let index = scrIndex
        if index == 0 {
            UIView.animate(withDuration: 0.15) {[weak self] in
                guard let `self` = self else {return}
                self.shellView.backBtn.transform3D = CATransform3DScale(CATransform3DIdentity, Transform3DScale, Transform3DScale, Transform3DScale)
            }
            return
        }
        
        if index == 1 {
            UIView.animate(withDuration: 0.15) {[weak self] in
                guard let `self` = self else {return}
                self.showView.backBtn.transform3D = CATransform3DScale(CATransform3DIdentity, Transform3DScale, Transform3DScale, Transform3DScale)
            }
            return
        }
        
        if index == 2 {
            UIView.animate(withDuration: 0.15) {[weak self] in
                guard let `self` = self else {return}
                self.shareIntroView.backBtn.transform3D = CATransform3DScale(CATransform3DIdentity, Transform3DScale, Transform3DScale, Transform3DScale)
            }
            return
        }
        if index == 3 {
            UIView.animate(withDuration: 0.15) {[weak self] in
                guard let `self` = self else {return}
                self.appStoreView.backBtn.transform3D = CATransform3DScale(CATransform3DIdentity, Transform3DScale, Transform3DScale, Transform3DScale)
            }
            return
        }
        
        if index == 4 {
            UIView.animate(withDuration: 0.15) {[weak self] in
                guard let `self` = self else {return}
                self.shellFourView.backBtn.transform3D = CATransform3DScale(CATransform3DIdentity, Transform3DScale, Transform3DScale, Transform3DScale)
            }
            return
        }
        if index == 5 {
            UIView.animate(withDuration: 0.15) {[weak self] in
                guard let `self` = self else {return}
                self.shellThreeView.backBtn.transform3D = CATransform3DScale(CATransform3DIdentity, Transform3DScale, Transform3DScale, Transform3DScale)
            }
            return
        }
        
    }
 
    @objc func pressBOut(){
        onPressing = false
        print("pressBOut ---- \(scrIndex)")
        let index = scrIndex
        if index == 0 {
            UIView.animate(withDuration: 0.15) {[weak self] in
                guard let `self` = self else {return}
                self.shellView.backBtn.transform3D = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
                
            } completion: { finish in
                if finish {
                    self.unitNotis()
                    self.dismiss()
                }
            }
            return
        }
        
        if index == 1 {
            UIView.animate(withDuration: 0.15) {[weak self] in
                guard let `self` = self else {return}
                self.showView.backBtn.transform3D = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
                
            } completion: { finish in
                if finish {
                    self.showView.longPassView.progressView.stopAnimation()
                    self.showView.introduceState = .stateNormal
                    self.scr.setContentOffset(CGPointMake(0, kHeight * CGFloat(index - 1)), animated: true)
                }
            }
            return
        }
        
        if index == 2 {
            UIView.animate(withDuration: 0.15) {[weak self] in
                guard let `self` = self else {return}
                self.shareIntroView.backBtn.transform3D = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
                
            } completion: { finish in
                if finish {
                    self.scr.setContentOffset(CGPointMake(0, kHeight * CGFloat(index - 1)), animated: true)
                }
            }
            return
        }
        
        if index == 3 {
            UIView.animate(withDuration: 0.15) {[weak self] in
                guard let `self` = self else {return}
                self.appStoreView.backBtn.transform3D = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
                
            } completion: { finish in
                if finish {
                    self.scr.setContentOffset(CGPointMake(0, kHeight * CGFloat(index - 1)), animated: true)
                }
            }
            return
        }
        
        if index == 4 {
            UIView.animate(withDuration: 0.15) {[weak self] in
                guard let `self` = self else {return}
                self.shellFourView.backBtn.transform3D = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
                
            } completion: { finish in
                if finish {
                    self.scr.setContentOffset(CGPointMake(0, kHeight * CGFloat(index - 1)), animated: true)
                }
            }
            return
        }
        
        if index == 5 {
            UIView.animate(withDuration: 0.15) {[weak self] in
                guard let `self` = self else {return}
                self.shellThreeView.backBtn.transform3D = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
                
            } completion: { finish in
                if finish {
                    self.scr.setContentOffset(CGPointMake(0, kHeight * CGFloat(index - 1)), animated: true)
                }
            }
            return
        }
        
    }
    
    @objc func pressInMenu(){
        let index = scrIndex
        guard index == 1  else { return }
        onPressing = true
        if showView.introduceState == .stateNormal {
            // 开始计时
            showView.longPassView.progressView.animate(fromAngle: 0,
                                                       toAngle: 360,
                                                       duration: ScreenshotLongPressSpaceTime)
            { _ in
                
            }
            TimerManger.share.cancelTaskWithId(longPressedID)
            let task = TimeTask.init(taskId: longPressedID, interval: 10) {[weak self] in
                guard let `self` = self else {return}
                self.menuAgainFlag = true
                self.screenshotLongPressedTime -= 1.0/5.0
                if self.screenshotLongPressedTime < 0 {
                    TimerManger.share.cancelTaskWithId(self.longPressedID)
                    self.screenshotLongPressedTime = ScreenshotLongPressSpaceTime
                    self.showView.introduceState = .doneScreenshot
                }
            }
            TimerManger.share.runTask(task: task)
        }
    }
    
    @objc func pressOutMenu(){
        onPressing = false
        if showView.introduceState == .stateNormal {
            screenshotLongPressedTime = ScreenshotLongPressSpaceTime
            TimerManger.share.cancelTaskWithId(longPressedID)
            showView.longPassView.progressView.stopAnimation()
            return
        }
        
        if showView.introduceState == .doneScreenshot {
            if menuAgainFlag == true {
                menuAgainFlag = false
            }else {
                showView.introduceState = .doneRecode
            }
            return
        }
    }
    
    @objc func pressOutOption(){
        let index = scrIndex
        if index == scr.subviews.count - 1 {
            unitNotis()
            dismiss()
        }
    }
}
