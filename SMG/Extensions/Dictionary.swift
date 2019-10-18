//
//  Dictionary.swift
//  WhyQ
//
//  Created by Himanshu Parashar on 17/03/17.
//  Copyright © 2017 SyonInfomedia. All rights reserved.
//

import Foundation

extension Dictionary {
    
    static func +<Key, Value> (lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
        var result = lhs
        rhs.forEach{ result[$0] = $1 }
        return result
    }
    
    mutating func merge(with dictionary: [Key: Value]) {
        dictionary.forEach { updateValue($1, forKey: $0) }
    }
    
    func merged(with dictionary: [Key: Value]) -> [Key: Value] {
        var dict = self
        dict.merge(with: dictionary)
        return dict
    }
}
extension Dictionary {
    //    var description:String {
    //        return self.json().replace(string: "\", replacement: "/")
    //    }
    func json() -> String {
        var returnValue  = "{}"
        if let jsonData = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) {
            if let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
                returnValue =  jsonString as String
            }
        }
        returnValue = returnValue.trimmingCharacters(in: .whitespacesAndNewlines)
        return returnValue
    }
}
extension String {
    func decodeJson() ->Any? {
        guard let data  = self.data(using: String.Encoding.utf8) else { return nil }
        guard let jsonObj = try? JSONSerialization.jsonObject(with: data, options: []) else  { return nil }
        return jsonObj
    }
}

extension Array {
    func json() -> String {
        var returnValue  = "[]"
        if let jsonData = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted) {
            if let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
                returnValue =  jsonString as String
            }
        }
        returnValue = returnValue.trimmingCharacters(in: .whitespacesAndNewlines)
        return returnValue
    }
}
