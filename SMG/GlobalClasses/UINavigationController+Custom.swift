//
//  UINavigationController+Custom.swift
//  GetTagg
//
//  Created by Amzad Khan on 24/08/17.
//  Copyright © 2017 Syon Infomedia. All rights reserved.
//

import Foundation
import UIKit

public extension UINavigationController {
    
    //MARK:- Setup Navigation bar appearance
    static func prepareBarAppearance(transparent:Bool = false) {
        
        UIApplication.shared.statusBarStyle = .lightContent
        UINavigationBar.appearance().tintColor = UIColor.white
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18),
            NSAttributedStringKey.foregroundColor : UIColor.white
        ]
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().shadowImage =  UIImage()
        
        if transparent {
            UINavigationBar.appearance().barTintColor = UIColor.clear
            UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        }else {
            UINavigationBar.appearance().barTintColor =  #colorLiteral(red: 0.9144535661, green: 0.2558653057, blue: 0.09014534205, alpha: 1)
            UINavigationBar.appearance().tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
    
    static func prepareTabBarAppearance() {
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        let barButtonItem = UIBarButtonItem.appearance()
        let barButtonAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18),
                                   NSAttributedStringKey.foregroundColor: UIColor.white]
        barButtonItem.setTitleTextAttributes(barButtonAttributes, for: .normal)
        
        UITabBar.appearance().barTintColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
        UITabBar.appearance().tintColor = #colorLiteral(red: 0.9144535661, green: 0.2558653057, blue: 0.09014534205, alpha: 1)
        
        let appearance = UITabBarItem.appearance()
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 11),
                          NSAttributedStringKey.foregroundColor: UIColor.black]
        
        let attributesSelected = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 11),
                                  NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.9144535661, green: 0.2558653057, blue: 0.09014534205, alpha: 1)] as [NSAttributedStringKey : Any]
        
        appearance.setTitleTextAttributes(attributes, for: .normal)
        appearance.setTitleTextAttributes(attributesSelected, for: .selected)
        
    }
}

