//
//  LanguageManager.swift
//  iApp
//
//  Created by Amzad Khan on 28/08/15.
//  Copyright (c) 2015 Syon Infomedia. All rights reserved.
//

import Foundation
import UIKit

public extension NSNotification.Name {
    static let kLanguageDidChange = Notification.Name("com.amzad.khan.LanguageDidChangeKey")
}

func MZLocalizedStringForKey(_ key:String) -> String {
    return LanguageManager.languageBundle.localizedString(forKey: key, value:nil, table: nil);
}

public func LocalizedStringForKey(_ key:String) -> String {
    return MZLocalizedStringForKey(key)
}

open class LanguageManager: NSObject {

    static let sharedInstance = LanguageManager()
    static var languageBundle:Bundle = Bundle.main

    override init(){
        super.init()
    }
    static func setAppLanguage(_ language:LanguageCode)-> Bool {
        if let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj") {
            if let bndl = Bundle(path: path) {
                if language == .arabic {
                    if #available(iOS 9.0, *) {
                        UIView.appearance().semanticContentAttribute = .forceRightToLeft
                    } else {
                        // Fallback on earlier versions
                    }
                }else {
                    if #available(iOS 9.0, *) {
                        UIView.appearance().semanticContentAttribute = .forceLeftToRight
                    } else {
                        // Fallback on earlier versions
                    }
                }
                languageBundle = bndl
                UserDefaults.standard.set([language.rawValue], forKey:"AppleLanguages")
                UserDefaults.standard.synchronize()
                NotificationCenter.default.post(name: .kLanguageDidChange, object: nil)
                return true
            }else {
                languageBundle = Bundle.main
                return false
            }
        }else {
            languageBundle = Bundle.main
            return false
        }
    }

    static func MZLocalizedStringForKey(_ key:String) -> String {
        return LanguageManager.languageBundle.localizedString(forKey: key, value:nil, table: nil);
    }

    class func getLanguage() -> LanguageCode{
        if let languages:[String] = UserDefaults.standard.object(forKey: "AppleLanguages") as? [String] {
            return LanguageCode.languageCode(languages.first!)
        }else {
            return LanguageCode.english
        }
    }
    class func setUserLanguage() {
       let userLanguage = LanguageManager.getLanguage()
        _ = LanguageManager.setAppLanguage(userLanguage)
    }
}

public enum LanguageCode:String {
    
    case arabic     = "ar"
    case english    = "en"
    case thai       = "th"
    case dutch      = "nl"
    case chinese    = "zh-Hans"
    case french     = "fr"
    case german     = "de"
    case italian    = "it"
    case spanish    = "es"
    case russian    = "ru"
    case bahasa     = "id-ID"
    
    var name: String {
        switch self {
        case .english:  return "English"
        case .thai:     return "Thai"
        case .dutch:    return "Dutch"
        case .chinese:  return "Chinese"
        case .french:   return "French"
        case .german:   return "German"
        case .italian:  return "Italian"
        case .spanish:  return "Spanish"
        case .russian:  return "Russian"
        case .bahasa:   return "Bahasa"
        case .arabic:   return "Arabic"
        }
    }
    static func languageCode(_ languageID:String) -> LanguageCode {
        if languageID.hasPrefix("en") {return .english }
        else if languageID.hasPrefix("th") { return .thai }
        else if languageID.hasPrefix("nl") { return .dutch }
        else if languageID.hasPrefix("zh-Hans") { return .chinese }
        else if languageID.hasPrefix("fr") { return .french }
        else if languageID.hasPrefix("de") { return .german }
        else if languageID.hasPrefix("it") { return .italian }
        else if languageID.hasPrefix("es") { return .spanish }
        else if languageID.hasPrefix("ru") { return .russian }
        else if languageID.hasPrefix("id-ID") { return .bahasa }
        else if languageID.hasPrefix("ar") { return .arabic }
        else { return .english}
    }
}
