//
//  TopicGameModel.swift
//  EggShell
//
//  Created by Panda on 2022/1/14.
//

import ObjectMapper

/// 主题数据中的游戏数据模型
class TopicGameModel: GameModel {
    
    var id = 0// 主题ID
    var name = ""
    var coverURL = ""
    var videoURL = ""
    var linkType = 0
    var linkURL = ""
    var urlSchemes: [String] = []// 游戏App的跳转链接
    var platforms: [PlatformModel] = []
    var appStoreId = 0// 游戏ID
    var videoId = 0
    var categoryId = 0
    var tag: [String] = []
    var desc = ""
    var content = ""
    var videoTitle = ""
    var likeNum = 0
    var nickname = ""
    var username = ""
    var isLike = false
    var categoryNumber = 0// 分类数量，只有分类主题下的【分类】才有
    var title = ""
    
    override func mapping(map: Map) {
        id <- map["id"]
        name <- map["title"]
        coverURL <- map["icon"]
        videoURL <- map["videoUrl"]
        linkType <- map["linkType"]
        linkURL <- map["linkUrl"]
        urlSchemes <- map["urlSchemes"]
        platforms <- map["platforms"]
        appStoreId <- map["appstoreId"]
        videoId <- map["videoId"]
        categoryId <- map["categoryId"]
        tag <- map["tag"]
        desc <- map["desc"]
        content <- map["content"]
        videoTitle <- map["videoTitle"]
        likeNum <- map["likeNum"]
        nickname <- map["nickName"]
        username <- map["username"]
        isLike <- map["isLike"]
        categoryNumber <- map["appstoreNum"]
        title <- map["title"]
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
}
