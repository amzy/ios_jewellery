//
//  NSObject.swift
//  WhyQ
//
//  Created by Amzad Khan on 17/03/17.
//  Copyright © 2017 SyonInfomedia. All rights reserved.
//

import UIKit

public extension NSObject  {
    
    var customDescription: String {
        let aClass : AnyClass? = type(of: self)
        var propertiesCount : CUnsignedInt = 0
        let propertiesInAClass  = class_copyIvarList(aClass, &propertiesCount)
        let className  = "\(NSStringFromClass(type(of: self)).components(separatedBy: ".").last ?? "")"
        
        var descriptionData = [String:Any]()
        for i in 0 ..< Int(propertiesCount) {
            if let key = String(cString: ivar_getName(propertiesInAClass![i])!, encoding: String.Encoding.utf8) {
                var value: Any = "nil"
                if let propValue = self.value(forKey: key) {
                    value = propValue
                }
                let key = "\(key)"
                descriptionData[key] = value
            }
        }
        
        return "\n*** \(className) ***\n" + "\(descriptionData)"
    }
}
