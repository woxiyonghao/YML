//
//  VideoModel.swift
//  Eggshell
//
//  Created by 刘富铭 on 2022/11/30.
//

import ObjectMapper

/// 游戏视频数据的模型
class VideoModel: Mappable {
    
    // 视频信息
    var coverURL = ""// 封面地址
    var videoURL = ""// 视频地址
    var videoTitle = ""
    var videoID = 0
    
    // 交互
    var likeNumber = 0
    var isLike = 0
    
    // 上传者信息
    var userID = 0
    var userName = ""
    var userNickname = ""
    
    // 关联游戏
    var gameID = ""
    
    func mapping(map: Map) {
        coverURL <- map["coverUrl"]
        videoURL <- map["videoUrl"]
        videoTitle <- map["videoTitle"]
        videoID <- map["videoId"]
        
        likeNumber <- map["likeNum"]
        isLike <- map["isLike"]
        
        userID <- map["userId"]
        userName <- map["username"]
        userNickname <- map["nickName"]
        
        gameID <- map["appstoreId"]
    }
    
    required init?(map: Map) {
        
    }
}
