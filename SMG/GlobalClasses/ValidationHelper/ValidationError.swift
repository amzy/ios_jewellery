//
//  ValidationErrorType.swift
//  Vookar Vendor
//
//  Created by Amzad Khan on 06/01/16.
//  Copyright © 2016 syoninfomedia. All rights reserved.
//

import UIKit

public class ValidationError: NSObject {

    public enum OfType : Error {
        
        case ErrorWithMessage(message: String)
        
        case Empty
        case EmptyEmail
        case EmptyEmailMobile
        case EmptyPassword
        case EmptyOldPassword
        case EmptyNewPassword
        case EmptyConfirmPassword
        case EmptyName
        case EmptyUserName
        case EmptyMobileCode
        case EmptyMobileNumber
        case EmptyAddress
        case EmptyCity
        case EmptyState
        case EmptyCountry
        case EmptyPostalCode
        case EmptyRating

        case TermsAndCondition
        
        case ValidEmail
        case ValidPassword
        case ValidConfirmPassword
        case ValidMobileNumber
        case AlreadyExistMobile
        case ValidUserName
        case ValidCompanyName
        case ValidFromCompany
        
        case CompanyName
        case carPlateNo
        case referralCode
       
        case EmptyDescription
        
        case EmptyReason
        case EmptyDate
        case EmptyAmount
        
        case EmptyDegination
        case EmptyjobTitle
        case EmptyJobPoints
        case EmptyJobDescription
        case EmptyCategory
        case EmptyKeywords
        case EmptyPreferredDay
        case EmptyPreferredTime
        case EmptyEstComJob
        case EmptyRequiredDate
        case EmptyEquipment
        case EmptyLocation
        case EmptyPaypalEmail
        case EmptyConfirmPass

    }
}

extension ValidationError.OfType {
    
    var description: String {
        switch self {
            
        case .ErrorWithMessage(let message):
            return message

        case .Empty:
            return "Cannot be blank."
        case .EmptyEmail:
            return "Please enter a valid email address."
        case .EmptyEmailMobile:
            return "Please enter a valid Email / Mobile number."
        case .EmptyPaypalEmail:
            return "Paypal email address cannot be blank."
        case .EmptyPassword:
            return "Password cannot be blank and must be 6 characters long."
            
        case .EmptyOldPassword:
            return "Old password cannot be blank."
        case .EmptyNewPassword:
            return "New password cannot be blank."
        case .EmptyConfirmPass:
            return "Confirm password cannot be blank."
        case .EmptyConfirmPassword:
            return "New Password and Confirm Password doesn't match."
        case .TermsAndCondition:
            return "Please accept terms and conditions."
         
        case .EmptyName:
            return "Name cannot be blank."
        case .EmptyUserName:
            return "User name cannot be blank."
            
        case .EmptyMobileNumber:
            return "Mobile number is required and can't be empty"
        case .EmptyAddress:
            return "Building name or Postal code cannot be blank !"
        case .EmptyCity:
            return "City cannot be blank."
        case .EmptyState:
            return "State cannot be blank."
        case .EmptyCountry:
            return "Country cannot be blank."
        case .EmptyPostalCode:
            return "Zip code cannot be blank."
        case .EmptyRating:
            return "Rating cannot be empty."
     

        case .ValidEmail:
            return "Please enter a valid email address."
        case .ValidPassword:
            return "Password cannot be blank and must be 6 characters long."
        case .ValidConfirmPassword:
            return "Password not match."
            
        case .AlreadyExistMobile:
            return "This mobile number already exist."
        
        case .ValidUserName:
            return "Enter a Valid username."
        case .EmptyMobileCode:
            return "Mobile code cannot be blank."
        case .ValidMobileNumber:
            return "Please enter valid number !"
        case .ValidCompanyName:
            return "Please enter company name"
        case .ValidFromCompany:
            return "Please enter description"
        case .CompanyName:
            return "Company name cannot be blank."
        case .carPlateNo:
            return "Please enter car plate number."
        case .referralCode:
            return "Please enter referral Code."

            
        case .EmptyDescription:
            return "Description cannot be blank."

        case .EmptyReason:
            return "Reason cannot be blank."
        case .EmptyDate:
            return "Date cannot be blank."

        case .EmptyAmount:
            return "Please enter a valid amount."
            
        case .EmptyjobTitle:
            return "Job title cannot be blank."
        case .EmptyJobPoints:
            return "Job point value cannot be blank."
        case .EmptyJobDescription:
            return "Job description cannot be blank."
        case .EmptyCategory:
            return "Category cannot be blank."
        case .EmptyKeywords:
            return "Keywords cannot be blank."
        case .EmptyPreferredDay:
            return "Preferred day cannot be blank."
        case .EmptyPreferredTime:
            return "Preferred time cannot be blank."
        case .EmptyEstComJob:
            return "Estimate time to complete job cannot be blank."
        case .EmptyRequiredDate:
            return "Required by date cannot be blank."
        case .EmptyEquipment:
            return "Equipment provided cannot be blank."
        case .EmptyLocation:
            return "Location cannot be blank."
            
        default: return ""
        }
    }
}

extension ValidationError {
    
    public enum Card : Error {
        
        case EmptyNickName
        case EmptyName
        case EmptyCardNo
        case EmptyExpMonth
        case EmptyExpYear
        case EmptyCvv
        case ValidCardDetails
        
        var description: String {
            switch self {
                
            case .EmptyNickName:
                return "Card Nickname cannot be blank."
            case .EmptyName:
                return "CardHolder Name cannot be blank."
            case .EmptyCardNo:
                return "Card Number cannot be blank."
            case .EmptyExpMonth:
                return "Expiry Date cannot be blank."
            case .EmptyExpYear:
                return "Expiry Date cannot be blank."
            case .EmptyCvv:
                return "CVV cannot be blank."
            case .ValidCardDetails:
                return "Please enter valid card details."
            }
        }
    }
}
