//
//  GameListModel.swift
//  GameSirBeyond
//
//  Created by leslie lee on 2024/4/22.
//

import Foundation
import ObjectMapper

class GameListModel: Mappable {
    
    var id = 0
    var name = ""
    var card_type = 0 //栏目类型 1通用卡片 2游戏方式卡片 3类别卡片 4精彩瞬间卡片 5了解更多卡片
    var list: [SimpleListModel] = []
    var is_all_game: [String] = []
    var size_type = 0  //卡片大小 1小卡片 2中卡片 3大卡片
 
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        card_type <- map["card_type"]
        list <- map["list"]
        is_all_game <- map["is_all_game"]
        size_type <- map["size_type"]
       
    }
    
    required init?(map: Map) {
    }
}
