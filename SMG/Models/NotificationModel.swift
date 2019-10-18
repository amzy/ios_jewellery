//
//  NotificationModel.swift
//
//  Created by Amzad Khan. on 15/03/18.
//  Copyright © 2018 Amzad Khan. All rights reserved.
//

import UIKit

class NotificationModel: NSObject {
    var id            :String?
    var photo         :Photo?
    var cover         :Photo?
    var userName      :String?
    var message       :String?
    var subject       :String?
    var connectionID  :String?
    var date          :String?
    
    override init() {}
    
    convenience init(attributes: [String: Any]) {
        
        self.init()
        
        id           = attributes["id"] as? String ?? ""
        userName     = attributes["user_name"] as? String ?? ""
        date         = attributes["date"] as? String ?? ""
        connectionID = attributes["connection_id"] as? String ?? ""
        subject      = attributes["subject"] as? String ?? ""
        message      = attributes["message"] as? String ?? ""
        
        
        if let urlString = attributes["user_avatar"] as? String, let url  = urlString.makeURL() {
            photo = Photo()
            photo?.url = url
        }
    }
}
