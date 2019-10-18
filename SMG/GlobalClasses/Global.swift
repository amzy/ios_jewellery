//
//  Global.swift
//  Fodder
//
//  Created by Himanshu Parashar on 20/07/15.
//  Copyright (c) 2015 syoninfomedia. All rights reserved.
//

import UIKit
import MBProgressHUD
import CoreLocation
import MapKit


public protocol TextInputDelegate : NSObjectProtocol {
    func didChangeText(textInput:Any, text:String, parent:Any?)
}
/// Just use //MARK: , //TODO: or //FIXME: instead of #pragma

@objc public protocol UICollectionViewButtonDelegate {
    /**
     Returns the button and cell reference
     */
    @objc optional func didSelect(_ sender: Any, ofCell cell: UICollectionViewCell)
    @objc optional func didSelect(_ sender: Any, ofHeader header: UICollectionReusableView)
}

@objc public protocol UITableViewButtonDelegate: class {
    /**
     Returns the button and cell reference
     */
    @objc optional func didSelect(_ sender: Any, ofCell cell: UITableViewCell)
    @objc optional func didSelect(_ sender: Any, ofHeader header: UITableViewHeaderFooterView)
}

public protocol CompletionDelegate: class {
    /**
     Returns completion with values
     */
    func didCompletion(with value: Any?)
}

@objc public protocol PageUpdateDelegate: class {
    
    @objc optional func didScrollTop()
    func didRefreshPage()
}

open class Global : NSObject {
    
    open class func stringifyJson(_ value: Any, prettyPrinted: Bool = false) -> NSString {
        let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : .prettyPrinted
        if JSONSerialization.isValidJSONObject(value) {
            if let data = try? JSONSerialization.data(withJSONObject: value, options: options) {
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string
                }
            }
        }
        return ""
    }
/*
    //MARK:- Sdd Background With Title
    open class func addBackground(_ title: String? = "No Results", font: CGFloat? = 14, color: UIColor? = UIColor.gray, table: UITableView, withWidth width: CGFloat? = Constants.kScreenWidth, withHeight height: CGFloat? = Constants.kScreenHeight) {
        
        table.viewWithTag(1)?.removeFromSuperview()
        
        let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width!, height: height!))
        emptyLabel.text = title //"Oops! you dont have any job to display here."
        emptyLabel.numberOfLines = 4
        emptyLabel.tag = 1
        emptyLabel.font = UIFont.systemFont(ofSize: 14)
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = color
        //emptyLabel.backgroundColor = UIColor.redColor()
        emptyLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //table.backgroundView = emptyLabel
        table.insertSubview(emptyLabel, belowSubview: table)
    }
  */
    /*************************************************************/
    //MARK:- Gradient Layer
    /*************************************************************/
    
    open class func linearGradient(with color : [CGColor], frame : CGRect, vertical:Bool = false, firstColorRatio:Double = 0.5) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = color
        
        if vertical {
            gradientLayer.startPoint = CGPoint(x:0.5, y:0.0)
            gradientLayer.endPoint = CGPoint(x:0.5, y:1.0)
        }else {
            gradientLayer.startPoint = CGPoint(x:0.0, y:0.8)
            gradientLayer.endPoint = CGPoint(x:0.8, y:1.0)
        }
        return gradientLayer
    }
    
    open class func angularGradient(with color : [CGColor], frame : CGRect) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = color
        gradientLayer.startPoint = CGPoint(x:0.7, y:-0.2)
        gradientLayer.endPoint = CGPoint(x:0.5, y:0.5)
        return gradientLayer
    }
    
    /***********************************************************************************************/
    //MARK:- Globle Alert
    /***********************************************************************************************/
    open class func showAlert(message: String, sender: UIViewController? = UIApplication.topViewController(), buttonTitle: String? = "OK") {
        
        let alert = UIAlertController(title: Constants.kAppDisplayName, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler:nil))
        sender?.present(alert, animated: true, completion: nil)
    }
    
    
    public class func showAlert(message: String, sender: UIViewController? = UIApplication.topViewController(), setTwoButton: Bool? = false , setFirstButtonTitle: String? = "OK" , setSecondButtonTitle: String? = "NO" , handler: ((UIAlertAction) -> Void)?) {
        
        let alert = UIAlertController(title: Constants.kAppDisplayName, message: message, preferredStyle: .alert)
        
        if (setTwoButton == true) {
            alert.addAction(UIAlertAction(title: setSecondButtonTitle, style: .default, handler:nil))
        }
        alert.addAction(UIAlertAction(title: setFirstButtonTitle, style: .default, handler:{ (action) in
            handler!(action)
        }))
        sender?.present(alert, animated: true, completion: nil)
    }
    
    /*************************************************************/
    //MARK:- show/hide Global ProgressHUD
    /*************************************************************/
    
    @discardableResult open class func showLoadingSpinner(_ message: String? = "", sender: UIView? = UIApplication.topViewController()?.view) -> MBProgressHUD {
        
        //let window:UIWindow = UIApplication.sharedApplication().windows.last!
        /*let senderView:UIView!
         if sender!.navigationController?.view != nil {
         senderView = sender!.navigationController?.view
         } else {
         senderView = sender!.view
         }*/
        let hud = MBProgressHUD.showAdded(to: sender!, animated: true)
        if(message!.length > 0) {
            hud.label.text = message!
        }
        //hud.labelFont = FontHelper.myRiadProRegularFontWithSize(18)
        //hud.dimBackground = true;
        return hud
    }
    
    open class func dismissLoadingSpinner(_ sender: UIView? = UIApplication.topViewController()?.view) -> Void {
        //let window:UIWindow = UIApplication.sharedApplication().windows.last!
        /*let senderView:UIView!
         if sender!.navigationController?.view != nil {
         senderView = sender!.navigationController?.view
         } else {
         senderView = sender!.view
         }*/
        MBProgressHUD.hideAllHUDs(for: sender!, animated: true)
    }
    
    
    /*************************************************************/
    //MARK:- Make a Phone call
    /*************************************************************/
    open class func makeCall(for number: String) {
        //number.digits
        guard let url = URL(string:"tel://\(number.trim())"), UIApplication.shared.canOpenURL(url) else {
            return
        }
        
        if #available(iOS 10.0, *){
            UIApplication.shared.open(url, completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    
    /*************************************************************/
    //MARK:- Open Url From String
    /*************************************************************/
    open class func openUrlFromString(_ urlString:String!) {
        
        if let targetURL = URL(string: "http://\(urlString)") {
            UIApplication.shared.openURL(targetURL)
        }
    }
    
    open class func openMap(for coordinates: CLLocationCoordinate2D) {
        
        let regionDistance:CLLocationDistance = 10000

        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.openInMaps(launchOptions: options)
    }

    open class func openGoogleMap(forDirection direction: Bool, of coordinates: CLLocationCoordinate2D) {
        
        let appScheme = URL(string: "comgooglemaps://")!
        let urlScheme = URL(string: "http://maps.google.com/")!
        var scheme: URL!
        var schemeOpenURL = ""
        
        if UIApplication.shared.canOpenURL(appScheme) {
            scheme = appScheme
        } else if UIApplication.shared.canOpenURL(urlScheme) {
            scheme = urlScheme
        } else {
            print("Can't use \(appScheme) on this device.")
            print("Can't use \(urlScheme) on this device.")
            return
        }
        
        if direction {
            schemeOpenURL = "\(scheme!)?saddr=&daddr=\(coordinates.latitude),\(coordinates.longitude)&directionsmode=driving"
        } else {
            schemeOpenURL = String(format: "\(scheme!)?q=%f,%f&center=%f,%f&zoom=14",coordinates.latitude, coordinates.longitude, coordinates.latitude, coordinates.longitude)
        }
        
        guard let directionsURL = URL(string: schemeOpenURL) else {
            print("Can't open \(schemeOpenURL) URL.")
            return
        }
        if #available(iOS 10.0, *){
            UIApplication.shared.open(directionsURL, completionHandler: nil)
        } else {
            UIApplication.shared.openURL(directionsURL)
        }
    }
    
    /*************************************************************/
    //MARK:- App Set UserDefaults Values
    /*************************************************************/
    open class func setAppUserDefaultsValues(_ value:AnyObject, key:String) {
        Constants.kUserDefaults.set(value, forKey: key)
        Constants.kUserDefaults.synchronize()
    }
    
    /*************************************************************/
    //MARK:- Get App UserDefaults Values
    /*************************************************************/
    open class func getAppUserDefaults(_ key:String) -> Any {
        Constants.kUserDefaults.synchronize()
        return Constants.kUserDefaults.object(forKey: key) 
    }
    
    /*************************************************************/
    //MARK:- Clear All UserDefaults Values
    /*************************************************************/
    open class func clearAllAppUserDefaults() {
        
        for key in Constants.kUserDefaults.dictionaryRepresentation().keys {
            if !(key == "iappToken" || key == "isShare" || key == "isShareEmail" || key == "pinButtonPressed" || key == HelperViews.Feed.rawValue) {
                Constants.kUserDefaults.removeObject(forKey: key)
            }
        }
        Constants.kUserDefaults.synchronize()
        //printDebug(APP_USER_DEFAULTS.dictionaryRepresentation().keys.array.count)
        //printDebug("ClearAllUserDefaults")
    }
    /*************************************************************/
    //MARK:- Print All User Defaults Values
    /*************************************************************/
    open class func printAppAllUserDefaults() {
        
        Constants.kUserDefaults.synchronize()
        for elem in Constants.kUserDefaults.dictionaryRepresentation() {
            printDebug("------------------------------")
            printDebug("User defaults value::- [\(elem)]")
        }
    }

    /*************************************************************/
    //MARK:- Dictionary Change NSNumber to String
    /*************************************************************/
    
    open class func stringifyDictionary(aDictionary param:NSDictionary) -> NSMutableDictionary {
        
        let rawData:NSDictionary = param
        let mutableRawData:NSMutableDictionary = NSMutableDictionary(dictionary: rawData)
        for key in rawData.allKeys {
            let value: AnyObject? = rawData.value(forKey: key as! String) as AnyObject?
            if (value!.isKind(of: NSNumber.self)) {
                let numberValue:NSNumber = rawData.value(forKey: key as! String) as! NSNumber
                mutableRawData.setValue(numberValue.stringValue, forKey: key as! String)
            }
        }
        return mutableRawData
    }
    
    /*************************************************************/
    //MARK:- Get Number Of Lines For String
    /*************************************************************/
    
    open class func numberOfLinesForString(_ label: UILabel) -> Int {
        var lineCount = 0;
        let textSize = CGSize(width: label.frame.size.width, height: CGFloat(Float.infinity));
        let rHeight = lroundf(Float(label.sizeThatFits(textSize).height))
        let charSize = lroundf(Float(label.font.lineHeight));
        lineCount = rHeight/charSize
        printDebug("No of lines \(lineCount)")
        
        return lineCount
    }
    
    open class func getTextHeightForString(_ string: String, font: UIFont, width: CGFloat, isHtmlText : Bool? = false) -> CGFloat {
        
        var height : CGFloat = 0.0
        var detailTitle : String = ""
        
        if string.length > 0 {
            detailTitle = string
        }
        
        if (detailTitle.length > 0 ) {
            if isHtmlText == true {
                
                let attrStr  = try! NSAttributedString(
                    data: "\(detailTitle)".data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                    options:[.documentType : NSAttributedString.DocumentType.html],
                    documentAttributes:nil)
                let constrainedSize: CGSize = CGSize(width: CGFloat(width), height: CGFloat.greatestFiniteMagnitude)
                let requiredHeight: CGRect = attrStr.boundingRect(with: constrainedSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
                height += requiredHeight.size.height
                
            } else {
                
                var myMutableString = NSMutableAttributedString()
                //Initialize the mutable string
                myMutableString = NSMutableAttributedString(
                    string: detailTitle,
                    attributes: [NSAttributedStringKey.font: font])
                let constrainedSize: CGSize = CGSize(width: CGFloat(width), height: CGFloat.greatestFiniteMagnitude)
                let requiredHeight: CGRect = myMutableString.boundingRect(with: constrainedSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
                height += requiredHeight.size.height
            }
            
        }
        return height
    }
    
    open class func setButtonEdgeInsets(_ button: UIButton) {
        
        // raise the image and push it right to center it
        button.imageEdgeInsets = UIEdgeInsetsMake(-((button.frame.size.height) - (button.imageView?.frame.size.height)! + 5.0 ), 0.0, 0.0,  -(button.titleLabel?.frame.size.width)!);
        
        // lower the text and push it left to center it
        button.titleEdgeInsets = UIEdgeInsetsMake(0.0, -(button.imageView?.frame.size.width)!, -((button.frame.size.height) - (button.titleLabel?.frame.size.height)!),0.0);
    }
}

//MARK:- Location Services
/************************************************************************************/

extension Global {
    
    public class func checkLocationServices() -> CLAuthorizationStatus {
        
        switch CLLocationManager.authorizationStatus() {
            
        case .notDetermined:
            triggerLocationServices() // User has not yet made a choice with regards to this application
        case .restricted, .denied:
            locationDisableAlert(UIApplication.topViewController()!)
        case .authorizedWhenInUse, .authorizedAlways:
            break
        }
        
        return CLLocationManager.authorizationStatus()
    }
    
    private class func triggerLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            if Constants.kLocationManager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization)) {
                Constants.kLocationManager.requestWhenInUseAuthorization()
            }
        }
    }
    
    public class func locationDisableAlert(_ sender: UIViewController? = UIApplication.topViewController()) {
        
        let message = "In order to use, go to your Settings\nApp > Privacy > Location Services"
        let alertController = UIAlertController(title: "Location is Disabled", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Not Now", style: .cancel, handler:nil))
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (action) in
            let SettingUrl = URL(string: UIApplicationOpenSettingsURLString)
            UIApplication.shared.openURL(SettingUrl!)
        }
        alertController.addAction(settingsAction)
        sender!.present(alertController, animated: true, completion: nil)
    }
}

//MARK:- Notification Disable Alert
/************************************************************************************/

extension Global {
    
    public class func checkNotificationServices() {
        // Elsewhere...
        
        if !UIDevice.isSimulator {
            // Do one thing
            if !UIApplication.shared.isRegisteredForRemoteNotifications {
                Global.notificationDisableAlert(UIApplication.topViewController()!)
            }
        }
    }
    fileprivate class func notificationDisableAlert(_ sender: UIViewController? = UIApplication.topViewController()) {
        
        let message = "Please unable services to use real time information of your request,\ngo to your Settings\nApp > Notification."
        let alertController = UIAlertController(title: "Notification services are disabled", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Not Now", style: .cancel, handler:nil))
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (action) in
            let SettingUrl = URL(string: UIApplicationOpenSettingsURLString)
            UIApplication.shared.openURL(SettingUrl!)
        }
        alertController.addAction(settingsAction)
        sender!.present(alertController, animated: true, completion: nil)
    }
    
    public class func setBorder(_ view:UIView, color:UIColor, width:CGFloat? = 1.0) {
        
        view.layer.borderWidth = width!
        view.layer.borderColor = color.cgColor
        view.layer.masksToBounds = true
    }
    
    public class func textfieldPaddingview(_ txtfield:UITextField, space:CGFloat) {
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: space, height: txtfield.frame.height))
        txtfield.leftView = paddingView
        txtfield.leftViewMode = UITextFieldViewMode.always
    }
}


//MARK:- Begin Refreshing Manually
/************************************************************************************/
extension UIRefreshControl {
    func beginRefreshingManually() {
        if let scrollView = superview as? UIScrollView , self.isRefreshing == false {
            scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y - self.frame.size.height), animated: true)
        }
        self.beginRefreshing()
    }
    func endRefreshingManually() {
        if let scrollView = superview as? UIScrollView {
            scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y + self.frame.size.height), animated: true)
        }
        self.endRefreshing()
    }
}

//MARK:- Coverter Methods.
extension Global {
    
    public class func convertToNSDictionary(dict:[String:Any]) -> NSMutableDictionary {
        return dict as! NSMutableDictionary
    }
    
    public class func convertToDictionary(dict:NSMutableDictionary) -> [String:Any] {
        return dict as! Dictionary<String,Any>
    }
    
    public class func isCallApi(limit:Int, CurrentCount:Int) -> Bool {
        if CurrentCount > 0 &&  CurrentCount < limit {
            return false
        } else {
            return true
        }
    }
}

