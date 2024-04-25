//
//  LanguageTool.swift
//  EggShell
//
//  Created by 刘富铭 on 2021/12/27.
//

import Foundation

enum Language: String {
    case chinese = "zh"
    case english = "en"
    case japanese = "ja"
}

func isUsingChinese() -> Bool {
    return Bundle.main.currentLanguage() == Language.chinese.rawValue
}

func isUsingEnglish() -> Bool {
    return Bundle.main.currentLanguage() == Language.english.rawValue
}

func isUsingJapanese() -> Bool {
    return Bundle.main.currentLanguage() == Language.japanese.rawValue
}

class BundleEx: Bundle {
    
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        if exBundle().isKind(of: Bundle.self) {
            return exBundle().localizedString(forKey: key, value: value, table: tableName)
        }
        else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
    }
    
    func exBundle() -> Bundle {
        var langString: String = currentLanguage()
        if langString.lengthOfBytes(using: String.Encoding.utf8) > 0 {
            // 有3个文件：en.lproj、ja.lproj、zh-Hans.lproj
            if langString.contains(Language.chinese.rawValue) {
                langString = "zh-Hans"
            }
            else if langString.contains(Language.japanese.rawValue) {
                langString = "ja"
            }
            else {
                langString = "en"
            }
            
            let path: String? = Bundle.main.path(forResource: langString, ofType: "lproj")
            if path != nil &&
                path!.lengthOfBytes(using: String.Encoding.utf8) > 0 {
                return Bundle.init(path: path!)!
            }
        }
        return Bundle.main
    }
}


let appLangKey = "appLanguageKey"
extension Bundle {
    func currentLanguage() -> String {
        var appLangString = ""
        let savedLangString: String? = UserDefaults.standard.object(forKey: appLangKey) as? String
        if savedLangString != nil &&
            savedLangString!.lengthOfBytes(using: String.Encoding.utf8) > 0 {
            appLangString = UserDefaults.standard.object(forKey: appLangKey) as! String
        }
        else if Locale.preferredLanguages.count > 0 {
            let preferLang = Locale.preferredLanguages.first!
            if preferLang.contains(Language.chinese.rawValue) {
                appLangString = Language.chinese.rawValue
            }
            else if preferLang.contains(Language.japanese.rawValue) {
                appLangString = Language.japanese.rawValue
            }
            else {
                appLangString = Language.english.rawValue
            }
        }
        else {
            let preferLang = Locale.current.identifier
            if preferLang.contains(Language.chinese.rawValue) {
                appLangString = Language.chinese.rawValue
            }
            else if preferLang.contains(Language.japanese.rawValue) {
                appLangString = Language.japanese.rawValue
            }
            else {
                appLangString = Language.english.rawValue
            }
        }
        
        return appLangString
    }
}

// 注意！使用前需在AppDelegate 添加 object_setClass(Bundle.main, BundleEx.self)
func setAppLanguage(lang: String) {
    if lang.lengthOfBytes(using: String.Encoding.utf8) == 0 {
        UserDefaults.standard.removeObject(forKey: appLangKey)
        UserDefaults.standard.setValue(nil, forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        return
    }
    
    UserDefaults.standard.setValue(lang, forKey: appLangKey)
    UserDefaults.standard.setValue([lang], forKey: "AppleLanguages")
    UserDefaults.standard.synchronize()
}
