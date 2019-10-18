//
//  AVPlayerViewController.swift
//
//  Created by Amzad Khan on 26/01/18.
//  Copyright © 2018 Amzad Khan. All rights reserved.
//

import Foundation
import AVKit

protocol Pageable {
    var pageIndex: Int {get}
    var mediaView:UIView? {get}
}

extension Notification.Name {
    static let kAVPlayerViewControllerDismissingNotification = Notification.Name.init("dismissing")
}
extension AVPlayerViewController {
    private struct AssociatedKey {
        static var page  = "mz_page"
    }
    var page: String {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.page) as? String ?? "0"
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKey.page, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
// create an extension of AVPlayerViewController
extension AVPlayerViewController : Pageable {
    var pageIndex: Int  {
        return Int(self.page) ?? 0
    }
    var mediaView:UIView? {
        return self.view
    }
    // override 'viewWillDisappear'
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // now, check that this ViewController is dismissing
        if self.isBeingDismissed == false {
            return
        }
        
        // and then , post a simple notification and observe & handle it, where & when you need to.....
        NotificationCenter.default.post(name: .kAVPlayerViewControllerDismissingNotification, object: nil)
    }
}
