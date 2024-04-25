//
//  UserView.swift
//  Eggshell
//
//  Created by 刘富铭 on 2022/11/21.
//

import UIKit
import Moya
import SwiftyJSON


/**
 真机环境下需添加代理方法：, NIMChatManagerDelegate, NIMLoginManagerDelegate
 模拟器环境下需移除代理方法：, NIMChatManagerDelegate, NIMLoginManagerDelegate
 */
class MenuView: UIView, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton1: AnimatedButton!
    @IBOutlet weak var backButton2: AnimatedButton!
    
    
//    var chatItemView:ChatItemView?
//    var chatView:ChatView?
    var chatItemView:UIView?
    var chatView:UIView?
    // MARK: 初始化
    var contentView: UIView!
    func initSubviews() {
        let bgImageView = UIImageView(frame: bounds)
        bgImageView.image = UIImage(named: "full_bg")
        bgImageView.contentMode = .scaleAspectFill
        addSubview(bgImageView)
        addBlurEffect(style: .dark, alpha: 0.3)
        
        contentView = ((Bundle.main.loadNibNamed("MenuView", owner: self, options: nil)?.first) as! UIView)
        addSubview(contentView)     
        contentView.frame = self.bounds// 不能用frame
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
        
        backButton1.tapAction = {
            self.removeFromSuperview()
        }
        backButton2.tapAction = {
            self.removeFromSuperview()
        }
        backButton2.setControllerImage(type: .b)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender: ))))
        
        initTableView()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initSubviews()
    }
    
    func reloadFriendsData() {
        self.tableView.reloadData()
        
//        if focusFriendCellIndexPath.row >= 0 {
//            let cell = tableView.cellForRow(at: focusFriendCellIndexPath) as? MenuFriendTableViewCell
//            cell?.isSelected = true
//        }
    }
    
    
    // MARK: 按键事件
    func showEditUserInfoView() {
        let destView = EditUserInformationView(frame: self.bounds)
        superview?.addSubview(destView)
    }
    
    func showMessageView() {
//        let messageView = MessageView.init(frame: self.bounds)
//        superview?.addSubview(messageView)
    }
    
    func showCaptureView() {
        let capturesView = CapturesView.init(frame: self.bounds)
        superview?.addSubview(capturesView)
//        removeFromSuperview()
    }
    
    func showSettingView() {
        let settingView = SettingsView.init(frame: self.bounds)
        superview?.addSubview(settingView)
        
//        removeFromSuperview()
    }
    
    func showSearchFriendView() {
#if !DEBUG
//        let searchFriendView = SearchFriendView.init(frame: self.bounds)
//        searchFriendView.closure = {
//            self.reloadFriendsData()
//        }
//        superview?.addSubview(searchFriendView)
#endif
    }
    
#if !DEBUG
//    func showChatItemView(user: NIMUser,cellFarme:CGRect) {
//        self.chatItemView?.frame = CGRectMake(self.tableView.frame.origin.x + self.tableView.frame.size.width + 15, cellFarme.maxY - self.chatItemView!.frame.height, self.chatItemView!.frame.width, self.chatItemView!.frame.height)
//        self.chatItemView?.clickClosure = { click in
//            switch click {
//            case .Profile:
//                self.showUserInfoView(user: user)
//            case .SendMessage:
//                self.showChatView(user: user)
//            }
//        }
//        self.addSubview(self.chatItemView!)
//    }
//    
//    func showUserInfoView(user: NIMUser) {
//        let userInfoView = UserInfoView.init(frame: self.bounds,user: user)
//        superview?.addSubview(userInfoView)
//    }
#endif
    
    //点击空白处关闭键盘方法
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            print("收回键盘")
            self.chatItemView?.removeFromSuperview()
        }
//         sender.cancelsTouchesInView = false
    }
    
    // MARK: 初始化initTableView
    func initTableView(){
        self.tableView.clipsToBounds = false
        self.tableView.backgroundColor = .clear
        self.tableView.separatorStyle = .none
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.contentInsetAdjustmentBehavior = .never
//        self.tableView.shouldIgnoreContentInsetAdjustment = true
        self.tableView.automaticallyAdjustsScrollIndicatorInsets = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "MenuTopTableViewCell", bundle: .main), forCellReuseIdentifier: "MenuTopTableViewCell")
        self.tableView.register(UINib(nibName: "MenuFriendTableViewCell", bundle: .main), forCellReuseIdentifier: "MenuFriendTableViewCell")
        self.tableView.register(UINib(nibName: "MenuSectionHeaderView", bundle: .main), forHeaderFooterViewReuseIdentifier: "MenuSectionHeaderView")
        self.tableView.tableHeaderView = nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0 :
            return 1
#if !DEBUG
        case 1:
            return 0
#endif
        default:return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0 :
            return 106
        case 1:
            return 40
        default:return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTopTableViewCell", for: indexPath) as! MenuTopTableViewCell
            cell.clickClosure = { clickBtn in
                switch clickBtn {
                case .Message:
                    self.showMessageView()
                case .Settings:
                    self.showSettingView()
                case .Capture:
                    self.showCaptureView()
                case .AddFriend:
                    self.showSearchFriendView()
                case .EggShellUserProfile:
                    self.showEditUserInfoView()
                }
            }
            return cell
#if !DEBUG
//        case 1:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuFriendTableViewCell", for: indexPath) as! MenuFriendTableViewCell
//            if (NIMFriendsArr.count  > indexPath.row){
//                cell.setUser(user:NIMFriendsArr[indexPath.row])
//                cell.clickClosure = {
////                    self.showChatItemView(user: self.NIMFriendsArr[indexPath.row], cellFarme: cell.frame)
//                    
//                    UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut) {
//                        cell.bgBtn.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
//                    } completion: { _ in
//                        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut) {
//                            cell.bgBtn.transform = CGAffineTransform(scaleX: 1, y: 1)
//                        } completion: { _ in
//                            self.showChatView(user: self.NIMFriendsArr[indexPath.row])
//                        }
//                    }
//                }
//            }
//            return cell
#endif
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0 :
            return 0
        default:
            return 43
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0 :
            return nil
#if !DEBUG
//        case 1 :
//            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MenuSectionHeaderView") as! MenuSectionHeaderView
//            if NIMFriendsArr.count > 0 {
//                header.label.text =  " " + "Friends".localized()
//            }
//            else {
//                header.label.text = ""
//            }
//            return header
#endif
        case 2 :
//            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MenuSectionHeaderView") as!MenuSectionHeaderView
//            header.label.text = i18n(string: "People you may know")
//            return header
            return UIView()
        default:
            return nil
        }
    }
    
    // MARK: 手柄操控
    func gamepadKeyUpAction() {
//        self.chatItemView?.removeFromSuperview()
        
//        if focusFriendCellIndexPath.row >= 0 {
//            if focusFriendCellIndexPath.row == 0 {
//                let friendCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? MenuFriendTableViewCell
//                friendCell?.isSelected = false
//                focusFriendCellIndexPath = IndexPath(row: -1, section: 1)
//                
//                let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? MenuTopTableViewCell
//                cell?.highlightCaptureButton()
//                appPlayScrollSound()
//            }
//            else {
#if !DEBUG
//                let destIndexPath = IndexPath(row: focusFriendCellIndexPath.row-1, section: focusFriendCellIndexPath.section)
//                if destIndexPath.row < NIMFriendsArr.count && destIndexPath.row >= 0 {
//                    let lastFocusFriendCellIndexPath = focusFriendCellIndexPath
//                    let cell = tableView.cellForRow(at: lastFocusFriendCellIndexPath) as? MenuFriendTableViewCell
//                    cell?.isSelected = false
//                    
//                    let destCell = tableView.cellForRow(at: destIndexPath) as? MenuFriendTableViewCell
//                    destCell?.isSelected = true
//                    focusFriendCellIndexPath = destIndexPath
//                    appPlayScrollSound()
//                }
#endif
//            }
//        }
//        else {
//            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? MenuTopTableViewCell
//            cell?.gamepadKeyUpAction()
//            appPlayScrollSound()
//        }
    }
    
    var focusFriendCellIndexPath = IndexPath(row: -1, section: 1)
    func gamepadKeyDownAction() {
//        self.chatItemView?.removeFromSuperview()
        
        if focusFriendCellIndexPath.row >= 0 {
            let destIndexPath = IndexPath(row: focusFriendCellIndexPath.row+1, section: focusFriendCellIndexPath.section)
#if !DEBUG
//            if destIndexPath.row >= NIMFriendsArr.count {
//                appPlayIneffectiveSound()
//                return
//            }
#endif
            
//            let lastFocusFriendCellIndexPath = focusFriendCellIndexPath
//            let cell = tableView.cellForRow(at: lastFocusFriendCellIndexPath) as? MenuFriendTableViewCell
//            cell?.isSelected = false
//            
//            let destCell = tableView.cellForRow(at: destIndexPath) as? MenuFriendTableViewCell
//            destCell?.isSelected = true
//            focusFriendCellIndexPath = destIndexPath
//            appPlayScrollSound()
            return
        }
        else {
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? MenuTopTableViewCell
            let needSelectFriendCell = cell?.gamepadKeyDownAction()
            if needSelectFriendCell ?? false {
#if !DEBUG
//                if NIMFriendsArr.count > 0 {
//                    let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? MenuFriendTableViewCell
//                    cell?.isSelected = true
//                    focusFriendCellIndexPath = IndexPath(row: 0, section: 1)
//                    appPlayScrollSound()
//                }
#endif
            }
        }
    }
    
    func gamepadKeyLeftAction() {
        if focusFriendCellIndexPath.row >= 0 {
            return
        }
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? MenuTopTableViewCell
        cell?.gamepadKeyLeftAction()
//        appPlayScrollSound()
    }
    
    func gamepadKeyRightAction() {
        if focusFriendCellIndexPath.row >= 0 {
            return
        }
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? MenuTopTableViewCell
        cell?.gamepadKeyRightAction()
//        appPlayScrollSound()
    }
    
    func gamepadKeyAAction() {
        if focusFriendCellIndexPath.row >= 0 {
//            let cell = tableView.cellForRow(at: focusFriendCellIndexPath) as? MenuFriendTableViewCell
//            cell?.bgBtn.sendActions(for: .touchUpInside)
            appPlaySelectSound()
            return
        }
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? MenuTopTableViewCell
        cell?.gamepadKeyAAction()
//        appPlaySelectSound()
    }
    
    func gamepadKeyBAction() {
        backButton2.sendActions(for: .touchUpInside)
        appPlaySelectSound()
    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        switch indexPath.section {
    //        case 0 :
    //            return
    //        case 1:
    //            if self.NIMFriendsArr.count > indexPath.row {
    //                let user = NIMFriendsArr[indexPath.row]
    //                showChatView(user: user)
    //            }
    //        default:
    //            return
    //        }
    //    }
}
