//
//  VideoPlayerVC.swift
//  Eggshell
//
//  Created by leslie lee on 2022/11/22.
//
import AVKit

extension VideoPlayerVC {
    enum VideoMode {
        case edit   //普通剪辑模式
        case highlight  //高光时刻剪辑模式  保存到高光时刻
        case playToEdit //全屏播放模式,可以剪辑
        case playOnly //全屏播放模式，不可以剪辑
    }
    
    enum VideoTrimMode {
        case showRangeSlider
        case showProgressSlider
    }
    typealias VideoPlayerClosure = () -> Void
}

class VideoPlayerVC: UIViewController {
    private lazy var player: CLPlayer? = {
        let view = CLPlayer(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height )) { config in
            config.topBarHiddenStyle = .never
            config.bottomToolbarBackgroundColor = UIColor.clear
            config.topToobarBackgroundColor = UIColor.clear
            config.progressBackgroundColor = UIColor.clear
            config.progressFinishedColor = UIColor.white
            config.sliderImage = UIImage.imageWithColor(UIColor.clear);
        }
        
        return view
    }()
    //按键文字大小
    public var btnFont: UIFont = UIFont.systemFont(ofSize: 16, weight: .medium)
    //按键文字颜色
    public var btnColor: UIColor?
    
    private var videoMode:VideoMode = VideoMode.playToEdit
    private var videoTrimMode:VideoTrimMode = VideoTrimMode.showProgressSlider
    public  var urlPath:URL?
    private var sliderImage:UIImage?
    private var clipStartTime:CGFloat = 0   //剪辑开始时间
    private var clipEndTime:CGFloat = 0     //剪辑结束时间
//    private var clipProgress:UIImageView = UIImageView.init(image: UIImage(named: "ve_slider"))
    private var  minDistance:CGFloat = 5  //最小间隔 0～100
    private var sliderH:CGFloat = 40  //图片进度条高度
    public  var closure:VideoPlayerClosure?
    private lazy var backgroundView: UIImageView = {
        let view = UIImageView.init(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height ))
        view.image = UIImage.init(named: "ve_background")
        return view
    }()
    
    private lazy var sliderImageView: UIImageView = {
        //剪辑时候的缩略图
        let view = UIImageView.init(frame: CGRect(x: 0, y: 0, width: view.bounds.width - 180, height: 40 ))
        view.image = UIImage.imageWithColor(UIColor.lightGray)
        return view
    }()
    private lazy var cancelButton: UIButton = {
        let view = UIButton()
        
        view.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        return view
    }()
    private lazy var saveButton: UIButton = {
        let view = UIButton()  //保存视频
        view.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        return view
    }()
    private lazy var trimButton: UIButton = {
        let view = UIButton() //剪辑视频
        view.addTarget(self, action: #selector(trimButtonAction(_:)), for: .touchUpInside)
        return view
    }()
    private lazy var playButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage.init(named: "ve_play"), for: .normal)
        view.setImage(UIImage.init(named: "ve_pause"), for: .selected)
        view.addTarget(self, action: #selector(playButtonAction(_:)), for: .touchUpInside)
        return view
    }()
    private lazy var sliderView: GSRangeSeekSlider = {
        let view = GSRangeSeekSlider()
        view.delegate = self
        view.tag = 1001
        return view
    }()
    
    private lazy var rangeSlider: GSRangeSeekSlider = {
        let view = GSRangeSeekSlider()
        view.delegate = self
        view.tag = 1002
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true;
        commonInit()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        
    }
    
   
    
    private func commonInit() {
        view.addSubview(backgroundView)
        view.addSubview(sliderImageView)
        view.addSubview(cancelButton)
        view.addSubview(saveButton)
        view.addSubview(trimButton)
        view.addSubview(sliderView)
        view.addSubview(playButton)
        view.addSubview(rangeSlider)
        
        view.addSubview(player!)
        videoMode = VideoMode.playToEdit
        player!.clickClosure = {  clickBtn in
            switch clickBtn {
            case .highlight:
                self.highlightButtonAction()
            case .edit:
                self.editButtonAction()
            case .download:
                self.downloadVideo(path: self.urlPath!.path)
            case .delete:
                self.deleteVideo(path: self.urlPath!.path)
            case .back:
                self.backVideo()
            }
        }
        
        player!.sliderClosure = {
            
            self.setSliderProgress()
        }
        makeConstraints()
        
        
        saveButton.setTitle(i18n(string: "Save"), for: .normal)
        saveButton.titleLabel?.font = btnFont
        saveButton.setTitleColor(btnColor, for: .normal)
        saveButton.setTitleColor(UIColor.lightGray, for: .selected)
        saveButton.isSelected = true
        
        cancelButton.setTitle(i18n(string: "Cancel"), for: .normal)
        cancelButton.titleLabel?.font = btnFont
        cancelButton.setTitleColor(btnColor, for: .normal)
        
        trimButton.setTitle(i18n(string: "Trim Mode"), for: .normal)
        trimButton.titleLabel?.font = btnFont
        trimButton.setTitleColor(btnColor, for: .normal)
        trimButton.setTitleColor(UIColor.lightGray, for: .selected)
        
        rangeSlider.isHidden = true
        rangeSlider.hideLabels = true
        rangeSlider.leftHandleImage = UIImage.init(named: "ve_sliderArrow_L")
        rangeSlider.rightHandleImage = UIImage.init(named: "ve_sliderArrow_R")
        rangeSlider.colorBetweenHandles = UIColor.clear
        rangeSlider.colorSlider = UIColor.clear
//        rangeSlider.minDistance = (10/(self.player?.totalDuration ?? 0.0))*100 //最小间距
        rangeSlider.minDistance = minDistance
        rangeSlider.sliderLineBetweenHandlesImage = UIImage.init(named: "ve_slider")
        rangeSlider.lineHeight = 40
        
        sliderView.leftHandleImage = UIImage.init(named: "ve_slider_w")
        sliderView.hideLabels = true
        sliderView.hideRightHandle = true
        sliderView.colorBetweenHandles = UIColor.clear
        sliderView.colorSlider = UIColor.clear
    }
    
    func resetVideo(){
        self.player!.url = urlPath
        self.player!.play()
        self.player?.snp.remakeConstraints { make in
            make.height.equalTo(view.bounds.height)
            make.width.equalTo(view.bounds.width)
            make.top.equalTo(0)
            make.centerX.equalToSuperview()
        }
        self.player?.setCorner(width: view.bounds.width, height: view.bounds.height, corners: .allCorners, cornerRadii: CGSize(width: 0, height: 0))
   
    }
    func makeConstraints() {
        
        sliderImageView.snp.makeConstraints { make in
            make.left.equalTo(90)
            make.right.equalTo(-90)
            make.bottom.equalTo(-70)
            make.height.equalTo(40)
        }
        sliderImageView.layoutIfNeeded()
        sliderImageView.setCorner(width: sliderImageView.bounds.width, height: sliderImageView.bounds.height, corners: .allCorners, cornerRadii: CGSize(width: 8, height: 8))
        
        sliderView.snp.makeConstraints { make in
            make.left.equalTo(80)
            make.right.equalTo(-80)
            make.bottom.equalTo(-70)
            make.height.equalTo(40)
        }
        
        rangeSlider.snp.makeConstraints { make in
            make.left.equalTo(80)
            make.right.equalTo(-80)
            make.bottom.equalTo(-90)
            make.height.equalTo(40)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.width.equalTo(70)
            make.height.equalTo(25)
            make.centerX.equalTo(sliderImageView.snp.left)
            make.bottom.equalTo(-25)
        }
        saveButton.snp.makeConstraints { make in
            //            make.width.equalTo(70)
            make.height.equalTo(25)
            make.left.equalTo(cancelButton.snp.right).offset(8)
            make.bottom.equalTo(-25)
            
        }
        trimButton.snp.makeConstraints { make in
            //            make.width.equalTo(170)
            make.height.equalTo(25)
            make.centerX.equalTo(sliderImageView.snp.right)
            make.bottom.equalTo(-25)
            
        }
        
        playButton.snp.makeConstraints { make in
            make.centerX.equalTo(sliderImageView.snp.centerX)
            make.bottom.equalTo(-25)
            
        }
        
        
    }
    //MARK: - 播放界面按键相应
    public func highlightPlayMode(flag:Bool){
        self.videoMode = flag ? .playOnly:.playToEdit
        resetVideo()
        self.player?.contentView.highlightPlayMode(flag: flag)
        if videoMode == .playToEdit{
            self.getSliderImageView()
        }
    }
    
    private func editButtonAction(){
        self.videoMode = .edit
        self.player?.pause()
        let vsize:CGSize  = self.resolutionForLocalVideo(url: urlPath!)!
        var hight:CGFloat = view.bounds.height - 148 - 32
        var width:CGFloat = (hight/vsize.height)*vsize.width
        if  (width > view.bounds.width - 220 ) {
            width = view.bounds.width - 220
            hight = (width/vsize.width)*vsize.height
            self.player?.snp.remakeConstraints { make in
                make.height.equalTo(hight)
                make.width.equalTo(width)
                make.centerY.equalTo(view.snp.centerY).offset(-50)
                make.centerX.equalToSuperview()
            }
            self.player?.setCorner(width: width, height: hight, corners: .allCorners, cornerRadii: CGSize(width: 16, height: 16))
        }else{
            self.player?.snp.remakeConstraints { make in
                make.height.equalTo(hight)
                make.width.equalTo(width)
                make.top.equalTo(32)
                make.centerX.equalToSuperview()
            }
            self.player?.setCorner(width: width, height: hight, corners: .allCorners, cornerRadii: CGSize(width: 16, height: 16))
        }
        self.player?.contentView.isHidden = true
        
    }
    
    private func downloadVideo(path:String){
        self.player?.pause()
        ESSaveToAlbum.shared.saveFileVideo(_videoPath: path, _viewCom: self) { boo in
            print("保存结果:  %@",boo)
   
            if (boo){
                DispatchQueue.main.sync {
                    let alert = UIAlertController(title: i18n(string: "Successfully saved to album"), message: "", preferredStyle: .alert)
                    let Cancel = UIAlertAction(title: i18n(string: "Confirm"), style: .cancel) { (UIAlertAction) in
                       
                    }
                    alert.addAction(Cancel)
                    self.present(alert, animated: true, completion:nil)
                }
            }else{
               print("保存失败，请稍后再试")
            }
         
        }
    }
    
    private func deleteVideo(path:String){
        //创建UIAlertController(警告窗口)
        let alert = UIAlertController(title: i18n(string: "Delete the video"), message: "", preferredStyle: .alert)
        //创建UIAlertController的Action
        let OK = UIAlertAction(title: i18n(string: "Delete"), style: .default) { (UIAlertAction) in
            self.player?.pause()
            self.player?.stop()
            do {
                try FileManager.default.removeItem(atPath: path)
                self.closure?()
            }catch{
                print("删除失败：%@",error)
            }
            self.navigationController?.popViewController(animated: true)
            self.view.removeFromSuperview()
        }
        let Cancel = UIAlertAction(title: i18n(string: "Cancel"), style: .cancel) { (UIAlertAction) in
            print("you selected cancel")
        }
        //将Actiont加入到AlertController
        alert.addAction(OK)
        alert.addAction(Cancel)
        //以模态方式弹出
        self.present(alert, animated: true, completion: nil)
    }
    
    private func backVideo(){
        self.rangeSlider.isHidden = true
        self.sliderView.isHidden = false
        self.clipEndTime = 0
        self.clipStartTime = 0
        self.sliderImage = nil
        self.sliderImageView.image = nil
        self.player?.pause()
        self.player?.stop()
        self.navigationController?.popViewController(animated: true)
        self.view.removeFromSuperview()
    }
    private func highlightButtonAction(){
        
        self.editButtonAction()
        self.videoMode = .highlight
    }
    
    //MARK: - 视频剪辑相关
    
    //获取视频比例
    private func resolutionForLocalVideo(url: URL) -> CGSize? {
        guard let track = AVURLAsset(url: url).tracks(withMediaType: AVMediaType.video).first else { return nil }
        let size = track.naturalSize.applying(track.preferredTransform)
        var width = 0.0
        var height = 0.0
        if size.height > size.width {
            width = size.height
            height = size.width
        }else{
            width = size.width
            height = size.height
        }
        return CGSize(width: abs(width), height: abs(height))
    }
    //获取视频特定帧
    fileprivate func generateThumnail(url : URL, fromTime:Float64) -> UIImage? {
        let asset :AVAsset = AVAsset(url: url)
        let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        assetImgGenerate.requestedTimeToleranceAfter = CMTime.zero;
        assetImgGenerate.requestedTimeToleranceBefore = CMTime.zero;
        let time : CMTime = CMTimeMakeWithSeconds(fromTime, preferredTimescale: 600)
        if let img = try? assetImgGenerate.copyCGImage(at:time, actualTime: nil) {
            return UIImage(cgImage: img)
        } else {
            return nil
        }
    }
    private func getVideoSliderTimeToImage()->[Float64]{
        let audioAsset = AVURLAsset.init(url: urlPath!, options: nil)
        let audioDuration = audioAsset.duration
        let audioDurationSeconds = CMTimeGetSeconds(audioDuration)  //视频总时间
        if (audioDurationSeconds  == 0) {
            return []
        }
        let pSize = resolutionForLocalVideo(url: urlPath!) ?? CGSizeMake(50, 50) //视频的size
        let everyPixelW = (pSize.width * 40)/pSize.height
        let sliderW = UIScreen.main.bounds.size.width - 180   //进度条长度
        
        let index:Int = Int(sliderW / everyPixelW)
        let everyimageTime:Float64 = Float64(audioDurationSeconds) / Float64(index)
        var arr:[Float64] = []
        for i4 in 0...index // 会将区间的值依次赋值给i
        {
            var a:Float64 =  everyimageTime * Double(i4);
            if a == 0 {a += 0.5} //刚刚启动0秒可能获取不到视频祯
            print(index)
            print(everyimageTime)
            print(pSize)
            arr.append(a)
        }
        
        return arr
    }
    
    private func getVideoThumnail()->[UIImage]{
        let arr =  getVideoSliderTimeToImage()
        var imageArr :[UIImage] = []
        print(arr)
        for a in 0...(arr.count-1){
          
            let image = generateThumnail(url: urlPath!, fromTime: arr[a])
            if (image != nil ){
                imageArr.append(image!)
            }else{
                print("第\(a)祯获取出现问题")
            }
           
        }
        return imageArr
    }
    
    
    
    // 1.把多张绘制成一张图片
    func drawImages(imageArray: [UIImage]) -> UIImage? {
        // 1.1.图片的宽度
        var width: CGFloat = 0
        // 1.2.图片的高度
        var height: CGFloat = 0
        
        // 1.3.遍历图片数组里的所有图片
        for image in imageArray {
            //            // 1.3.1.获取每一张图片的宽度
            //            width = (image.size.width > width) ? image.size.width : width
            //            // 1.3.2.获取每一张图片的高度, 并且相加
            //            height += image.size.height
            
            // 1.3.1.获取每一张图片的宽度
            height = (image.size.height > height) ? image.size.height : height
            // 1.3.2.获取每一张图片的高度, 并且相加
            width += image.size.width
        }
        
        // 1.4.开始绘制图片的大小
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        
        // 1.5.设置一个变量用来获取UIImage的X值
        var imageX: CGFloat = 0
        
        // 1.6.遍历图片的数组
        for image in imageArray {
            // 1.6.1.开始绘画图片
            image.draw(at: CGPoint(x: imageX, y: 0))
            // 1.6.2.自增每张图片的X轴
            imageX += image.size.width
        }
        
        // 1.7.获取已经绘制好的图片
        let drawImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 1.8.结束绘制图片
        UIGraphicsEndImageContext()
        
        // 1.9.返回已经绘制的图片
        return drawImage
    }
    
    
    @objc func cancelButtonAction() {
        self.videoMode = .playToEdit
        self.rangeSlider.selectedMaxValue = 100
        self.clipEndTime = 0
        self.clipStartTime = 0
        self.player?.contentView.isHidden = false
        self.saveButton.isSelected = true
        self.player?.snp.remakeConstraints { make in
            make.height.equalTo(view.bounds.height)
            make.width.equalTo(view.bounds.width)
            make.top.equalTo(0)
            make.centerX.equalToSuperview()
        }
        self.player?.setCorner(width: view.bounds.width, height: view.bounds.height, corners: .allCorners, cornerRadii: CGSize(width: 0, height: 0))
        self.player?.play()
        
        rangeSlider.isHidden = true
        sliderView.isHidden = false
        saveButton.isSelected = true
        trimButton.isSelected = false
        setSliderProgress()
        sliderView.isUserInteractionEnabled = true
        clipEndTime = 0
    }
    
    @objc func saveButtonAction(){
        
        if (videoMode == .edit  || videoMode == .highlight){
            clipVideo()
        }
    }
    
    @objc  func playButtonAction(_ button: UIButton) {
        button.isSelected = !button.isSelected
        if (button.isSelected){
            player?.isUserPause = false
            let dragedCMTime = CMTimeMake(value: Int64(ceil(clipStartTime)), timescale: 1)
            player?.player?.seek(to: dragedCMTime, toleranceBefore: .zero, toleranceAfter: .zero)
            player?.play()
        }else{
            player?.isUserPause = true
            player?.pause()
        }
    }
    @objc  func trimButtonAction(_ button: UIButton) {
        videoTrimMode =  (videoTrimMode == VideoTrimMode.showProgressSlider) ?  VideoTrimMode.showRangeSlider:VideoTrimMode.showProgressSlider
        self.player?.pause()
        playButton.isSelected = false
        if (videoTrimMode == VideoTrimMode.showProgressSlider){
            rangeSlider.isHidden = true
            sliderView.isHidden = false
            saveButton.isSelected = true
            trimButton.isSelected = false
            setSliderProgress()
            sliderView.isUserInteractionEnabled = true
            clipEndTime = 0
        }else{
            if (clipEndTime == 0){
                clipEndTime = self.player?.totalDuration ?? 0
                self.rangeSlider.selectedMaxValue = 100
            }
            rangeSlider.isHidden = false
            setRangeSliderProgress()
            saveButton.isSelected = false
            trimButton.isSelected = true
            sliderView.isUserInteractionEnabled = false
        }
        
    }
    
    
//    @objc func progressSliderTouchBegan(_ slider: CLSlider) {
//
//        player?.pause()
//        playButton.isSelected = false
//
//    }
//
//    @objc func progressSliderValueChanged(_ slider: CLSlider) {
//        //        delegate?.sliderValueChanged(slider, in: self)
////        print("\(slider.value)")
//
//            var currentDuration:Double = player?.currentDuration ?? 0.00
//            let totalDuration:Double = player?.totalDuration ?? 0.00
//            currentDuration = totalDuration * TimeInterval(slider.value)
//            let dragedCMTime = CMTimeMake(value: Int64(ceil(currentDuration)), timescale: 1)
//            player?.player?.seek(to: dragedCMTime, toleranceBefore: .zero, toleranceAfter: .zero)
////        print("dragedCMTime    \(dragedCMTime.value)      slider.value  \(slider.value)")
//    }
//
//    @objc func progressSliderTouchEnded(_ slider: CLSlider) {
//
//    }
    func setSliderProgress() {
        let currentDuration:Double = player?.currentDuration ?? 0.00
        let totalDuration:Double = player?.totalDuration ?? 0.00
        let playbackProgress = currentDuration/totalDuration
        if (playbackProgress >= (clipEndTime/totalDuration) && clipEndTime != 0){
            print("======playbackProgress \(playbackProgress)   rangeSlider.maxValue \(clipEndTime/totalDuration)")
            self.playButtonAction(self.playButton)
        }
        sliderView.selectedMinValue = (CGFloat(playbackProgress) * 100)
    }
    
    func setRangeSliderProgress() {
        let currentDuration:Double = player?.currentDuration ?? 0.00
        let totalDuration:Double = player?.totalDuration ?? 0.00
        let playbackProgress = currentDuration/totalDuration
        if ((rangeSlider.maxValue - (playbackProgress * 100)) >= minDistance){
            rangeSlider.selectedMinValue = CGFloat(playbackProgress * 100)
            clipStartTime = currentDuration
        }else{
            rangeSlider.selectedMinValue = (rangeSlider.maxValue - minDistance)
        }
       
        
    }
    
     
    private func clipVideo(){
      
        let asset  = AVAsset.init(url: urlPath!)
        let videoAssetTrack = asset.tracks(withMediaType: .video).first!
        let audioAssetTrack = asset.tracks(withMediaType: .audio).first
        let timescale = videoAssetTrack.timeRange.duration.timescale
        let startTime:CMTime = CMTimeMake(value: Int64(clipStartTime * CGFloat(timescale)), timescale: timescale)
        let endTime:CMTime = CMTimeMake(value: Int64(clipEndTime * CGFloat(timescale)), timescale: timescale)
        
        //这是工程文件
        let composition = AVMutableComposition.init()
        
        //视频轨道
        
        let videoCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)!
        
        //在视频轨道插入一个时间段的视频
        
        do {
            try videoCompositionTrack.insertTimeRange(CMTimeRange(start: startTime, end: endTime), of: videoAssetTrack, at: .zero)
            print("成功加入视频  startTime: \(startTime)   endTime:  \(endTime)  videoAssetTrack :\(videoAssetTrack.timeRange.duration)")
        }catch{
            print(error)
        }
        if audioAssetTrack != nil {
            //音频轨道
            let audioCompositionTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)!
            //插入音频数据，否则没有声音
            do {
                try  audioCompositionTrack.insertTimeRange(CMTimeRange(start: startTime, end: endTime), of: audioAssetTrack!, at: .zero)
                print("成功加入音频  audioAssetTrack :\(audioAssetTrack!.timeRange.duration)")
            }catch{
                print(error)
            }
        }
     
        //导出
        let exporter = AVAssetExportSession.init(asset: composition, presetName: AVAssetExportPresetHighestQuality)
        let fileName = Date.timestamp()
        var path:URL
        var imageCoverPath:URL //保存一张封面
        var imageSliderPath:URL   //获取进度条缓存图
        if videoMode == .edit {
             path = ScreenRecSharePath.filePathUrlWithFileName(fileName)
             imageCoverPath = ScreenRecSharePath.filePathUrlWithFileName(fileName, "png")  //保存一张封面
             imageSliderPath = ScreenRecSharePath.filePathUrlWithFileName(fileName + "_slider", "png")  //获取进度条缓存图
        }else{
            path = ScreenRecSharePath.highlightFilePathUrlWithFileName(fileName)
            imageCoverPath = ScreenRecSharePath.highlightFilePathUrlWithFileName(fileName, "png")  //保存一张封面
            imageSliderPath = ScreenRecSharePath.highlightFilePathUrlWithFileName(fileName + "_slider", "png")  //获取进度条缓存图
        }
        
        
        exporter?.outputURL = path
        exporter?.outputFileType = .mp4
        exporter?.shouldOptimizeForNetworkUse = true
        exporter?.exportAsynchronously(completionHandler: {
            if ((exporter?.error) != nil){
                
                print(exporter!.error!)
                print("视频剪切失败  \(path)",path)
            }else{
                print("视频剪切成功  \(path)",path)
                let image = self.generateThumnail(url: path, fromTime: 0.5)
                let data =  image?.pngData()
                do {
                    try data?.write(to: imageCoverPath)
                    print("封面保存成功")
                }catch{
                    print("封面保存失败")
                }
                
                let imageArr = self.getVideoThumnail()
                if imageArr.count == 0 {return}
                let image2 =  self.drawImages(imageArray: imageArr)!
                let data2 =  image2.pngData()
                do {
                    try data2?.write(to: imageSliderPath)
                    print("进度条缩略图保存成功")
                    
                }catch{
                    print("进度条缩略图封面保存失败")
                }
                
                DispatchQueue.main.sync {
                    if self.videoMode == .edit {
                        let alert = UIAlertController(title: i18n(string: "Video clip success"), message: "", preferredStyle: .alert)
                        let Cancel = UIAlertAction(title: i18n(string: "Confirm"), style: .cancel) { (UIAlertAction) in
                            
                        }
                        alert.addAction(Cancel)
                        self.present(alert, animated: true, completion:nil)
                    }else if (self.videoMode == .highlight){
                        self.displayHighlightNameView()
                        CaptureManager.shared.highlightVideoURL = path.path
                        CaptureManager.shared.highlightCoverUrlFromVideo = imageCoverPath.path
                    }
                }
            }
            
        })
    }
    
    func getSliderImageView(){
        var imagePath = self.urlPath?.path.replacingOccurrences(of: ".mp4", with: "") ?? ""
        imagePath.append("_slider.png")
        let imageUrl = URL.init(fileURLWithPath: imagePath)
        do{
            let imgData = try Data.init(contentsOf: imageUrl)
            let image = UIImage(data: imgData)
            print("进度条缩略图缓存获取成功")
            self.sliderImage = image
            self.sliderImageView.image = self.sliderImage
        }catch{
            self.player?.readyClosure = {
                let workItem  = DispatchWorkItem{
                    print("self.player?.totalDuration :\(self.player!.totalDuration)")
                    if (self.player?.totalDuration ?? 0 > 0){
                        let imageArr = self.getVideoThumnail()
                        if imageArr.count == 0 {return}
                        self.sliderImage =  self.drawImages(imageArray: imageArr)!
                    }
                }
                DispatchQueue.global().async(execute: workItem)
                workItem.notify(queue: DispatchQueue.main) {
                    print("任务执行完回到主队列刷新UI")
                    if self.sliderImage == nil {return}
                    self.sliderImageView.image = self.sliderImage
                    self.sliderImageView.contentMode = .scaleAspectFill
                    //获取进度条缓存图
                    let data =  self.sliderImage?.pngData()
                    do {
                        try data?.write(to: imageUrl)
                        print("进度条缩略图保存成功")
                    }catch{
                        print("进度条缩略图封面保存失败")
                    }
                }
            }
        }
    }
    func displayHighlightNameView() {
        let nameView = HighlightNameView(frame: self.view.bounds)
        self.view.superview?.addSubview(nameView)
    }
    
}

extension VideoPlayerVC: GSRangeSeekSliderDelegate {
    //滑动进度条
    func rangeSeekSlider(_ slider: GSRangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if slider.tag == 1002 {
//            双向的
            self.player?.pause()
            self.playButton.isSelected = false
            var dragedCM:Double = 0.0
            if (clipStartTime != (minValue / 100) * (player?.totalDuration ?? 0) ){
                clipStartTime = (minValue / 100) * (player?.totalDuration ?? 0)
                dragedCM = clipStartTime
          
            }else if ( clipEndTime != (maxValue / 100) * (player?.totalDuration ?? 0)){
                clipEndTime = (maxValue / 100) * (player?.totalDuration ?? 0)
                dragedCM = clipEndTime
            }
            if dragedCM == 0 {return}
//            var duration:Double = dragedCM //获得百分比
            let dragedCMTime = CMTimeMake(value: Int64(ceil(dragedCM)), timescale: 1)
            player?.player?.seek(to: dragedCMTime, toleranceBefore: .zero, toleranceAfter: .zero)
//            print("----minValue-\(minValue)--maxValue:\(maxValue)--dragedCMTime \(dragedCMTime)--")
//            print("duration :\(duration)  dragedCM:\(dragedCM)   dragedCMTime:\(dragedCMTime) player?.totalDuration:\(player?.totalDuration ?? 0)")
        }else if (slider.tag == 1001){
//            单项进度条
            
            
        }
    }
    
    func didStartTouches(in slider: GSRangeSeekSlider) {
        print("did start touches")
    }
    
    func didEndTouches(in slider: GSRangeSeekSlider) {
        print("did end touches")
    }
}


