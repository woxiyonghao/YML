//
//  SearchGameModel.swift
//  Eggshell
//
//  Created by 刘富铭 on 2022/12/1.
//

import ObjectMapper

/// 搜索游戏列表中的游戏数据模型
class SearchGameModel: GameModel {
    
    var video_url = ""
    var game_open_param: [GameOpenModel] = []
    var name = ""
    var id = 0
    var cover_image = ""
    var back_image = 0
    var package_str = ""
    override func mapping(map: Map) {
        video_url <- map["video_url"]
        game_open_param <- map["game_open_param"]
        name <- map["name"]
        id <- map["id"]
        cover_image <- map["cover_image"]
        back_image <- map["back_image"]
        package_str <- map["package_str"]
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
}

class GameOpenModel: GameModel {
    
  
    var open_type = 0
    var jump_url = ""
 
    override func mapping(map: Map) {
        open_type <- map["open_type"]
        jump_url <- map["jump_url"]
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
}
