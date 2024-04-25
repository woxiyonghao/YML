//
//  GSSetterNotiViewController.swift
//  GameSirBeyond
//
//  Created by lu on 2024/4/12.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
class GSSetterNotiViewController: UIViewController {

    var backHandler = {() in}
    var onPressing = false
    var dismiss = {() in}
    var onFcousIndexPath = IndexPath(item: -1, section: -1){
        didSet{
            if onFcousIndexPath.section == 0 {
                if onFcousIndexPath.item == 0 {
                    noNotiBtn.titleL.textColor = .hex("#252525")
                    noNotiBtn.subtitleL.textColor = .hex("#252525")
                    noNotiBtn.backgroundColor = .hex("#ffffff")
                    
                    notiSetBtnTitleL.textColor = .hex("#ffffff")
                    notiSetBtn.backgroundColor = self.normalColor
                    
                    UIView.animate(withDuration: 0.2) {
                        self.noNotiBtn.frame = CGRectMake(self.LeftBtnX - 8.widthScale,
                                                           CGRectGetMaxY(self.subtitleL.frame)+20.widthScale,
                                                           self.size.width - (self.LeftBtnX - 8.widthScale) * 2,
                                                           44.widthScale)
                        
                        self.notiSetBtn.frame = CGRectMake(self.LeftBtnX,
                                                           CGRectGetMaxY(self.noNotiBtn.frame)+12.widthScale,
                                                           self.size.width - self.LeftBtnX  * 2,
                                                           44.widthScale)
                    }
                }
                else {
                    
                    noNotiBtn.titleL.textColor = .hex("#ffffff")
                    noNotiBtn.subtitleL.textColor = .hex("#ffffff")
                    self.noNotiBtn.backgroundColor = self.normalColor
                    
                    self.notiSetBtnTitleL.textColor = .hex("#252525")
                    self.notiSetBtn.backgroundColor = .hex("#ffffff")
                    
                    UIView.animate(withDuration: 0.2) {
                        self.noNotiBtn.frame = CGRectMake(self.LeftBtnX ,
                                                           CGRectGetMaxY(self.subtitleL.frame)+20.widthScale,
                                                           self.size.width - self.LeftBtnX  * 2,
                                                           44.widthScale)
                        
                        self.notiSetBtn.frame = CGRectMake(self.LeftBtnX - 8.widthScale,
                                                           CGRectGetMaxY(self.noNotiBtn.frame)+12.widthScale,
                                                           self.size.width - (self.LeftBtnX - 8.widthScale) * 2,
                                                           44.widthScale)
                    }
                }
                return
            }
            
            if onFcousIndexPath.section == 1 {
                if onFcousIndexPath.item == 0 {
                    otherNotiBtn.titleL.textColor = .hex("#252525")
                    otherNotiBtn.subtitleL.textColor = .hex("#252525")
                    otherNotiBtn.backgroundColor = .hex("#ffffff")
                    
                    friendNotiBtn.titleL.textColor = .hex("#ffffff")
                    friendNotiBtn.subtitleL.textColor = .hex("#ffffff")
                    friendNotiBtn.backgroundColor = normalColor
                    
                    momentNotiBtn.titleL.textColor = .hex("#ffffff")
                    momentNotiBtn.subtitleL.textColor = .hex("#ffffff")
                    momentNotiBtn.backgroundColor = normalColor
                    
                    UIView.animate(withDuration: 0.2) {
                        self.otherNotiBtn.frame = CGRectMake(self.LeftBtnX - 8.widthScale,
                                                             self.otherNotiBtn.y,
                                                             self.size.width - (self.LeftBtnX - 8.widthScale)  * 2,
                                                             self.otherNotiBtn.height)
                        
                        self.friendNotiBtn.frame = CGRectMake(self.LeftBtnX ,
                                                              self.friendNotiBtn.y,
                                                              self.size.width - self.LeftBtnX  * 2,
                                                              self.friendNotiBtn.height)
                        
                        self.momentNotiBtn.frame = CGRectMake(self.LeftBtnX,
                                                              self.momentNotiBtn.y,
                                                              self.size.width - self.LeftBtnX  * 2,
                                                              self.momentNotiBtn.height)
                    }
                }
                else if onFcousIndexPath.item == 1 {
                    friendNotiBtn.titleL.textColor = .hex("#252525")
                    friendNotiBtn.subtitleL.textColor = .hex("#252525")
                    friendNotiBtn.backgroundColor = .hex("#ffffff")
                    
                    otherNotiBtn.titleL.textColor = .hex("#ffffff")
                    otherNotiBtn.subtitleL.textColor = .hex("#ffffff")
                    otherNotiBtn.backgroundColor = normalColor
                    
                    momentNotiBtn.titleL.textColor = .hex("#ffffff")
                    momentNotiBtn.subtitleL.textColor = .hex("#ffffff")
                    momentNotiBtn.backgroundColor = normalColor
                    
                    UIView.animate(withDuration: 0.2) {
                        self.otherNotiBtn.frame = CGRectMake(self.LeftBtnX,
                                                             self.otherNotiBtn.y,
                                                             self.size.width - self.LeftBtnX   * 2,
                                                             self.otherNotiBtn.height)
                        
                        self.friendNotiBtn.frame = CGRectMake(self.LeftBtnX - 8.widthScale,
                                                              self.friendNotiBtn.y,
                                                              self.size.width - (self.LeftBtnX - 8.widthScale)  * 2,
                                                              self.friendNotiBtn.height)
                        
                        self.momentNotiBtn.frame = CGRectMake(self.LeftBtnX,
                                                              self.momentNotiBtn.y,
                                                              self.size.width - self.LeftBtnX * 2,
                                                              self.momentNotiBtn.height)
                    }
                }
                else if onFcousIndexPath.item == 2{
                    momentNotiBtn.titleL.textColor = .hex("#252525")
                    momentNotiBtn.subtitleL.textColor = .hex("#252525")
                    momentNotiBtn.backgroundColor = .hex("#ffffff")
                    
                    friendNotiBtn.titleL.textColor = .hex("#ffffff")
                    friendNotiBtn.subtitleL.textColor = .hex("#ffffff")
                    friendNotiBtn.backgroundColor = normalColor
                    
                    otherNotiBtn.titleL.textColor = .hex("#ffffff")
                    otherNotiBtn.subtitleL.textColor = .hex("#ffffff")
                    otherNotiBtn.backgroundColor = normalColor
                    
                    UIView.animate(withDuration: 0.2) {
                        self.otherNotiBtn.frame = CGRectMake(self.LeftBtnX,
                                                             self.otherNotiBtn.y,
                                                             self.size.width - self.LeftBtnX   * 2,
                                                             self.otherNotiBtn.height)
                        
                        self.friendNotiBtn.frame = CGRectMake(self.LeftBtnX ,
                                                              self.friendNotiBtn.y,
                                                              self.size.width - self.LeftBtnX  * 2,
                                                              self.friendNotiBtn.height)
                        
                        self.momentNotiBtn.frame = CGRectMake(self.LeftBtnX - 8.widthScale,
                                                              self.momentNotiBtn.y,
                                                              self.size.width - (self.LeftBtnX - 8.widthScale) * 2,
                                                              self.momentNotiBtn.height)
                    }
                }
                
                else {
                    momentNotiBtn.titleL.textColor = .hex("#ffffff")
                    momentNotiBtn.subtitleL.textColor = .hex("#ffffff")
                    momentNotiBtn.backgroundColor = normalColor
                    
                    friendNotiBtn.titleL.textColor = .hex("#ffffff")
                    friendNotiBtn.subtitleL.textColor = .hex("#ffffff")
                    friendNotiBtn.backgroundColor = normalColor
                    
                    otherNotiBtn.titleL.textColor = .hex("#ffffff")
                    otherNotiBtn.subtitleL.textColor = .hex("#ffffff")
                    otherNotiBtn.backgroundColor = normalColor
                    
                    UIView.animate(withDuration: 0.2) {
                        self.otherNotiBtn.frame = CGRectMake(self.LeftBtnX,
                                                             self.otherNotiBtn.y,
                                                             self.size.width - self.LeftBtnX   * 2,
                                                             self.otherNotiBtn.height)
                        
                        self.friendNotiBtn.frame = CGRectMake(self.LeftBtnX ,
                                                              self.friendNotiBtn.y,
                                                              self.size.width - self.LeftBtnX  * 2,
                                                              self.friendNotiBtn.height)
                        
                        self.momentNotiBtn.frame = CGRectMake(self.LeftBtnX,
                                                              self.momentNotiBtn.y,
                                                              self.size.width - self.LeftBtnX  * 2,
                                                              self.momentNotiBtn.height)
                    }
                }
            }
            
        }
    }
    
    fileprivate var notiAble = false{
        didSet{
            noNotiBtn.icon.image = notiAble ? UIImage(named: "friend_add_select"):UIImage(named: "white_unselect")
        }
    }
    
    fileprivate var friendAble = false{
        didSet{
            friendNotiBtn.icon.image = friendAble ? UIImage(named: "friend_add_select"):UIImage(named: "white_unselect")
        }
    }
    
    fileprivate var otherAble = false{
        didSet{
            otherNotiBtn.icon.image = otherAble ? UIImage(named: "friend_add_select"):UIImage(named: "white_unselect")
        }
    }
    
    fileprivate var momentAble = false{
        didSet{
            momentNotiBtn.icon.image = momentAble ? UIImage(named: "friend_add_select"):UIImage(named: "white_unselect")
        }
    }
    
    fileprivate var size = CGSize(width: 0, height: 0)
    fileprivate let LeftBtnX:CGFloat = 60.widthScale
    fileprivate let normalColor = UIColor(red: 76.0/255, green: 76.0/255, blue: 76.0/255, alpha: 1)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.bm_colorGradientChange(with: size,direction: .upwardDiagonalLine,start: .hex("#20242F"),end: .hex("#353B49"))
        
        setupLeftUI()
        
        setupRightUI()
        
        regisNotis()
    }
    
    
    func setupRightUI(){
        rightView = UIView(frame: CGRectMake(size.width, 0, size.width, size.height))
        view.addSubview(rightView)
        rightView.backgroundColor = UIColor.bm_colorGradientChange(with: size,direction: .upwardDiagonalLine,start: .hex("#20242F"),end: .hex("#353B49"))
        rightTitleL = UILabel().then { [weak self] in
            guard let `self` = self else {return}
            $0.text = "通知设置"
            $0.textColor = .hex("#cccccc")
            self.rightView.addSubview($0)
            $0.font = font_24(weight: .regular)
            $0.textAlignment = .center
            $0.frame = CGRectMake(40.widthScale, 40.widthScale, self.size.width - 40.widthScale * 2, 30.widthScale)
        }
       
        rightSubtitleL = UILabel().then { [weak self] in
            guard let `self` = self else {return}
            $0.text = "您可以在下面更改您接收的通知类型。要更改与聊天相关的\n通知，请使用聊天设置。"
            $0.numberOfLines = 2
            $0.textColor = .hex("#cccccc")
            $0.font = font_16(weight: .regular)
            $0.textAlignment = .center
            $0.frame = CGRectMake(self.rightTitleL.x, CGRectGetMaxY(self.rightTitleL.frame)+12.widthScale, self.rightTitleL.width, 40.widthScale)
            self.rightView.addSubview($0)
        }
        
        
        otherNotiBtn = GSSetterNotiBtn(frame: CGRectMake(LeftBtnX, CGRectGetMaxY(self.rightSubtitleL.frame)+32.widthScale, self.size.width - LeftBtnX * 2, 44.widthScale))
        otherNotiBtn.layer.cornerRadius = 8
        otherNotiBtn.layer.masksToBounds = true
        otherNotiBtn.backgroundColor = self.normalColor
        rightView.addSubview(otherNotiBtn)
        otherNotiBtn.titleL.text = "其他通知"
        otherNotiBtn.subtitleL.text = "推荐游戏、游戏新闻和优惠信"
        
        friendNotiBtn = GSSetterNotiBtn(frame: CGRectMake(LeftBtnX, CGRectGetMaxY(self.otherNotiBtn.frame)+12.widthScale, self.size.width - LeftBtnX * 2, 44.widthScale))
        friendNotiBtn.layer.cornerRadius = 8
        friendNotiBtn.layer.masksToBounds = true
        friendNotiBtn.backgroundColor = self.normalColor
        rightView.addSubview(friendNotiBtn)
        friendNotiBtn.titleL.text = "好友通知"
        friendNotiBtn.subtitleL.text = "当好友上线或开始玩游戏时"
        
        momentNotiBtn = GSSetterNotiBtn(frame: CGRectMake(LeftBtnX, CGRectGetMaxY(self.friendNotiBtn.frame)+12.widthScale, self.size.width - LeftBtnX * 2, 44.widthScale))
        momentNotiBtn.layer.cornerRadius = 8
        momentNotiBtn.layer.masksToBounds = true
        momentNotiBtn.backgroundColor = self.normalColor
        rightView.addSubview(momentNotiBtn)
        momentNotiBtn.titleL.text = "精彩瞬间通知"
        momentNotiBtn.subtitleL.text = "当其他用户对您的精彩瞬间进行评论或有所反应时"
        
        otherNotiBtn.addTarget(self, action: #selector(otherNotiBtnAction), for: .touchUpInside)
        friendNotiBtn.addTarget(self, action: #selector(friendNotiBtnAction), for: .touchUpInside)
        momentNotiBtn.addTarget(self, action: #selector(momentNotiBtnAction), for: .touchUpInside)
    }
    
    @objc func otherNotiBtnAction(){
        if self.onFcousIndexPath.item == 0 && self.onFcousIndexPath.section == 1 {
            print("其他通知")
            self.otherAble = !self.otherAble
        }
        else {
            self.onFcousIndexPath = IndexPath(item: 0, section: 1)
        }
    }
    
    @objc func friendNotiBtnAction(){
        if self.onFcousIndexPath.item == 1 && self.onFcousIndexPath.section == 1 {
            print("好友通知")
            self.friendAble = !self.friendAble
        }
        else {
            self.onFcousIndexPath = IndexPath(item: 1, section: 1)
        }
    }
    
    @objc func momentNotiBtnAction(){
        if self.onFcousIndexPath.item == 2 && self.onFcousIndexPath.section == 1 {
            print("精彩瞬间通知")
            self.momentAble = !self.momentAble
        }
        else {
            self.onFcousIndexPath = IndexPath(item: 2, section: 1)
        }
    }
    
    func showRightView(){
        UIView.animate(withDuration: 0.25) {[unowned self] in
            self.rightView.x = 0
        }
    }
    
    func dismissRightView(){
        UIView.animate(withDuration: 0.25) {[unowned self] in
            self.rightView.x = size.width
        }
    }
    
    var rightView:UIView!
    var rightTitleL:UILabel!
    var rightSubtitleL:UILabel!
    var otherNotiBtn:GSSetterNotiBtn!
    var friendNotiBtn:GSSetterNotiBtn!
    var momentNotiBtn:GSSetterNotiBtn!
    
    var leftView:UIView!
    func setupLeftUI(){
        leftView = UIView(frame: CGRectMake(0, 0, size.width, size.height))
        view.addSubview(leftView)
        
        titleL = UILabel().then { [weak self] in
            guard let `self` = self else {return}
            $0.text = "我的游戏"
            $0.textColor = .hex("#cccccc")
            $0.font = font_24(weight: .regular)
            $0.textAlignment = .center
            $0.frame = CGRectMake(40.widthScale, 40.widthScale, self.size.width - 40.widthScale * 2, 30.widthScale)
            self.leftView.addSubview($0)
        }
       
        subtitleL = UILabel().then { [weak self] in
            guard let `self` = self else {return}
            $0.text = "您可以在下面修改您接收通知的频率。通过通知设置更改您接收的\n通知类型。"
            $0.numberOfLines = 0
            $0.textColor = .hex("#cccccc")
            $0.font = font_16(weight: .regular)
            $0.textAlignment = .center
            $0.frame = CGRectMake(self.titleL.x, CGRectGetMaxY(titleL.frame)+12.widthScale, self.titleL.width, 40.widthScale)
            self.leftView.addSubview($0)
        }
        
        noNotiBtn = GSSetterNotiBtn(frame: CGRectMake(LeftBtnX, CGRectGetMaxY(self.subtitleL.frame)+20.widthScale, self.size.width - LeftBtnX * 2, 44.widthScale))
        noNotiBtn.layer.cornerRadius = 8
        noNotiBtn.layer.masksToBounds = true
        noNotiBtn.backgroundColor = self.normalColor
        view.addSubview(noNotiBtn)
        
        
        notiSetBtn = UIButton().then({[weak self] in
            guard let `self` = self else {return}
            $0.layer.cornerRadius = 8
            $0.layer.masksToBounds = true
            $0.backgroundColor = self.normalColor
            $0.frame = CGRectMake(LeftBtnX, CGRectGetMaxY(self.noNotiBtn.frame)+12.widthScale, self.size.width - LeftBtnX * 2, 44.widthScale)
            self.leftView.addSubview($0)
            
            self.notiSetBtnTitleL = UILabel()
            self.notiSetBtnTitleL.text = "通知设置"
            self.notiSetBtnTitleL.textColor = .hex("#ffffff")
            self.notiSetBtnTitleL.textAlignment = .left
            self.notiSetBtnTitleL.font = font_16(weight: .regular)
            $0.addSubview(self.notiSetBtnTitleL)
            self.notiSetBtnTitleL.frame = CGRectMake(24.widthScale, 0, $0.width - 24.widthScale, $0.height)
        })
        
        bottomL = UILabel().then { [weak self] in
            guard let `self` = self else {return}
            $0.text = "随时向我们发送内容为STOP的短信即可退订。可能会收取短信\n资费。"
            $0.numberOfLines = 0
            $0.textColor = .hex("#cccccc")
            $0.font = font_16(weight: .regular)
            $0.textAlignment = .left
            $0.frame = CGRectMake(self.notiSetBtn.x, CGRectGetMaxY(self.notiSetBtn.frame)+12.widthScale, self.size.width, 40.widthScale)
            self.leftView.addSubview($0)
        }
        
        noNotiBtn.addTarget(self, action: #selector(noNotiBtnAction), for: .touchUpInside)
        notiSetBtn.addTarget(self, action: #selector(notiSetBtnAction), for: .touchUpInside)
    }
    
    @objc func noNotiBtnAction(){
        if self.onFcousIndexPath.item == 0 && self.onFcousIndexPath.section == 0 {
            print("减少通知")
            notiAble = !notiAble
        }
        else {
            self.onFcousIndexPath = IndexPath(item: 0, section: 0)
        }
    }
    
    @objc func notiSetBtnAction(){
        if self.onFcousIndexPath.item == 1 && self.onFcousIndexPath.section == 0 {
            print("进入通知选项")
            showRightView()
        }
        else {
            self.onFcousIndexPath = IndexPath(item: 1, section: 0)
        }
    }
    
    var titleL:UILabel!
    var subtitleL:UILabel!
    
    var noNotiBtn:GSSetterNotiBtn!
    
    var notiSetBtn:UIButton!
    var notiSetBtnTitleL:UILabel!
    var bottomL:UILabel!
    
    init(viewSize:CGSize){
        self.size = viewSize
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("\(self.classForCoder) deinit")
        unitNotis()
    }
}

class GSSetterNotiBtn:UIButton {
    
    var titleL:UILabel!
    var subtitleL:UILabel!
    var icon:UIImageView!
    
    override init(frame:CGRect){
        super.init(frame: frame)
        
        titleL = UILabel()
        titleL.text = "减少通知"
        titleL.textColor = .hex("#ffffff")
        titleL.textAlignment = .left
        titleL.font = font_16(weight: .regular)
        addSubview(titleL)
        titleL.frame = CGRectMake(24.widthScale, 0, self.width - 24.widthScale, 22.widthScale)
        
        subtitleL = UILabel()
        subtitleL.text = "我们将限制您收到的通知数"
        subtitleL.textColor = .hex("#ffffff")
        subtitleL.textAlignment = .left
        subtitleL.font = font_12(weight: .regular)
        addSubview(subtitleL)
        subtitleL.frame = CGRectMake(titleL.x, 22.widthScale, self.width - subtitleL.x, 16.widthScale)
        
        //round_black
        icon = UIImageView()
        icon.image = UIImage(named: "white_unselect")
        addSubview(icon)
        icon.frame = CGRectMake(self.width - 20.widthScale - 24.widthScale, self.height * 0.5 - 10.widthScale, 20.widthScale, 20.widthScale)
    }
   
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
// 关于手柄
extension GSSetterNotiViewController {
    
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
        if onFcousIndexPath.section == 0 && onFcousIndexPath.item == 0{
            UIView.animate(withDuration: 0.2) {
                self.noNotiBtn.frame = CGRectMake(self.LeftBtnX,
                                                   CGRectGetMaxY(self.subtitleL.frame)+20.widthScale,
                                                   self.size.width - self.LeftBtnX * 2,
                                                   44.widthScale)
                
            }
            return
        }
        if onFcousIndexPath.section == 0 && onFcousIndexPath.item == 1{
            UIView.animate(withDuration: 0.2) {
                self.notiSetBtn.frame = CGRectMake(self.LeftBtnX,
                                                   CGRectGetMaxY(self.noNotiBtn.frame)+12.widthScale,
                                                   self.size.width - self.LeftBtnX  * 2,
                                                   44.widthScale)
                
            }
            
            return
        }
        
        if onFcousIndexPath.section == 1 && onFcousIndexPath.item == 0{
            UIView.animate(withDuration: 0.2) {
                self.otherNotiBtn.frame = CGRectMake(self.LeftBtnX ,
                                                     self.otherNotiBtn.y,
                                                     self.size.width - self.LeftBtnX  * 2,
                                                     self.otherNotiBtn.height)
                
            }
            return
        }
        
        
        if onFcousIndexPath.section == 1 && onFcousIndexPath.item == 1{
            UIView.animate(withDuration: 0.2) {
                self.friendNotiBtn.frame = CGRectMake(self.LeftBtnX ,
                                                      self.friendNotiBtn.y,
                                                      self.size.width - self.LeftBtnX  * 2,
                                                      self.friendNotiBtn.height)
                
            }
            return
        }
        
        if onFcousIndexPath.section == 1 && onFcousIndexPath.item == 2{
            UIView.animate(withDuration: 0.2) {
                self.momentNotiBtn.frame = CGRectMake(self.LeftBtnX,
                                                      self.momentNotiBtn.y,
                                                      self.size.width - self.LeftBtnX  * 2,
                                                      self.momentNotiBtn.height)
                
            }
            return
        }
    }
 
    @objc func pressAOut(){
        onPressing = false
        if onFcousIndexPath.section == 0 && onFcousIndexPath.item == 0{
            UIView.animate(withDuration: 0.2) {
                self.noNotiBtn.frame = CGRectMake(self.LeftBtnX - 8.widthScale,
                                                   CGRectGetMaxY(self.subtitleL.frame)+20.widthScale,
                                                   self.size.width - (self.LeftBtnX - 8.widthScale) * 2,
                                                   44.widthScale)
                
            }
            notiAble = !notiAble
            return
        }
        if onFcousIndexPath.section == 0 && onFcousIndexPath.item == 1{
            UIView.animate(withDuration: 0.2) {
                self.notiSetBtn.frame = CGRectMake(self.LeftBtnX - 8.widthScale,
                                                   CGRectGetMaxY(self.noNotiBtn.frame)+12.widthScale,
                                                   self.size.width - (self.LeftBtnX - 8.widthScale) * 2,
                                                   44.widthScale)
                
            }
            onFcousIndexPath = IndexPath(item: 999, section: 1)
            showRightView()
            return
        }
        
        if onFcousIndexPath.section == 1 && onFcousIndexPath.item == 0{
            UIView.animate(withDuration: 0.2) {
                self.otherNotiBtn.frame = CGRectMake(self.LeftBtnX - 8.widthScale,
                                                     self.otherNotiBtn.y,
                                                     self.size.width - (self.LeftBtnX - 8.widthScale)  * 2,
                                                     self.otherNotiBtn.height)
                
            }
            otherAble = !otherAble
            return
        }
        
        
        if onFcousIndexPath.section == 1 && onFcousIndexPath.item == 1{
            UIView.animate(withDuration: 0.2) {
                self.friendNotiBtn.frame = CGRectMake(self.LeftBtnX - 8.widthScale,
                                                      self.friendNotiBtn.y,
                                                      self.size.width - (self.LeftBtnX - 8.widthScale)  * 2,
                                                      self.friendNotiBtn.height)
                
            }
            friendAble = !friendAble
            return
        }
        
        if onFcousIndexPath.section == 1 && onFcousIndexPath.item == 2{
            UIView.animate(withDuration: 0.2) {
                self.momentNotiBtn.frame = CGRectMake(self.LeftBtnX - 8.widthScale,
                                                      self.momentNotiBtn.y,
                                                      self.size.width - (self.LeftBtnX - 8.widthScale) * 2,
                                                      self.momentNotiBtn.height)
                
            }
            momentAble = !momentAble
            return
        }
    }
    
    @objc func pressUp(){
        guard onPressing == false else {
            print("正在按紧A/B键")
            return
        }
        if onFcousIndexPath.section == 0 {
            if onFcousIndexPath.item == 0{
                return
            }
            else{
                onFcousIndexPath.item = 0
                self.onFcousIndexPath = IndexPath(item: 0, section: 0)
            }
        }
        if onFcousIndexPath.section == 1 {
            if onFcousIndexPath.item == 999 {
                return
            }
            var item = onFcousIndexPath.item - 1 < 0 ? 0:onFcousIndexPath.item - 1
            onFcousIndexPath = IndexPath(item: item, section: onFcousIndexPath.section)
            return
        }
    }
    
    @objc func pressDown(){
        guard onPressing == false else {
            print("正在按紧A/B键")
            return
        }
        if onFcousIndexPath.section == -1 && onFcousIndexPath.item == -1 {
            self.onFcousIndexPath = IndexPath(item: 0, section: 0)
            return
        }
        if onFcousIndexPath.section == 0 {
            if onFcousIndexPath.item == 1{
                return
            }
            else{
                onFcousIndexPath.item = 1
                self.onFcousIndexPath = IndexPath(item: 1, section: 0)
            }
        }
        print(onFcousIndexPath)
        if onFcousIndexPath.section == 1 {
            if onFcousIndexPath.item == 999 {
                onFcousIndexPath = IndexPath(item: 0, section: onFcousIndexPath.section)
                return
            }
            var item = onFcousIndexPath.item + 1 > 2 ? 2:onFcousIndexPath.item + 1
            onFcousIndexPath = IndexPath(item: item, section: onFcousIndexPath.section)
            return
        }
    }
    
}
