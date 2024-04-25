//
//  ScreenRecSynthesis.swift
//  Eggshell
//
//  Created by leslie lee on 2023/3/21.
//
import AVFoundation
import Foundation
class ScreenRecSynthesis {
    
    public static var shared  = ScreenRecSynthesis()
    
    
    public func SynthesiVideo(videoPath:URL,audioPath:URL){
      
        let assetVideo  = AVAsset.init(url: videoPath)
        let assetAudio  = AVAsset.init(url: audioPath)
        let videoAssetTrack = assetVideo.tracks(withMediaType: .video).first ?? nil
        if videoAssetTrack == nil {
            print("videoPath  \(videoPath)")
            print(assetVideo.tracks(withMediaType: .video))
//            removeFile(videoPath: videoPath, audioPath: audioPath)
            print("录屏生成文件失败")
            return
        }
        let audioAssetTrack = assetAudio.tracks(withMediaType: .audio).first
        let timescale = videoAssetTrack!.timeRange.duration.timescale
//        let scale  = timescale/100
        let startTime:CMTime =  videoAssetTrack!.timeRange.start
        let endTime:CMTime = videoAssetTrack!.timeRange.end
        //这是工程文件
        let composition = AVMutableComposition.init()
        
        //视频轨道
        
        let videoCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)!
        //在视频轨道插入一个时间段的视频
        
        do {
            try videoCompositionTrack.insertTimeRange(CMTimeRange(start: startTime, end: endTime), of: videoAssetTrack!, at: .zero)
            print("成功加入视频  startTime: \(startTime)   endTime:  \(endTime)  videoAssetTrack :\(videoAssetTrack!.timeRange.duration)")
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
        let path = ScreenRecSharePath.filePathUrlWithFileName(fileName)
        let imageCoverPath = ScreenRecSharePath.filePathUrlWithFileName(fileName, "png")  //保存一张封面
        let imageSliderPath = ScreenRecSharePath.filePathUrlWithFileName(fileName + "_slider", "png")  //获取进度条缓存图
        
        exporter?.outputURL = path
        exporter?.outputFileType = .mp4
        exporter?.shouldOptimizeForNetworkUse = true
        exporter?.exportAsynchronously(completionHandler: {
            if ((exporter?.error) != nil){
                
                print(exporter!.error!)
                print("视频剪切失败  \(path)",path)
            }else{
                print("视频合成成功  \(path)",path)
                self.removeFile(videoPath: videoPath, audioPath: audioPath)
                
//                let image = self.generateThumnail(url: path, fromTime: 0.5)
//                let data =  image?.pngData()
//                do {
//                    try data?.write(to: imageCoverPath)
//                    print("封面保存成功")
//                }catch{
//                    print("封面保存失败")
//                }
//
//                let imageArr = self.getVideoThumnail()
//                if imageArr.count == 0 {return}
//                let image2 =  self.drawImages(imageArray: imageArr)!
//                let data2 =  image2.pngData()
//                do {
//                    try data2?.write(to: imageSliderPath)
//                    print("进度条缩略图保存成功")
//
//                }catch{
//                    print("进度条缩略图封面保存失败")
//                }
            }
            
        })
        
    }
    
    func removeFile(videoPath:URL,audioPath:URL){
        let sharedDefaults = UserDefaults.init(suiteName: ScreenRecSharePathKey.GroupIDKey)
        let videoName:String  = sharedDefaults?.object(forKey: ScreenRecSharePathKey.FileKey) as? String ?? ""
        let audioName:String  = sharedDefaults?.object(forKey: ScreenRecSharePathKey.AudioFileKey) as? String ?? ""
        do {
            try FileManager.default.removeItem(atPath: videoPath.path)
        }catch{
            print("删除失败videoPath：%@",error)
        }
        do {
            try FileManager.default.removeItem(atPath: audioPath.path)
        }catch{
            print("删除失败audioPath：%@",error)
        }
        if (videoName != ""){
            let newFileName  = ""
            sharedDefaults?.set(newFileName, forKey: ScreenRecSharePathKey.FileKey)
            sharedDefaults?.synchronize()
            print("清空了 videoName")
        }
        if (audioName != ""){
            let newFileName  = ""
            sharedDefaults?.set(newFileName, forKey: ScreenRecSharePathKey.AudioFileKey)
            sharedDefaults?.synchronize()
            print("清空了 audioName")
        }
    }
    
}
    
