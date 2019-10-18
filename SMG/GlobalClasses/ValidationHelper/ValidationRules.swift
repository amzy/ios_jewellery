//
//  ValidationRules.swift
//  Vookar Vendor
//
//  Created by Amzad Khan on 06/01/16.
//  Copyright © 2016 syoninfomedia. All rights reserved.
//

import UIKit

public class ValidationRules: NSObject {

    public class func isBlank(_ object: Any) -> Bool {
        
        if object is UITextField {
            
            let text = (object as! UITextField).text!.trim()
            if text.isEmpty {
                return true
            }
        } else if object is UITextView {
            
            let text = (object as! UITextView).text.trim()
            if text.isEmpty {
                return true
            }
        } else if object is String {
            
            let text = (object as! String).trim()
            if text.isEmpty {
                return true
            }
        }
        return false
    }
    
    public class func isValid(name: String) -> Bool {
        // check the String is between 4 and 16 characters
        if !(4...16 ~= name.trim().count) {
            return false
        }
        
        return true
    }
    
    public class func isValid(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let range = email.trim().range(of: emailRegEx, options:.regularExpression)
        let result = range != nil ? true : false
        return !result
    }
    public class func isValid(gstNo: String) -> Bool {
        let emailRegEx = "^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$"
        let range = gstNo.trim().range(of: emailRegEx, options:.regularExpression)
        let result = range != nil ? true : false
        return !result
    }
    
    public class func isValid(password: String) -> Bool {
        // Alternative Regexes
        
        // 8 characters. One uppercase
        // static let regex = "^(?=.*?[A-Z]).{8,}$"
        //
        // 8 characters. One uppercase. One Lowercase. One number.
        // static let regex = "^(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[a-z]).{8,}$"
        //
        // no length. One uppercase. One lowercae. One number.
        // static let regex = "^(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[a-z]).*?$"
        
        let regex = "^.{6,}$"
        
        let range = password.range(of: regex, options:.regularExpression)
        let result = range != nil ? true : false
        return !result
    }
    
    public class func isValid(phoneNumber: String) -> Bool {
        
        //let phoneRegEx = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneRegEx = "^\\d{1,}-\\d{8,}$"
        let range = phoneNumber.range(of: phoneRegEx, options:.regularExpression)
        let result = range != nil ? true : false
        return !result

        /*let phoneRegEx = "^\\d{8}$"
        let range = phoneNumber.range(of: phoneRegEx, options:.regularExpression)
        let result = range != nil ? true : false
        return !result*/
    }
   public class func isValid(webUrl: String?) -> Bool {
        guard let urlString = webUrl else {return false}
        guard let url = NSURL(string: urlString) else {return false}
        if !UIApplication.shared.canOpenURL(url as URL) {return false}
        
        //
        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluate(with: urlString)
    }
    public class func isValid(url: String) -> Bool {
        
        //var urlRegEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        //let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[urlRegEx])
        //var urlTest = NSPredicate.predicateWithSubstitutionVariables(predicate)
        //return predicate.evaluateWithObject(stringURL)
        
        let urlRegEx = "((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let range = url.range(of: urlRegEx, options:.regularExpression)
        let result = range != nil ? true : false
        return !result
    }

    
    public class func isValidTime(startTime: String, endTime: String) -> Bool {
     
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm"
        var date = Date()
        let eventdate = startTime + " " + endTime
        date = formatter.date(from: eventdate)!
        let currentDate = Date()

        return !self.isGreaterThanDate(startDate: date, dateToCompare: currentDate)
    }
 
    
   public class  func isGreaterThanDate(startDate :Date , dateToCompare: Date) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if startDate.compare(dateToCompare as Date) == ComparisonResult.orderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
}
