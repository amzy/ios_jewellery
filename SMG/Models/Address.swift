//
//  Address.swift
//
//  Created by Amzad Khan on 25/01/18.
//  Copyright © 2018 Amzad Khan. All rights reserved.
//

import UIKit

class Address: NSObject {
    var id              :String?
    var address         :String?
    
    var cityID          :String?
    var city            :String?
    
    var stateID         :String?
    var state           :String?
    
    var postalCode      :String?
    
    var countryCode     :String?
    var countryName     :String?
    
    var latitude        :String?
    var longitude       :String?
    
    override init() {
        super.init()
    }
    
    func encodeWithCoder(_ aCoder: NSCoder!) {
        
        if id != nil { aCoder.encode(id, forKey: "id") }
        
        if address != nil { aCoder.encode(address, forKey: "address") }
        
        if city != nil { aCoder.encode(city, forKey: "city") }
        if cityID != nil { aCoder.encode(cityID, forKey: "cityID") }
        
        if state != nil { aCoder.encode(state, forKey: "state") }
        if stateID != nil { aCoder.encode(stateID, forKey: "stateID") }
        
        if postalCode != nil { aCoder.encode(postalCode, forKey: "postalCode") }
        
        if countryCode != nil { aCoder.encode(countryCode, forKey: "countryCode") }
        if countryName != nil { aCoder.encode(countryName,    forKey: "countryName") }
        
    }
    
    init(coder aDecoder: NSCoder!) {
        
        id                   = aDecoder.decodeObject(forKey: "id")            as? String

        address              = aDecoder.decodeObject(forKey: "address")       as? String
        
        city                 = aDecoder.decodeObject(forKey: "city")          as? String
        cityID               = aDecoder.decodeObject(forKey: "cityID")        as? String
        
        state                = aDecoder.decodeObject(forKey: "state")         as? String
        stateID              = aDecoder.decodeObject(forKey: "stateID")       as? String
        
        postalCode           = aDecoder.decodeObject(forKey: "postalCode")    as? String
        
        countryCode          = aDecoder.decodeObject(forKey: "countryCode")   as? String
        countryName          = aDecoder.decodeObject(forKey: "countryName")   as? String
        
    }
}

/*

extension Address: Encodable {
    enum AddressKey: String, CodingKey {
        case id
        case address
        case cityID
        case city
        case state
        case stateID
        case countryName
        case countryCode
        case postalCode
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AddressKey.self)
        try container.encode(address, forKey: .address)
        try container.encode(id, forKey: .id)
        try container.encode(cityID, forKey: .cityID)
        try container.encode(city, forKey: .city)
        try container.encode(stateID, forKey: .stateID)
        try container.encode(state, forKey: .state)
        try container.encode(countryName, forKey: .countryName)
        try container.encode(countryCode, forKey: .countryCode)
        try container.encode(postalCode, forKey: .postalCode)
    }
}
extension Address: Decodable {
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: AddressKey.self)
        id = try values.decode(String.self, forKey: .id)
        address = try values.decode(String.self, forKey: .address)
        cityID = try values.decode(String.self, forKey: .cityID)
        city = try values.decode(String.self, forKey: .city)
        stateID = try values.decode(String.self, forKey: .stateID)
        state = try values.decode(String.self, forKey: .state)
        countryName = try values.decode(String.self, forKey: .countryName)
        countryCode = try values.decode(String.self, forKey: .countryCode)
        postalCode = try values.decode(String.self, forKey: .postalCode)
    }
}
*/
