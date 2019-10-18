//
//  UIFont.swift
//  GetTagg
//
//  Created by Sumit Agarwal on 22/08/17.
//  Copyright © 2017 Syon Infomedia. All rights reserved.
//

import UIKit

extension UIFont {
    public enum Name: String {
        
        var toString:String {
            switch self {
            case .lato: return "Lato"
            case .timesNewRoman: return "Times New Roman"
            case .helvetica: return "Helvetica"
            case .verdana: return "Verdana"
            case .gotham: return "Gotham"
            default: return "Gotham"
            }
        }
        
        case lato           = "Lato"
        case latoMedium     = "Lato-medium"
        case latoBold       = "Lato-Heavy"
        
        case gotham             = "Gotham-Book"
        case verdana            = "Verdana"
        case timesNewRoman      = "TimesNewRomanPSMT"
        case helvetica          = "HelveticaNeue"
        
        
        var bold:String {
            switch self {
            case .lato: return "Lato-Heavy"
            case .timesNewRoman: return "TimesNewRomanPS-BoldMT"
            case .helvetica: return "HelveticaNeue-Bold"
            case .verdana: return "Verdana-Bold"
            case .gotham: return "Gotham-Bold"
            default: return "Gotham-Bold"
            }
        }
        var italic:String {
            switch self {
            case .lato: return "Lato"
            case .timesNewRoman: return "TimesNewRomanPS-ItalicMT"
            case .helvetica: return "HelveticaNeue-Italic"
            case .verdana: return "Verdana-Italic"
            case .gotham: return "Gotham-BookItalic"
            default: return "Gotham-BookItalic"
            }
        }
        var medium:String {
            switch self {
            case .lato: return "Lato-medium"
            case .timesNewRoman: return "TimesNewRomanPSMT"
            case .helvetica: return "HelveticaNeue-Medium"
            case .verdana: return "Verdana"
            case .gotham: return "Gotham-Medium"
            default: return "Gotham-Medium"
            }
        }
        
        var light:String {
            switch self {
            case .timesNewRoman: return "TimesNewRomanPSMT"
            case .helvetica: return "HelveticaNeue-Light"
            case .verdana: return "Verdana"
            case .gotham: return "Gotham-Light"
            default: return "Gotham-Light"
            }
        }

        /*
         ------------------------------
         Font Family Name = [Verdana]
         Font Name = [["Verdana-Italic", "Verdana", "Verdana-Bold", "Verdana-BoldItalic"]]
        ------------------------------
        Font Family Name = [Times New Roman]
        Font Name = [["TimesNewRomanPS-ItalicMT", "TimesNewRomanPS-BoldItalicMT", "TimesNewRomanPS-BoldMT", "TimesNewRomanPSMT"]]
         ------------------------------
         Font Family Name = [Helvetica Neue]
         Font Name = [["HelveticaNeue-UltraLightItalic", "HelveticaNeue-Medium", "HelveticaNeue-MediumItalic", "HelveticaNeue-UltraLight", "HelveticaNeue-Italic", "HelveticaNeue-Light", "HelveticaNeue-ThinItalic", "HelveticaNeue-LightItalic", "HelveticaNeue-Bold", "HelveticaNeue-Thin", "HelveticaNeue-CondensedBlack", "HelveticaNeue", "HelveticaNeue-CondensedBold", "HelveticaNeue-BoldItalic"]]
         ------------------------------
         Font Family Name = [Gotham]
         Font Name = [["Gotham-Black", "Gotham-MediumItalic", "Gotham-Thin", "Gotham-Light", "Gotham-BookItalic", "Gotham-Ultra", "Gotham-Bold", "Gotham-Medium", "Gotham-ThinItalic", "Gotham-UltraItalic", "Gotham-LightItalic", "Gotham-ExtraLight", "Gotham-ExtraLightItalic", "Gotham-BlackItalic", "Gotham-Book", "Gotham-BoldItalic"]]
         ------------------------------
         
 
 */

    }
    public convenience init(_ fontName: Name, size: CGFloat) {
        self.init(name: fontName.rawValue, size: size)!
    }
    public static func printFonts() {
        let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let name = UIFont.fontNames(forFamilyName: familyName)
            print("Font Name = [\(name)]")
        }
    }
}

extension UIFont {
    
    func withTraits(_ traits:UIFontDescriptorSymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor
            .withSymbolicTraits(UIFontDescriptorSymbolicTraits(traits).union(self.fontDescriptor.symbolicTraits))
        return UIFont(descriptor: descriptor!, size: 0)
    }
    func withoutTraits(_ traits:UIFontDescriptorSymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor
            .withSymbolicTraits(  self.fontDescriptor.symbolicTraits.subtracting(UIFontDescriptorSymbolicTraits(traits)))
        return UIFont(descriptor: descriptor!, size: 0)
    }
    func bold() -> UIFont {
        return withTraits( .traitBold)
    }
    
    func italic() -> UIFont {
        return withTraits(.traitItalic)
    }
    
    func noItalic() -> UIFont {
        return withoutTraits(.traitItalic)
    }
    func noBold() -> UIFont {
        return withoutTraits(.traitBold)
    }
}

