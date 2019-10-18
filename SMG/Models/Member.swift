//
//  Member.swift
//
//  Created by Amzad Khan. on 14/03/18.
//  Copyright © 2018 Amzad Khan. All rights reserved.
//

import UIKit

class Member: NSObject {
    
    var id            :String?
    var groupID       :String?
    var member        = 0
    var friend   :String?
    var tital         :String?
    var discription   :String?
    var photo         :Photo?
    var name          :String?
    var userID        :String?
    var isAdmin        = false
    var isMe           = false
    
    override init() {}
    
    convenience init(attributes: [String: Any]) {
        self.init()
        
        id           = attributes["id"] as? String ?? ""
        userID       = attributes["user_id"] as? String ?? ""
        name         = attributes["user_name"] as? String ?? ""
        groupID      = attributes["groupid"] as? String ?? ""
        friend       = attributes["friendsCount"] as? String ?? ""
        member       = Int(any:attributes["members"])
        tital        = attributes["title"] as? String ?? ""
        discription  = attributes["user_status"] as? String ?? ""
        isAdmin      = Bool(any:attributes["isAdmin"])
        isMe         = Bool(any:attributes["isMe"])
        
        if let urlString = attributes["user_avatar"] as? String, let url  = urlString.makeURL() {
            photo = Photo()
            photo?.url = url
        }
    }
}


