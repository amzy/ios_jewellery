//
//  AppStyle.swift
//  WhyQ
//
//  Created by Amzad Khan on 14/04/17.
//  Copyright © 2017 SyonInfomedia. All rights reserved.
//

import Foundation
import UIKit

// MARK: -
extension Notification.Name {
    
    /* ex. :
     - To Post Notification
     NotificationCenter.default.post(name: .kUpdateLeftMenu, object: nil)
     
     - To Observe Notification
     NotificationCenter.default.addObserver(self, selector: #selector(self.tableView.reloadData), name: .kUpdateLeftMenu, object: nil)
     
     */
    // Definition:
    public static let kUpdateFontName = Notification.Name("com.amzad.khan.UpdateFontName")
    public static let kUpdateFontSize = Notification.Name("com.amzad.khan.UpdateFontSize")
}


public enum Style {
    case heading1
    case heading2
    case heading3
    case heading4
    case bodyText
    case barText
    case buttonSmall
    case buttonMedium
    case buttonLarge
    
    case labelText
    case timeText
    case inputText
    case navigationBar
    case navigationTint
    case tabbar
    case background
    case forground1
    case forground2
    
    case separator
    case anchor
    case colorTitle
    case title
    case smallHeading
    var fontSize:CGFloat?  {
        var returnValue:CGFloat!
        switch self {
        //_______________________________
        case .buttonSmall:    returnValue = 11
        case .buttonMedium:   returnValue = 12
        case .buttonLarge:    returnValue = 14
        //_______________________________
        case .heading1:       returnValue = 27
        case .heading2:       returnValue = 23
        case .heading3:       returnValue = 18
        case .heading4:       returnValue = 14
        case .smallHeading:   returnValue = 12
            
        case .bodyText:       returnValue = 14
        case .labelText:      returnValue = 12
        case .anchor:         returnValue = 12
        case .timeText:       returnValue = 12
        case .inputText:      returnValue = 14
        case .title:          returnValue = 18
            
        default: return nil
        }
        return returnValue
    }
    var fontName:String?  {
        var returnValue:String!
        switch self {
        //_______________________________
        case .buttonSmall, .buttonMedium, .buttonLarge, .heading1, .heading2, .heading3, .heading4:
            returnValue = AppTheme.default.fontName.bold
        case .bodyText, .labelText, .anchor, .timeText, .inputText, .title:
            returnValue = AppTheme.default.fontName.rawValue
        default: return nil
        }
        return returnValue
    }
    var color:UIColor! {
        //1AD898
        //#colorLiteral(red: 0.1019607843, green: 0.8470588235, blue: 0.5960784314, alpha: 1)
        //11A3DE
        //#colorLiteral(red: 0.06666666667, green: 0.6392156863, blue: 0.8705882353, alpha: 1)
        
        var returnValue = UIColor.black
        switch self {
        case .buttonSmall, .buttonMedium, .buttonLarge : returnValue  = #colorLiteral(red: 0.8391239047, green: 0.8392685056, blue: 0.8391147852, alpha: 1)
        case .heading1, .heading2, .heading3:  returnValue = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        case .bodyText:         returnValue = #colorLiteral(red: 0.2078431373, green: 0.2078431373, blue: 0.2078431373, alpha: 1)
        case .labelText:        returnValue = #colorLiteral(red: 0.5215686275, green: 0.3882352941, blue: 0.3803921569, alpha: 1)
        case .anchor:           returnValue = #colorLiteral(red: 0.8941176471, green: 0.2196078431, blue: 0.2509803922, alpha: 1)
        case .timeText:         returnValue = #colorLiteral(red: 0.5843137255, green: 0.5843137255, blue: 0.5843137255, alpha: 1)
        case .separator:        returnValue = #colorLiteral(red: 0.7490196078, green: 0.7490196078, blue: 0.7490196078, alpha: 1)
        case .navigationBar:    returnValue = #colorLiteral(red: 0.8941176471, green: 0.2196078431, blue: 0.2509803922, alpha: 1)
        case .navigationTint:   returnValue = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        case .background:       returnValue = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        case .inputText:        returnValue = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        case .colorTitle:       returnValue = #colorLiteral(red: 0, green: 0.3529411765, blue: 0.5019607843, alpha: 1)
            
        default: break
        }
        return returnValue
    }
}

enum FontStyle:Int32 {
    case samll = 0, medium = 4, large = 8
    
    var toString:String {
        switch self {
        case .samll: return "Small"
        case .medium: return "Medium"
        case .large: return "Large"
        }
    }
    init?(value:RawValue){
        switch value {
        case FontStyle.samll.rawValue: self     = FontStyle.samll
        case FontStyle.medium.rawValue: self    = FontStyle.medium
        case FontStyle.large.rawValue: self     = FontStyle.large
        default: self = FontStyle.samll
        }
    }
    
}

final class AppTheme : NSObject, NSCoding  {
    static let `default` = AppTheme()
    var fontStyle = FontStyle.samll {
        didSet {
            NotificationCenter.default.post(name: .kUpdateFontSize, object: nil)
        }
    }
    var fontName:UIFont.Name = .gotham {
        didSet {
            NotificationCenter.default.post(name: .kUpdateFontName, object: nil)
        }
    }
    override init() {
        super.init()
        guard let theme = AppTheme.defaultTheme() else { return }
        self.fontName = theme.fontName
        self.fontStyle = theme.fontStyle
    }
    func appStyleFont(font:UIFont) -> UIFont {
        let size = font.pointSize
        let appSize = size + CGFloat(self.fontStyle.rawValue)
        return UIFont(name: font.fontName, size: appSize)!
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(fontStyle.rawValue, forKey: "fontStyle")
        aCoder.encode(fontName.rawValue, forKey: "fontName")
    }
    
    required init?(coder aDecoder: NSCoder) {
        // Methods
        super.init()
        let fontSize = aDecoder.decodeInt32(forKey: "fontStyle")
        fontStyle = FontStyle(rawValue: fontSize) ?? FontStyle.samll
        if let fontNameString = aDecoder.decodeObject(forKey: "fontName") as? String {
            fontName = UIFont.Name(rawValue: fontNameString) ?? UIFont.Name.gotham
        }else {
            fontName = UIFont.Name.gotham
        }
    }
    
    func saveTheme() {
        let data  = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.set(data, forKey: Constants.kAppDisplayName+"theme")
        UserDefaults.standard.synchronize()
    }
    
    static func defaultTheme() -> AppTheme! {
        if let data = UserDefaults.standard.object(forKey: Constants.kAppDisplayName+"theme") as? Data {
            let unarc = NSKeyedUnarchiver(forReadingWith: data)
            return unarc.decodeObject(forKey: "root") as! AppTheme
        } else {
            return nil
        }
    }
}

extension UILabel {
    func updateStyle(style:Style)  {
        if let color  = style.color {
            self.textColor = color
        }
        self.font = UIFont.init(style)
    }
}

extension UITextField {
    func updateStyle(style:Style)  {
        if let color  = style.color {
            self.textColor = color
        }
        self.font = UIFont.init(style)
    }
}

extension UIFont {
    convenience init(_ style: Style) {
        let size = (style.fontSize ?? 0) + CGFloat(AppTheme.default.fontStyle.rawValue)
        self.init(name: style.fontName ?? UIFont.Name.gotham.rawValue, size: size)!
    }
}

