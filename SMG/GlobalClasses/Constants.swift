//
//  Constants.swift
//  Fodder
//
//  Created by Himanshu Parashar on 14/04/16.
//  Copyright © 2016 SyonInfomedia. All rights reserved.
//

import UIKit
import CoreLocation


public struct Constants {
    static let kCalendar:Calendar           = Calendar.current
    static let kAppDelegate                 = UIApplication.shared.delegate as! AppDelegate
    static let kUserDefaults                = UserDefaults.standard
    static let kScreenWidth                 = UIScreen.main.bounds.width
    static let kScreenHeight                = UIScreen.main.bounds.height
    static let kAppDisplayName              = UIApplication.appName
    static let kAppVersion                  = UIApplication.shortVersionString
    static let kLocationManager             = CLLocationManager()
    
    static let kPerPage                     = 10
    static let kAvailableDict               = ["Yes", "No"]
    static let kGoogleAPIKey                = "AIzaSyDhUxXQBB2dcIpn5yWz-2pukgKxG-N21L8"
    static let kAPIVersion                  = "1.0"
    static let kAuthAPIKey                  = "GPMDc9Z3bq65QtnAEDRs"
    static let kDeviceType                  = "i"
    static let kStripePublisherKey          = "pk_test_UmfKJ3we5uxjTeev5RadAh2p"
    
    static let kHeaders = ["X-API-KEY": kAuthAPIKey,
                          "Device-Type": kDeviceType,
                          "App-Version": kAppVersion,
                          "Api-Version": kAPIVersion,
                          "Device-Id": kAppDelegate.deviceID ?? API.kSimulatorDeviceID]
                          //"lang": LanguageManager.getLanguage().rawValue]
                          //"Device-Id": kAppDelegate.deviceID]
    typealias CompletionHandler = (_ result: Any?, _ error: Error?) -> Void
    typealias VoidHandler = () -> Void
}

public struct AssetsImages {
    static let kLogoBig                     = UIImage(named: "logo_big")
    static let kLogoSmall                   = UIImage(named: "logo_small")
    static let kLogo                        = UIImage(named: "logo")
    static let kAppIconSmall                = UIImage(named: "AppIcon29x29")
    static let kBack                        = #imageLiteral(resourceName: "back")
    static let kDismiss                     = #imageLiteral(resourceName: "dismiss")
    static let kDefualtUser                 = UIImage(named: "small_user")
    static let kDefaultUpload               = UIImage(named: "defult_uplode")
    static let kNoImage                     = UIImage(named: "post_defult_icon")
    static let kImagePlaceHolder            = #imageLiteral(resourceName: "placeholderImage")
    static let kChecked                     = #imageLiteral(resourceName: "greenChecked")
    static let kUnChecked                   = #imageLiteral(resourceName: "unCheck")
}

public struct Identifiers {
    static let kDefaltCell                  = "Cell"
    static let kLeftMenuHeader              = "LeftMenuHeader"
    static let kLeftMenuCell                = "LeftMenuCell"
    static let kLogOutMenuCell              = "LogOutCell"
    static let kProfileHeader               = "ProfileHeader"
    static let kProfileCell                 = "ProfileCell"
    static let kLoadMoreCollectionCell      = "LoadMoreCollectionCell"
    static let kLoadMoreTableCell           = "LoadMoreTableViewCell"
    // MARK : - Home Cell Identifiers
}

// MARK: -
extension Notification.Name {
    
    /* ex. :
     - To Post Notification
     NotificationCenter.default.post(name: .kUpdateLeftMenu, object: nil)
     
     - To Observe Notification
     NotificationCenter.default.addObserver(self, selector: #selector(self.tableView.reloadData), name: .kUpdateLeftMenu, object: nil)
     
     */
        // Definition:
    public static let kUpdateLeftMenu = Notification.Name("com.amzad.khan.UpdateLeftMenu")
    public static let kDidUpdateCart  = Notification.Name("com.amzad.khan.DidUpdateCart")
     public static let kDidLoginUser  = Notification.Name("com.amzad.khan.DidLoginUser")
    
    
}

public struct NotificationKey {
    static let kNewOrder = "org.app.notification.key.newOrder"
}

public struct ConstantsErrors {
    static let kNoInternetConnection = NSError(domain: Constants.kAppDisplayName, code: NSURLErrorNotConnectedToInternet, userInfo: [NSLocalizedDescriptionKey: ConstantsMessages.kConnectionFailed])
    static let kCancelledFacebook = NSError(domain: Constants.kAppDisplayName, code: 1000000, userInfo: [NSLocalizedDescriptionKey : "You have cancelled logging in with Facebook."])
    static let kDeclinedFacebookPermissions = NSError(domain: Constants.kAppDisplayName, code: 1000001, userInfo: [NSLocalizedDescriptionKey : "You  Declined Facebook Permissions."])
    static let kSomethingWrong = NSError(domain: Constants.kAppDisplayName, code: 1000002, userInfo: [NSLocalizedDescriptionKey : "Something went wrong\nPlease try again soon!."])
}

public struct ConstantsMessages {
    static let kConnectionFailed    = "looks like there is some problem in your internet connection,\nPlease try again after some time."
    static let kNetworkFailure      = "looks like there is some network error,\nPlease try after some time."
    static let kSomethingWrong      = "Something went wrong\nPlease try again soon!"
}

public enum UIState {
    case loading
    case success
    case failure
}

enum HelperViews: String {
    case Feed = "FeedHelperView"
    func getViewForController(_ controller: UIViewController) -> UIView {
        return UINib(nibName: self.rawValue, bundle: nil).instantiate(withOwner: controller, options: nil)[0] as! UIView
    }
}
