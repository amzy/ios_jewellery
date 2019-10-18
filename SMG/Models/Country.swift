//
//  Country.swift
//  Created by Amzad Khan on 28/09/16.
//  Copyright © 2016 Amzad Khan. All rights reserved.
//

import UIKit

class UserAddress {
    
    var addressLine1 : String?
    var addressLine2 : String?
    var city    :City?
    var state   :State?
    var country :Country?
    var latitude :String?
    var longitude :String?
}

class Country: NSObject {
    
    var isoCode         :String?
    var id              :String?
    var name            :String?
    var phoneCode       :String?
    var isSelected             = false
    override init(){
        
    }
     convenience init(_ attributes: [String: Any]) {
        self.init()
        id = attributes["id"] as? String ?? ""
        name = attributes["Country_Name"] as? String ?? ""
        isoCode = attributes["Short_Name"] as? String ?? ""
        phoneCode = attributes["phone_code"] as? String ?? ""
    }
    
}

class State: NSObject {
    var name            :String?
    var id              :String?
    var isSelected      = false
    override init(){
        
    }
    convenience init(_ attributes: [String: Any]) {
        self.init()
        id = attributes["id"] as? String ?? ""
        name = attributes["State_Name"] as? String ?? ""
    
    }
}

class City: NSObject {
    var name            :String?
    var id              :String?
    var isSelected          = false
    override init(){
        
    }
    convenience init(_ attributes: [String: Any]) {
        self.init()
        id = attributes["id"] as? String ?? ""
        name = attributes["city_name"] as? String ?? ""
    }
}
