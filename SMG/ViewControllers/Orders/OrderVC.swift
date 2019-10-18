//
//  OrderVC.swift
//  SMG
//
//  Created by Amzad Khan on 12/09/18.
//  Copyright © 2018 Amzad Khan. All rights reserved.
//



import UIKit
import XLPagerTabStrip

class OrderVC: ButtonBarPagerTabStripViewController {
    
    let child_1 = MyOrderVC.instantiate(fromAppStoryboard: .home)
    let child_2 = MyCustomOrderVC.instantiate(fromAppStoryboard: .home)
    
    
    override func viewDidLoad() {
        
        self.configurePageController()
        super.viewDidLoad()
        self.title = "ORDERS"
        self.configureTopBar(left: [.leftMenu], right: [.call])
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
     override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as? ButtonBarViewCell
     
     cell?.label.superview?.backgroundColor =  #colorLiteral(red: 0.3333333333, green: 0.7529411765, blue: 0.9215686275, alpha: 1)
     cell?.label.superview?.cornerRadius = 12
     
     return cell!
     }
     */
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            //Condition if payment done call super did select else return from here to restrict tap on 3 Step
        }else {
            super.collectionView(collectionView, didSelectItemAt: indexPath)
        }
    }
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return [child_1, child_2]
    }
}

extension OrderVC {
    
    func configurePageController()  {

        settings.style.buttonBarBackgroundColor     = #colorLiteral(red: 0.9144535661, green: 0.2558653057, blue: 0.09014534205, alpha: 1)
        settings.style.buttonBarItemBackgroundColor =  #colorLiteral(red: 0.9144535661, green: 0.2558653057, blue: 0.09014534205, alpha: 1)
        settings.style.selectedBarBackgroundColor   = .white
        settings.style.selectedBarHeight            = 4.0
        settings.style.buttonBarMinimumLineSpacing  = 0 // top and bottom spacing8
        settings.style.buttonBarItemTitleColor      = .white
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset    = 0 //Left 8
        settings.style.buttonBarRightContentInset   = 0 // Right 8
        settings.style.buttonBarItemFont  = UIFont.boldSystemFont(ofSize: 12)
        
    }
}
