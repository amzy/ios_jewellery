//
//  Created by Himanshu Parashar on 11/08/15.
//  Copyright (c) 2015 Syon Infomedia. All rights reserved.
//

import UIKit

extension UIColor {
    
    /*************************************************************/
     //MARK:-   UIColor  : App Color Codes
     /*************************************************************/

    

/*
    Color info:
    Sky blue bg color - #c6f2f5
    Button bg color - #ce667a
    heading blue text color - #239fc4
    Search bar text color - #8c8c8c
    light bg color of km - #afd3d6
    first pink color bg -#f19bab
    second pink color bg -#ed8a9d
    third pink color bg - #dd778a
    fourth pink color bg -#ce667a
    */
    
    //195 150 91,  19 19 19, 135 93 72
    /*************************************************************/
     //MARK:-   Hex UIColor extensions
     /*************************************************************/
    
    convenience init(hex: String) {
        self.init(hex: hex, alpha:1)
    }
    
    convenience init(hex: String, alpha: CGFloat) {
        var hexWithoutSymbol = hex
        if hexWithoutSymbol.hasPrefix("#") {
            hexWithoutSymbol = hex.substring(1)
        }
        
        let scanner = Scanner(string: hexWithoutSymbol)
        var hexInt:UInt32 = 0x0
        scanner.scanHexInt32(&hexInt)
        
        var r:UInt32!, g:UInt32!, b:UInt32!
        switch (hexWithoutSymbol.length) {
        case 3: // #RGB
            r = ((hexInt >> 4) & 0xf0 | (hexInt >> 8) & 0x0f)
            g = ((hexInt >> 0) & 0xf0 | (hexInt >> 4) & 0x0f)
            b = ((hexInt << 4) & 0xf0 | hexInt & 0x0f)
            break;
        case 6: // #RRGGBB
            r = (hexInt >> 16) & 0xff
            g = (hexInt >> 8) & 0xff
            b = hexInt & 0xff
            break;
        default:
            // TODO:ERROR
            break;
        }
        
        self.init(
            red: (CGFloat(r)/255),
            green: (CGFloat(g)/255),
            blue: (CGFloat(b)/255),
            alpha:alpha)
    }
    
    /*************************************************************/
     //MARK:-   Hex UIColor extensions
     /*************************************************************/
    open class func random() -> UIColor {
        let red = CGFloat(arc4random() % 256) / 256.0
        let green = CGFloat(arc4random() % 256) / 256.0
        let blue = CGFloat(arc4random() % 256) / 256.0
        let alpha = CGFloat(arc4random() % 256) / 256.0
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
