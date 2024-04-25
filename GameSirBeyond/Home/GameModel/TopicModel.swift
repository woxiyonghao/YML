//
//  TopicModel.swift
//  Eggshell
//
//  Created by 刘富铭 on 2022/11/29.
//

import ObjectMapper

/// 首页主题数据的模型
class TopicModel: Mappable {
    
    var id = 0
    var title = ""
    var type = 0
    var games: [TopicGameModel] = []
    
    func mapping(map: Map) {
        id <- map["topicId"]
        title <- map["topicTitle"]
        type <- map["topicType"]
        games <- map["data"]
    }
    
    required init?(map: Map) {
        
    }
}
