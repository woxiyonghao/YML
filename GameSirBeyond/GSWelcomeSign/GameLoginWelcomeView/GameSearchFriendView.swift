//
//  GameSearchFriendView.swift
//  GameLoginWelcome
//
//  Created by lu on 2024/3/6.
//

import UIKit
class GameSearchFriendView: UIView {

    var countDown = 3
    let taskID = "countDown.id"
    
    open var btnFocusOnAddAll = true {
        didSet{
            addAllBtn.setTitleColor(btnFocusOnAddAll ? .hex("#ffffff"):.hex("#252525"), for: .normal)
            addAllBtn.backgroundColor = btnFocusOnAddAll ? .hex("#252525"):.hex("#E4E4E4")
            continueBtn.setTitleColor(btnFocusOnAddAll ? .hex("#252525"):.hex("#ffffff"), for: .normal)
            continueBtn.backgroundColor = btnFocusOnAddAll ? .hex("#E4E4E4"):.hex("#252525")
        }
    }
    
    var lastTouch = 0
    
    open var focusOnColl = true{
        didSet{
            if focusOnColl != true {
                results.forEach { model in
                    model.isSelect = false
                }
                reslutColl.reloadData()
                addAllBtn.setTitleColor(.hex("#ffffff"), for: .normal)
                addAllBtn.backgroundColor = .hex("#252525")
                continueBtn.setTitleColor(.hex("#252525"), for: .normal)
                continueBtn.backgroundColor = .hex("#E4E4E4")
            }
            else{
                for i in 0..<results.count {
                    results[i].isSelect = i == 0
                }
                reslutColl.reloadData()
                addAllBtn.setTitleColor(.hex("#252525"), for: .normal)
                addAllBtn.backgroundColor = .hex("#E4E4E4")
                continueBtn.setTitleColor(.hex("#252525"), for: .normal)
                continueBtn.backgroundColor = .hex("#E4E4E4")
            }
        }
    }
    
    var isSearching = true {
        didSet{
            if isSearching {
                
                self.timerStart()
                
                initSearchState()
            }
            else{
                
                defer {
                    reslutColl.reloadData()
                }
                
                for i in 0..<20{
                    let model = GameSearchFriendReslut()
                    model.isSelect = i == 0
                    model.isAdd = false
                    results.append(model)
                }
//                results = [GameSearchFriendReslut]()
            }
        }
    }
    
    open var results = [GameSearchFriendReslut](){
        didSet{
            if results.count == 0 {
                initNoSearchResult()
            }
            else{
                initSearchReslut()
            }
        }
    }
    
    init(){
        super.init(frame: .zero)
        
        addSubview(backBtn)
        backBtn.snp.remakeConstraints {
            $0.right.equalToSuperview().offset(-30.widthScale)
            $0.bottom.equalToSuperview().offset(-30.widthScale)
            $0.width.equalTo(80.widthScale)
            $0.height.equalTo(40.widthScale)
        }
        
        addSubview(continueXBtn)
        continueXBtn.snp.remakeConstraints {
            $0.right.equalTo(backBtn.snp.left).offset(-8.widthScale)
            $0.bottom.equalToSuperview().offset(-30.widthScale)
            $0.width.equalTo(80.widthScale)
            $0.height.equalTo(40.widthScale)
        }
        
        addSubview(titleL)
        titleL.snp.remakeConstraints {
            $0.left.equalToSuperview().offset(48.widthScale)
            $0.top.equalToSuperview().offset(70.widthScale)
        }
        
        addSubview(waitView)
        waitView.snp.makeConstraints {
            $0.width.height.equalTo(56.widthScale)
            $0.left.equalTo(titleL)
            $0.top.equalTo(titleL.snp.bottom).offset(18.widthScale)
        }
        
        addSubview(subtitleL)
        subtitleL.snp.makeConstraints {
            $0.left.equalTo(titleL)
            $0.top.equalTo(waitView.snp.bottom).offset(12.widthScale)
        }
        
        addSubview(jumpBtn)
        jumpBtn.snp.makeConstraints {
            $0.left.equalTo(titleL)
            $0.top.equalTo(subtitleL.snp.bottom).offset(36.widthScale)
            $0.height.equalTo(44.widthScale)
            $0.width.equalTo(168.widthScale)
        }
        
        addSubview(reslutColl)
        reslutColl.snp.makeConstraints {
            $0.left.equalTo(titleL)
            $0.height.equalTo(152.widthScale)
            $0.width.equalTo(160.widthScale * 4 + 12.widthScale * 4)
            $0.top.equalTo(titleL.snp.bottom).offset(12.widthScale)
        }
        
        addSubview(bottomV)
        bottomV.snp.makeConstraints {
            $0.left.equalTo(titleL)
            $0.height.equalTo(44.widthScale)
            $0.width.equalTo(168.widthScale * 2 + 12)
            $0.top.equalTo(reslutColl.snp.bottom).offset(20.widthScale)
        }
        
    }
    
    func timerStart(){
        TimerManger.share.cancelTaskWithId(taskID)
        let task = TimeTask.init(taskId: taskID, interval: 60) {[weak self] in
            guard let `self` = self else {return}
            self.timerCountDown()
        }
        TimerManger.share.runTask(task: task)
    }
    
    func initSearchState(){
        
        titleL.text = "正在寻找好友......"
        
        waitView.image = UIImage(named: "search_friend_loading")
        // 设置初始角度为0
        let angleInRadians: CGFloat = 0
        // 定义动画持续时间
        let duration: TimeInterval = 1
         
        // 创建一个CABasicAnimation对象并指定其keyPath为"transform.rotation.z"
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = NSNumber(value: angleInRadians) // 起始角度
        rotationAnimation.toValue = NSNumber(value: angleInRadians + .pi * 2) // 结束角度（完成两次全部旋转）
        rotationAnimation.duration = duration
        rotationAnimation.repeatCount = Float.infinity // 无限重复
        // 将动画添加到视图上
        waitView.layer.add(rotationAnimation, forKey: nil)
        
        countDownLabel.isHidden = false
        
        jumpLabel.text = "暂时跳过"
        
        jumpLabel.isHidden = false
        waitView.isHidden = false
        subtitleL.isHidden = false
        jumpBtn.isHidden = false
        reslutColl.isHidden = true
        bottomV.isHidden = true
        continueXBtn.isHidden = true
    }
    
    func initNoSearchResult(){
        
        titleL.text = "未找到联系人"
        
        waitView.image = UIImage(named: "search_friend_no_result")
        
        waitView.layer.removeAllAnimations()
        
        countDownLabel.isHidden = true
        
        jumpLabel.text = "下一个"
        
        jumpLabel.isHidden = false
        waitView.isHidden = false
        subtitleL.isHidden = false
        jumpBtn.isHidden = false
        reslutColl.isHidden = true
        bottomV.isHidden = true
        continueXBtn.isHidden = false
    }
    
    func initSearchReslut(){
        titleL.text = "\(results.count)个联系人已经在 Backbone 上"
        waitView.image = UIImage(named: "search_friend_no_result")
        waitView.layer.removeAllAnimations()
        jumpLabel.text = "下一个"
        countDownLabel.isHidden = true
        jumpLabel.isHidden = true
        waitView.isHidden = true
        subtitleL.isHidden = true
        jumpBtn.isHidden = true
        reslutColl.isHidden = false
        bottomV.isHidden = false
        continueXBtn.isHidden = true
    }
    
    func timerCountDown(){
        //print("几时开始 \(countDown)")
        if countDown == 0 || countDown < 0{
            countDown = 3
            TimerManger.share.cancelTaskWithId(taskID)
            isSearching = false
        }
        else{
            countDown -= 1
            countDownLabel.text = "\(countDown)"
        }
    }
    lazy var titleL:UILabel = {
        let label = UILabel().then {
            $0.textAlignment = .left
            $0.font = font_32(weight: .regular)
            $0.textColor = .hex("#252525")
            $0.text = "正在寻找好友......"
        }
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var backBtn:GameBackKeyBtn = {
        let btn = GameBackKeyBtn().then {
            $0.label.textColor = .hex("#252525")
            $0.icon.image = UIImage(named: "ic-B")
            $0.btn.backgroundColor = .hex("#ffffff")
            $0.btn.layer.cornerRadius = 20.widthScale
            $0.btn.layer.masksToBounds = true
            $0.anim = true
        }
        return btn
    }()
   
    lazy var continueXBtn:GameBackKeyBtn = {
        let btn = GameBackKeyBtn().then {
            $0.label.text = "继续"
            $0.icon.image = UIImage(named: "ic-X")
            $0.btn.backgroundColor = .hex("#ffffff")
            $0.btn.layer.cornerRadius = 20.widthScale
            $0.btn.layer.masksToBounds = true
            $0.anim = true
        }
        btn.isHidden = true
        return btn
    }()
    
    lazy var waitView:UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.image = UIImage(named: "search_friend_loading")
        view.contentMode = .center
        return view
    }()
    
    
    
    lazy var subtitleL:UILabel = {
        let label = UILabel().then {
            $0.textAlignment = .left
            $0.font = font_14(weight: .regular)
            $0.textColor = .hex("#3D3D3D")
            $0.text = "只需要片刻时间。您可以等待或稍后从侧边菜单中进行操作。"
            $0.numberOfLines = 1
        }
        return label
    }()
    
    var jumpLabel:UILabel!
    lazy var jumpBtn:UIButton = {
        let btn = UIButton().then {
            $0.backgroundColor = .hex("#252525")
            $0.layer.cornerRadius = 8
            $0.layer.masksToBounds = true
        }
        let icon = UIImageView()
        icon.backgroundColor = .clear
        icon.image = UIImage(named: "ic-A-clear")
        btn.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.centerY.equalTo(btn)
            make.left.equalTo(btn).offset(43.widthScale)
            make.size.equalTo(CGSizeMake(20.widthScale, 20.widthScale))
        }
        
        jumpLabel = UILabel()
        jumpLabel.text = "暂时跳过"
        jumpLabel.textColor = .white
        jumpLabel.font = font_14(weight: .regular)
        jumpLabel.textAlignment = .center
        btn.addSubview(jumpLabel)
        jumpLabel.snp.makeConstraints { make in
            make.centerY.equalTo(btn)
            make.left.equalTo(icon.snp.right).offset(8.widthScale)
        }
        btn.addTarget(self, action: #selector(jumpBtnAction), for: .touchUpInside)
        
        countDownLabel = UILabel()
        countDownLabel.text = "\(countDown)"
        countDownLabel.textColor = .hex("#3D3D3D")
        countDownLabel.font = font_14(weight: .regular)
        countDownLabel.textAlignment = .center
        countDownLabel.backgroundColor = .hex("#CCCCCC")
        btn.addSubview(countDownLabel)
        countDownLabel.snp.makeConstraints { make in
            make.centerY.equalTo(btn)
            make.left.equalTo(jumpLabel.snp.right).offset(6.widthScale)
            make.width.height.equalTo(24.widthScale)
        }
        countDownLabel.layer.cornerRadius = 12.widthScale
        countDownLabel.layer.masksToBounds = true
        return btn
    }()
    
    @objc func jumpBtnAction(){
        NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyAPressed.rawValue),
                                        object: nil)
    }
    
    lazy var reslutColl:UICollectionView = {
        var coll:UICollectionView!
        let itemH:CGFloat = 152.widthScale
        let x:CGFloat = 0
        let space:CGFloat = 12.widthScale
        let itemW:CGFloat = 160.widthScale
        // 5.设置collectionView的布局
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: itemW, height: itemH)
        flowLayout.minimumLineSpacing = 16.widthScale
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        coll = UICollectionView.init(frame: .zero, collectionViewLayout: flowLayout)
        coll.backgroundColor = .clear
        // 6.设置collectionView的尺寸
        //bottomView?.contentSize = CGSize(width:mWidth * CGFloat(4),height:mHeight)
        // 7.分页
        //bottomView?.isPagingEnabled = true
        // 8.去掉滚动条
        coll.showsVerticalScrollIndicator = false
        coll.showsHorizontalScrollIndicator = false
        // 9.设置代理
        coll.delegate = self
        coll.dataSource = self
        // 10.注册cell
        coll.register(GameSearchFriendReslutItemView.self, forCellWithReuseIdentifier: "friendItem");
        if #available(iOS 10.0, *) {
            // 11.预加载
            coll.isPrefetchingEnabled = true
        } else {
            // Fallback on earlier versions
        }
        coll.isScrollEnabled = false
        
        coll.isHidden = true
        return coll
    }()
    
    var countDownLabel:UILabel!
    
    // 添加所有，继续
    lazy var bottomV:UIView = {
        let view = UIView()
        view.isHidden = true
        
        addAllBtn = UIButton()
        addAllBtn.setTitle("添加所有", for: .normal)
        addAllBtn.setTitleColor(.hex("#252525"), for: .normal)
        addAllBtn.titleLabel?.font = font_14(weight: .semibold)
        addAllBtn.backgroundColor = .hex("#E4E4E4")
        addAllBtn.layer.cornerRadius = 8
        addAllBtn.layer.masksToBounds = true
        view.addSubview(addAllBtn)
        addAllBtn.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(168.widthScale)
        }
        
        addAllBtn.addTarget(self, action: #selector(addAllBtnAction), for: .touchUpInside)
        
        continueBtn = UIButton()
        continueBtn.setTitle("继续", for: .normal)
        continueBtn.setTitleColor(.hex("#252525"), for: .normal)
        continueBtn.titleLabel?.font = font_14(weight: .semibold)
        continueBtn.backgroundColor = .hex("#E4E4E4")
        view.addSubview(continueBtn)
        continueBtn.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(168.widthScale)
        }
        continueBtn.layer.cornerRadius = 8.widthScale
        continueBtn.layer.masksToBounds = true
        continueBtn.addTarget(self, action: #selector(continueBtnAction), for: .touchUpInside)
        return view
    }()
    
    @objc func addAllBtnAction(){
        focusOnColl = false
        if btnFocusOnAddAll == true {
            if lastTouch != 2 {
                lastTouch = 2
            }
            else{
                NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyAPressed.rawValue), object: nil)
            }
        }else{
            btnFocusOnAddAll = true
        }
    }
    @objc func continueBtnAction(){
        focusOnColl = false
        if btnFocusOnAddAll == false {
            NotificationCenter.default.post(name: NSNotification.Name(ControllerNotificationName.KeyAPressed.rawValue), object: nil)
        }else{
            btnFocusOnAddAll = false
        }
        lastTouch = 3
    }
    var addAllBtn:UIButton!
    var continueBtn:UIButton!
}

extension GameSearchFriendView:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "friendItem", for: indexPath) as! GameSearchFriendReslutItemView
        item.model = results[indexPath.row]
        item.layer.cornerRadius = 8.widthScale
        item.layer.masksToBounds = true
        item.stateIconActionHandler = {[weak self](model:GameSearchFriendReslut?) in
            guard let `self` = self,let `model` = model else { return }
            // TODO: VC
            if model.isAdd == false {
                model.isAdd = true
                self.reslutColl.reloadData()
            }
        }
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        defer {
            lastTouch = 1
            reslutColl.reloadData()
        }
        if focusOnColl == false {
            focusOnColl = true
            for model in results {
                model.isSelect = false
            }
            results[indexPath.row].isSelect = true
        }
        else {
            for model in results {
                model.isSelect = false
            }
            results[indexPath.row].isSelect = true
        }
       
        //
        /*
         1.如果已经发送请求添加好友了，则固定显示icon已添加，bg不一定
         2.如果点击的是+，是改变icon为已添加
         3.如果点击+以外，则是改变北京市
         */
        
    }
}

class GameSearchFriendReslut:NSObject {
    // 0 表示没有选中，1表示已选中，2表示已添加
    @objc var isSelect = false
    @objc var isAdd = false
}

class GameSearchFriendReslutItemView:UICollectionViewCell {
    
    
    var stateIconActionHandler = {(model:GameSearchFriendReslut?) in}
    var model:GameSearchFriendReslut? {
        didSet{
            if let tmp = model {
                self.backgroundColor = tmp.isSelect ? .hex("#3D3D3D"):.hex("#f2f2f2")
                subTitleL.textColor = tmp.isSelect ? .hex("#ffffff"):.hex("#3D3D3D")
                titleL.textColor = tmp.isSelect ? .hex("#ffffff"):.hex("#3D3D3D")
                if tmp.isAdd {
                    stateIcon.image = UIImage(named: "friend_add_select")
                }
                else{
                    stateIcon.image = tmp.isSelect ? UIImage(named: "friend_add_white") : UIImage(named: "friend_add_black")
                }
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(icon)
        icon.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32.widthScale)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(42.widthScale)
        }
        icon.layer.cornerRadius = 21.widthScale
        icon.layer.masksToBounds = true
        
        addSubview(subTitleL)
        subTitleL.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16.widthScale)
            $0.bottom.equalToSuperview().offset(-10.widthScale)
        }
        addSubview(titleL)
        titleL.snp.makeConstraints {
            $0.left.equalTo(subTitleL)
            $0.bottom.equalToSuperview().offset(-31.widthScale)
        }
        
        addSubview(stateIcon)
        stateIcon.snp.makeConstraints {
            $0.height.width.equalTo(22.widthScale)
            $0.bottom.right.equalToSuperview().offset(-16.widthScale)
        }
        stateIcon.isUserInteractionEnabled = true
        stateIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(stateIconAction)))
    }
    
    @objc func stateIconAction(){
        stateIconActionHandler(model)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var icon:UIImageView = {
        let i = UIImageView()
        i.backgroundColor = .red
        return i
    }()
    
    lazy var subTitleL:UILabel = {
        let l = UILabel()
        l.text = "Courage"
        l.textColor = .hex("#252525")
        l.textAlignment = .left
        l.font = font_14(weight: .regular)
        return l
    }()
    
    lazy var titleL:UILabel = {
        let l = UILabel()
        l.text = "Courage"
        l.textColor = .hex("#252525")
        l.textAlignment = .left
        l.font = font_14(weight: .semibold)
        return l
    }()
    
    lazy var stateIcon:UIImageView = {
        let i = UIImageView()
        i.image = UIImage(named: "friend_add_white")
        return i
    }()
}
