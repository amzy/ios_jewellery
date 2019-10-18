//
//  Created by Himanshu Parashar on 11/08/15.
//  Copyright (c) 2015 Syon Infomedia. All rights reserved.
//

import Foundation
import UIKit

public extension String {
    
    public func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func capitalizingFirstLetter() -> String {
        guard self.length > 0 else { return "" }
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    public static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    public func substring(_ from: Int) -> String {
        return self.substring(from: self.index(self.startIndex, offsetBy: from))
    }
    
    public func startWith(_ find: String) -> Bool {
        return self.hasPrefix(find)
    }
    
    public func equals(_ find: String) -> Bool {
        return self == find
    }
    
    public func contains(_ find: String) -> Bool {
        if let _ = self.range(of: find) {
            return true
        }
        return false
    }
    
    public var length: Int {
        return self.count
    }
    
    public var str: NSString {
        return self as NSString
    }
    public var pathExtension: String {
        return str.pathExtension 
    }
    public var lastPathComponent: String {
        return str.lastPathComponent 
    }
    
    public func boolValue() -> Bool? {
        var returnValue:Bool = false
        let falseValues = ["false", "no", "0"]
        let lowerSelf = self.lowercased()
        
        if falseValues.contains(lowerSelf) {
            returnValue =  false
        } else {
            returnValue = true
        }
        return returnValue
    }
    
    public var floatValue: Float {
        return (self as NSString).floatValue
    }
    public var doubleValue: Double {
        return (self as NSString).doubleValue
    }
    
    func URLEncodedString() -> String {
        let escapedString = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        return escapedString ?? ""
    }
    
    public func makeURL() -> URL? {
        let urlString = self.removingPercentEncoding ?? ""
        let trimmed = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        guard let url = URL(string: trimmed ?? "") else {
            return nil
        }
        return url
    }
    
    static func heightForText(_ text: String, font: UIFont, width: CGFloat) -> CGFloat {
        
        let rect = NSString(string: text).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        return ceil(rect.height)
    }
    
    func replace(string: String, replacement: String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: String.CompareOptions.literal, range: nil)
    }
    static func widthForText(_ text: String, font: UIFont, height: CGFloat) -> CGFloat {
        
        let rect = NSString(string: text).boundingRect(with: CGSize(width:  CGFloat(MAXFLOAT), height:height), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        return ceil(rect.width)
    }

    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }

    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined(separator: "")
    }
    
    public static func format(_ duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        if duration >= 3600 {
            formatter.allowedUnits.insert(.hour)
        }
        return formatter.string(from: duration)!
    }
    
    var attributedString:NSAttributedString {
        let data = Data(self.utf8)
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
          return attributedString
        }else {
            return NSAttributedString(string: self)
        }
    }
}
