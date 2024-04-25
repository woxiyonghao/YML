//
//  SimpleGameModel.swift
//  Eggshell
//
//  Created by 刘富铭 on 2022/12/6.
//

import ObjectMapper

/// 最基础的游戏数据模型，仅包含最基础的数据
class SimpleGameModel: Mappable {
    
    var id = 0
    var name = ""
    var coverURL = ""
    var platforms: [PlatformModel] = []
    var urlSchemes: [String] = []
    var videoURL = ""
    var categoryNumber = 0// 分类数量，只有分类主题下的【分类】才有
    var categoryId = 0// 分类ID，只有分类主题下的【分类】才有
    var desc = ""
    var content = ""
    var linkType = 0
    var linkUrl = ""
    var likeNum = 0
    var videoId = 0
    var title = ""
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        coverURL <- map["coverURL"]
        platforms <- map["platforms"]
        urlSchemes <- map["urlSchemes"]
        videoURL <- map["videoURL"]
        categoryNumber <- map["appstoreNum"]
        categoryId <- map["categoryId"]
        desc <- map["desc"]
        content <- map["content"]
        linkType <- map["linkType"]
        linkUrl <- map["linkUrl"]
        likeNum <- map["likeNum"]
        videoId <- map["videoId"]
        title <- map["title"]
    }
    
    required init?(map: Map) {
    }
}
