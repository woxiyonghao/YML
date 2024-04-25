//
//  ScreenRecSharePath.swift
//  Eggshell
//
//  Created by leslie on 2022/10/27.
//

import Foundation
struct ScreenRecSharePathKey{
    static  let ScreenExtension = "com.xiaoji.game.ScreenRecording"
    static  let GroupIDKey = "group.com.xiaoji.Eggshell"
    
    static let FileKey = "screen_file_key"
    static let AudioFileKey = "screen_Audio_file_key"
    static let ScreenDidStartNotif = "ScreenDidStart"
    static let ScreenDidFinishNotif = "ScreenDidFinish"
    static let ScreenRecordStartNotif = "ScreenRecordStart"
    static let ScreenRecordFinishNotif = "ScreenRecordFinish"
}
extension Date {
    static  func timestamp() -> String{
        let  timeinterval =  (Date().timeIntervalSinceReferenceDate * 1000)
        return String.init(format: "%ld", timeinterval)
    }
}
class ScreenRecSharePath: NSObject {
    static var EXReplaysPath:String = ""
    static var replaysPath:String = ""
    /*
     获取host文件存储的主路径
     */
    static func documentPath()->String{
        if replaysPath.isEmpty {
            let  fileManager = FileManager.default
//            let  documentRootPath = fileManager.containerURL(forSecurityApplicationGroupIdentifier: ScreenRecSharePathKey.GroupIDKey)
            let documentRootPath:String = NSHomeDirectory()+"/Documents"
            let str:String  = UserDefaults.standard.object(forKey: "UserIdKey") as? String ?? "" //路径加入userid 区分不同的用户录屏
            replaysPath = documentRootPath.appending("/Recordings/" + str)
            if (!fileManager.fileExists(atPath: replaysPath)){
                do{
                    try fileManager.createDirectory(atPath: replaysPath, withIntermediateDirectories: true)
                    print("%@路径创建成功!", replaysPath);
                }catch{
                    print("%@路径创建失败:%@", replaysPath, error);
                }
            }
        }
         return replaysPath
    }
    static func documentHighlightPath()->String{
        if replaysPath.isEmpty {
            let  fileManager = FileManager.default
//            let  documentRootPath = fileManager.containerURL(forSecurityApplicationGroupIdentifier: ScreenRecSharePathKey.GroupIDKey)
            let documentRootPath:String = NSHomeDirectory()+"/Documents"
            let str:String  = UserDefaults.standard.object(forKey: "UserIdKey") as? String ?? "" //路径加入userid 区分不同的用户录屏
            replaysPath = documentRootPath.appending("/Highlights/" + str)
            if (!fileManager.fileExists(atPath: replaysPath)){
                do{
                    try fileManager.createDirectory(atPath: replaysPath, withIntermediateDirectories: true)
                    print("%@路径创建成功!", replaysPath);
                }catch{
                    print("%@路径创建失败:%@", replaysPath, error);
                }
            }
        }
         return replaysPath
    }
    /*
     获取EX 文件存储的主路径
     */
    static func EXDocumentPath()->String{
        if EXReplaysPath.isEmpty {
            let  fileManager = FileManager.default
            let  documentRootPath = fileManager.containerURL(forSecurityApplicationGroupIdentifier: ScreenRecSharePathKey.GroupIDKey)
//            let documentRootPath:String = NSHomeDirectory()+"/Documents"
            EXReplaysPath = documentRootPath!.path.appending("/Recordings")
            if (!fileManager.fileExists(atPath: replaysPath)){
                do{
                    try fileManager.createDirectory(atPath: EXReplaysPath, withIntermediateDirectories: true)
                    print("%@路径创建成功!", replaysPath);
                }catch{
                    print("%@路径创建失败:%@", replaysPath, error);
                }
            }
        }
         return EXReplaysPath
    }
    /*
     获取当前将要录制视频文件的保存路径
     */
    static func filePathUrlWithFileName(_ fileName:String)->URL{
        let filePath = fileName.appending(".mp4")
        let fullPath = self.documentPath().appendingFormat("/%@", filePath)
        return URL(fileURLWithPath: fullPath)
    }
    static func filePathUrlWithFileName(_ fileName:String, _ fileTpye:String)->URL{
        let filePath = fileName.appending(".\(fileTpye)")
        let fullPath = self.documentPath().appendingFormat("/%@", filePath)
        return URL(fileURLWithPath: fullPath)
    }
    static func highlightFilePathUrlWithFileName(_ fileName:String)->URL{
        let filePath = fileName.appending(".mp4")
        let fullPath = self.documentHighlightPath().appendingFormat("/%@", filePath)
        return URL(fileURLWithPath: fullPath)
    }
    static func filePathUrlWithAppGroupFileName(_ fileName:String, _ fileTpye:String)->URL{
        let filePath = fileName.appending(".\(fileTpye)")
        let fullPath = self.EXDocumentPath().appendingFormat("/%@", filePath)
        return URL(fileURLWithPath: fullPath)
    }
    static func highlightFilePathUrlWithFileName(_ fileName:String, _ fileTpye:String)->URL{
        let filePath = fileName.appending(".\(fileTpye)")
        let fullPath = self.documentHighlightPath().appendingFormat("/%@", filePath)
        return URL(fileURLWithPath: fullPath)
    }
    /*
     用于获取自定义路径下的所有文件
     */
    
    static func fetechAllResource() -> [URL]{
        let fileManager = FileManager.default
        let documentPath = self.documentPath()
        let  documentURL = URL(fileURLWithPath: documentPath)
        
        do{
            let allResource = try fileManager.contentsOfDirectory(at: documentURL, includingPropertiesForKeys:NSArray() as? [URLResourceKey],options: .skipsSubdirectoryDescendants)
            var arr:[URL] = []
            for url in allResource {
//                print("url  \(url)")
                if (url.path.contains("mp4")){
                    arr.append(url)
                }
            }
            return arr
        }catch{
            print(error)
            return []
        }
    }
    
    
    static func fetechAllResourceToString() -> [String]{
        let fileManager = FileManager.default
        let documentPath = self.documentPath()
        let documentURL = URL(fileURLWithPath: documentPath)
        
        do{
            let allResource = try fileManager.contentsOfDirectory(at: documentURL, includingPropertiesForKeys:NSArray() as? [URLResourceKey],options: .skipsSubdirectoryDescendants)
            var arr:[String] = []
            for resource in allResource {
//                print("url  \(resource)")
                if (resource.path.contains("mp4")){
                    arr.append(resource.path)
                }
            }
            return arr
        }catch{
            print(error)
            return []
        }
    }
    
    static func fetechAllEXResource() -> [URL]{
        let fileManager = FileManager.default
        let documentPath = self.EXDocumentPath()
        let  documentURL = URL(fileURLWithPath: documentPath)
        do{
            let allResource = try fileManager.contentsOfDirectory(at: documentURL, includingPropertiesForKeys:NSArray() as? [URLResourceKey],options: .skipsSubdirectoryDescendants)
            var arr:[URL] = []
            for url in allResource {
//                print("url  \(url)")
                if (url.path.contains("mp4")){
                    arr.append(url)
                }
            }
            return arr
        }catch{
            print(error)
            return []
        }
    }
    
    static func fetechAllEXResourceToString() -> [String]{
        let fileManager = FileManager.default
        let documentPath = self.EXDocumentPath()
        let documentURL = URL(fileURLWithPath: documentPath)
        
        do{
            let allResource = try fileManager.contentsOfDirectory(at: documentURL, includingPropertiesForKeys:NSArray() as? [URLResourceKey],options: .skipsSubdirectoryDescendants)
            var arr:[String] = []
            for resource in allResource {
//                print("url  \(resource)")
                if (resource.path.contains("mp4")){
                    arr.append(resource.path)
                  print("getSize :\(self.getSize(url: resource))")  
                }
            }
            return arr
        }catch{
            print(error)
            return []
        }
    }
    //获取文件大小
    static func getSize(url: URL)->UInt64{
            var fileSize : UInt64 = 0
     
            do {
                let attr = try FileManager.default.attributesOfItem(atPath: url.path)
                fileSize = attr[FileAttributeKey.size] as! UInt64
     
                let dict = attr as NSDictionary
                fileSize = dict.fileSize()
            } catch {
                print("Error: \(error)")
            }
            return fileSize
    }
}

