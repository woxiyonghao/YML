//
//  GSSetViewController.swift
//  GameSirBeyond
//
//  Created by lu on 2024/4/17.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
/**
 * 上下有一个毛玻璃效果的高度
 */
let GSSetterRightViewContentTop:CGFloat = 44.widthScale
let GSSetterRightViewContentBottom:CGFloat = 44.widthScale
let GSSetterRightCellH:CGFloat = 44.widthScale + 8.widthScale
// 通知有相对应的延迟，并不适合。故弃置，采用block。
//let GSSetterRightCellTouchEnter      = "GSSetterRightCellTouchEnter"
//let GSSetterRightCellTouchLeave      = "GSSetterRightCellTouchLeave"
let GSSetterMenuWidth = 246.widthScale

class GSSetViewController: UIViewController {
    
    let GSSetterMenuWidth = 246.widthScale
    let tabHeaderH:CGFloat = 86.widthScale
    let tabCellH:CGFloat = 50.widthScale
    var onPressing = false
    var popHandler = {(this:GSSetViewController) in}
    private var popController:UIViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGesBackUnable()
        
        fd_prefersNavigationBarHidden = true
        
        view.backgroundColor = .hex("#20242F").withAlphaComponent(1)
        
        setupLeftView()
        
        setupRightView()
        
        setupSelectMenuCell()
        
        view.addSubview(coverView)
        
        setupBackBtn()
    }
    
    func setupBackBtn(){
        view.addSubview(backBtn)
        backBtn.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-30.widthScale)
            $0.bottom.equalToSuperview().offset(-30.widthScale)
            $0.width.equalTo(80.widthScale)
            $0.height.equalTo(40.widthScale)
        }
        
        backBtn.backHandler = {[weak self] in
            guard let `self` = self else { return }
            self.backBtn.runAnim()
            self.pressBOut()
        }
    }
    
    var backBtn:GameBackKeyBtn = {
        let btn = GameBackKeyBtn().then {
            $0.label.textColor = .hex("#ffffff")
            $0.icon.image = UIImage(named: "ic-B-clear")
            $0.btn.backgroundColor = .clear
            $0.btn.layer.cornerRadius = 20.widthScale
            $0.btn.layer.masksToBounds = true
            $0.anim = true
        }
        return btn
    }()
    
    func setupSelectMenuCell(){
        view.addSubview(selectView)
        selectView.menuModel = menuDatas[0]
    }
    
    func setupRightView(){
        rightScr.backgroundColor = .clear
        rightScr.showsVerticalScrollIndicator = false
        rightScr.showsHorizontalScrollIndicator = false
        rightScr.isPagingEnabled = true
        rightScr.isScrollEnabled = false
        view.addSubview(rightScr)
        rightScr.frame = CGRectMake(leftScr.width, 0, kWidth - leftScr.width, kHeight)
        
        rightScr.addSubview(accoundView)
        accoundView.model = menuDatas[0]
        
        rightScr.addSubview(linkView)
        linkView.model = menuDatas[1]
        
        rightScr.addSubview(joyconView)
        joyconView.model = menuDatas[2]
        
        rightScr.addSubview(recodeView)
        recodeView.model = menuDatas[3]
        
        rightScr.addSubview(helpView)
        helpView.model = menuDatas[4]
        
        rightScr.addSubview(aboutView)
        aboutView.model = menuDatas[5]
        
        
        rightBaseViews.append(accoundView)
        rightBaseViews.append(linkView)
        rightBaseViews.append(joyconView)
        rightBaseViews.append(recodeView)
        rightBaseViews.append(helpView)
        rightBaseViews.append(aboutView)
        
        rightScr.contentSize = CGSize(width: 0, height: kHeight * CGFloat(rightBaseViews.count))
        rightScr.contentInsetAdjustmentBehavior = .never
        
        rightScr.subviews.forEach {
            if let this = $0 as? GSSetterRightBaseView {
                this.didSelectCellHandler = {[weak self] (cell:GSSetterRightCell,menuModel:GSSetterMenuModel) in
                    guard let `self` = self else {return}
                    self.didClickedOnRightCell(cell: cell,menuModel: menuModel)
                }
                this.enterSelectCellHandler = {[weak self](cell:GSSetterRightCell,menuModel:GSSetterMenuModel) in
                    guard let `self` = self else {return}
                    self.setLeftEnter(menuModel: menuModel)
                }
            }
        }
        
        let topBlur = UIView(frame: CGRectMake(0, 0, kWidth-GSSetterMenuWidth, GSSetterRightViewContentTop))
        rightScr.addSubview(topBlur)
        topBlur.addBlurEffect(style: .dark, alpha: 0.1)
        
        let bottomBlur = UIView(frame: CGRectMake(0, kHeight - GSSetterRightViewContentBottom, kWidth-GSSetterMenuWidth, GSSetterRightViewContentBottom))
        rightScr.addSubview(bottomBlur)
        bottomBlur.addBlurEffect(style: .dark, alpha: 0.1)
    }
    
    /**
     * 已经选中了右边的某一个cell
     */
    func didClickedOnRightCell(cell:GSSetterRightCell,menuModel:GSSetterMenuModel){
        print("已经选中了右边的某一个cell")
        /***************************** 账号 ****************************************/
        
        if menuModel.id == 0 && cell.myModel!.id == 0  {
            print("编辑个人信息")
            let size = CGSizeMake(kWidth - 196.widthScale * 2, kHeight - 60.widthScale * 2)
            let editInfo = GSSetterEditInfoViewController(viewSize: size)
            self.addChild(editInfo)
            view.addSubview(editInfo.view)
            editInfo.view.frame = CGRectMake(view.centerX, view.centerY, 0, 0)
            editInfo.view.alpha = 0
            coverView.alpha = 0.7
            unitNotisWithoutPressB()
            weak var weakEditInfo = editInfo
            coverView.dismiss = {[weak self] in
                guard let `self` = self,
                      let `editInfo` = weakEditInfo
                else { return  }
                self.coverView.alpha = 0
                UIView.animate(withDuration: 0.25) {
                    editInfo.view.frame = CGRectMake(self.view.centerX, self.view.centerY, 0, 0)
                    editInfo.view.alpha = 0
                } completion: { finish in
                    if finish {
                        editInfo.view.removeFromSuperview()
                        editInfo.removeFromParent()
                        self.popController = nil
                        self.regisNotisWithoutPressB()
                    }
                    
                }
            }
            editInfo.dismiss = coverView.dismiss
            UIView.animate(withDuration: 0.25) {
                editInfo.view.frame = CGRectMake((kWidth - size.width)*0.5, (kHeight - size.height)*0.5,size.width, size.height)
                editInfo.view.alpha = 1
            }
            view.bringSubviewToFront(backBtn)
            popController = editInfo
            return
        }
        
        
        if menuModel.id == 0 && cell.myModel!.id == 1  {
            print("编辑游戏名字")
            let size = CGSizeMake(kWidth - 196.widthScale * 2, kHeight - 60.widthScale * 2)
            let editName = GSSetterEditGameNameViewController(viewSize: size)
            self.addChild(editName)
            view.addSubview(editName.view)
            editName.view.frame = CGRectMake(view.centerX, view.centerY, 0, 0)
            editName.view.alpha = 0
            coverView.alpha = 0.7
            unitNotisWithoutPressB()
            weak var weakEditName = editName
            coverView.dismiss = {[weak self] in
                guard let `self` = self,
                      let `editName` = weakEditName
                else { return  }
                self.coverView.alpha = 0
                UIView.animate(withDuration: 0.25) {
                    editName.view.frame = CGRectMake(self.view.centerX, self.view.centerY, 0, 0)
                    editName.view.alpha = 0
                } completion: { finish in
                    if finish {
                        editName.view.removeFromSuperview()
                        editName.removeFromParent()
                        self.popController = nil
                        self.regisNotisWithoutPressB()
                    }
                    
                }
                
            }
            UIView.animate(withDuration: 0.25) {
                editName.view.frame = CGRectMake((kWidth - size.width)*0.5, (kHeight - size.height)*0.5,size.width, size.height)
                editName.view.alpha = 1
            }
            view.bringSubviewToFront(backBtn)
            popController = editName
            return
        }
        
        if menuModel.id == 0 && cell.myModel!.id == 2  {
            print("通知")
            let size = CGSizeMake(rightScr.width, kHeight)
            let noti = GSSetterNotiViewController(viewSize: size)
            self.addChild(noti)
            view.addSubview(noti.view)
            noti.view.frame = CGRectMake(kWidth, 0, size.width, kHeight)
            weak var weakNoti = noti
            unitNotisWithoutPressB()
            noti.dismiss = {
                UIView.animate(withDuration: 0.25) {
                    weakNoti?.view.x = kWidth
                } completion: { finish in
                    if finish {
                        weakNoti?.view.removeFromSuperview()
                        weakNoti?.removeFromParent()
                        self.regisNotisWithoutPressB()
                        self.popController = nil
                    }
                }
            }
            
            noti.backHandler = {[weak self]() in
                guard let `self` = self,
                      let `noti` = weakNoti
                else { return  }
                noti.onFcousIndexPath = IndexPath(item: 1, section: 0)
                UIView.animate(withDuration: 0.2) {
                    noti.rightView.x = kWidth
                }
            }
            
            UIView.animate(withDuration: 0.25) {[unowned self] in
                noti.view.x = self.rightScr.x
            } completion: { _ in
                
            }
            view.bringSubviewToFront(backBtn)
            popController = noti
            return
        }
        
        if menuModel.id == 0 && cell.myModel!.id == 3  {
            print("退出登录")
            let size = CGSizeMake(kWidth - 196.widthScale * 2, kHeight - 60.widthScale * 2)
            let signout = GSSetterSignoutViewController(viewSize: size,initStyle: .signout)
            signout.view.frame = CGRectMake(kWidth * 0.5, kHeight * 0.5, 0, 0)
            self.addChild(signout)
            view.addSubview(signout.view)
            weak var weakVC = signout
            signout.view.alpha = 0
            coverView.alpha = 0.7
            unitNotisWithoutPressB()
            coverView.dismiss = {[weak self] in
                guard let `self` = self,
                      let signout = weakVC
                else { return  }
                self.coverView.alpha = 0
                UIView.animate(withDuration: 0.25) {
                    signout.view.frame = CGRectMake(self.view.centerX, self.view.centerY, 0, 0)
                    signout.view.alpha = 0
                } completion: { finish in
                    if finish {
                        signout.view.removeFromSuperview()
                        signout.removeFromParent()
                        self.popController = nil
                        self.regisNotisWithoutPressB()
                    }
                    
                }
            }
            UIView.animate(withDuration: 0.25) {
                signout.view.frame = CGRectMake((kWidth - size.width)*0.5, (kHeight - size.height)*0.5,size.width, size.height)
                signout.view.alpha = 1
            }
            signout.dismiss = coverView.dismiss
            popController = signout
            view.bringSubviewToFront(backBtn)
            return
        }
        
        /***************************** 链接 ****************************************/
        if menuModel.id == 1 && cell.myModel!.id == 0 {
            print("关联Steam账号")
            return
        }
        if menuModel.id == 1 && cell.myModel!.id == 1 {
            print("关联Xbox账号")
            return
        }
        if menuModel.id == 1 && cell.myModel!.id == 2 {
            print("关联PlayStation账号")
            return
        }
        
        /***************************** 手柄 ****************************************/
        if menuModel.id == 2 && cell.myModel!.id == 0 {
            print("手柄 - 手柄")
            let size = rightScr.size
            let vc = GSJoyconDetailViewController(viewSize: size)
            self.addChild(vc)
            view.addSubview(vc.view)
            vc.view.frame = CGRectMake(kWidth, 0, size.width, size.height)
            weak var weakVC = vc
            unitNotisWithoutPressB()
            vc.dismiss = {
                UIView.animate(withDuration: 0.25) {
                    weakVC?.view.x = kWidth
                } completion: { finish in
                    if finish {
                        weakVC?.view.removeFromSuperview()
                        weakVC?.removeFromParent()
                        self.popController = nil
                        self.regisNotisWithoutPressB()
                    }
                }
            }
            UIView.animate(withDuration: 0.25) {[unowned self] in
                weakVC?.view.x = self.rightScr.x
            } completion: { _ in
                
            }
            view.bringSubviewToFront(backBtn)
            popController = weakVC
            return
        }
        if menuModel.id == 2 && cell.myModel!.id == 1 {
            print("在任何屏幕上进行游戏")
            let vc = GSAnyScreenGameViewController()
            self.addChild(vc)
            view.addSubview(vc.view)
            vc.view.frame = CGRectMake(kWidth, 0, kWidth, kHeight)
            UIView.animate(withDuration: 0.25) {
                vc.view.x = 0
            }
            weak var weakVC = vc
            self.unitNotisWithoutPressB()
            vc.dismiss = {[weak self] in
                guard let `self` = self,let `vc` = weakVC else { return  }
                UIView.animate(withDuration: 0.25) {
                    vc.view.x = kWidth
                } completion: { finish in
                    if finish {
                        vc.removeFromParent()
                        vc.view.removeFromSuperview()
                        self.popController = nil
                        self.regisNotisWithoutPressB()
                    }
                }
            }
            popController = vc
            view.bringSubviewToFront(backBtn)
            return
        }
        if menuModel.id == 2 && cell.myModel!.id == 2 {
            print("快速访问快捷方式")
            let vc = GSQuickAccessViewController()
            self.addChild(vc)
            view.addSubview(vc.view)
            unitNotisWithoutPressB()
            vc.view.frame = CGRectMake(kWidth, 0, kWidth, kHeight)
            UIView.animate(withDuration: 0.25) {
                vc.view.x = 0
            }
            weak var weakVC = vc
            vc.dismiss = {[weak self] in
                guard let `self` = self,let `vc` = weakVC else { return  }
                UIView.animate(withDuration: 0.25) {
                    vc.view.x = kWidth
                } completion: { finish in
                    if finish {
                        vc.removeFromParent()
                        vc.view.removeFromSuperview()
                        self.popController = nil
                        self.regisNotisWithoutPressB()
                    }
                }
            }
            popController = vc
            view.bringSubviewToFront(backBtn)
            return
        }
        if menuModel.id == 2 && cell.myModel!.id == 3 {
            print("摇杆校准")
            return
        }
        if menuModel.id == 2 && cell.myModel!.id == 4 {
            print("测试游戏手柄按键")
            let vc = GSTectKeyViewController()
            self.addChild(vc)
            view.addSubview(vc.view)
            vc.view.frame = CGRectMake(kWidth, 0, kWidth, kHeight)
            UIView.animate(withDuration: 0.25) {
                vc.view.x = 0
            }
            unitNotis()
            weak var weakVC = vc
            vc.dismiss = {[weak self] in
                guard let `self` = self,let `vc` = weakVC else { return  }
                UIView.animate(withDuration: 0.25) {
                    vc.view.x = kWidth
                } completion: { finish in
                    if finish {
                        vc.removeFromParent()
                        vc.view.removeFromSuperview()
                        self.popController = nil
                        self.regisNotis()
                    }
                }
            }
            popController = vc
            return
        }
        
        if menuModel.id == 2 && cell.myModel!.id == 5 {
            print("按键映射")
            let size = CGSizeMake(kWidth - 100.widthScale * 2, kHeight - 40.widthScale * 2)
            let vc = KeyMappingViewController(viewSize: size)
            vc.view.frame = CGRectMake(view.centerX, view.centerY, 0, 0)
            self.addChild(vc)
            view.addSubview(vc.view)
            weak var weakVC = vc
            vc.view.alpha = 0
            coverView.alpha = 0.7
            unitNotisWithoutPressB()
            coverView.dismiss = {[weak self] in
                guard let `self` = self,
                      let vc = weakVC
                else { return  }
                self.coverView.alpha = 0
                UIView.animate(withDuration: 0.25) {
                    vc.view.frame = CGRectMake(self.view.centerX, self.view.centerY, 0, 0)
                    vc.view.alpha = 0
                } completion: { finish in
                    if finish {
                        vc.view.removeFromSuperview()
                        vc.removeFromParent()
                        self.popController = nil
                        self.regisNotisWithoutPressB()
                    }
                }
            }
            vc.dismiss = coverView.dismiss
            UIView.animate(withDuration: 0.25) {
                vc.view.frame = CGRectMake((kWidth - size.width)*0.5, (kHeight - size.height)*0.5,size.width, size.height)
                vc.view.alpha = 1
            }
            view.bringSubviewToFront(backBtn)
            popController = vc
            return
        }
        
        if menuModel.id == 2 && cell.myModel!.id == 6{
            print("出厂设置")
            let size = CGSizeMake(kWidth - 196.widthScale * 2, kHeight - 60.widthScale * 2)
            let vc = GSSetterSignoutViewController(viewSize: size,initStyle: .factorySettings)

            vc.view.frame = CGRectMake(kWidth * 0.5, kHeight * 0.5, 0, 0)
            self.addChild(vc)
            view.addSubview(vc.view)
            weak var weakVC = vc
            vc.view.alpha = 0
            coverView.alpha = 0.7
            unitNotisWithoutPressB()
            coverView.dismiss = {[weak self] in
                guard let `self` = self,
                      let signout = weakVC
                else { return  }
                self.coverView.alpha = 0
                UIView.animate(withDuration: 0.25) {
                    signout.view.frame = CGRectMake(self.view.centerX, self.view.centerY, 0, 0)
                    signout.view.alpha = 0
                } completion: { finish in
                    if finish {
                        signout.view.removeFromSuperview()
                        signout.removeFromParent()
                        self.popController = nil
                        self.regisNotisWithoutPressB()
                    }
                }
            }
            UIView.animate(withDuration: 0.25) {
                vc.view.frame = CGRectMake((kWidth - size.width)*0.5, (kHeight - size.height)*0.5,size.width, size.height)
                vc.view.alpha = 1
            }
            view.bringSubviewToFront(backBtn)
            popController = vc
            vc.dismiss = coverView.dismiss
            return
        }
        
        /***************************** 录制 ****************************************/
        if menuModel.id == 3 && cell.myModel!.id == 0 {
            print("录制模式")
            let size = CGSize(width: kWidth, height: kHeight)
            let vc = GSRecodeModeViewController(viewSize: CGSize(width: kWidth, height: kHeight))
            
            self.addChild(vc)
            view.addSubview(vc.view)
            unitNotisWithoutPressB()
            vc.view.frame = CGRectMake(kWidth, 0, size.width, size.height)
            UIView.animate(withDuration: 0.25) {
                vc.view.x = 0
            }
            weak var weakVC = vc
            vc.dismiss = {[weak self] in
                guard let `self` = self,
                      let `vc` = weakVC
                else { return  }
                UIView.animate(withDuration: 0.25) {
                    vc.view.x = kWidth
                } completion: { finish in
                    if finish {
                        vc.removeFromParent()
                        vc.view.removeFromSuperview()
                        self.regisNotisWithoutPressB()
                        self.popController = nil
                    }
                }
            }
            
            popController = vc
            view.bringSubviewToFront(backBtn)
            return
        }
        if menuModel.id == 3 && cell.myModel!.id == 1 {
            print("录制视频")
            let size = rightScr.size
            let vc = GSRecodeFPSViewController(viewSize: size)
            unitNotisWithoutPressB()
            self.addChild(vc)
            view.addSubview(vc.view)
            vc.view.frame = CGRectMake(kWidth, 0, size.width, size.height)
            UIView.animate(withDuration: 0.25) {
                vc.view.x = kWidth - size.width
            }
        
            weak var weakVC = vc
            vc.dismiss = {[weak self] in
                guard let `self` = self else { return }
                UIView.animate(withDuration: 0.25) {
                    weakVC?.view.x = kWidth
                } completion: { finish in
                    if finish {
                        weakVC?.view.removeFromSuperview()
                        weakVC?.removeFromParent()
                        self.popController = nil
                        self.regisNotisWithoutPressB()
                    }
                }
            }
            popController = vc
            view.bringSubviewToFront(backBtn)
            return
        }
        if menuModel.id == 3 && cell.myModel!.id == 2 {
            print("格式")
            let size = rightScr.size
            let vc = GSRecodeFormatViewController(viewSize: size)
            
            self.addChild(vc)
            view.addSubview(vc.view)
            unitNotisWithoutPressB()
            vc.view.frame = CGRectMake(kWidth, 0, size.width, size.height)
            UIView.animate(withDuration: 0.25) {
                vc.view.x = kWidth - size.width
            }
            weak var weakVC = vc
            vc.dismiss = {[weak self] in
                guard let `self` = self else { return }
                UIView.animate(withDuration: 0.25) {
                    weakVC?.view.x = kWidth
                } completion: { finish in
                    if finish {
                        weakVC?.view.removeFromSuperview()
                        weakVC?.removeFromParent()
                        self.popController = nil
                        self.regisNotisWithoutPressB()
                    }
                }
            }
            popController = vc
            view.bringSubviewToFront(backBtn)
            return
        }
        if menuModel.id == 3 && cell.myModel!.id == 3 {
            print("比特率")
            let size = rightScr.size
            let vc = GSRecodeBitRateViewController(viewSize: size)
            self.addChild(vc)
            view.addSubview(vc.view)
            unitNotisWithoutPressB()
            
            vc.view.frame = CGRectMake(kWidth, 0, size.width, size.height)
            UIView.animate(withDuration: 0.25) {
                vc.view.x = kWidth - size.width
            }
            
            weak var weakVC = vc
            vc.dismiss = {[weak self] in
                guard let `self` = self else { return }
                UIView.animate(withDuration: 0.25) {
                    weakVC?.view.x = kWidth
                } completion: { finish in
                    if finish {
                        weakVC?.view.removeFromSuperview()
                        weakVC?.removeFromParent()
                        self.popController = nil
                        self.regisNotisWithoutPressB()
                    }
                }
            }
            
            
            popController = vc
            view.bringSubviewToFront(backBtn)
            return
        }
        /***************************** 帮助 ****************************************/
        if menuModel.id == 4 && cell.myModel!.id == 0 {
            print("新手教程")
            let vc = GSNewGuideViewController()
            self.addChild(vc)
            view.addSubview(vc.view)
            unitNotis()
            vc.view.frame = CGRectMake(0, kHeight, kWidth, kHeight)
            UIView.animate(withDuration: 0.25) {
                vc.view.y = 0
            }
            
            weak var weakVC = vc
            vc.dismiss = {[weak self] in
                guard let `self` = self
                else { return }
                UIView.animate(withDuration: 0.25) {
                    weakVC?.view.y = kHeight
                } completion: { finish in
                    weakVC?.view.removeFromSuperview()
                    weakVC?.removeFromParent()
                    self.regisNotis()
                    self.popController = nil
                }
            }
            
            popController = vc
            //view.bringSubviewToFront(backBtn)
            return
        }
        if menuModel.id == 4 && cell.myModel!.id == 1 {
            print("帮助&客户支持")
            
            return
        }
        if menuModel.id == 4 && cell.myModel!.id == 2 {
            print("提交意见反馈 ")
            
            let fb = GSFeedbackViewController()
            addChild(fb)
            view.addSubview(fb.view)
            unitNotis()
            fb.view.frame = CGRectMake(kWidth, 0, kWidth, kHeight)
            UIView.animate(withDuration: 0.25) {
                fb.view.x = 0
            }
            
            weak var weakFB = fb
            fb.dismiss = {[weak self] in
                UIView.animate(withDuration: 0.25) {
                    weakFB?.view.x = kWidth
                } completion: { [weak self] finish in
                    if finish {
                        guard let `self` = self else {return}
                        weakFB?.view.removeFromSuperview()
                        weakFB?.removeFromParent()
                        self.forceOrientationLandscape()
                        self.regisNotis()
                    }
                }
            }
            return
        }
        if menuModel.id == 4 && cell.myModel!.id == 3 {
            print("兑换免费适配器")
            return
        }
        if menuModel.id == 4 && cell.myModel!.id == 4 {
            print("请求删除数据")
            let size = CGSizeMake(kWidth - 160.widthScale * 2, kHeight - 40.widthScale * 2)
            let delete = GSSetterDeallocViewController(viewSize: size)
            weak var weakVC = delete
            coverView.alpha = 0.7
            addChild(delete)
            view.addSubview(delete.view)
            delete.view.frame = CGRectMake(view.centerX, view.centerY, 0, 0)
            unitNotisWithoutPressB()
            coverView.dismiss = {[weak self] in
                guard let `self` = self,
                      let `delete` = weakVC
                else { return  }
                self.coverView.alpha = 0
                UIView.animate(withDuration: 0.25) {
                    delete.view.frame = CGRectMake(self.view.centerX, self.view.centerY, 0, 0)
                    delete.view.alpha = 0
                } completion: { finish in
                    if finish {
                        delete.view.removeFromSuperview()
                        delete.removeFromParent()
                        self.popController = nil
                        self.regisNotisWithoutPressB()
                    }
                    
                }
            }
            UIView.animate(withDuration: 0.25) {
                delete.view.frame = CGRectMake((kWidth - size.width)*0.5, (kHeight - size.height)*0.5,size.width, size.height)
                delete.view.alpha = 1
            }
            delete.dismiss = coverView.dismiss
            popController = delete
            view.bringSubviewToFront(backBtn)
            return
        }
        
        /***************************** 关于 ****************************************/
        if menuModel.id == 5 && cell.myModel!.id == 0 {
            print("App版本")
            return
        }
        if menuModel.id == 5 && cell.myModel!.id == 1 {
            print("构建")
            return
        }
        if menuModel.id == 5 && cell.myModel!.id == 2 {
            print("系统版本")
            return
        }
        if menuModel.id == 5 && cell.myModel!.id == 3 {
            print("手机型号")
            return
        }
    }
    /**
     * 点击已进入右边的某一个cell,左边的menu应该进入选中状态
     */
    func setLeftEnter(menuModel:GSSetterMenuModel){
        print("已经选中了右边的某一个cell,左边的menu应该进入选中状态")
        
        var index = -1
        for i in 0..<menuDatas.count {
            menuDatas[i].select = menuDatas[i].id == menuModel.id
            menuDatas[i].inSubMenu = menuDatas[i].id == menuModel.id
            if menuDatas[i].inSubMenu {
                index = i
            }
        }
        if index != -1 {
            let menu = menuCells[index]
            selectView.menuModel = menuDatas[index]
            UIView.animate(withDuration: 0.25) {[unowned self] in
                self.selectView.y = menu.y
            }
        }
        
    }
    /// 禁止侧滑返回
    fileprivate func setGesBackUnable(){
        let target = navigationController?.interactivePopGestureRecognizer?.delegate
        print(target)
        if target != nil {
            let pan = UIPanGestureRecognizer(target: target!, action: nil)
            view.addGestureRecognizer(pan)
        }
    }
    
    func setupLeftView(){
        view.addSubview(leftScr)
        leftScr.frame = CGRectMake(0, 0, GSSetterMenuWidth, kHeight)
        leftScr.isScrollEnabled = false
        leftScr.isPagingEnabled = true
        leftScr.backgroundColor = .clear
        leftScr.contentInsetAdjustmentBehavior = .never
        
        let labelX:CGFloat = 24
        let label = UILabel(frame: CGRectMake(labelX, 40.widthScale,leftScr.width - labelX, 40.widthScale))
        label.text = "设置"
        label.textAlignment = .center
        label.textColor = .hex("#CCCCCC")
        label.font = font_24(weight: .semibold)
        label.backgroundColor = .clear
        leftScr.addSubview(label)
        
        for i in 0..<menuDatas.count {
            let y = tabHeaderH + CGFloat(i) * tabCellH
            let menuCell = GSSetterMenuCell(style: .default, reuseIdentifier: nil)
            menuCell.tag = 10 + i
            menuCell.menuModel = menuDatas[i]
            menuCells.append(menuCell)
            menuCell.frame = CGRectMake(0,y, leftScr.width, tabCellH)
            leftScr.addSubview(menuCell)
            menuCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(menuCellTapDidClicked)))
        }
        
        let bottomY = CGRectGetMaxY(menuCells.last!.frame) + 40.widthScale
        if bottomY > kHeight {
            leftScr.contentSize = CGSize(width: 0, height: bottomY)
        }
        else {
            leftScr.contentSize = CGSize(width: 0, height: kHeight)
        }
    }
    
    @objc func menuCellTapDidClicked(tap:UITapGestureRecognizer){
        if let menuCell = tap.view as? GSSetterMenuCell{
            menuCellDidClicked(menuCell:menuCell)
        }
    }
    
    func menuCellDidClicked(menuCell:GSSetterMenuCell){
        selectView.menuModel?.select = false
        selectView.menuModel?.inSubMenu = false
        menuCell.menuModel?.select = true
        selectView.menuModel = menuCell.menuModel
        UIView.animate(withDuration: 0.25) {[unowned self] in
            self.selectView.y = menuCell.y
        }
        rightScr.setContentOffset(CGPoint(x: 0, y: kHeight * CGFloat(menuCell.tag-10)),
                                  animated: true)
        // 重置
        resetRightViewState()
    }
    
    // 重置右边选中状态
    func resetRightViewState(){
        rightScr.subviews.forEach {
            if let this = $0 as? GSSetterRightBaseView{
                this.onFcous = -1
                this.model.datas.forEach { model in
                    model.enter = false
                    model.select = false
                }
                this.scrSubviews.forEach { view in
                    if let cell = view as? GSSetterRightCell {
                        cell.fullModel(model: cell.myModel!, style: cell.myStyle!)
                    }
                }
            }
        }
    }
    
    lazy var accoundView:GSSetterRightBaseView = GSSetterRightBaseView(frame: CGRectMake(0, 0, kWidth - GSSetterMenuWidth, kHeight),style: .accound)
    
    lazy var linkView:GSSetterRightBaseView = GSSetterRightBaseView(frame: CGRectMake(0, kHeight, kWidth - GSSetterMenuWidth, kHeight),style: .link)
    
    lazy var joyconView:GSSetterRightBaseView = GSSetterRightBaseView(frame: CGRectMake(0, 2 * kHeight, kWidth - GSSetterMenuWidth, kHeight),style: .joycon)
    
    lazy var recodeView:GSSetterRightBaseView = GSSetterRightBaseView(frame: CGRectMake(0, 3 * kHeight, kWidth - GSSetterMenuWidth, kHeight),style: .recode)
    
    lazy var helpView:GSSetterRightBaseView = GSSetterRightBaseView(frame: CGRectMake(0, 4 * kHeight, kWidth - GSSetterMenuWidth, kHeight),style: .help)
    
    lazy var aboutView:GSSetterRightBaseView = GSSetterRightBaseView(frame: CGRectMake(0, 5 * kHeight, kWidth - GSSetterMenuWidth, kHeight),style: .about)
    
    lazy var coverView = CoverView(frame: CGRectMake(0, 0, kWidth, kHeight)).then {
        $0.backgroundColor = .hex("#252525")
        $0.alpha = 0
    }
    
    public class CoverView:UIView{
        var dismiss = {() in}
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            dismiss()
        }
    }
    
    lazy var leftScr = UIScrollView()
    lazy var rightScr = UIScrollView()
    lazy var selectView = GSSetterSelectCell(frame: CGRectMake(0, tabHeaderH, GSSetterMenuWidth + 8.widthScale, tabCellH))
    // 左边的data
    lazy var menuCells = [GSSetterMenuCell]()
    lazy var menuDatas = [
        GSSetterMenuModel(normalIcon: "setter_accound_normal",
                          selectIcon: "setter_accound_select",
                          iconTxt: "账号",
                          normalIconTxtColor: .hex("#CCCCCC"),
                          selectIconTxtColor: .hex("#252525"),
                          inSubMenuColor: .hex("#3E424A"),
                          tipViewColor: .hex("#1A9FFC"),
                          select: true,
                          inSubMenu:false,
                          id: 0,
                          datas: [
                            GSSetterMenuOPModel(title: "编辑用户信息",id: 0),
                            GSSetterMenuOPModel(title: "编辑游戏用户名",id: 1),
                            GSSetterMenuOPModel(title: "通知",id: 2),
                            GSSetterMenuOPModel(title: "退出",id: 3),]
                         ),
        
        GSSetterMenuModel(normalIcon: "setter_link_normal",
                          selectIcon: "setter_link_select",
                          iconTxt: "链接",
                          normalIconTxtColor: .hex("#CCCCCC"),
                          selectIconTxtColor: .hex("#252525"),
                          inSubMenuColor: .hex("#3E424A"),
                          tipViewColor: .hex("#1A9FFC"),
                          select: false,
                          inSubMenu:false,
                          id: 1
                          ,datas: [
                            GSSetterMenuOPModel(title: "关联Steam账号",normalIcon: "stream_logo_white",selectIcon: "stream_logo_black",id: 0),
                            GSSetterMenuOPModel(title: "关联Xbox账号",normalIcon: "xbox_logo_white",selectIcon: "xbox_logo_black",id: 1),
                            GSSetterMenuOPModel(title: "关联PlayStation账号",normalIcon: "ps_logo_white",selectIcon: "ps_logo_black",id: 2)
                          ]),
        
        GSSetterMenuModel(normalIcon: "setter_joycon_normal",
                          selectIcon: "setter_joycon_select",
                          iconTxt: "手柄",
                          normalIconTxtColor: .hex("#CCCCCC"),
                          selectIconTxtColor: .hex("#252525"),
                          inSubMenuColor: .hex("#3E424A"),
                          tipViewColor: .hex("#1A9FFC"),
                          select: false,
                          inSubMenu:false,
                          id: 2,datas: [
                            GSSetterMenuOPModel(title: "手柄",subtitle: "型号",id: 0),
                            GSSetterMenuOPModel(title: "在任何屏幕上进行游戏",subtitle: "禁用",id: 1),
                            GSSetterMenuOPModel(title: "快速访问快捷方式",subtitle: "无",id: 2),
                            GSSetterMenuOPModel(title: "摇杆校准",id: 3),
                            GSSetterMenuOPModel(title: "测试游戏手柄按键",id: 4),
                            GSSetterMenuOPModel(title: "按键映射",id: 5),
                            GSSetterMenuOPModel(title: "出厂设置",id: 6),
                          ]),
        
        GSSetterMenuModel(normalIcon: "setter_recode_normal",
                          selectIcon: "setter_recode_select",
                          iconTxt: "录制",
                          normalIconTxtColor: .hex("#CCCCCC"),
                          selectIconTxtColor: .hex("#252525"),
                          inSubMenuColor: .hex("#3E424A"),
                          tipViewColor: .hex("#1A9FFC"),
                          select: false,
                          inSubMenu:false,
                          id: 3,
                          datas: [
                            GSSetterMenuOPModel(title: "录制模式",subtitle: "录制一切",id: 0),
                            GSSetterMenuOPModel(title: "录制视频",subtitle: "分辨率为1080p，帧率为30FPS",id: 1),
                            GSSetterMenuOPModel(title: "格式",subtitle: "H264",id: 2),
                            GSSetterMenuOPModel(title: "比特率",subtitle: "H264",id: 3),
                          ]),
        
        GSSetterMenuModel(normalIcon: "setter_help_normal",
                          selectIcon: "setter_help_select",
                          iconTxt: "帮助",
                          normalIconTxtColor: .hex("#CCCCCC"),
                          selectIconTxtColor: .hex("#252525"),
                          inSubMenuColor: .hex("#3E424A"),
                          tipViewColor: .hex("#1A9FFC"),
                          select: false,
                          inSubMenu:false,
                          id: 4,
                          datas: [
                            GSSetterMenuOPModel(title: "新手教程",id: 0),
                            GSSetterMenuOPModel(title: "帮助&客户支持",id: 1),
                            GSSetterMenuOPModel(title: "提交意见反馈",id: 2),
                            GSSetterMenuOPModel(title: "兑换免费适配器",id: 3),
                            GSSetterMenuOPModel(title: "请求删除数据",id: 4)
                          ]),
        
        GSSetterMenuModel(normalIcon: "setter_about_normal",
                          selectIcon: "setter_about_select",
                          iconTxt: "关于",
                          normalIconTxtColor: .hex("#CCCCCC"),
                          selectIconTxtColor: .hex("#252525"),
                          inSubMenuColor: .hex("#3E424A"),
                          tipViewColor: .hex("#1A9FFC"),
                          select: false,
                          inSubMenu:false,
                          id: 5,
                          datas: [
                            GSSetterMenuOPModel(title: "App版本",subtitle: Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? "",id: 0),
                            GSSetterMenuOPModel(title: "构建",subtitle: Bundle.main.infoDictionary! ["CFBundleVersion"] as? String ?? "",id: 1),
                            GSSetterMenuOPModel(title: "系统版本",subtitle: UIDevice.current.systemVersion as String,id: 2),
                            GSSetterMenuOPModel(title: "手机型号",subtitle: UIDevice.current.model,id:3),
                            
                          ])
    ]
    
    lazy var rightBaseViews = [GSSetterRightBaseView]()
    
    deinit {
        print("deinit")
        unitNotis()
    }
    
    ///强制横屏
    func forceOrientationLandscape() {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.isForcePortrait = false
        let _ = appdelegate.application(UIApplication.shared,
                                        supportedInterfaceOrientationsFor: self.view.window)
        
        //强制翻转屏幕，Home键在右边。
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue,
                                  forKey: "orientation")
        //刷新
        UIViewController.attemptRotationToDeviceOrientation()
        
    }
}




// 关于手柄
extension GSSetViewController {
    
    public func unitNotis(){
        NotificationCenter.default.removeObserver(self)
    }
    
    // 保留B键的通知
    public func unitNotisWithoutPressB(){
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onPressingB),
                                               name: NSNotification.Name(ControllerNotificationName.KeyBPressIn.rawValue),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressBOut),
                                               name: NSNotification.Name(ControllerNotificationName.KeyBPressOut.rawValue),
                                               object: nil)
    }
    //
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
    public func regisNotis(){
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onPressingA),
                                               name: NSNotification.Name(ControllerNotificationName.KeyAPressIn.rawValue),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onPressingB),
                                               name: NSNotification.Name(ControllerNotificationName.KeyBPressIn.rawValue),
                                               object: nil)
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressAOut),
                                               name: NSNotification.Name(ControllerNotificationName.KeyAPressOut.rawValue),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pressBOut),
                                               name: NSNotification.Name(ControllerNotificationName.KeyBPressOut.rawValue),
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
        
        selectView.menuModel!.inSubMenu ? joinRightCellFcous():firstPressingASetRightFristCellInFcous()
        
    }
    
    @objc func onPressingB(){
        onPressing = true
        UIView.animate(withDuration: 0.15) {[weak self] in
            guard let `self` = self else {return}
            self.backBtn.transform3D = CATransform3DScale(CATransform3DIdentity, Transform3DScale, Transform3DScale, Transform3DScale)
        }
    }
    
    @objc func pressAOut(){
        onPressing = false
        _pressA()
    }
    
    
    @objc func pressBOut(){
        onPressing = false
        guard let menu = selectView.menuModel else{
            return
        }
        if menu.inSubMenu == false {
            popHandler(self)
        }
        else {
            UIView.animate(withDuration: 0.15) {[weak self] in
                guard let `self` = self else {return}
                self.backBtn.transform3D = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
            }
            if let _ = popController as? GSSetterEditInfoViewController {
                coverView.dismiss()
                return
            }
            
            if let _ = popController as? GSSetterEditGameNameViewController{
                coverView.dismiss()
                return
            }
            
            if let noti = popController as? GSSetterNotiViewController{
                if noti.onFcousIndexPath.section == 0 || noti.onFcousIndexPath.section == -1 {
                    noti.dismiss()
                }
                else {
                    noti.backHandler()
                }
                return
            }
            
            if let _ = popController as? GSSetterSignoutViewController{
                coverView.dismiss()
                return
            }
            
            if let joycon = popController as? GSJoyconDetailViewController{
                joycon.dismiss()
                return
            }
            
            if let anyScreen = popController as? GSAnyScreenGameViewController{
                anyScreen.dismiss()
                return
            }
            
            if let quick = popController as? GSQuickAccessViewController{
                quick.dismiss()
                return
            }
            
            if let _ = popController as? GSTectKeyViewController{
                // 这个需要内部处理
                return
            }
            
            if let _ = popController as? KeyMappingViewController {
                coverView.dismiss()
                return
            }
            
            if let mode = popController as? GSRecodeModeViewController{
                mode.dismiss()
                return
            }
            
            if let fps = popController as? GSRecodeFPSViewController{
                fps.dismiss()
                return
            }
            
            if let fmt = popController as? GSRecodeFormatViewController{
                fmt.dismiss()
                return
            }
            
            if let bitRate = popController as? GSRecodeBitRateViewController{
                bitRate.dismiss()
                return
            }
            
            
            if let _ = popController as? GSSetterDeallocViewController {
                coverView.dismiss()
                return
            }
            
            if let _ = popController as? GSNewGuideViewController{
                // 内部处理
                return
            }
            
            menu.datas.forEach { op in
                op.select = false
                op.enter = false
            }
            menu.inSubMenu = false
            menuCellDidClicked(menuCell: menuCells[menu.id])
        }
    }
    
    @objc func _pressA(){
        //selectView.menuModel!.inSubMenu ? joinRightCellLeaveFcous():pressAOutSetCellAnim()
        pressAOutSetCellAnim()
    }
    
    
    @objc func pressUp(){
        guard onPressing == false else {
            print("正在按紧A/B键")
            return
        }
        print(selectView.menuModel!.inSubMenu)
        selectView.menuModel!.inSubMenu ? subMenuTabPrev():menuTabPrev()
    }
    
    @objc func pressDown(){
        guard onPressing == false else {
            print("正在按紧A/B键")
            return
        }
        print(selectView.menuModel!.inSubMenu)
        selectView.menuModel!.inSubMenu ? subMenuTabNext():menuTabNext()
    }
    
    
    func menuTabPrev(){
        var index = selectView.menuModel!.id
        index -= 1
        if index < 0 {
            index = 0
        }
        
        menuCellDidClicked(menuCell: menuCells[index])
    }
    
    func menuTabNext(){
        var index = selectView.menuModel!.id
        index += 1
        if index > menuDatas.count - 1 {
            index = menuDatas.count - 1
        }
        menuCellDidClicked(menuCell: menuCells[index])
    }
    
    func subMenuTabPrev(){
        var ops = selectView.menuModel!.datas
        var index = -1
        for i in 0..<ops.count{
            if ops[i].select {
                index = i
                break
            }
        }
        print("subMenuTabPrev == \(index)")
        if index == -1 { return }
        index -= 1
        if index < 0 { index = 0 }
        let right = rightBaseViews[selectView.menuModel!.id]
        var fcous:GSSetterRightCell?
        for view in right.scrSubviews {
            if let cell = view as? GSSetterRightCell{
                if cell.myModel!.id == index {
                    fcous = cell
                    break
                }
            }
        }
        if fcous == nil { return }
        ops.forEach { model in
            model.select = false
            model.enter = false
        }
        right.onFcous = -1
        right.touchLeave(cell: fcous!)
    }
    
    func subMenuTabNext(){
        var ops = selectView.menuModel!.datas
        var index = -1
        for i in 0..<ops.count{
            if ops[i].select {
                index = i
                break
            }
        }
        print("subMenuTabNext == \(index)")
        if index == -1 { return }
        index += 1
        if index > ops.count - 1 { index = ops.count - 1 }
        let right = rightBaseViews[selectView.menuModel!.id]
        var fcous:GSSetterRightCell?
        for view in right.scrSubviews {
            if let cell = view as? GSSetterRightCell{
                if cell.myModel!.id == index {
                    fcous = cell
                    break
                }
            }
        }
        if fcous == nil { return }
        ops.forEach { model in
            model.select = false
            model.enter = false
        }
        right.onFcous = -1
        right.touchLeave(cell: fcous!)
    }
    
    
    // 点击A，使右边cell进入焦点
    func joinRightCellFcous(){
        if let menu = selectView.menuModel{
            let right = rightBaseViews[menu.id]
            var tagCell:GSSetterRightCell?
            for view in right.scrSubviews {
                if let cell = view as?GSSetterRightCell {
                    if cell.myModel!.enter && cell.myModel!.select {
                        tagCell = cell
                        break
                    }
                }
            }
            if tagCell == nil {return }
            right.touchEnter(cell: tagCell!)
        }
    }
    
    // 松开A，使右边cell进入焦点
    func joinRightCellLeaveFcous(){
        if let menu = selectView.menuModel{
            let right = rightBaseViews[menu.id]
            var tagCell:GSSetterRightCell?
            for view in right.scrSubviews {
                if let cell = view as?GSSetterRightCell {
                    if cell.myModel!.enter && cell.myModel!.select {
                        tagCell = cell
                        break
                    }
                }
            }
            if tagCell == nil {return }
            right.touchLeave(cell: tagCell!)
        }
    }
    
    // 首次点击A，使右边第一个cell进入焦点
    func firstPressingASetRightFristCellInFcous(){
        if let menu = selectView.menuModel{
            let right = rightBaseViews[menu.id]
            var firstCell:GSSetterRightCell?
            for view in right.scrSubviews {
                if let cell = view as?GSSetterRightCell {
                    firstCell = cell
                    break
                }
            }
            if firstCell == nil {return }
            right.touchEnter(cell: firstCell!)
        }
    }
    
    // 松开A键，使右边的cell动画。model.enter
    func pressAOutSetCellAnim(){
        if let menu = selectView.menuModel{
            let right = rightBaseViews[menu.id]
            var fcous:GSSetterRightCell?
            for view in right.scrSubviews {
                if let cell = view as?GSSetterRightCell {
                    if cell.myModel!.enter {
                        fcous = cell
                        break
                    }
                }
            }
            if fcous == nil {return }
            right.touchLeave(cell: fcous!)
        }
    }
}
