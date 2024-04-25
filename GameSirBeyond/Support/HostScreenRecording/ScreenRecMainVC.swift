//
//  ScreenRecMainVC.swift
//  Eggshell
//
//  Created by leslie on 2022/10/27.
//

import Foundation
import UIKit
import ReplayKit
import AVKit
//MARK: - 注册全局通知 接受Extension的消息
//let onDarwinReplayKit2PushFinish:CFNotificationCallback = {_,_,_,_,_ in
//    //转到cocoa层框架处理
//    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: ScreenRecSharePathKey.ScreenRecordFinishNotif), object: nil)
//}
//
//let onDarwinReplayKit2PushStart:CFNotificationCallback = {_,_,_,_,_ in
//    //转到cocoa层框架处理
//    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: ScreenRecSharePathKey.ScreenRecordStartNotif), object: nil)
//}

class ScreenRecMainVC: UIViewController {
    //MARK: - lazy
    //使用以下保存mp4
    lazy var assetWriter:AVAssetWriter? = {
        let sharedDefaults = UserDefaults.init(suiteName: ScreenRecSharePathKey.GroupIDKey)
        var fileName:String  = sharedDefaults?.object(forKey: ScreenRecSharePathKey.FileKey) as? String ?? ""
        if (fileName.isEmpty){
            let newFileName  = Date.timestamp()
            sharedDefaults?.set(newFileName, forKey: ScreenRecSharePathKey.FileKey)
            sharedDefaults?.synchronize()
            print("创建 新的assetWriter fileName:\(newFileName)")
            fileName = newFileName
        }
        
        let filePathURL:URL = ScreenRecSharePath.filePathUrlWithFileName(fileName)
        print("创建 assetWriter filePathURL:\(filePathURL)")
        do {
            let input = try AVAssetWriter.init(url: filePathURL, fileType: AVFileType.mp4)
            return input
        }catch{
            assert(false, "assetWriter初始化失败")
            return nil
        }
    }()
    
    lazy var videoInput: AVAssetWriterInput? = {
        let size  = UIScreen.main.bounds.size
        //写入视频大小
        let numPixels:CGFloat =  size.width  * size.height
        //每像素比特
        let bitsPerPixel:CGFloat = 10
        let bitsPerSecond = numPixels * bitsPerPixel
        // 码率和帧率设置
        let compressionProperties:Dictionary = [
            AVVideoAverageBitRateKey: NSNumber(value:bitsPerSecond), //码率(平均每秒的比特率)
            AVVideoExpectedSourceFrameRateKey :NSNumber(value:15),//帧率（如果使用了AVVideoProfileLevelKey则该值应该被设置，否则可能会丢弃帧以满足比特流的要求）
            AVVideoMaxKeyFrameIntervalKey : NSNumber(value:15),//关键帧最大间隔
            AVVideoProfileLevelKey : AVVideoProfileLevelH264BaselineAutoLevel
        ]
        let videoOutputSettings:Dictionary = [
            AVVideoCodecKey : AVVideoCodecType.h264,  // AVVideoCodecTypeH264
            AVVideoScalingModeKey : AVVideoScalingModeResizeAspect,
            AVVideoWidthKey : NSNumber(value:size.width ),
            AVVideoHeightKey : NSNumber(value:size.height ),
            AVVideoCompressionPropertiesKey : compressionProperties
        ]
        print("videoOutputSettings \(videoOutputSettings)")
        let input =  AVAssetWriterInput.init(mediaType: AVMediaType.video, outputSettings: videoOutputSettings)
        input.expectsMediaDataInRealTime = true
        return input
        
    }()
    
    lazy var audioAppInput: AVAssetWriterInput? = {
        let audioCompressionSettings:Dictionary = [
            AVEncoderBitRatePerChannelKey : NSNumber(value: 28000),
            AVFormatIDKey : "\(kAudioFormatMPEG4AAC)",
            AVNumberOfChannelsKey : NSNumber(value: 1),
            AVSampleRateKey : NSNumber(value: 22050)
        ]
        let input  = AVAssetWriterInput(mediaType: AVMediaType.audio, outputSettings: audioCompressionSettings)
        input.expectsMediaDataInRealTime = true
        return input
    }()
    
    lazy var audioMicInput: AVAssetWriterInput? = {
        let audioCompressionSettings:Dictionary = [
            AVEncoderBitRatePerChannelKey : NSNumber(value: 28000),
            AVFormatIDKey : "\(kAudioFormatMPEG4AAC)",
            AVNumberOfChannelsKey : NSNumber(value: 1),
            AVSampleRateKey : NSNumber(value: 22050)
        ]
        let input  = AVAssetWriterInput(mediaType: AVMediaType.audio, outputSettings: audioCompressionSettings)
        input.expectsMediaDataInRealTime = true
        return input
    }()
    
    //MARK: - 当前类初始化相关
    var closure: ()->Void = {}
    let playVC: VideoPlayerVC = VideoPlayerVC.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        commonInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    func commonInit() {
        self.title = "ScreenRec"
        let pickView = RPSystemBroadcastPickerView.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.view .addSubview(pickView)
        pickView.preferredExtension = ScreenRecSharePathKey.ScreenExtension;
        pickView.center = self.view.center;
        
        let copyBtn = UIButton.init(frame: CGRect.init(x: view.bounds.width-120, y: view.bounds.height - 50, width: 100, height: 50))
        copyBtn.setTitle("拷贝", for: .normal)
        copyBtn.setTitleColor(.blue, for: .normal)
        view.addSubview(copyBtn)
        copyBtn.addTarget(self, action:#selector(copyVideoToSanbox) , for: .touchUpInside)
        
        let playBtn = UIButton.init(frame: CGRect.init(x: view.bounds.width-120, y:  50, width: 100, height: 50))
        playBtn.setTitle("播放最后一个视频", for: .normal)
        playBtn.setTitleColor(.blue, for: .normal)
        view.addSubview(playBtn)
        playBtn.addTarget(self, action:#selector(playLastVideo) , for: .touchUpInside)
        
        
        let deleteBtn = UIButton.init(frame: CGRect.init(x: 30, y: view.bounds.height - 50, width: 100, height: 50))
        deleteBtn.setTitle("清理缓存", for: .normal)
        deleteBtn.setTitleColor(.blue, for: .normal)
        view.addSubview(deleteBtn)
        deleteBtn.addTarget(self, action:#selector(deleteAllResource) , for: .touchUpInside)
        
        //        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), UnsafeRawPointer(Unmanaged<ScreenRecMainVC>.passUnretained(self).toOpaque()), onDarwinReplayKit2PushStart, ScreenRecSharePathKey.ScreenDidStartNotif as CFString, nil, CFNotificationSuspensionBehavior.deliverImmediately)
        //
        //        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), UnsafeRawPointer(Unmanaged<ScreenRecMainVC>.passUnretained(self).toOpaque()), onDarwinReplayKit2PushFinish, ScreenRecSharePathKey.ScreenDidFinishNotif as CFString, nil, CFNotificationSuspensionBehavior.deliverImmediately)
        //
        //        NotificationCenter.default.addObserver(self, selector: #selector(handleScreenRecordStartNotification), name: Notification.Name(ScreenRecSharePathKey.ScreenRecordStartNotif), object: nil)
        //        NotificationCenter.default.addObserver(self, selector: #selector(handleScreenRecordEndNotification), name: Notification.Name(ScreenRecSharePathKey.ScreenRecordFinishNotif), object: nil)
        
        ESSampleHandlerClientSocketManager.shared().setupSocket()
        ESSampleHandlerClientSocketManager.shared().getBufferBlock = {
            (sampleBuffer:CMSampleBuffer) in
            autoreleasepool {
                let status = self.assetWriter!.status;
                if (status == .failed || status == .cancelled || status == .completed){
                    //                    assert(false,"屏幕录制AVAssetWriterStatusFailed error :\(self.assetWriter?.error)")
                    
                    return
                }
                
                if (status == .unknown) {
                    self.assetWriter?.startWriting()
                    let time = CMSampleBufferGetDecodeTimeStamp(sampleBuffer)
                    if time.value > 0 {
                        self.assetWriter?.startSession(atSourceTime: time)
                    }
                }
                
                if (status == .writing) {
                    if (self.videoInput?.isReadyForMoreMediaData == true){
                        let time = CMSampleBufferGetDecodeTimeStamp(sampleBuffer)
                        if time.value > 0 {
                            let success = self.videoInput?.append(sampleBuffer)
                            if (success == false){
                                self.stopWriting()
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
    @objc func removeView() {
        closure()
    }
    
    @objc func deleteAllResource() {
        let arr = ScreenRecSharePath.fetechAllResource()
        for url:URL in arr {
            do {
                try FileManager.default.removeItem(atPath: url.path)
            }
            catch {
                print("删除失败：%@",error)
            }
        }
    }
    
    @objc func copyVideoToSanbox() {
        //        let orignFilePath1 = Bundle.main.path(forResource: "mojito", ofType: "mp4")
        //        let fileManager = FileManager.default
        //        let url1 = ScreenRecSharePath.filePathUrlWithFileName("mojito")
        //        if (!fileManager.fileExists(atPath: url1.path)){
        //
        //            do {
        //                try fileManager.copyItem(atPath: orignFilePath1!, toPath: url1.path)
        //            }catch{
        //                print("拷贝失败 %@",error.localizedDescription)
        //            }
        //
        //        }
    }
    
    @objc func playLastVideo() {
        self.navigationController?.pushViewController(playVC, animated: true)
    }
    
    //MARK: - 合成视频相关方法
    func setupAssetWriter() {
        if self.assetWriter == nil {
            return
        }
        
        if (self.assetWriter!.canAdd(self.videoInput!)) {
            self.assetWriter!.add(self.videoInput!)
        }
        else {
            //            assert(false, "添加视频写入失败");
        }
        //        if (self.assetWriter!.canAdd(self.audioAppInput!)) {
        //            self.assetWriter!.add(self.audioAppInput!)
        //        }else{
        //            assert(false, "添加App音频写入失败");
        //        }
        //        if (self.assetWriter!.canAdd(self.audioMicInput!)) {
        //            self.assetWriter!.add(self.audioMicInput!)
        //        }else{
        //            assert(false, "添加Mic音频写入失败");
        //        }
        
    }
    
    func stopWriting() {
        if (self.assetWriter?.status == AVAssetWriter.Status.writing) {
            self.videoInput?.markAsFinished()
            self.audioAppInput?.markAsFinished()
            self.audioMicInput?.markAsFinished()
            self.assetWriter?.finishWriting(completionHandler: {
                self.videoInput = nil;
                self.audioAppInput = nil;
                self.audioMicInput = nil;
                self.assetWriter = nil;
            });
        }
        
        let sharedDefaults = UserDefaults.init(suiteName: ScreenRecSharePathKey.GroupIDKey)
        var fileName:String  = sharedDefaults?.object(forKey: ScreenRecSharePathKey.FileKey) as? String ?? ""
        if (!fileName.isEmpty){
            let newFileName  = ""
            sharedDefaults?.set(newFileName, forKey: ScreenRecSharePathKey.FileKey)
            sharedDefaults?.synchronize()
            print("清空了 fileName")
        }
    }
    
    //录屏开始以后的推送
    @objc  func handleScreenRecordStartNotification(noti:NSNotification) {
        print("主APP录屏开始：%@",noti)
        //        let sharedDefaults = UserDefaults.init(suiteName: ScreenRecSharePathKey.GroupIDKey)
        //        let oldfileName:String  = sharedDefaults?.object(forKey: ScreenRecSharePathKey.FileKey) as? String ?? ""
        //        if (oldfileName.isEmpty){
        //            let fileName  = Date.timestamp()
        //            sharedDefaults?.set(fileName, forKey: ScreenRecSharePathKey.FileKey)
        //            print("录屏开始 新 sub fileName：%@",fileName)
        //        }
        //        print("录屏开始 sub fileName：%@",oldfileName)
        //        sharedDefaults?.synchronize()
        
        self.setupAssetWriter()  //初始化AssetWriter
    }
    
    //录屏结束以后的推送
    @objc func handleScreenRecordEndNotification(noti:NSNotification) {
        print("录屏结束：%@",noti)
        self.stopWriting()
        //        let sharedDefaults = UserDefaults.init(suiteName: ScreenRecSharePathKey.GroupIDKey)
        //        let fileName:String  = sharedDefaults?.object(forKey: ScreenRecSharePathKey.FileKey) as? String ?? ""
        //        print("录屏结束 sub fileName：%@",fileName)
        //        if (!fileName.isEmpty) {
        //            let oldUrl:URL = ScreenRecSharePath.filePathUrlWithFileName(fileName)
        //            self.moveFromGroupUrl(oldUrl)
        //
        //        }
    }
    
    func moveFromGroupUrl(_ oldUrl:URL) {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
        let newUrl = URL.init(fileURLWithPath: path?.appending(String.init(format: "/%@.mp4", Date.timestamp())) ?? "")
        print("oldUrl:\(oldUrl) \n newUrl:\(newUrl)");
        do {
            try FileManager.default.moveItem(at: oldUrl, to: newUrl)
            self.playVideo(newUrl)
        }
        catch {
            print("转移失败：%@",error)
            self.playVideo(oldUrl)
        }
        
        let sharedDefaults = UserDefaults.init(suiteName: ScreenRecSharePathKey.GroupIDKey)
        sharedDefaults?.removeObject(forKey: ScreenRecSharePathKey.FileKey)
        sharedDefaults?.synchronize()
    }
    
    //播放录屏后的mp4
    func playVideo(_ url:URL) -> Void {
        //播放mp4
        let playerViewController = AVPlayerViewController.init()
        let player = AVPlayer(url:url)
        playerViewController.player = player
        self.navigationController?.present(playerViewController, animated: true , completion: {
            playerViewController.player?.play()
            
        })
        
        playerViewController.player?.play()
        //保存到相册
        //    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        //        [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:url];
        //    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        //        if (error) {
        //            NSLog(@"保存失败：%@",error);
        //        }else{
        //            NSLog(@"保存成功");
        //        }
        //    }];
    }
}


