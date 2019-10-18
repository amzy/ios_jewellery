//
//  AppStoryboard.swift
//  SMG
//
//  Created by Amzad Khan on 29/08/18.
//  Copyright © 2018 Amzad Khan. All rights reserved.
//

import Foundation
import UIKit
enum AppStoryboard : String {
    
    case main, authentication, home, search

    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue.capitalizingFirstLetter(), bundle: Bundle.main)
    }
    
    func viewController<T : UIViewController>(viewControllerClass : T.Type) -> T {
        
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: storyboardID) as! T
    }
    
    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
}
extension UIViewController {
    
    class var storyboardID : String {
        return "\(self)"
    }
    
    static func instantiate(fromAppStoryboard appStoryboard : AppStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
}

