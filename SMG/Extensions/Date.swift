//
//  Date.swift
//
//  Created by Amzad Khan on 05/01/16.
//  Copyright © 2016 Amzad Khan. All rights reserved.
//

import Foundation

extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
    static var UTCDate: Date {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString  = dateFormatter.string(from: date)
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let requiredDate = dateFormatter.date(from: dateString)
        return requiredDate!
    }
    static var timestamp: String {
        return "\(Date().millisecondsSince1970)"
    }
    static var UTCTimestamp: String {
        let requiredDate = Date.UTCDate
        return "\(requiredDate.millisecondsSince1970)"
    }
}

extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}

public extension Date {
    //////////////////////////////
    //
    // MARK: today
    //
    public static func today() -> Date? {
        
        // *** Create date ***
        let date = Date()
        
        // *** Get components using current Local & Timezone ***
        let components = Constants.kCalendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        
        return Constants.kCalendar.date(from: components)
    }
    
    //
    // MARK: to string
    //
    
    public var sun:     String { get { return stringFromFormat("EEE")       } }
    public var sunday:  String { get { return stringFromFormat("EEEE")      } }
    public var jan:     String { get { return stringFromFormat("MMM")       } }
    public var january: String { get { return stringFromFormat("MMMM")      } }
    public var monJan1: String { get { return stringFromFormat("EEE MMM d") } }
    
    //
    // MARK: yesterday/tomorrow
    //
    
    public var yesterday: Date { get { return self - 1 } }
    public var tomorrow:  Date { get { return self + 1 } }
    
    //
    // MARK: components
    //
    
    public var year:    Int { get { return Constants.kCalendar.dateComponents([.year], from: self).year! } }
    public var month:   Int { get { return Constants.kCalendar.dateComponents([.month], from: self).month! } }
    public var day:     Int { get { return Constants.kCalendar.dateComponents([.day], from: self).day! } }
    public var weekday: Int { get { return Constants.kCalendar.dateComponents([.weekday], from: self).weekday! } }
    
    public var daysInMonth: Int {
        get {
            return (Constants.kCalendar as NSCalendar).range(of: [NSCalendar.Unit.day], in: [NSCalendar.Unit.month], for: self).length
        }
    }
    
    //
    // MARK: month math
    //
    
    public func subtractMonths(_ rhs: Date) -> Int {
        return (year * 12 + month) - (rhs.year * 12 + rhs.month)
    }
    
    //
    // MARK: with
    //
    
    public func withDay(_ day: Int) -> Date {
        var components = (Constants.kCalendar as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month], from: self)
        components.day = day
        return Constants.kCalendar.date(from: components)!
    }
    public func withMonth(_ month: Int) -> Date {
        var components = (Constants.kCalendar as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.day], from: self)
        components.month = month
        return Constants.kCalendar.date(from: components)!
    }
    public func withYear(_ year: Int) -> Date {
        var components = (Constants.kCalendar as NSCalendar).components([NSCalendar.Unit.month, NSCalendar.Unit.day], from: self)
        components.year = year
        return Constants.kCalendar.date(from: components)!
    }
    
    var is18yearsOld:Bool {
        return Date().yearsFrom(self) > 18
    }
    func yearsFrom(_ date:Date)   -> Int { return (Calendar.current as NSCalendar).components(NSCalendar.Unit.year, from: date, to: self, options: []).year! }
    
    
    public func stringFromFormat(_ format: String) -> String {
        
        //let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = format //"yyyy-MM-dd HH:mm:ss.SSS"//2014-09-23 15:15:28.252
        let defaultTimeZoneStr = formatter.string(from: self)
        
        return defaultTimeZoneStr
    }
    
    func components(_ unitFlags: NSCalendar.Unit) -> DateComponents {
        return (Constants.kCalendar as NSCalendar).components(unitFlags, from: self)
    }
    
    
    /**
     Convert the date format.
     
     - Parameters:
     - string:       The date string.
     - forFormat:    The date string Formate.
     - toFormat:     Converted Formate.
     
     - Returns: A new converted Date and String.
     */
    public static func convert(from dateString: String, forFormat: String? = "yyyy-MM-dd HH:mm:ss", toFormat: String? = "yyyy-MM-dd HH:mm:ss") -> (date: Date?, string: String?) {
        
        let dateMakerFormatter = DateFormatter()
        
        dateMakerFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
        //dateMakerFormatter.timeZone = TimeZone(identifier: "UTC") //for GMT Time
        
        dateMakerFormatter.dateFormat = forFormat
        guard let date = dateMakerFormatter.date(from: dateString) else {
            return (nil, nil)
        }
        dateMakerFormatter.dateFormat = toFormat
        let toDateString = dateMakerFormatter.string(from: date)
        
        return (date, toDateString)
    }
    
    public static func getDateString(fromString date: String, formate: String, convertFormate: String) -> String? {
        if date == "" || date == "0000-00-00" || date == "0000-00-00 00:00:00" {
            return ""
        }
        
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = formate
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = convertFormate
        
        return dateFormatter.string(from: date!)
    }
    
    public static func getDate(fromString date: String, formate: String? = "yyyy-MM-dd HH:mm:ss") -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = formate
        let date = dateFormatter.date(from: date)
        
        return date
    }
    
    public static func getDateString(fromDate date: Date, formate: String) -> String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formate
        let date = dateFormatter.string(from: date)
        return date
    }
    
    
    /*
     // How to work with dates and times : DateFormatter
     www.globalnerdy.com/2016/08/22/how-to-work-with-dates-and-times-in-swift-3-part-2-dateformatter/
     
     - Examples: String for format:
     - convert(from: "Tue Nov 29 at 01:00 PM", forFormat: "E MMM dd' at 'hh:mm a")
     - convert(from: "28 November, 2016 at 06:30 PM", forFormat: "dd MMMM, yyyy' at 'hh:mm a", toFormat: "EEEE, MMMM dd, yyyy' at 'h:mm a.")
     
     If dateStyle and timeStyle are both set to…	the date formatter’s output looks like…
     NoStyle
     ShortStyle	1/27/10, 1:00 PM
     MediumStyle	Jan 27, 2010, 1:00:00 PM
     LongStyle	January 27, 2010 at 1:00:00 PM EST
     FullStyle	Wednesday, January 27, 2010 at 1:00:00 PM Eastern Standard Time
     
     'Year: 'y' Month: 'M' Day: 'd	Year: 2007 Month: 1 Day: 9
     MM/dd/yy	01/09/07
     MMM dd, yyyy	Jan 09, 2007
     E MMM dd, yyyy	Tue Jan 09, 2007
     EEEE, MMMM dd, yyyy' at 'h:mm a.	Tuesday, January 09, 2007 at 10:00 AM.
     EEEE, MMMM dd, yyyy' at 'h:mm a zzzz.	Tuesday, January 09, 2007 at 10:00 AM Pacific Standard Time.
     
     */
}


//
// MARK: date/month math
//

public func +(l: Date, r: DateComponents) -> Date {
    return (Constants.kCalendar as NSCalendar).date(byAdding: r, to: l, options: [])!
}

public func  +(l: Date, r: Int) -> Date { return l + DateComponents(day:    r) }
public func  -(l: Date, r: Int) -> Date { return l + DateComponents(day:   -r) }
public func >>(l: Date, r: Int) -> Date { return l + DateComponents(month:  r) }
public func <<(l: Date, r: Int) -> Date { return l + DateComponents(month: -r) }

public func  +=(l: inout Date, r: Int) { l = l +  r }
public func  -=(l: inout Date, r: Int) { l = l -  r }
public func >>=(l: inout Date, r: Int) { l = l >> r }
public func <<=(l: inout Date, r: Int) { l = l << r }

public prefix func ++(l: inout Date) -> Date {
    l += 1
    return l
}
public postfix func ++(l: inout Date) -> Date {
    let old = l
    l += 1
    return old
}

public func -(l: Date, r: Date) -> Int {
    let components = (Constants.kCalendar as NSCalendar).components([NSCalendar.Unit.day], from: r, to: l, options: [])
    return components.day!
}

//
// MARK: DateComponents
//

extension DateComponents {
    init(day: Int) {
        self.init()
        self.day = day
    }
    init(month: Int) {
        self.init()
        self.month = month
    }
}

extension TimeInterval {
    public static func getTimeString(from interval: TimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

extension Date {
    func timeAgo(showNumeric:Bool = true) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = NSDate()
        let earliest = now.earlierDate(self)
        let latest = (earliest == now as Date) ? self : now as Date
        let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (showNumeric){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (showNumeric){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (showNumeric){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (showNumeric){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (showNumeric){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (showNumeric){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
    }
}
