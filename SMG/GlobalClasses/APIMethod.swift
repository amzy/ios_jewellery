//
//  APIMethod.swift
//  My Life
//
//  Created by Amzad Khan on 25/05/17.
//  Copyright © 2017 Syon. All rights reserved.
//

import Foundation

enum API: String {
    
    case empty                  = ""
    case registerMobile         = "user_register_with_mobile"
    case verifyUserToken        = "verify_user_token"
    case newToken               = "custom_token"
    case updateProfile          = "update_user_profile"
    case getProfile             = "get_user_profile"
    
    case categoryProducts       = "get_category_products"
    
    case homeSlider             = "get_home_slider"
    case homeProducts           = "get_home_products"
    case productDetail          = "get_product_details"
    
    case addToCart              = "add_to_cart_product"
    case cartList               = "get_cart_item"
    case removeCartItem         = "remove_cart_item"
    case createOrder            = "create_order"
    case createCustomOrder      = "create_custom_order"
    case callingNumber          = "get_call_button_setting"
    
    case searchProduct          = "get_search_product" //?max_weight=&posts_per_page=50&user_id=4&min_weight=&sku=smg
    case cartProductDetail      = "get_cart_single_products" //?cart_id=168&user_id=4&product_id=733
    case updateCartProduct      = "update_cart_item_single_product" //?cart_id=168&size=25&user_id=4&purity=22-carrot&product_id=733&qty=1&weight=35.500Grm&remark=&sku=CL0090VDY
    
    case updateCartItemQuantity = "update_cart_items" //{ {cart_id=168, user_id=4, qty=2, product_id=733}}
    case addToWhishList         = "add_to_wishlist_product" //?size=23&user_id=4&purity=22-carrot&product_id=733&qty=1&weight=35.500Grm&remark=&sku=CL0090VDY
    case whishList              = "get_wishlist_item" //?user_id=4
    case removeWhichListItem    = "remove_wishlist_item" //?user_id=4&product_id=733&wishlist_id=63
    case whichListCart          = "wishlist_product_add_to_cart" //?user_id=4&product_id=731&wishlist_id=64&sku=CL0089VDY"
    case getOrders              = "get_user_order_list" //?user_id=4&per_page_orders=10&current_page=1
    case customOrderList        = "get_user_custom_order_list" //?user_id=4&per_page_orders=10&current_page=1
    case orderProducts          = "get_order_products" //?user_id=4&order_id=504
    case cancelOrder            = "cancel_order"
    case cancelCustomOrder      = "cancel_custom_order?"
    
    case home                   = "common/banners"
    case aboutUS                = "users/staticPages"
    case sendFeedback           = "feedback/sendFeedback"
    
    case sendDeviceID           = "common/sendDeviceDetail"
    case setNotification        = "common/setNotificationSettings"
    case getNotification        = "common/NotificationDetail"
    
    
    
}
//https://smgbangles.com/wp-json/wp/v2/user_register_with_mobile
//smgbangles.com
extension API : APIRequirement {
    static let kSimulatorDeviceID = "1CF1A9F53144FB3543E708BDC6DBCF8F94C9FCCC3CA0D2FD259EFC5D8CFC8E06"
    static var baseURL: String {
        #if DEBUG
            return "https://smgbangles.com/"
        #else
            return "https://smgbangles.com/"
        #endif
    }
    var apiHeader: [String : String]! {
        var finalHeader  = Constants.kHeaders
        let deviceID:String = Constants.kAppDelegate.deviceID ?? API.kSimulatorDeviceID
        finalHeader["Device-Id"] = deviceID
        return finalHeader
    }
    var imagePath: String {
        return "\(API.baseURL)assets/uploads/users/"
    }
    var apiPath: String {
        return "\(API.baseURL)wp-json/wp/v2/"
    }
    var methodPath: String {
        return self.rawValue
    }
    func finalParameters(from parameters: [String : Any]) -> [String : Any] {
        var finalParameters  = parameters
        finalParameters["device_id"] = Constants.kAppDelegate.deviceID ?? API.kSimulatorDeviceID
        finalParameters["time_zone"] = "asia/calcutta"
        
        if let user = User.isUserLogin() {
            //Registered User
            if parameters ["user_id"] == nil {
                finalParameters["user_id"] = user.id //25
            }
            //finalParameters["user_token"] = user.accessToken
        }else {
            //Guest User
            if self.rawValue != API.registerMobile.rawValue {
                if parameters ["user_id"] == nil {
                    finalParameters["user_id"] = "40"
                }
            }
        }
        
        return finalParameters
    }
    
    func tokenDidExpired() {
        Constants.kAppDelegate.logout(for: "")
    }
}

extension API : APIValidationRequirement {
    
    func validateAllResponse(_ JSON:Any?, error:Error?, success:APISuccessHandler?, failed:APIFailureHandler?) {
        if let apiError = error {
           /* #if targetEnvironment(simulator)
                if let responseString  = JSON as? String {
                    print(responseString)
                }
            #endif*/
            if let responseString  = JSON as? String {
                print(responseString)
            }
            guard let failedHandler = failed else {
                switch self {
                case .empty: break
                default:
                    Global.showAlert(message:apiError.localizedDescription)
                }
                return
            }
            failedHandler(apiError, nil)
        }else if let response = JSON as? [String:Any] {
            print("Success with JSON: \(Global.stringifyJson(response).replacingOccurrences(of: "\\/", with: "/"))")

            guard Int(any: response["logout"]) == 0 else {
                self.tokenDidExpired()
                return
            }
            guard Int(any: response["status"]) != 2 else {
                self.tokenDidExpired()
                return
            }
            // Successfullu recieve response from server
            
            guard response["status"] != nil else {
                success!(response) // Success response
                return
            }
            guard Int(any: response["status"]) == 0 else {
                // status = 1 return data to controller
                success!(response) // Success response
                return
            }
            var newError:NSError = NSError(domain: Constants.kAppDisplayName, code: 404, userInfo:nil)
            var messageString = ""
            if let message = response["message"] as? String {
                let messageStr = (message)
                let regex = try! NSRegularExpression(pattern: "<.*?>", options: [.caseInsensitive])
                let range = NSMakeRange(0, messageStr.count)
                let htmlLessString :String = regex.stringByReplacingMatches(in: messageStr, options: [], range:range, withTemplate: "")
                newError = NSError(domain: Constants.kAppDisplayName, code: 404, userInfo: [NSLocalizedDescriptionKey : htmlLessString])
                messageString = htmlLessString
            }
            guard let failedHandler = failed else {
                if messageString != "" {
                    Global.showAlert(message:messageString)
                }
                return
            }
            failedHandler(newError, response)
            
        }
    }
}
import Alamofire
extension API {
    static var reachabilityManager:NetworkReachabilityManager?
    static var isHandleRechability = false
    static func monitorRechability() {
        isHandleRechability = true
        reachabilityManager = NetworkReachabilityManager()
        reachabilityManager?.startListening()
        reachabilityManager?.listener = { _ in
            if let isNetworkReachable = self.reachabilityManager?.isReachable,
                isNetworkReachable == true {
                //Internet Available
            } else {
                //Internet Not Available"
                Global.showAlert(message:ConstantsMessages.kConnectionFailed)
            }
        }
    }
}
