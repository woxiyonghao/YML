//
//  GSFeedbackViewController.swift
//  GameSirBeyond
//
//  Created by lu on 2024/4/10.
//

import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit
//import JXPhotoBrowser
class GSFeedbackViewController: UIViewController {
    
    fileprivate let disposeBag = DisposeBag()
    fileprivate let mWidth = kHeight
    fileprivate let mHeight = kWidth
    fileprivate var photoBtns = [GSFeedbackPhotoBtn]()
    fileprivate var userPhotos = [UIImage]()// 封面，图片
    fileprivate var userAssets = [PHAsset]()// 实体
    fileprivate let maxPhotoCount:Int = 5
    
    fileprivate var describeBgH:CGFloat{
        return 210
    }
    fileprivate var describeTFW:CGFloat {
        return mWidth-24.widthScale-24.widthScale
    }
    
    var dismiss = {() in}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        //fd_prefersNavigationBarHidden = false
        
        setupNav()
        
        setupScr()
        
        setupEmall()
        
        setupDescribe()
        
        setupPhotos()
        
    }
 
    func setupPhotos(){
        let photoW:CGFloat = 82.widthScale+24.widthScale
        let photoY:CGFloat =  CGRectGetMaxY(describeBg.frame) + 21.widthScale
        let photoH = photoW
        for i in 0..<maxPhotoCount {
            var photo:GSFeedbackPhotoBtn!
            if i < 3 {
                photo = GSFeedbackPhotoBtn(frame: CGRectMake(photoW * CGFloat(i),photoY, photoW,photoH))
            }
            else{
                photo = GSFeedbackPhotoBtn(frame: CGRectMake(photoW * CGFloat(i%3),photoY + photoH, photoW,photoH))
            }
            photo.photoView.tag = 10 + i
            photo.deleteBtn.tag = 10 + i
            photoBtns.append(photo)
            scr.addSubview(photo)
            photo.isHidden = i != 0
            photo.deleteBtn.isHidden = true
            photo.photoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector(photoViewAction)))
            photo.deleteBtn.addTarget(self, action: #selector(photoDeleteBtnAction), for: .touchUpInside)
        }
    }
    
    @objc func photoViewAction(tap:UIGestureRecognizer){
        
        guard let photoView = tap.view as? UIImageView else {
            return
        }
        emallTF.endEditing(true)
        describeTF.endEditing(true)
         GSAuthTool.checkPhotoLibraryPermission {[unowned self] reslut in
             var lib = UserDefaultWrapper<Int?>(key: UserDefaultKeys.ifNeedLibrary)
             lib.wrappedValue = reslut
             if reslut == 2 {
                 print("library 未授权")
                 return
             }
             let count = self.userPhotos.count
             let tag = photoView.tag - 10
             if tag < count {
                 self.showBigPicture(photoView: photoView)
             }
             else {
                 self.toPicketPhoto()
             }
             
         }
    }
    
    func showBigPicture(photoView:UIImageView){
        let tag = photoView.tag - 10
        let asset = userAssets[tag]
        
        if asset.mediaType == .video {
            TZImageManager.default().getVideoWith(asset) { [weak self] item, _ in
                guard let `self` = self else { return  }
                videoPreview(item: item)
            }
            return
        }
        if asset.mediaType == .image {
            photoPreview(image: userPhotos[tag])
            return
        }
    }
    
    func photoPreview(image:UIImage){
        // 实例化
        let browser = JXPhotoBrowser()
        // 浏览过程中实时获取数据总量
        browser.numberOfItems = {
            1
        }
        // 刷新Cell数据。本闭包将在Cell完成位置布局后调用。
        browser.reloadCellAtIndex = { context in
            let browserCell = context.cell as? JXPhotoBrowserImageCell
            let indexPath = IndexPath(item: context.index, section: 0)
            browserCell?.imageView.image = image
        }
        // 可指定打开时定位到哪一页
        browser.pageIndex = 0
        // 展示
        browser.show()
        
        // dismis回调
        browser.willDismiss = { _ in
            JXPhotoBrowserLog.low("即将dismiss!")
            return true
        }
        browser.didDismiss = { _ in
            JXPhotoBrowserLog.low("已经dismiss!")
        }
    }
    
    func videoPreview (item:AVPlayerItem?){
        
        let browser = JXPhotoBrowser()
        // 指定滑动方向为垂直
        browser.scrollDirection = .vertical
        browser.numberOfItems = {
            1
        }
        browser.cellClassAtIndex = { index in
            VideoCell.self
        }
        browser.reloadCellAtIndex = { context in
            JXPhotoBrowserLog.high("reload cell!")
            let browserCell = context.cell as? VideoCell
            browserCell?.player.replaceCurrentItem(with: item)
            
        }
        browser.cellWillAppear = { cell, index in
            JXPhotoBrowserLog.high("开始播放")
            (cell as? VideoCell)?.player.play()
        }
        browser.cellWillDisappear = { cell, index in
            JXPhotoBrowserLog.high("暂停播放")
            (cell as? VideoCell)?.player.pause()
        }
       
        browser.pageIndex = 0
        browser.show()
    }
   
    
    
    
    func setupEmall(){
        emallL = UILabel().then({[weak self] in
            guard let `self` = self else { return }
            $0.text = "电子邮件"
            $0.textAlignment = .left
            $0.font = font_16(weight: .medium)
            $0.textColor = .hex("#252525")
            self.scr.addSubview($0)
            $0.frame = CGRectMake(12.widthScale, 12.widthScale, mWidth-12.widthScale, 20.widthScale)
        })
        
        emallBg = UIView().then({[weak self] in
            guard let `self` = self else { return }
            $0.backgroundColor = .hex("#F7F7F7")
            $0.layer.cornerRadius = 8.widthScale
            $0.layer.masksToBounds = true
            self.scr.addSubview($0)
            $0.frame = CGRectMake(self.emallL.x, CGRectGetMaxY(self.emallL.frame) + 6.widthScale, mWidth-24.widthScale, 48.widthScale)
        })
        
        emallTF = UITextField().then({[weak self] in
            guard let `self` = self else { return }
            self.emallBg.addSubview($0)
            $0.frame = CGRectMake(12.widthScale, 14.widthScale, self.emallBg.width-24.widthScale, self.emallBg.height-28.widthScale)
            let str = "输入电子邮件地址" as NSString
            let attr = NSMutableAttributedString(str as String)
            attr.addAttribute(.font, value: font_14(weight: .regular), range: NSMakeRange(0, str.length))
            attr.addAttribute(.foregroundColor, value: UIColor.hex("#B4B4B4"), range: NSMakeRange(0, str.length))
            $0.attributedPlaceholder = attr
            $0.font = font_14(weight: .regular)
            $0.textColor = .hex("#252525")
            $0.textAlignment = .left
            $0.returnKeyType = .done
        })
        
        emallTF.rx.controlEvent(.editingDidEnd)
            .subscribe {_ in
                print("emallTF 编辑完成")
            }.disposed(by: disposeBag)
        
        emallTF.rx.text.orEmpty
            .subscribe {
                [weak self] in
                guard let `self` = self else { return }
                print($0)
            }.disposed(by: disposeBag)
    }
    
    func setupDescribe(){
        describeL = UILabel().then({[weak self] in
            guard let `self` = self else { return }
            $0.text = "描述"
            $0.textAlignment = .left
            $0.font = font_16(weight: .medium)
            $0.textColor = .hex("#252525")
            self.scr.addSubview($0)
            $0.frame = CGRectMake(self.emallL.x, CGRectGetMaxY(self.emallBg.frame)+24.widthScale, mWidth-12.widthScale, 20.widthScale)
        })
        
        
        describeBg = UIView().then({[weak self] in
            guard let `self` = self else { return }
            $0.backgroundColor = .hex("#F7F7F7")
            $0.layer.cornerRadius = 8.widthScale
            $0.layer.masksToBounds = true
            self.scr.addSubview($0)
            $0.frame = CGRectMake(self.emallL.x, CGRectGetMaxY(self.describeL.frame) + 6.widthScale, mWidth-24.widthScale, describeBgH)
        })
        
        describeTF = UITextView().then({[weak self] in
            guard let `self` = self else { return }
            $0.backgroundColor = .clear
            $0.font = font_14(weight: .regular)
            $0.textColor = .hex("#252525")
            $0.textAlignment = .left
            $0.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            $0.textContainer.lineFragmentPadding = 0
            self.describeBg.addSubview($0)
            $0.frame = CGRectMake(12.widthScale, 14.widthScale, describeTFW, self.describeBg.height-14.widthScale - 40.widthScale) // - 40 是0/500的高度
        })
        
        describePlaceholdL = UILabel().then({ [weak self] in
            guard let `self` = self else { return }
            $0.text = "请留下您宝贵的意见，我们将努力改进~"
            $0.numberOfLines = 0
            $0.textAlignment = .left
            $0.font = font_14(weight: .regular)
            $0.textColor = .hex("#B4B4B4")
            self.describeTF.addSubview($0)
            $0.frame = CGRectMake(0, 0, self.describeBg.width, 20)
        })
        
        describeCountL = UILabel().then({[weak self] in
            guard let `self` = self else { return }
            $0.text = "0/500"
            $0.textAlignment = .right
            $0.font = font_16(weight: .medium)
            $0.textColor = .hex("#cccccc")
            self.describeBg.addSubview($0)
            $0.frame = CGRectMake(0, CGRectGetMaxY(self.describeTF.frame)+0, self.describeBg.width-12.widthScale, 40.widthScale)
        })
        
        // 编辑中改变
        describeTF.rx.text.orEmpty.subscribe(onNext: {[weak self] in
            guard let `self` = self else { return }
            self.describeCountL.text = "\($0.count)" + "/500"
            //let height = self.calculateInputTFHeight(str:NSMutableString(string: $0))
        })
        .disposed(by: disposeBag)
            
        //开始编辑响应
        describeTF.rx.didBeginEditing.subscribe(onNext: {[weak self] in
            guard let `self` = self else { return }
            //print("开始编辑")
            self.describePlaceholdL.isHidden = true
        })
        .disposed(by: disposeBag)
        
        //结束编辑响应
        describeTF.rx.didEndEditing.subscribe(onNext: {[weak self] in
            guard let `self` = self else { return }
            self.describePlaceholdL.isHidden = !self.describeTF.text.isBlank
        })
        .disposed(by: disposeBag)
    }
    /*
    func calculateInputTFHeight(str:NSMutableString)->CGFloat{
        let style = NSMutableParagraphStyle()
        style.maximumLineHeight = 20
        style.lineSpacing = 0
        style.minimumLineHeight = 20
        style.lineBreakMode = .byCharWrapping
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: self.describeTF.font ?? font_14(weight: .regular),
            .paragraphStyle: style,
            .foregroundColor:UIColor.hex("#252525")
        ]
        self.describeTF.attributedText = NSAttributedString(string: str as String,attributes: textAttributes)
        let size = str.boundingRect(with: CGSize(width: self.describeTF.frame.width, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: textAttributes, context: nil)
        return size.height
    }
    */
    private func textViewChangeHeightHandler(){
      
    }
    
    func setupScr(){
        scr = UIScrollView().then({[weak self] in
            guard let `self` = self else { return }
            self.view.addSubview($0)
            $0.backgroundColor = .white
            $0.frame = CGRect(x: 0, y: 80.widthScale, width: mWidth, height: mHeight - 80.widthScale)
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            if #available(iOS 11.0, *) {
                $0.contentInsetAdjustmentBehavior = .never
            } else {
                automaticallyAdjustsScrollViewInsets = false
            }
        })
    }
    
    func setupNav(){
        /*
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: commitBtn)
        navigationItem.titleView = titleL
       
        backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        commitBtn.addTarget(self, action: #selector(commitBtnAction), for: .touchUpInside)
         */
        let nav = UIView(frame: CGRectMake(0, 0, mWidth, 80.widthScale))
        view.addSubview(nav)
        nav.addSubview(titleL)
        titleL.frame = CGRectMake(0, 40.widthScale, mWidth, 40.widthScale)
        nav.addSubview(backBtn)
        backBtn.frame = CGRectMake(0, 40.widthScale, 40.widthScale, 40.widthScale)
        nav.addSubview(commitBtn)
        commitBtn.frame = CGRectMake(mWidth-40.widthScale, 40.widthScale, 40.widthScale, 40.widthScale)
        backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        commitBtn.addTarget(self, action: #selector(commitBtnAction), for: .touchUpInside)
    }
    
    @objc func backAction(){
        
        dismiss()
       

    }
    
    @objc func commitBtnAction(){
        guard emallTF.text?.isBlank == false else {
            print("请输入emall")
            return
        }
        guard describeTF.text?.isBlank == false else {
            print("请输入描述")
            return
        }
        
        guard userAssets.count != 0 else {
            print("请选择图片")
            return
        }
        emallTF.endEditing(true)
        describeTF.endEditing(true)
        print("commitBtnAction")
    }
    
    lazy var backBtn:UIButton = {
        let btn = UIButton(frame: CGRectMake(0, 0, 40.widthScale, 40.widthScale))
        btn.setImage(UIImage(named: "nav_close_black"), for: .normal)
        btn.backgroundColor = .clear
        return btn
    }()
    
    lazy var commitBtn:UIButton = {
        let btn = UIButton(frame: CGRectMake(0, 0, 40.widthScale, 40.widthScale))
        btn.setImage(UIImage(named: "feedback_commit"), for: .normal)
        btn.backgroundColor = .clear
        return btn
    }()
    
    lazy var titleL:UILabel = {
        let l = UILabel(frame: CGRectMake(0, 0, mWidth, 40))
        l.text = "意见反馈"
        l.textColor = .hex("#333333")
        l.textAlignment = .center
        l.font = font_18(weight: .medium)
        return l
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 强制竖屏
        forceOrientationPortrait()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // 强制横屏
        forceOrientationLandscape()
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
    
    ///强制竖屏
    func forceOrientationPortrait() {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.isForcePortrait = true
        let _ = appdelegate.application(UIApplication.shared,
                                        supportedInterfaceOrientationsFor: self.view.window)
        
        //强制翻转屏幕，Home键在右边。
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue,
                                  forKey: "orientation")
        //刷新
        UIViewController.attemptRotationToDeviceOrientation()
        
    }
    
    var scr:UIScrollView!
    var emallL:UILabel!
    var emallBg:UIView!
    var emallTF:UITextField!
    
    var describeL:UILabel!
    var describeBg:UIView!
    var describeTF:UITextView!
    var describePlaceholdL:UILabel!
    var describeCountL:UILabel!
}


extension GSFeedbackViewController:TZImagePickerControllerDelegate{
    
    
    func toPicketPhoto(){
        let count = maxPhotoCount - userPhotos.count
        guard let imagePickerVc = TZImagePickerController.init(maxImagesCount: count, delegate: self)
              else { return }
        imagePickerVc.allowPickingMultipleVideo = true
        imagePickerVc.allowPickingOriginalPhoto = true
        imagePickerVc.showSelectedIndex = true
        //imagePickerVc.isSelectOriginalPhoto = true
        imagePickerVc.allowCrop = false
        imagePickerVc.allowEditVideo = false
        imagePickerVc.allowTakeVideo = false
        imagePickerVc.allowPickingGif = false
        imagePickerVc.allowTakePicture = false
        imagePickerVc.allowPickingVideo = true
        imagePickerVc.allowPickingImage = true
        imagePickerVc.modalPresentationStyle = .fullScreen;
        navigationController?.present(imagePickerVc, animated: true,completion: {
            
        })
       
    }
    
    func tz_imagePickerControllerDidCancel(_ picker: TZImagePickerController!) {
        
    }
    
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool, infos: [[AnyHashable : Any]]!) {
        
        /*
        for tmp in assets {
            let asset = tmp as? PHAsset
            if asset == nil {
                continue
            }
            if asset!.mediaType == .image {
                self.fetchPhotos(asset: asset!)
                    .subscribe { image in
                    if image != nil {
                        self.userAssets.append(asset!)
                        self.userPhotos.append(image!)
                    }
                }.disposed(by: self.disposeBag)
            }
            else if asset!.mediaType == .video {
                self.fetchVideoUrl(asset: asset!)
                    .flatMap { return self.fetchVideoCover(url: $0)}
                    .subscribe {
                        if $0 != nil {
                            self.userAssets.append(asset!)
                            self.userPhotos.append($0!)
                        }
                    }.disposed(by: self.disposeBag)
            }
            else {
                continue
            }
        }
        */
        photos.forEach { image in
            self.userPhotos.append(image)
        }
        assets.forEach { asset in
            
            self.userAssets.append(asset as! PHAsset)
        }
        showPhotos()
        picker.dismiss(animated: true)
    }
    
    func showPhotos(){
        if userPhotos.count == maxPhotoCount {
            for i in 0..<photoBtns.count {
                photoBtns[i].isHidden = false
                photoBtns[i].photoView.image = userPhotos[i]
                photoBtns[i].deleteBtn.isHidden = false
            }
        }
        else {
            for i in 0..<photoBtns.count {
                photoBtns[i].photoView.image = i < userPhotos.count ? userPhotos[i] :UIImage(named: "feedback_add_photo")
                photoBtns[i].isHidden = !(i <= userPhotos.count)
                photoBtns[i].deleteBtn.isHidden = !(i < userPhotos.count)
            }
        }
    }
    
    @objc func photoDeleteBtnAction(btn:UIButton){
        let tag = btn.tag - 10
        if tag >= 0 && tag < self.userPhotos.count {
            self.userPhotos.remove(at: tag)
            self.userAssets.remove(at: tag)
        }
        showPhotos()
    }
    
    ///---------   避免回调地狱
    /// 获取这个asset对应的图片
    func fetchPhotos(asset: PHAsset) -> Observable<UIImage?> {
        return Observable<UIImage?>.create { observer in
            TZImageManager.default().getPhotoWith(asset) { image, _, reslut in
                
                observer.onNext(image)
            }
            return Disposables.create()
        }
    }
    
    /// 获取这个asset对应的视频AVPlayerItem
    func fetchVideos(asset: PHAsset) -> Observable<AVPlayerItem?>{
        return Observable<AVPlayerItem?>.create { observer in
            TZImageManager.default().getVideoWith(asset) { item, _ in
                observer.onNext(item)
            }
            return Disposables.create()
        }
    }
    
    /// 获取这个asset对应的视频url
    func fetchVideoUrl(asset:PHAsset)-> Observable<URL?> {
        return Observable<URL?>.create { observer in
            //let semaphoreSignal = DispatchSemaphore(value: 1)
            //semaphoreSignal.wait()
            PHCachingImageManager.default().requestAVAsset(forVideo: asset, options: nil, resultHandler: { (video, audioMix, info) in
                print("当前线程 \(Thread.current)")
                DispatchQueue.main.async {
                    var url: URL?
                    if let urlAsset = video as? AVURLAsset {
                        url = urlAsset.url
                    }
                    //semaphoreSignal.signal()
                    observer.onNext(url)
                 }
            })
            
            return Disposables.create()
        }
    }
    
    
    
    /// 获取这个url对应的cover
    func fetchVideoCover(url: URL?) -> Observable<UIImage?>{
        return Observable<UIImage?>.create { observer in
            if url == nil {
                observer.onNext(nil)
            }
            else {
                let image = TZImageManager.default().getImageWithVideoURL(url)
                observer.onNext(image)
            }
            return Disposables.create()
        }
    }
  
}

//class GSFeedbackViewModel {
//    /// 验证邮箱 必填
//    let emallValid: Observable<Bool>
//    /// 验证描述 必填
//    let describeValid: Observable<Bool>
//    /// 验证图片 必填
//    let photoValid: Observable<Bool>
//    /// 邮箱，描述，图片 输出
//    let commitValid: Observable<Bool>
//    
//    
//    init(emoji:Observable<String>,describe:Observable<String>,phots:Observable<[UIImage]>){
//        
//        emallValid    = emoji
//                .map({$0.isBlank == false})
//                .share(replay: 1)
//        
//        describeValid = describe
//            .map({$0.isBlank == false && $0.count <= 500})
//            .share(replay: 1)
//        
//        photoValid = phots
//            .map({ $0.count > 0})
//            .share(replay: 1)
//        
//        commitValid = Observable
//            .combineLatest(emallValid, describeValid, photoValid){
//                $0 && $1 && $2
//            }.share(replay: 1)
//        
//    }
//    
//}

class GSFeedbackPhotoBtn:UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(photoView)
        photoView.isUserInteractionEnabled = true
        photoView.image = UIImage(named: "feedback_add_photo")
        photoView.contentMode = .scaleAspectFit
        //photoBtn.setBackgroundImage(UIImage(named: "feedback_add_photo"), for: .normal)
        photoView.backgroundColor = .clear
        photoView.frame = CGRectMake(12.widthScale, 12.widthScale, self.width - 24.widthScale, self.height-24.widthScale)
        
        self.addSubview(deleteBtn)
        deleteBtn.setBackgroundImage(UIImage(named: "feedback_delete_photo"), for: .normal)
        deleteBtn.backgroundColor = .clear
        deleteBtn.frame = CGRectMake(self.width-24.widthScale, 0, 24.widthScale, 24.widthScale)
        deleteBtn.layer.cornerRadius = deleteBtn.width * 0.5
        deleteBtn.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var photoView = UIImageView()
    lazy var deleteBtn = UIButton()
    
}

