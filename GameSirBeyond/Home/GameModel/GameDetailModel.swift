//
//  GameDetailModel.swift
//  Eggshell
//
//  Created by 刘富铭 on 2022/12/7.
//

import ObjectMapper

class GameDetailModel: Mappable {
    var id = 0// 主题ID
    var name = ""
    var orgName = ""
    var coverURL = ""
    var screenshotURLs: [String] = []
    var videoURL = ""
    var highlights: [VideoModel] = []
    var urlSchemes: [String] = []// 游戏App的跳转链接
    var platforms: [PlatformModel] = []
    var desc = ""
    var content = ""
    var categoryName = ""
    
    func mapping(map: Map) {
        id <- map["appstoreId"]
        name <- map["appstoreName"]
        orgName <- map["appstoreOrgName"]
        coverURL <- map["appstoreLogo"]
        screenshotURLs <- map["appstorePic"]
        videoURL <- map["appstoreVideoUrl"]
        highlights <- map["appstoreVideo"]
        urlSchemes <- map["urlSchemes"]
        platforms <- map["appstorePlatform"]
        desc <- map["appstoreDesc"]
        content <- map["content"]
        categoryName <- map["categoryName"]
    }
    
    required init?(map: Map) {
    }
}
