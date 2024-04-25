//
//  ESSaveToAlbum.swift
//  Eggshell
//
//  Created by leslie lee on 2022/11/23.
//

import UIKit
import Photos
//Privacy - Photo Library Usage Description
//App保存视频需要使用您的照片权限，否则无法保存视频，请点击“好”以允许App访问您的照片。

//Privacy - Photo Library Additions Usage Description
//App保存视频需要使用您的照片权限，否则无法保存视频，请点击“好”以允许App访问您的照片。

class ESSaveToAlbum{
    public static var shared  = ESSaveToAlbum()
    
    private var viewCom:UIViewController?
    private var thisCom:((_ boo:Bool)->Void)?
    private var action: UIAlertController?
    
    private var videoPath:String = ""
   
    public func saveFileVideo( _videoPath:String, _viewCom:UIViewController ,_com:@escaping (_ boo:Bool)->Void){
        thisCom = _com
        viewCom = _viewCom
        videoPath = _videoPath
        permissions()
    }
    
    
    ///有没有pn写入s权限判断
    private func permissions(_ int:Int = 0){
        
        if PHPhotoLibrary.authorizationStatus().rawValue == PHAuthorizationStatus.notDetermined.rawValue {
            ///用户还没做选择
            PHPhotoLibrary.requestAuthorization({ (status) in
                
                if status.rawValue == PHAuthorizationStatus.authorized.rawValue {
                    //print("点同意")
                    self.save()
                } else if status == PHAuthorizationStatus.denied ||  status == PHAuthorizationStatus.restricted {
                    //print("点拒绝")
                    self.jumpSet(str: "相册")
                }
                
            })
        } else if(PHPhotoLibrary.authorizationStatus().rawValue == PHAuthorizationStatus.authorized.rawValue ) {
            //用户同意写入权限
            print(PHPhotoLibrary.authorizationStatus().rawValue)
            self.save()
        }else{
            self.jumpSet(str: "相册")
        }
    }
    
    ///跳转到设置中开启权限
    private func jumpSet(str:String){
        action = UIAlertController(title: "提示", message: "请在在设置中打开app的\(str)权限", preferredStyle: UIAlertController.Style.alert)
        let action1 = UIAlertAction(title: "设置", style: UIAlertAction.Style.default) { (actions) in
            let settingUrl = URL(string: UIApplication.openSettingsURLString)!
            //print(UIApplication.shared.canOpenURL(settingUrl))
            if UIApplication.shared.canOpenURL(settingUrl)
            {
                UIApplication.shared.openURL(settingUrl)
            }
        }
        let action2 = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel) { (actions) in
            //print("取消")
        }
        action?.addAction(action1)
        action?.addAction(action2)
        
        if(viewCom != nil){
            viewCom?.present(action!, animated: true, completion: nil)
        }
        
    }
    
    private func save(){
        if(videoPath.count < 10){
            
            if(self.thisCom != nil){
                
                self.thisCom!(false)
            }
            self.videoPath = ""
            self.thisCom = nil
            return
        }
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(string: self.videoPath)!)
            //路径不能有中文 ！
        }) { (boo, error) in
            
            if(self.thisCom != nil){
                
                if(boo){
                    self.thisCom!(true)
                }else{
                    self.thisCom!(false)
                }
            }
            self.videoPath = ""
            self.thisCom = nil
        }
    }
}

