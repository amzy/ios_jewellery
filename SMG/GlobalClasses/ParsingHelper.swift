//
//  ParsingHelper.swift
//
//  Created by Amzad Khan on 2/22/18.
//  Copyright © 2018 Amzad Khan. All rights reserved.
//

import Foundation

extension Double {
    
    init(any:Any? ) {
        if let value = any {
            if let val = value as? Double {
                self = val
            } else if let val = value as? Int {
                self  =  Double(val)
            } else if let val = value as? String {
                self  =  Double(val) ?? 0
            } else if let val = value as? Bool {
                self =  Double(truncating: NSNumber(value: val))
            } else {
                self =  value as? Double ?? 0.0
            }
        }else {
            self = 0.0
        }
    }
}

extension Int {
    init(any:Any?) {
        if let value = any {
            if let val = value as? Int {
                self =  val
            }else if let val = value as? Double {
                self = Int(val)
            } else if let val = value as? String {
                self =  Int(Double(val) ?? 0)
            } else if let val = value as? Bool {
                self =  Int(truncating: NSNumber(value: val))
            } else {
                self =  value as? Int ?? 0
            }
        }else {
            self = 0
        }
    }
}

extension Bool {
    init(any:Any?) {
        self = Int(any: any) == 0 ? false : true
    }
}

extension String {
    init(any:Any? ) {
        if let value = any {
            if let val = value as? Int {
                self =  "\(val)"
            }else if let val = value as? Double {
                self = "\(val)"
            } else if let val = value as? String {
                self =  val
            } else if let val = value as? Bool {
                self =  val == true ? "true" : "false"
            } else {
                self =  value as? String ?? ""
            }
        }else {
            self = ""
        }
    }
}

extension Date {
    init(timestamp:Any? ) {
        if let value = timestamp {
            let time = Double(any:value)
            self = Date(timeIntervalSince1970: time)
        }else {
            self = Date()
        }
    }
}
extension URL {
    init?(urlString:String? ) {
        if let urlStr  = urlString as? String, let url  = urlStr.makeURL() {
            self = url
        }else {
            return nil
        }
    }
    
    static func parse(any:Any?) ->URL? {
        if let urlString  = any as? String, let url  = urlString.makeURL() {
            return url
        }else {
            return nil
        }
    }
}
