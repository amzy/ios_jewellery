//
//  FakeSplashVC.swift
//  GetTagg
//
//  Created by Amzad Khan on 24/08/17.
//  Copyright © 2017 Syon Infomedia. All rights reserved.
//

import UIKit
import UserNotifications

class FakeSplashVC: UIViewController {
    var notificationInfo: [AnyHashable: Any]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
     /*   if let user  = User.isUserLogin()  {
            Constants.kAppDelegate.user = user
            Constants.kAppDelegate.applicationLoggedInSuccessfully(notificationInfo, animated: true)
        }else {
            Constants.kAppDelegate.loadLoginNavigation(animated: false)
        }
    */
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadApplicationRouter()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadApplicationRouter(){
        /*
        UINavigationController.prepareBarAppearance(transparent: false)
        Constants.kAppDelegate.applicationLoggedInSuccessfully(notificationInfo, animated: true)
        */
        if let user  = User.isUserLogin()  {
            UINavigationController.prepareBarAppearance(transparent: false)
            Constants.kAppDelegate.user = user
            Constants.kAppDelegate.applicationLoggedInSuccessfully(notificationInfo, animated: true)
        }else {
            UINavigationController.prepareBarAppearance(transparent: false)
            //Constants.kAppDelegate.loadLoginNavigation(animated: false)
            Constants.kAppDelegate.applicationLoggedInSuccessfully(notificationInfo, animated: true)
        }

    }
    func loadDataFromServer() {
        
//        if #available(iOS 10.0, *) {
//            UNUserNotificationCenter.current().getDeliveredNotifications { (notifications) in
//                <#code#>
//            }
//        } else {
//            // Fallback on earlier versions
//        }
        
        DataStore.downloadJsonFileFromServer {
            UINavigationController.prepareBarAppearance()
            Constants.kAppDelegate.applicationLoggedInSuccessfully(Constants.kAppDelegate.notificationInfo, animated: true)
        }
    }
}
