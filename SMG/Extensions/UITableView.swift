//
//  Created by Amzad Khan on 11/08/15.
//  Copyright (c) 2015 Syon Infomedia. All rights reserved.
//


import UIKit

public extension UITableView {
    public func registerCellClass(_ cellClass: AnyClass) {
        let identifier = String.className(cellClass)
        self.register(cellClass, forCellReuseIdentifier: identifier)
    }
    
    public func registerCellNib(_ cellClass: AnyClass) {
        let identifier = String.className(cellClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forCellReuseIdentifier: identifier)
    }
    
    public func registerHeaderFooterViewClass(_ viewClass: AnyClass) {
        let identifier = String.className(viewClass)
        self.register(viewClass, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    public func registerHeaderFooterViewNib(_ viewClass: AnyClass) {
        let identifier = String.className(viewClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    /**
     Displays or hides a label in the background of the table view.
     
     - parameter message:    The String message to display. The message is hidden
     if `nil` is provided.
     */
    public func setBackgroundMessage(_ message: String?, color: UIColor? = UIColor.lightGray) {
        if let message = message {
            // Display a message when the table is empty
            let messageLabel = UILabel()
            messageLabel.text = message
            //messageLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
            messageLabel.font = UIFont.systemFont(ofSize: 14)
            messageLabel.textColor = color
            messageLabel.textAlignment = .center
            messageLabel.numberOfLines = 0
            messageLabel.sizeToFit()
            self.bgForNil = messageLabel
            self.backgroundView = messageLabel
            self.separatorStyle = .none
        } else {
            self.backgroundView = nil
            self.separatorStyle = .singleLine
        }
    }
    
    /*func scrollToSelectedRow() {
     let selectedRows = self.indexPathsForSelectedRows
     if let selectedRow = selectedRows?[0] as? NSIndexPath {
     self.scrollToRowAtIndexPath(selectedRow, atScrollPosition: .Middle, animated: true)
     }
     }*/
    
    func scrollToFirstRow(_ animated: Bool? = false) {
        
        let delay = 0.1 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            
            let numberOfRows = self.numberOfRows(inSection: 0)
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: 0, section: 0)
                self.scrollToRow(at: indexPath, at: .top, animated: animated!)
            }
        })
    }

    func scrollToHeader() {
        self.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
    }
    
    func scrollToTop(_ animated: Bool? = false) {
        DispatchQueue.main.async(execute: {
            self.setContentOffset(CGPoint.zero, animated: animated!)
        })
    }
    
    func scrollToBottom(_ animated: Bool = false) {
        
        let delay = 0.1 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            
            let numberOfSections = self.numberOfSections
            let numberOfRows = self.numberOfRows(inSection: numberOfSections-1)
            
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                self.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: animated)
            }
        })
    }
}

public extension UITableViewCell {
    
    public func removeMargins() {
        
        if self.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            self.separatorInset = UIEdgeInsets.zero
        }
        
        if self.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins)) {
            self.preservesSuperviewLayoutMargins = false
        }
        
        if self.responds(to: #selector(setter: UIView.layoutMargins)) {
            self.layoutMargins = UIEdgeInsets.zero
        }
    }
}

public extension UICollectionView {
    
    public func setBackgroundMessage(_ message: String?) {
        if let message = message {
            // Display a message when the table is empty
            let messageLabel = UILabel()
            messageLabel.text = message
            //messageLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
            messageLabel.font = UIFont.systemFont(ofSize: 14)
            messageLabel.textColor = UIColor.gray
            messageLabel.textAlignment = .center
            messageLabel.numberOfLines = 0
            messageLabel.sizeToFit()
            self.bgForNil = messageLabel
            self.backgroundView = messageLabel
        } else {
            self.backgroundView = nil
        }
    }
    
    func scrollToTop(_ animated: Bool? = false) {
        self.setContentOffset(CGPoint.zero, animated: animated!)
    }
}

public extension UITableView {
    
    private struct AssociatedKey {
        static var bgOnNil  = "mz_backgroundviewOnNil"
    }
    var bgForNil: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.bgOnNil) as? UIView
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKey.bgOnNil, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    func setBackgroundForNil(nibName: String) {
        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let nView  = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        nView.translatesAutoresizingMaskIntoConstraints = false
        self.bgForNil = nView
    }
    func setBackgroundForNil(message: String) {
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.font = UIFont.systemFont(ofSize: 14)
        messageLabel.textColor = UIColor.gray
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.sizeToFit()
        self.bgForNil = messageLabel
    }
    
    fileprivate func defaultBackgroundView() -> UIView {
        let messageLabel = UILabel()
        messageLabel.text = "Item not available!"
        messageLabel.font = UIFont.systemFont(ofSize: 14)
        messageLabel.textColor = UIColor.gray
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.sizeToFit()
        return messageLabel
    }
    
    var isBackgroundHidden:Bool {
        get {
            guard self.backgroundView != nil else { return true }
            return false
        }
        set(newValue) {
            if newValue == true {
                self.backgroundView = nil
            }else {
                if let bgView = self.bgForNil { self.backgroundView = bgView }
                else {
                    self.bgForNil = self.defaultBackgroundView()
                    self.backgroundView = self.bgForNil
                }
            }
        }
    }
}

public extension UICollectionView {
    private struct AssociatedKey {
        static var bgOnNil  = "mz_backgroundviewOnNil"
    }
    var bgForNil: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.bgOnNil) as? UIView
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKey.bgOnNil, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func setBackgroundForNil(nibName: String) {
        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let nView  = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        nView.translatesAutoresizingMaskIntoConstraints = false
        self.bgForNil = nView
    }
    func setBackgroundForNil(message: String) {
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.font = UIFont.systemFont(ofSize: 14)
        messageLabel.textColor = UIColor.gray
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.sizeToFit()
        self.bgForNil = messageLabel
    }
    fileprivate func defaultBackgroundView() -> UIView {
        let messageLabel = UILabel()
        messageLabel.text = "Item not available!"
        messageLabel.font = UIFont.systemFont(ofSize: 14)
        messageLabel.textColor = UIColor.gray
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.sizeToFit()
        return messageLabel
    }
    
    var isBackgroundHidden:Bool {
        get {
            guard self.backgroundView != nil else { return true }
            return false
        }
        set(newValue) {
            if newValue == true {
                self.backgroundView = nil
            }else {
                if let bgView = self.bgForNil { self.backgroundView = bgView }
                else {
                    self.bgForNil = self.defaultBackgroundView()
                    self.backgroundView = self.bgForNil
                }
            }
        }
    }
}



