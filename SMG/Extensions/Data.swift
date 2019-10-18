//
//  Data.swift
//  EzyParent
//
//  Created by Himanshu Parashar on 14/12/16.
//  Copyright © 2016 SyonInfomedia. All rights reserved.
//

import Foundation

extension Data {
    func hexString() -> String {
        return self.reduce("") { string, byte in
            string + String(format: "%02X", byte)
        }
    }
}

