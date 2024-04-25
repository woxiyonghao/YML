//
//  ModelManager.swift
//  Eggshell
//
//  Created by 刘富铭 on 2022/12/7.
//

import UIKit
import ObjectMapper


private enum ModelKey: String {
    case id = "id"
    case name = "name"
    case coverURL = "coverURL"
    case platforms = "platforms"
    case urlSchemes = "urlSchemes"
    case videoURL = "videoURL"
    case appstoreNum = "appstoreNum"// 分类数量，只有分类主题下的【分类】才有
    case categoryId = "categoryId"// 分类数量，只有分类主题下的【分类】才有
    case desc = "desc"
    case content = "content"
    case linkType = "linkType"
    case linkUrl = "linkUrl"
    case likeNum = "likeNum"
    case videoId = "videoId"
    case title = "title"
}

class ModelManager: NSObject {

    static var shared: ModelManager = {
        let manager = ModelManager.init()
        return manager
    }()
    
    func getSimpleGameModelFrom(model: TopicGameModel, excludeVideo: Bool = false) -> SimpleGameModel {
        var platforms: [[String: Any]] = []
        for platform in model.platforms {
            let platformDict = Mapper<PlatformModel>().toJSON(platform)
            platforms.append(platformDict)
        }
        let dict = [ModelKey.id.rawValue: model.appStoreId,
                    ModelKey.name.rawValue: model.name,
                    ModelKey.coverURL.rawValue: model.coverURL,
                    ModelKey.platforms.rawValue: platforms,
                    ModelKey.urlSchemes.rawValue: model.urlSchemes,
                    ModelKey.videoURL.rawValue: excludeVideo ? "" : model.videoURL,
                    ModelKey.appstoreNum.rawValue: model.categoryNumber,
                    ModelKey.categoryId.rawValue: model.categoryId,
                    ModelKey.desc.rawValue: model.desc,
                    ModelKey.content.rawValue: model.content,
                    ModelKey.linkType.rawValue: model.linkType,
                    ModelKey.linkUrl.rawValue: model.linkURL,
                    ModelKey.likeNum.rawValue: model.likeNum,
                    ModelKey.videoId.rawValue: model.videoId,
                    ModelKey.title.rawValue: model.title] as [String : Any]
        let newModel = SimpleGameModel(JSONString: dict.string()!)!
        return newModel
    }
    
    func getSimpleGameModelFrom(model: SearchGameModel) -> SimpleGameModel {
        var platforms: [[String: Any]] = []
//        for platform in model.platforms {
//            let platformDict = Mapper<PlatformModel>().toJSON(platform)
//            platforms.append(platformDict)
//        }
        let dict = [ModelKey.id.rawValue: model.id, ModelKey.name.rawValue: model.name, ModelKey.coverURL.rawValue: model.cover_image, ModelKey.platforms.rawValue: platforms, ModelKey.urlSchemes.rawValue: [], ModelKey.videoURL.rawValue: ""] as [String : Any]// 没数据则传入默认数据
        let newModel = SimpleGameModel(JSONString: dict.string()!)!
        return newModel
    }
}
