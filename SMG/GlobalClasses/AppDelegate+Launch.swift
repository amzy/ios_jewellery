//
//  AppDelegate+Launch.swift
//  GetTagg
//
//  Created by Amzad Khan on 24/08/17.
//  Copyright © 2017 Syon Infomedia. All rights reserved.
//

import Foundation
import SlideMenuControllerSwift
import UIKit

extension AppDelegate {
    
    //MARK:- Logout User
    func logout(for id: String? = nil) {
        if let userID = id{
            //loadApiForLogout()
        }else {
            self.clearAppOnLogout()
        }
    }
    
    //MARK:- clear All App Data
    fileprivate func clearAppOnLogout(showAlert alert: Bool? = false) {
        self.sideMenu = nil
        Global.clearAllAppUserDefaults()
        self.user = nil
        LocationTracker.shared.stopUpdating()
        self.loadLoginNavigation()
    }
}

extension AppDelegate {
    
    func applicationLoggedInSuccessfully(_ info: [AnyHashable: Any]?, animated: Bool = true) {
        self.apiCallingNumber()
        self.apiLoadUserData()
        let vc = HomeVC.instantiate(fromAppStoryboard: .home)
        let leftVC =  LeftNavigationVC(nibName:"LeftViewController", bundle:Bundle.main)
        let nvc = UINavigationController(rootViewController: vc)
        //leftVC.home = nvc
        SlideMenuOptions.hideStatusBar = false
        SlideMenuOptions.panFromBezel = false
   
        self.sideMenu = SlideMenuController(mainViewController: nvc, leftMenuViewController: leftVC)
        self.sideMenu?.changeLeftViewWidth(300)
        
        let duration = animated ? 0.5 : 0.0
        SlideMenuOptions.contentViewScale = 1.0
        var currentLodedVC = self.window?.rootViewController
        
        UIView.transition(with: self.window!, duration: duration, options: UIViewAnimationOptions.transitionCrossDissolve, animations: { () -> Void in
            
            self.window?.rootViewController = self.sideMenu
            self.window?.backgroundColor = UIColor.white
            self.window?.makeKeyAndVisible()
             Global.dismissLoadingSpinner()
            
        }) { (finished) -> Void in
            if currentLodedVC != nil {
                currentLodedVC?.view.removeFromSuperview()
                currentLodedVC = nil
            }
            if (info) != nil {
                self.perform(#selector(self.loadNotification), with: nil, afterDelay: 0.5)
            }
        }
    }
    
    @objc func loadNotification() {
        self.appRemoteNotificationHandelar(.inactive, notificationInfo: Constants.kAppDelegate.notificationInfo!)
    }
    
    func loadLoginNavigation(animated: Bool = true) {
        //UINavigationController.prepareBarAppearance(transparent: true)
        //UINavigationController.prepareBarAppearance(transparent: true)
        let loginNavigation  = AppStoryboard.authentication.initialViewController()
        
        let duration = animated ? 0.5 : 0.0
        var currentLodedVC = self.window?.rootViewController
        
        UIView.transition(with: self.window!, duration: duration, options: UIViewAnimationOptions.transitionCrossDissolve, animations: { () -> Void in
    
            self.window?.rootViewController = loginNavigation
            self.window?.backgroundColor    = UIColor.white
            
            self.window?.makeKeyAndVisible()
            Global.dismissLoadingSpinner()
            
        }) { (finished) -> Void in
            if currentLodedVC != nil {
                currentLodedVC?.view.removeFromSuperview()
                currentLodedVC = nil
            }
        }
    }
}

//MARK:- LOGOUT USER API.
extension AppDelegate {
    
   /* func loadApiForLogout () {
        
        if User.isUserLogin() != nil {
            let parameters = ["Device-Id": Constants.kAppDelegate.deviceID == "" ? API.kSimulatorDeviceID : Constants.kAppDelegate.deviceID ??  API.kSimulatorDeviceID] as [String : Any]
            if let request = API.logout.request(with: parameters) {
                Global.showLoadingSpinner("Please wait..")
                request.responseJSON { response in
                    Global.dismissLoadingSpinner()
                    API.logout.validatedResponse(response, success: { (jsonObject) in
                        self.clearAppOnLogout(showAlert: false)
                    }, failed: nil)
                }
            }
        }
    }*/
    //callingNumber
    func apiLoadUserData () {
        if User.isUserLogin() != nil {
            if let request = API.getProfile.request(method: .get, with: [:]) {
                request.responseJSON { response in
                    API.getProfile.validatedResponse(response, success: { (jsonObject) in
                        guard let data = jsonObject?["data"] as? [String:Any] else {return}
                        let user = User.parse(json: data)
                        user.accessToken = Constants.kAppDelegate.user.accessToken ?? ""
                        user.firmAddress = Constants.kAppDelegate.user.firmAddress
                        user.avatar = Constants.kAppDelegate.user.avatar
                        user.saveUser()
                        Constants.kAppDelegate.user = user
                        NotificationCenter.default.post(name: .kDidUpdateCart, object: nil)
                        
                    }, failed: {(error, json) in
                        
                    })
                }
            }
        }
    }
    func apiCallingNumber () {
        if let request = API.callingNumber.request(method: .post, with: [:]) {
            request.responseJSON { response in
                API.getProfile.validatedResponse(response, success: { (jsonObject) in
                    guard let code = jsonObject?["country_code"] as? String, let mobile =  jsonObject?["phone_number"] as? String else {return}
                    let callingNumber = "\(code)\(mobile)"
                    UserDefaults.standard.set(callingNumber, forKey: "smgPhone")
                    UserDefaults.standard.synchronize()
                    
                }, failed: {(error, json) in
                    
                })
            }
        }
    }
}



