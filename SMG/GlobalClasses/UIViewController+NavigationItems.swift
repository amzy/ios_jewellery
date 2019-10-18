//
//  UIViewController+NavigationItems.swift
//  Dalal
//
//  Created by Amzad Khan on 3/5/18.
//  Copyright © 2018 Amzad Khan. All rights reserved.
//

import UIKit
//import SlideMenuControllerSwift
private enum ActionType: Int {
    case popViewController
    case popToRootViewController
    case dismissViewController
}

public enum NavigationOptions: Equatable {
    
    case back
    case backToRoot
    case dismiss
    case leftMenu
    case logo
    case title
    case search
    case cart
    case notification
    case call
    case filter
    case login
}

public extension UIViewController {
    
    func setNavigationBarLogo() {
        let logo = #imageLiteral(resourceName: "logo")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit
        imageView.frame =  CGRect(x: 0, y: 0, width: 25, height: 20)
        self.navigationItem.titleView = imageView
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor   = UIColor.yellow
        self.setNavigationBarStyle(forHidden: false)
    }
    var userInterfaceLayoutDirection: UIUserInterfaceLayoutDirection
    {
        if #available(iOS 9.0, *) {
            return UIView.userInterfaceLayoutDirection(for: self.view.semanticContentAttribute)
        } else {
            return UIApplication.shared.userInterfaceLayoutDirection
        }
    }
    //MARK:- Navigation bar appearance
    func setNavigationBarStyle(forHidden hidden: Bool? = false) {
        self.navigationController?.isNavigationBarHidden = hidden!
        self.navigationController?.navigationBar.isHidden = hidden!
    }
    
    func configureTopBar(left:[NavigationOptions], right:[NavigationOptions]? = nil) {
        
        var leftItems = [UIBarButtonItem]()
        for option in left {
            switch option {
            case .logo:
                leftItems.append(logoButton())
            case .leftMenu:
                leftItems.append(leftBarButton())
            case .back:
                leftItems.append(leftBarItem(for: ActionType.popViewController))
            case .backToRoot:
                leftItems.append(leftBarItem(for: ActionType.popToRootViewController))
            case .dismiss:
                leftItems.append(leftBarItem(for: ActionType.dismissViewController))
            case .login:
                leftItems.append(loginButton())
                
            default:
                break
            }
        }
        
        self.navigationItem.setLeftBarButtonItems(leftItems, animated: false)
        guard let rightOptions = right else { return }
        
        var rightItems = [UIBarButtonItem]()
        
        for option in rightOptions.reversed() {
            switch option {
            case .logo:
                leftItems.append(logoButton())
            case .cart :
                let btn = cartButton()
                self.cartBtn = btn
                rightItems.append(btn)
            case .search:
                rightItems.append(searchButton())
            case .notification:
                let btn = notificationButton()
                self.notificationBtn = btn
                rightItems.append(btn)
            case .call:
                rightItems.append(callButton())
            case .filter:
                rightItems.append(filterButton())
                
            default:
                break
            }
        }
        self.navigationItem.setRightBarButtonItems(rightItems, animated: false)
    }
    private func leftBarButton() -> UIBarButtonItem {
        /*
         self.addLeftBarButtonWithImage(#imageLiteral(resourceName: "menu"))
         //self.slideMenuController()?.removeLeftGestures()
         self.slideMenuController()?.addLeftGestures()
         */
        // self.addLeftBarButtonWithImage(#imageLiteral(resourceName: "menu"))
        let leftBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "navigation-icon"), style: .plain, target: self, action: #selector(slideMenuController()?.toggleLeft))
        
        //let leftBarButton = UIBarButtonItem(image: AssetsImages.kBack, style: .plain, target: self, action: #selector(self.didTapMenu))
        //  self.slideMenuController()?.removeRightGestures()
        return User.isUserLogin() != nil ? leftBarButton : UIBarButtonItem(customView: UILabel())
    }
    @objc func didTapMenu() {
        //        if let leftVC = slideMenuController()?.leftViewController as? LeftNavigationVC {
        //            leftVC.changeController(to: .home)
        //        }
        //        if let leftVC = slideMenuController()?.rightViewController as? LeftNavigationVC {
        //            leftVC.changeController(to: .home)
        //        }
    }
    
    func setLogoOnNavigation() {
        
        let logo = UIImageView(image: #imageLiteral(resourceName: "logo"))
        logo.contentMode = UIViewContentMode.scaleAspectFit
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 130, height: 30))
        logo.frame = titleView.bounds
        
        titleView.center = CGPoint(x: (self.navigationController?.navigationBar.width)! / 2.0, y: (self.navigationController?.navigationBar.height)! / 2.0)
        
        titleView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        
        titleView.addSubview(logo)
        self.navigationItem.titleView = titleView
    }
    
    private func leftBarItem(for type: ActionType) -> UIBarButtonItem {
        
        var leftButton = backButton()
        
        switch type {
        case .popViewController:
            leftButton.addTarget(self.navigationController, action: #selector(self.navigationController?.popViewController(animated:)), for : .touchUpInside)
            
        case .popToRootViewController:
            leftButton.addTarget(self.navigationController, action: #selector(self.navigationController?.popToRootViewController(animated:)), for : .touchUpInside)
            
        case .dismissViewController:
            leftButton = dismissButton()
            leftButton.addTarget(self, action: #selector(self.didTapDismiss(_:)), for: .touchUpInside)
        }
        
        return UIBarButtonItem(customView: leftButton)
    }
    //    func setLeftMenuItem() {
    //        //menutootle-icon
    //
    //        if self.userInterfaceLayoutDirection == .leftToRight {
    //            let leftButton: UIBarButtonItem = UIBarButtonItem(image: AssetsImages.kLeftMenu, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.toggleLeft))
    //            navigationItem.leftBarButtonItem = leftButton
    //            self.slideMenuController()?.addLeftGestures()
    //        } else {
    //
    //            let leftButton: UIBarButtonItem = UIBarButtonItem(image: AssetsImages.kLeftMenu, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.toggleRight))
    //            navigationItem.leftBarButtonItem = leftButton
    //            self.slideMenuController()?.addRightGestures()
    //        }
    //    }
    
    func setTransparentNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage =  UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func removeLeftNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = nil
        //self.slideMenuController()?.removeLeftGestures()
    }
    
    private func backButton(with image: UIImage? = AssetsImages.kBack) -> UIButton {
        
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 25, height: 20)
        backButton.tintColor = UIColor.white
        backButton.setImage(image, for: .normal)
        return backButton
    }
    
    private func dismissButton(with image: UIImage? = AssetsImages.kDismiss) -> UIButton {
        
        let dismissButton = UIButton(type: .custom)
        dismissButton.frame = CGRect(x: 0, y: 0, width: 25, height: 20)
        dismissButton.tintColor = UIColor.white
        dismissButton.setImage(image, for: .normal)
        return dismissButton
    }
    private func mapButton() -> UIBarButtonItem {
        
        let mapButton = UIButton(type: .custom)
        mapButton.frame = CGRect(x: 0, y: 0, width: 22, height: 17)
        mapButton.tintColor = UIColor.white
        //mapButton.setImage(AssetsImages.kMap, for: .normal)
        mapButton.addTarget(self, action: #selector(self.didTapMapItem(_:)), for: .touchUpInside)
        
        return UIBarButtonItem(customView: mapButton)
    }
    
    
    
    private func logoButton() -> UIBarButtonItem {
        let logo = #imageLiteral(resourceName: "logo")
        let logoButton = UIButton(type: .custom)
        let ratio = logo.size.width/logo.size.height
        logoButton.frame = CGRect(x: 0, y: 0, width: logo.size.width, height: (ratio * logo.size.height) )
        logoButton.tintColor = UIColor.white
        logoButton.setImage(logo, for: .normal)
        return UIBarButtonItem(customView: logoButton)
    }
    
    private func cartButton() -> UIBarButtonItem {
        
        let infoButton = UIButton(type: .custom)
        infoButton.frame = CGRect(x: 0, y: 0, width: 24, height: 22)
        infoButton.setImage(#imageLiteral(resourceName: "cart"), for: .normal)
        infoButton.addTarget(self, action: #selector(self.didTapCart(_:)), for: .touchUpInside)
        let btn = UIBarButtonItem(customView: infoButton)
        return btn
    }
    private func searchButton() -> UIBarButtonItem {
        let infoButton = UIButton(type: .custom)
        infoButton.frame = CGRect(x: 0, y: 0, width: 24, height: 22)
        infoButton.setImage(#imageLiteral(resourceName: "magnifying-glass"), for: .normal)
        infoButton.tintColor = UIColor.white
        infoButton.addTarget(self, action: #selector(self.didTapSearch(_:)), for: .touchUpInside)
        
        return UIBarButtonItem(customView: infoButton)
    }
    //
    private func callButton() -> UIBarButtonItem {
        let infoButton = UIButton(type: .custom)
        infoButton.frame = CGRect(x: 0, y: 0, width: 24, height: 22)
        infoButton.setImage(#imageLiteral(resourceName: "ic_local_phone.png"), for: .normal)
        infoButton.tintColor = UIColor.white
        infoButton.addTarget(self, action: #selector(self.didTapCall(_:)), for: .touchUpInside)
        
        return UIBarButtonItem(customView: infoButton)
    }
    
    private func filterButton() -> UIBarButtonItem {
        
        let infoButton = UIButton(type: .custom)
        infoButton.frame = CGRect(x: 0, y: 0, width: 24, height: 22)
        infoButton.setImage(#imageLiteral(resourceName: "ic_filter_list.png"), for: .normal)
        infoButton.addTarget(self, action: #selector(self.didTapFiler(_:)), for: .touchUpInside)
        
        return UIBarButtonItem(customView: infoButton)
    }
    
    func viewSpace() -> UIBarButtonItem {
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 11, height: 19))
        return UIBarButtonItem(customView: leftView)
    }
    
    func fixedSpace(width: CGFloat? = 18) -> UIBarButtonItem {
        
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpace.width = width! //18.0 // Set 26px of fixed space between the two UIBarButtonItems
        
        return fixedSpace
    }
    private func fixedSpaceButton() -> UIBarButtonItem {
        
        /// set the second navigation More button's
        let moreButton = UIButton(type: .custom)
        moreButton.frame = CGRect(x: 0, y: 0, width: 50, height: 52)
        return UIBarButtonItem(customView: moreButton)
    }
    
    private func loginButton() -> UIBarButtonItem {
        
        let mapButton = UIButton(type: .custom)
        mapButton.frame = CGRect(x: 0, y: 0, width: 50, height: 17)
        mapButton.tintColor = UIColor.white
        mapButton.setTitle("Login", for: .normal)
        //mapButton.setImage(AssetsImages.kMap, for: .normal)
        mapButton.addTarget(self, action: #selector(self.didTapLogin(_:)), for: .touchUpInside)
        return UIBarButtonItem(customView: mapButton)
    }
    // MARK: Actions
    @objc func didTapLogin(_ sender: UIButton) {
        let vc = AppStoryboard.authentication.initialViewController() as! UINavigationController
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true) {
            
        }
    }
    
    // MARK: Actions
    @objc func didTapDismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapCall(_ sender: UIButton) {
        guard let phone = UserDefaults.standard.value(forKey: "smgPhone") as? String else {return}
        self.dialNumber(number: phone)
    }
    @objc func didTapFiler(_ sender: UIButton) {
        let vc =  FilterVC.instantiate(fromAppStoryboard: .home)
        vc.hander = { (responseData, error) in
            guard let rangeData = responseData as? [String:Any] else {return}
            guard let min = rangeData["min"], let max = rangeData["max"] else {return}
            self.dismiss(animated: true, completion: nil)
            let vc = SearchVC.instantiate(fromAppStoryboard: .search)
            vc.type = .range
            vc.minSize = "\(min)"
            vc.maxSize = "\(max)"
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(UINavigationController(rootViewController:vc), animated: true) {
            }
        }
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
    }
    
    func didTapBack(_ sender: UIButton) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    func didTapBackToRoot(_ sender: UIButton) {
        let _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func didTapMapItem(_ sender: UIButton) {
        
    }
    
    @objc func didTapCart(_ sender: UIButton) {
        guard User.isUserLogin() != nil else {return}
        let vc =  CartVC.instantiate(fromAppStoryboard: .home)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(UINavigationController(rootViewController:vc), animated: true) {
            
        }
    }
    @objc func didTapSearch(_ sender: UIButton) {
        let vc = SearchVC.instantiate(fromAppStoryboard: .search)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(UINavigationController(rootViewController:vc), animated: true) {
            vc.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    func setNavigation(title: String) {
        
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.frame = self.navigationController!.navigationBar.frame
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        let attributes: NSDictionary = [
            // NSFontAttributeName: UIFont.init(.gothamBook, size: 16),
            NSAttributedStringKey.kern: CGFloat(2.0)
        ]
        
        let attributedTitle = NSAttributedString(string: title, attributes:attributes as? [NSAttributedStringKey : AnyObject])
        
        titleLabel.attributedText = attributedTitle
        self.navigationItem.titleView = titleLabel
    }
    
    func setAttributedTitle(string: NSAttributedString) {
        let titleLabel = UILabel()//frame: CGRect(x: 0, y: 0, width: 200, height: 40)
        titleLabel.frame = self.navigationController!.navigationBar.frame
        titleLabel.textAlignment = .center
        
        titleLabel.attributedText = string
        //titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
    }
    
    func getAttributedString(text: String, string1: String, string2: String) -> NSAttributedString {
        
        let attributes: NSDictionary = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18),
            NSAttributedStringKey.foregroundColor: UIColor.green,
            NSAttributedStringKey.kern:CGFloat(0.5)]
        let range1 = (text as NSString).range(of: string1)
        let range2 = (text as NSString).range(of: string2)
        let attributedTitle = NSMutableAttributedString(string: text, attributes: attributes as? [NSAttributedStringKey : AnyObject])
        attributedTitle.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white , range: range1)
        attributedTitle.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white , range: range2)
        return attributedTitle
    }
}

extension UIViewController  {
    
    func applyGradientBackground() {
        self.view.backgroundColor = UIColor.white
        self.view.applyGradientBackground(colors: [ #colorLiteral(red: 0.1019607843, green: 0.8470588235, blue: 0.5960784314, alpha: 1), #colorLiteral(red: 0.06666666667, green: 0.6392156863, blue: 0.8705882353, alpha: 1)], locations: [0.0, 0.50])
    }
}

extension UIView {
    
    func applyGradientBackground(colors:[UIColor], locations:[NSNumber]) {
        
        let gradientLayer   = CAGradientLayer()
        gradientLayer.frame = self.bounds
        
        let cgColors  = colors.map { (color) -> CGColor in
            return color.cgColor
        }
        gradientLayer.colors        = cgColors //[color1, color2, color3, color4]
        gradientLayer.locations     = locations //[0.0, 0.25, 0.75, 1.0]
        gradientLayer.startPoint    = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint      = CGPoint(x: 0, y: 1)
        self.layer.insertSublayer(gradientLayer, at: 0)
        self.layer.masksToBounds    = true
        gradientLayer.masksToBounds = true
        self.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "grediant_bg").stretchableImage(withLeftCapWidth: 0, topCapHeight: 0))
    }
}

extension UIViewController {
    private struct AssociatedKey {
        static var cart  = "mz_cart"
        static var notification  = "mz_notification"
    }
    var cartBtn:UIBarButtonItem! {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.cart) as? UIBarButtonItem
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKey.cart, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    var notificationBtn:UIBarButtonItem! {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.notification) as? UIBarButtonItem
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKey.notification, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

