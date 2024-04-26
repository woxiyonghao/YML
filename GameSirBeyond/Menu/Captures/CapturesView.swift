//
//  CapturesView.swift
//  Eggshell
//
//  Created by 刘富铭 on 2022/11/21.
//

import UIKit
import Moya
import SwiftyJSON
import AVFoundation
import SwiftVideoBackground
import Photos
import AVFoundation

enum CaptureType: Int {
    case recording = 1
    case highlight = 2
    case screenshot = 4
}

class CapturesView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var type: CaptureType = .recording
    
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var backButton1: AnimatedButton!
    @IBOutlet weak var backButton2: AnimatedButton!
    @IBOutlet weak var operationButtonsView: UIView!
    @IBOutlet weak var openButton: AnimatedButton!
    @IBOutlet weak var saveButton: AnimatedButton!
    @IBOutlet weak var deleteButton: AnimatedButton!
    @IBOutlet weak var addButton: AnimatedButton!
    
    var tableView = TabTableView(frame: CGRect.zero, style: .plain)
    
    var focusTableViewIndexPath = IndexPath(row: 0, section: 0)
    var datas: [String] = []
    let cellSize = CGSizeMake(150, 70)
    var focusCollectionViewIndexPath: IndexPath = IndexPath.init(row: -1, section: 0) {
        didSet {
            if focusCollectionViewIndexPath.row < 0 {
                operationButtonsView.isHidden = true
            }
            else {
                operationButtonsView.isHidden = false
            }
        }
    }
    var highlights: [VideoModel] = []
    
#if !DEBUG
//    let playVC = VideoPlayerVC.init()
#endif
    
    @objc func injected() {
        collectionView.removeFromSuperview()
        initCollectionView()
    }
    
    var contentView: UIView!
    func initSubviews() {
        let bgImageView = UIImageView(frame: bounds)
        bgImageView.image = UIImage(named: "full_bg")
        bgImageView.contentMode = .scaleAspectFill
        addSubview(bgImageView)
        addBlurEffect(style: .dark, alpha: 0.3)
        
        contentView = ((Bundle.main.loadNibNamed("CapturesView", owner: self, options: nil)?.first) as! UIView)
        addSubview(contentView)
        contentView.frame = self.bounds// 不能用frame
        
        deleteButton.setTitle("  ".appending(i18n(string: "Delete")), for: .normal)
        saveButton.setTitle("  ".appending(i18n(string: "Save")), for: .normal)
        openButton.setTitle("  ".appending(i18n(string: "Open")), for: .normal)
        addButton.setTitle("  ".appending(i18n(string: "Add")), for: .normal)
        
        backButton1.tapAction = {
            self.btnActionBack()
        }
        backButton2.tapAction = {
            self.btnActionBack()
        }
        deleteButton.tapAction = {
            self.btnActionDelete()
        }
        saveButton.tapAction = {
            self.btnActionSaveToAlbum()
        }
        openButton.tapAction = {
            self.btnActionOpen()
        }
        addButton.tapAction = {
            self.pickAnImage()
        }
        
        deleteButton.setControllerImage(type: .y)
        saveButton.setControllerImage(type: .x)
        openButton.setControllerImage(type: .a)
        backButton2.setControllerImage(type: .b)
        addButton.setControllerImage(type: .menu)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshScreenshots), name: Notification.Name("GetScreenshotNotification"), object: nil)
        
        self.datas = getRecordings()
        //        if getRecordings().count > 0 {
        //            self.datas = [getRecordings()[0], getRecordings()[0], getRecordings()[0], getRecordings()[0], getRecordings()[0], getRecordings()[0], getRecordings()[0]]// TODO: 删除测试数据
        //        }
        CaptureManager.shared.shouldReuqestHighlightData = true
        
        initCollectionView()
        initTableView()
        
        contentView.bringSubviewToFront(leftView)// 放在rightView之上
        leftView.clipsToBounds = false
        contentView.bringSubviewToFront(deleteButton)
        operationButtonsView.isHidden = true
        contentView.bringSubviewToFront(operationButtonsView)
    }
    
    var isShowingImagePickerController = false
    var imagePicker: UIImagePickerController?
    func pickAnImage() {
        imagePicker = UIImagePickerController()
        imagePicker!.delegate = self
        imagePicker!.sourceType = .photoLibrary
        imagePicker!.allowsEditing = false
        imagePicker!.videoQuality = .typeHigh
        imagePicker!.mediaTypes = ["public.image", "public.movie"]
        viewController()!.present(imagePicker!, animated: true) {
            print("UIImagePickerController: presented")
            self.isShowingImagePickerController = true
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String {
            if mediaType == "public.image" {
                guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
                    return
                }
                
                saveImageToApp(image: image, name: Date().string)
                picker.dismiss(animated: true) { [unowned self] in
                    self.isShowingImagePickerController = false
                }
            } else if mediaType == "public.movie" {
                guard let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL else {
                    return
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    // 在此处使用视频URL进行处理
                    // 获取视频的持续时间
                    let asset = AVAsset(url: videoURL)
                    let durationInSeconds = CMTimeGetSeconds(asset.duration)
                    if durationInSeconds > 30 {
                        MBProgressHUD.showMsgWithtext(i18n(string: "Sorry, only supports adding videos within 30 seconds"))
                        picker.dismiss(animated: true) { [unowned self] in
                            self.isShowingImagePickerController = false
                        }
                        return
                    }
                    
                    let creationDate = self.getCreationDate(for: asset as! AVURLAsset)
                    let name = creationDate?.string ?? Date().string
                    // 保存视频到本地
                    self.saveVideoToApp(videoUrl: videoURL, name: name)
                    picker.dismiss(animated: true) { [unowned self] in
                        self.isShowingImagePickerController = false
                    }
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) { [unowned self] in
            self.isShowingImagePickerController = false
        }
    }
    
    let errorOccurredMsg = i18n(string: "An error occurred")
    func saveVideoToApp(videoUrl: URL, name: String) {
        if name == "" {
            MBProgressHUD.showMsgWithtext(self.errorOccurredMsg)
            return
        }
        
        let hud = MBProgressHUD.showActivityLoading("")
        
        let asset = AVURLAsset(url: videoUrl)
        let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHEVCHighestQuality)// 取最高质量的视频
        let urlString = recordingsPath().appending(name).appending(".mp4")
        let outputURL = URL(fileURLWithPath: urlString)
        exportSession?.outputURL = outputURL
        exportSession?.outputFileType = AVFileType.mp4
        exportSession?.exportAsynchronously(completionHandler: {
            if exportSession?.status == .completed {
                MainThread {
                    hud.removeFromSuperview()
                    MBProgressHUD.showMsgWithtext(i18n(string: "Video added"))
                    if self.focusTableViewIndexPath.row == 0 {
                        self.datas = getRecordings()
                        self.reloadCollectionView()
                    }
                }
            } else if exportSession?.status == .failed {
                MainThread {
                    hud.removeFromSuperview()
                    MBProgressHUD.showMsgWithtext(i18n(string: "Failed to add video"))
                }
            }
        })
    }
    
    func saveImageToApp(image: UIImage, name: String) {
        if name == "" {
            MBProgressHUD.showMsgWithtext(self.errorOccurredMsg)
            return
        }
        
        let hud = MBProgressHUD.showActivityLoading("")
        let urlString = screenshotsPath().appending(name).appending(".png")
        let outputURL = URL(fileURLWithPath: urlString)
        do {
            try image.pngData()?.write(to: outputURL)
            hud.removeFromSuperview()
            MBProgressHUD.showMsgWithtext(i18n(string: "Image added"))
            MainThread {
                if self.focusTableViewIndexPath.row == 2 {
                    self.datas = getScreenshots()
                    self.reloadCollectionView()
                }
            }
        }
        catch {
            hud.removeFromSuperview()
            MBProgressHUD.showMsgWithtext(i18n(string: "Failed to add image"))
        }
    }
    
    func getCreationDate(for asset: AVURLAsset) -> Date? {
        let keys = ["creationDate"]
        var creationDate: Date?
        
        asset.loadValuesAsynchronously(forKeys: keys) {
            for key in keys {
                var error: NSError?
                let status = asset.statusOfValue(forKey: key, error: &error)
                
                if status == .loaded {
                    creationDate = asset.creationDate?.startDate
                    break
                } else if status == .failed {
                    print("Error loading asset values: \(error?.localizedDescription ?? "")")
                    break
                }
            }
        }
        return creationDate
    }
    
    func initCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 15
        flowLayout.minimumInteritemSpacing = 30
        flowLayout.itemSize = cellSize
        //        collectionView = UICollectionView(frame: rightView.bounds, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        //        rightView.addSubview(collectionView)
        collectionView.collectionViewLayout = flowLayout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ScreenshotCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "ScreenshotCollectionViewCell")
        collectionView.register(UINib(nibName: "RecordingCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "RecordingCollectionViewCell")
        // 根据CellSize，算出contentInset
        let collectionViewWidth = (UIScreen.main.bounds.size.width-200)
        let leftRight = collectionViewWidth-cellSize.width*3-2*30// 每行显示3个cell
        collectionView.contentInset = UIEdgeInsets.init(top: 20, left: leftRight/2.0, bottom: 20, right: leftRight/2.0)
        rightView.bringSubviewToFront(collectionView)
    }
    
    func initTableView() {
        tableView = TabTableView.init(frame: CGRect(x: 0, y: 85, width: 200, height: UIScreen.main.bounds.size.height-85), style: .plain)
        leftView.addSubview(tableView)
        leftView.bringSubviewToFront(addButton)
        
        let settingsLeftDatas = [
            [
                SettingsTabDataKey.icon.rawValue: "recordings",
                SettingsTabDataKey.selectedIcon.rawValue: "recordings_selected",
                SettingsTabDataKey.title.rawValue: i18n(string: "Recordings"),
                SettingsTabDataKey.number.rawValue: "0"
            ],
            [
                SettingsTabDataKey.icon.rawValue: "highlights",
                SettingsTabDataKey.selectedIcon.rawValue: "highlights_selected",
                SettingsTabDataKey.title.rawValue: i18n(string: "Highlights"),
                SettingsTabDataKey.number.rawValue: "0"
            ],
            [
                SettingsTabDataKey.icon.rawValue: "photos",
                SettingsTabDataKey.selectedIcon.rawValue: "photos_selected",
                SettingsTabDataKey.title.rawValue: i18n(string: "Screenshots"),
                SettingsTabDataKey.number.rawValue: "0"
            ]
        ]
        
        // MARK: 切换录屏、高光时刻、截图
        tableView.didSelectRow = { row in
            self.focusTableViewIndexPath = IndexPath(row: row, section: 0)
            
            switch row {
            case 0:
                self.datas = []
                self.reloadCollectionView()
                
                self.type = .recording
                self.datas = getRecordings()
                self.reloadCollectionView()
            case 1:
//                self.datas = getHighlights()
                self.reloadCollectionView()
                
                self.type = .highlight
                self.requestHighlights()
            case 2:
                self.datas = []
                self.reloadCollectionView()
                
                self.type = .screenshot
                self.datas = getScreenshots()
                self.reloadCollectionView()
            default:
                return
            }
        }
        
        tableView.datas = settingsLeftDatas
    }
    
    func reloadCollectionView() {
        focusCollectionViewIndexPath = IndexPath.init(row: -1, section: 0)
        
        delay(interval: 0.01) {
            MainThread {
                if self.collectionView != nil {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    @objc func refreshScreenshots() {
        if focusTableViewIndexPath.row == 2 {
            datas = getScreenshots()
            
            reloadCollectionView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initSubviews()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch type {
        case .recording:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecordingCollectionViewCell", for: indexPath) as! RecordingCollectionViewCell
            if datas.count > indexPath.row {
                let filePath = datas[indexPath.row]
                let image = generateThumnail(url: URL.init(fileURLWithPath: filePath), fromTime: 1)
                cell.coverImageView.image = image
            }
            return cell
            
        case .highlight:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecordingCollectionViewCell", for: indexPath) as! RecordingCollectionViewCell
//            if datas.count > indexPath.row {
//                let filePath = datas[indexPath.row]
//                let image = generateThumnail(url: URL.init(fileURLWithPath: filePath), fromTime: 1)
//                cell.coverImageView.image = image
//            }
            if highlights.count > indexPath.row{
                
                cell.coverImageView.sd_setImage(with: URL.init(string: highlights[indexPath.row].coverURL))
                
            }
            return cell
            
        case .screenshot:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScreenshotCollectionViewCell", for: indexPath) as! ScreenshotCollectionViewCell
            if datas.count > indexPath.row {
                let imagePath = datas[indexPath.row]
                let imageData = FileManager.default.contents(atPath: imagePath)
                let image = UIImage(data: imageData ?? Data())
                cell.set(image: image ?? UIImage(named: "category_bg")!)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch type {
        case .recording:
            if focusCollectionViewIndexPath == indexPath {
                if focusCollectionViewIndexPath.row < 0 || focusCollectionViewIndexPath.row >= datas.count {
                    return
                }
                displayRecordingDetailView(videoUrl: self.datas[indexPath.item])
                return
            }
        case .highlight:
            if focusCollectionViewIndexPath == indexPath {
                if focusCollectionViewIndexPath.row < 0 || focusCollectionViewIndexPath.row >= highlights.count {
                    return
                }
                
                displayHighlightDetailView(videoUrl: highlights[indexPath.item].videoURL)

                return
            }
        case .screenshot:
            if focusCollectionViewIndexPath == indexPath {
                displayFullPhotoView()
                return
            }
        }
        
        let lastCell = collectionView.cellForItem(at: focusCollectionViewIndexPath)
        let cell = collectionView.cellForItem(at: indexPath)
        focusCollectionViewIndexPath = indexPath
        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
        UIView.animate(withDuration: animationDuration(), delay: 0, options: .curveEaseInOut) {
            lastCell?.transform = CGAffineTransform(scaleX: 1, y: 1)
            cell?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
    }
    
    func displayRecordingDetailView(videoUrl: String) {
        if videoUrl == "" {
            MBProgressHUD.showMsgWithtext(self.errorOccurredMsg)
            return
        }
        
//        let destView = RecordingDetailView(frame: UIScreen.main.bounds)
//        superview?.addSubview(destView)
//        destView.videoUrl = videoUrl
        
#if !DEBUG
//                playVC.urlPath = URL.init(fileURLWithPath: videoUrl)
//                superview?.addSubview(playVC.view)
//                playVC.closure = {
//                    self.datas = getRecordings()
//                    self.reloadCollectionView()
//                }
//                playVC.highlightPlayMode(flag: false)
#endif
    }
    
    func displayHighlightDetailView(videoUrl: String) {
        if videoUrl == "" {
            MBProgressHUD.showMsgWithtext(self.errorOccurredMsg)
            return
        }
        
        let destView = RecordingDetailView(frame: UIScreen.main.bounds)
        superview?.addSubview(destView)
        destView.videoUrl = videoUrl
        destView.shareButton.isHidden = true
    }
    
    // MARK: 全屏展示图片
    func displayFullPhotoView() {
        let cell = collectionView.cellForItem(at: focusCollectionViewIndexPath) as? ScreenshotCollectionViewCell
        if cell == nil {
            return
        }
        
        let fullView = FullPhotoView.init(frame: bounds)
        superview?.addSubview(fullView)
        fullView.photoImageView.image = cell!.coverImageView.image
    }
    
    // MARK: 打开
    func btnActionOpen() {
        if focusCollectionViewIndexPath.row < 0 || focusCollectionViewIndexPath.row >= datas.count {
            return
        }
        
        collectionView(collectionView, didSelectItemAt: focusCollectionViewIndexPath)
    }
    
    // MARK: 保存到相册
    func btnActionSaveToAlbum() {
        if focusCollectionViewIndexPath.row < 0 || focusCollectionViewIndexPath.row >= datas.count {
            MBProgressHUD.showMsgWithtext(i18n(string: "Please select a capture"))
            return
        }
        
        switch type {
        case .recording:
            let coverUrl = datas[focusCollectionViewIndexPath.row]// 注意！表格数据是封面图片
            let videoUrl = URL(string: coverUrl)!.path.replacingOccurrences(of: "png", with: "mp4")// 视频
            saveRecordingToAlbum(videoUrl: URL(string: videoUrl)!)
        case .highlight:
            let videoUrl = highlights[focusCollectionViewIndexPath.row].videoURL
            saveHighlightToAlbum(videoUrl: URL(string: videoUrl)!)
        case .screenshot:
            let cell = collectionView.cellForItem(at: focusCollectionViewIndexPath) as? ScreenshotCollectionViewCell
            if cell == nil {
                return
            }
            let image = cell!.coverImageView.image!
            saveImageToAlbum(image: image)
        }
    }
    
    // 保存图片到相册
    let savedImageToAlbum = i18n(string: "Image saved to album")
    let failedToSaveImage = i18n(string: "Failed to save image")
    func saveImageToAlbum(image: UIImage) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { saved, error in
            if saved {
                MBProgressHUD.showMsgWithtext(self.savedImageToAlbum)
            } else {
                MBProgressHUD.showMsgWithtext(self.failedToSaveImage)
            }
        }
    }
    
    // 保存视频到相册
    let savedVideoToAlbum = i18n(string: "Video saved to album")
    let failedToSaveVideo = i18n(string: "Failed to save video")
    func saveRecordingToAlbum(videoUrl: URL) {
        if videoUrl.absoluteString == "" {
            MBProgressHUD.showMsgWithtext(self.errorOccurredMsg)
            return
        }
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoUrl)
        }) { saved, error in
            if saved {
                MBProgressHUD.showMsgWithtext(self.savedVideoToAlbum)
            } else {
                MBProgressHUD.showMsgWithtext(self.failedToSaveVideo)
            }
        }
    }
    
    func saveHighlightToAlbum(videoUrl: URL) {
        if videoUrl.absoluteString == "" {
            MBProgressHUD.showMsgWithtext(self.errorOccurredMsg)
            return
        }
        
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                var hud: MBProgressHUD?
                MainThread {
                    hud = MBProgressHUD.showActivityLoading("")
                }
                URLSession.shared.dataTask(with: videoUrl) { data, response, error in
                    if let data = data {
                        let tempFilePath = NSTemporaryDirectory().appending("temp.mp4")
                        let tempFileURL = URL(fileURLWithPath: tempFilePath)
                        do {
                            try data.write(to: tempFileURL)
                            PHPhotoLibrary.shared().performChanges({
                                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: tempFileURL)
                            }) { success, error in
                                if success {
                                    MainThread {
                                        hud?.removeFromSuperview()
                                        MBProgressHUD.showMsgWithtext(self.savedVideoToAlbum)
                                    }
                                } else {
                                    MainThread {
                                        hud?.removeFromSuperview()
                                        MBProgressHUD.showMsgWithtext(self.failedToSaveVideo)
                                    }
                                }
                            }
                        } catch {
                            MainThread {
                                hud?.removeFromSuperview()
                                MBProgressHUD.showMsgWithtext(self.failedToSaveVideo)
                            }
                        }
                    } else {
                        MainThread {
                            hud?.removeFromSuperview()
                            MBProgressHUD.showMsgWithtext(self.failedToSaveVideo)
                        }
                    }
                }.resume()
            } else {
                print("Photo library access denied")
            }
        }
    }
    
    // MARK: 删除
    let alertTitle = i18n(string: "Are you sure to delete the capture?")
    let cancelTitle = i18n(string: "Cancel")
    let confirmTitle = i18n(string: "Confirm")
    func btnActionDelete() {
        if focusCollectionViewIndexPath.row < 0 || focusCollectionViewIndexPath.row >= datas.count {
            MBProgressHUD.showMsgWithtext(i18n(string: "Please select a capture"))
            return
        }
        
        let filePath = datas[focusCollectionViewIndexPath.row]
        
        switch type {
        case .recording:
            let quitView = QuitAccountView(frame: self.bounds)
            quitView.titleLabel.text = alertTitle
            quitView.confirmButton.setTitle(confirmTitle, for: .normal)
            quitView.cancelButton.setTitle(cancelTitle, for: .normal)
            self.superview?.addSubview(quitView)
            quitView.didTapCloseButton = {
                quitView.removeFromSuperview()
            }
            quitView.didTapCancelButton = {
                quitView.removeFromSuperview()
            }
            quitView.didTapConfirmButton = {
                do {
                    try FileManager.default.removeItem(atPath: filePath)
                    self.datas.remove(at: self.focusCollectionViewIndexPath.row)
                    self.collectionView.deleteItems(at: [self.focusCollectionViewIndexPath])
                }
                catch {
                    MBProgressHUD.showMsgWithtext(i18n(string: "Failed to delete recording"))
                }
                
                quitView.removeFromSuperview()
            }
        case .highlight:
            let quitView = QuitAccountView(frame: self.bounds)
            quitView.titleLabel.text = alertTitle
            quitView.confirmButton.setTitle(confirmTitle, for: .normal)
            quitView.cancelButton.setTitle(cancelTitle, for: .normal)
            self.superview?.addSubview(quitView)
            quitView.didTapCloseButton = {
                quitView.removeFromSuperview()
            }
            quitView.didTapCancelButton = {
                quitView.removeFromSuperview()
            }
            quitView.didTapConfirmButton = {
                if self.focusCollectionViewIndexPath.row < 0 || self.focusCollectionViewIndexPath.row >= self.highlights.count {
                    MBProgressHUD.showMsgWithtext(self.errorOccurredMsg)
                    return
                }
                
                let networker = MoyaProvider<GameService>()
                networker.request(.deleteGameVideo(id: String(self.highlights[self.focusCollectionViewIndexPath.row].videoID))) { result in
                    switch result {
                    case let .success(response): do {
                        let data = try? response.mapJSON()
                        let json = JSON(data!)
                        let responseData = json.dictionaryObject!
                        let code = responseData["code"] as! Int
                        if code == NetworkErrorType.NeedLogin.rawValue {
                            NotificationCenter.default.post(name: Notification.Name("UserDidLogoutNotification"), object: nil)
                            return
                        }
                        if code == 200 {
                            print("删除视频成功")
                            self.datas.remove(at: self.focusCollectionViewIndexPath.row)
                            self.highlights.remove(at: self.focusCollectionViewIndexPath.row)
                            self.collectionView.deleteItems(at: [self.focusCollectionViewIndexPath])
                            CaptureManager.shared.shouldReuqestHighlightData = true
                        }
                        else {
                            MBProgressHUD.showMsgWithtext(i18n(string: "Failed to delete highlight"))
                        }
                    }
                    case .failure(_): do {
                        print("网络错误")
                    }
                        break
                    }
                }
                
                quitView.removeFromSuperview()
            }
        case .screenshot:
            let quitView = QuitAccountView(frame: self.bounds)
            quitView.titleLabel.text = alertTitle
            quitView.confirmButton.setTitle(confirmTitle, for: .normal)
            quitView.cancelButton.setTitle(cancelTitle, for: .normal)
            self.superview?.addSubview(quitView)
            quitView.didTapCloseButton = {
                quitView.removeFromSuperview()
            }
            quitView.didTapCancelButton = {
                quitView.removeFromSuperview()
            }
            quitView.didTapConfirmButton = {
                do {
                    try FileManager.default.removeItem(atPath: filePath)
                    self.datas.remove(at: self.focusCollectionViewIndexPath.row)
                    self.collectionView.deleteItems(at: [self.focusCollectionViewIndexPath])
//                    self.focusCollectionViewIndexPath = IndexPath(row: -1, section: 0)
                    
                    // 选中上一张图片
//                    var destRow = self.focusTableViewCellIndexPath.row-1
//                    if destRow > 0 {
//                        if self.datas.count > destRow {
//                            self.focusCollectionViewIndexPath = IndexPath(row: destRow, section: self.focusCollectionViewIndexPath.section)
//                        }
//                    }
//                    else {// 或者选中下一张图片
//                        destRow = self.focusTableViewCellIndexPath.row+1
//                        if self.datas.count > destRow {
//                            self.focusCollectionViewIndexPath = IndexPath(row: destRow, section: self.focusCollectionViewIndexPath.section)
//                        }
//                    }
                    
//                    self.collectionView(self.collectionView, didSelectItemAt: self.focusCollectionViewIndexPath)
                    self.collectionView.reloadData()
                    print("删除截图成功")
                }
                catch {
                    MBProgressHUD.showMsgWithtext(i18n(string: "Failed to delete screenshot"))
                }
                
                quitView.removeFromSuperview()
            }
        }
    }
    
    // MARK: 获取Highlights数据
    private var highlightDatas: [String] = []
    func requestHighlights() {
        if CaptureManager.shared.shouldReuqestHighlightData == false {// 有数据，直接展示
            datas = highlightDatas
            self.reloadCollectionView()
            return
        }
        
        let networker = MoyaProvider<GameService>()
        networker.request(.getSharedGameVideos) { result in
            switch result {
            case let .success(response): do {
                if self.focusTableViewIndexPath.row == 1 {
                    let data = try? response.mapJSON()
                    let json = JSON(data!)
                    let responseData = json.dictionaryObject!
                    let code = responseData["code"] as! Int
                    if code == NetworkErrorType.NeedLogin.rawValue {
                        NotificationCenter.default.post(name: Notification.Name("UserDidLogoutNotification"), object: nil)
                        return
                    }
                    if code == 200 {
                        self.datas = []
                        
                        let videoDatas = (responseData["data"] as! [String: Any])["result"] as! [[String: Any]]
                        print(videoDatas)
                        for data in videoDatas {
                            let model = VideoModel(JSONString: data.string()!)
                            self.datas.append((model?.coverURL)!)// 只保存封面数据
                            self.highlights.append(model!)// 保存完整数据
                        }
                        print("获取Highlight数据成功：", responseData)
                        self.reloadCollectionView()
                        self.highlightDatas = self.datas
                        
                        CaptureManager.shared.shouldReuqestHighlightData = false
                    }
                    else {
                        print("获取Highlight数据失败", responseData["msg"]!)
                        self.datas = []
                        self.highlightDatas = []
                        self.reloadCollectionView()
                    }
                }
            }
            case .failure(_): do {
                print("网络错误")
                if self.focusTableViewIndexPath.row == 1 {
                    self.datas = []
                    self.highlightDatas = []
                    self.reloadCollectionView()
                }
            }
                break
            }
        }
    }
    
    // MARK: 返回
    func btnActionBack() {
//        let destView = UserView.init(frame: superview!.bounds)
//        superview?.addSubview(destView)
        
        removeFromSuperview()
    }
    
    // MARK: 手柄操控
    func gamepadKeyUpAction() {
        if isShowingImagePickerController {
            appPlayIneffectiveSound()
            return
        }
        if UIViewController.current() is UIActivityViewController {
            appPlayIneffectiveSound()
            return
        }
        
        // focusCollectionViewCellIndexPath >= 0：此时焦点在collectionView上
        if focusCollectionViewIndexPath.row >= 0 {
            let destRow = focusCollectionViewIndexPath.row-3
            if destRow < 0 || destRow >= datas.count {
                appPlayIneffectiveSound()
                return // 禁止再次点击
            }
            
            appPlayScrollSound()
            let destIndexPath = IndexPath(row: destRow, section: focusCollectionViewIndexPath.section)
            collectionView(collectionView, didSelectItemAt: destIndexPath)
        }
        else {
            let destRow = focusTableViewIndexPath.row-1
            if destRow < 0 || destRow >= tableView.datas.count {
                appPlayIneffectiveSound()
                return
            }
            
            appPlayScrollSound()
            clickTableViewCell(at: IndexPath(row: focusTableViewIndexPath.row-1, section: focusTableViewIndexPath.section))
        }
    }
    
    func gamepadKeyDownAction() {
        if isShowingImagePickerController {
            appPlayIneffectiveSound()
            return
        }
        if UIViewController.current() is UIActivityViewController {
            appPlayIneffectiveSound()
            return
        }
        
        if focusCollectionViewIndexPath.row >= 0 {
            var destRow = focusCollectionViewIndexPath.row+3
            if destRow < 0 || destRow >= datas.count {
                destRow = focusCollectionViewIndexPath.row+2// 试试前一个
                if destRow < 0 || destRow >= datas.count {
                    destRow = focusCollectionViewIndexPath.row+1// 再试前一个
                    if destRow < 0 || destRow >= datas.count {
                        appPlayIneffectiveSound()
                        return
                    }
                }
            }
            
            appPlayScrollSound()
            let destIndexPath = IndexPath(row: destRow, section: focusCollectionViewIndexPath.section)
            collectionView(collectionView, didSelectItemAt: destIndexPath)
        }
        else {
            let destRow = focusTableViewIndexPath.row+1
            if destRow < 0 || destRow >= tableView.datas.count {
                appPlayIneffectiveSound()
                return
            }
            
            appPlayScrollSound()
            clickTableViewCell(at: IndexPath(row: destRow, section: focusTableViewIndexPath.section))
        }
    }
    
    func gamepadKeyLeftAction() {
        if isShowingImagePickerController {
            appPlayIneffectiveSound()
            return
        }
        if UIViewController.current() is UIActivityViewController {
            appPlayIneffectiveSound()
            return
        }
        
        if focusCollectionViewIndexPath.row >= 0 {
            appPlayScrollSound()
            if focusCollectionViewIndexPath.row%3 == 0 {// 最左侧cell
                let cell = collectionView.cellForItem(at: focusCollectionViewIndexPath)
                UIView.animate(withDuration: animationDuration(), delay: 0, options: .curveEaseInOut) {
                    cell?.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
                
                clickTableViewCell(at: focusTableViewIndexPath)
            }
            else {
                let destRow = focusCollectionViewIndexPath.row-1// 前面已排除最左侧cell，因此这里必然>=0
                let destIndexPath = IndexPath(row: destRow, section: focusCollectionViewIndexPath.section)
                collectionView(collectionView, didSelectItemAt: destIndexPath)
            }
        }
        else {
            appPlayIneffectiveSound()
        }
    }
    
    func gamepadKeyRightAction() {
        if isShowingImagePickerController {
            appPlayIneffectiveSound()
            return
        }
        if UIViewController.current() is UIActivityViewController {
            appPlayIneffectiveSound()
            return
        }
        
        if focusCollectionViewIndexPath.row >= 0 {// 焦点在collectionView
            let destRow = focusCollectionViewIndexPath.row+1
            if destRow < 0 || destRow >= datas.count {
                appPlayIneffectiveSound()
                return
            }
            
            appPlayScrollSound()
            let destIndexPath = IndexPath(row: destRow, section: focusCollectionViewIndexPath.section)
            collectionView(collectionView, didSelectItemAt: destIndexPath)
        }
        else {
            if datas.count <= 0 {
                appPlayIneffectiveSound()
                return
            }
            
            appPlayScrollSound()
            let cell = tableView.cellForRow(at: focusTableViewIndexPath) as? TabTableViewCell
            cell?.isSelected = false
            cell?.isGrayStatus = true
            let destIndexPath = IndexPath(row: 0, section: 0)
            collectionView(collectionView, didSelectItemAt: destIndexPath)
        }
    }
    
    func gamepadKeyAAction() {// 确认
        if isShowingImagePickerController {
            appPlayIneffectiveSound()
            return
        }
        if UIViewController.current() is UIActivityViewController {
            appPlayIneffectiveSound()
            return
        }
        
        appPlaySelectSound()
        openButton.sendActions(for: .touchUpInside)
    }
    
    func gamepadKeyBAction() {// 返回
        if isShowingImagePickerController {
            imagePicker?.dismiss(animated: true, completion: {
                self.isShowingImagePickerController = false
            })
            appPlaySelectSound()
            return
        }
        
        if UIViewController.current() is UIActivityViewController {
            (UIViewController.current() as! UIActivityViewController).dismiss(animated: true)
            appPlaySelectSound()
            return
        }
        
        appPlaySelectSound()
        backButton2.sendActions(for: .touchUpInside)
    }
    
    func gamepadKeyXAction() {// 保存
        if isShowingImagePickerController {
            appPlayIneffectiveSound()
            return
        }
        if UIViewController.current() is UIActivityViewController {
            appPlayIneffectiveSound()
            return
        }
        
        if focusCollectionViewIndexPath.row < 0 {
            return
        }
        
        appPlaySelectSound()
        saveButton.sendActions(for: .touchUpInside)
    }
    
    func gamepadKeyYAction() {// 删除
        if isShowingImagePickerController {
            appPlayIneffectiveSound()
            return
        }
        if UIViewController.current() is UIActivityViewController {
            appPlayIneffectiveSound()
            return
        }
        
        appPlaySelectSound()
        deleteButton.sendActions(for: .touchUpInside)
    }
    
    func gamepadKeyMenuAction() {// 添加
        if isShowingImagePickerController {
            appPlayIneffectiveSound()
            return
        }
        self.addButton.sendActions(for: .touchUpInside)
    }
    
    func clickTableViewCell(at: IndexPath) {
        tableView.selectRow(at: at, animated: false, scrollPosition: .none)
        tableView.tableView(tableView, didSelectRowAt: at)
    }
}



// MARK: 从视频获取封面
fileprivate func generateThumnail(url : URL, fromTime:Float64) -> UIImage? {
    
    let imagePath = url.path.replacingOccurrences(of: "mp4", with: "png")
    let imageUrl = URL.init(fileURLWithPath: imagePath)
    do{
        let imgData = try Data.init(contentsOf: imageUrl)
        let image = UIImage(data: imgData)
        print("视频封面缓存获取成功")
        return image
    }catch{
        print(error)
        let asset :AVAsset = AVAsset(url: url)
        let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        assetImgGenerate.requestedTimeToleranceAfter = CMTime.zero;
        assetImgGenerate.requestedTimeToleranceBefore = CMTime.zero;
        let time : CMTime = CMTimeMakeWithSeconds(fromTime, preferredTimescale: 600)
        if let img = try? assetImgGenerate.copyCGImage(at:time, actualTime: nil) {
            let data =  UIImage(cgImage: img).pngData()
            do {
                try data?.write(to: imageUrl)
                print("封面保存成功")
            }catch{
                print("封面保存失败")
            }
            return UIImage(cgImage: img)
        } else {
            return nil
        }
    }
}
