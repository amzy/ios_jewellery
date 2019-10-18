//
//  UserCard.swift
//
//  Created by Amzad Khan on 05/04/17.
//  Copyright © 2017 Amzad Khan. All rights reserved.
//

import UIKit

class UserCard: NSObject {
    var id              = ""
    var number          = ""
    var type            = ""
    
    convenience init(_ attributes: [AnyHashable: Any]) {
        self.init()
        id              = attributes["id"] as? String ?? ""
        number          = attributes["card_number"] as? String ?? ""
        type            = attributes["card_type"] as? String ?? ""
    }
}
