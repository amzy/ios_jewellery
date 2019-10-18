//
//  Profile.swift
//
//  Created by Amzad Khan on 26/07/17.
//  Copyright © 2017 Amzad Khan. All rights reserved.
//

import UIKit

class Profile: NSObject {
    var photo           : Photo!
    var name            = ""
    var startTime       = ""
    var endTime         = ""
    var content         = ""
    
    override init() {
    }
    convenience init(attributes: [String: Any]) {
        self.init()
        name        = attributes["full_name"] as? String ?? ""
        content     = attributes["content"] as? String ?? ""
        startTime   = attributes["start_time"] as? String ?? ""
        endTime     = attributes["end_time"] as? String ?? ""
        
        if let urlString = attributes["image"] as? String, let url  = urlString.makeURL() {
            photo = Photo()
            photo?.url = url
        }
    }
}

extension Date {
    func appWeekDay()->WeekDay {
        let day = self.weekday
        if day == 1 {
            return WeekDay.sunday
        }else {
            return WeekDay(value: day-1)
        }
    }
}

enum WeekDay:Int {
    
    case notAvailable = 0, monday = 1 , tuesday, wednesday, thursday, friday, saturday, sunday
    var name:String {
        switch rawValue {
        case 1: return "Monday"
        case 2: return "Tuesday"
        case 3: return "Wednesday"
        case 4: return "Thursday"
        case 5: return "Friday"
        case 6: return "Saturday"
        // If images count more then one, type would change to `gallery`
        case 7: return "Sunday"
        default: return "N/A"
        }
    }
    public init(value: Any?) {
        let rawValue = Int(any: value)
        switch rawValue {
        case 1: self = .monday
        case 2: self = .tuesday
        case 3: self = .wednesday
        case 4: self = .thursday
        case 5: self = .friday
        case 6: self = .saturday
        // If images count more then one, type would change to `gallery`
        case 7: self = .sunday
        default: self = .notAvailable
        }
    }
}


struct RJTime {
    var startTime:String
    var endTime:String
    var day:WeekDay
    
    init(attributes: [AnyHashable: Any]) {
        startTime   = attributes["start_time"]  as? String ?? ""
        endTime     = attributes["end_time"]    as? String ?? ""
        day = WeekDay(value: attributes["day_index"])
    }
}

struct RJRadio {
    
    var id:String?
    var photo: Photo?
    var name:String?
    var email:String?
    var mobile:String?
    var fbLink:String?
    var youtubeLink:String?
    var isFavourite:Int?
    
    var weekSchedule = [RJTime]()
    var currentDay:RJTime?
    
    static func parse(json:[AnyHashable:Any])-> RJRadio {
        
        var obj = RJRadio()
        obj.id          = json["id"]  as? String ?? ""
        obj.name        = json["full_name"]  as? String ?? ""
        obj.email       = json["email"]    as? String
        obj.mobile      = json["mobile_number"]    as? String
        obj.fbLink      = json["fb_url"]    as? String
        obj.youtubeLink = json["youtube_url"]    as? String
        obj.isFavourite = json["is_fav"]    as? Int//Int(any:attributes["is_fav"])
        obj.currentDay   = RJTime(attributes: json)
        
        if let urlString = json["image"] as? String, let url  = urlString.makeURL() {
            obj.photo = Photo()
            obj.photo?.url = url
        }
        if let working = json["working_timing"] as? [[AnyHashable:Any]] {
            for day in working {
                let time = RJTime(attributes: day)
                obj.weekSchedule.append(time)
            }
        }
        return obj
    }
}
