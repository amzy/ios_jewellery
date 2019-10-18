//
//  UIButton.swift
//  WhyQ
//
//  Created by Himanshu Parashar on 23/03/17.
//  Copyright © 2017 SyonInfomedia. All rights reserved.
//

import Foundation
import UIKit

typealias ButtonAction = () -> Void
extension UIButton {
    
    private struct AssociatedKeys {
        static var ActionKey = "ActionKey"
    }
    
    private class ActionWrapper {
        let action: ButtonAction
        init(action: @escaping ButtonAction) {
            self.action = action
        }
    }
    var action: ButtonAction? {
        set(newValue) {
            removeTarget(self, action: #selector(performAction), for: .touchUpInside)
            var wrapper: ActionWrapper? = nil
            if let newValue = newValue {
                wrapper = ActionWrapper(action: newValue)
                addTarget(self, action: #selector(performAction), for: .touchUpInside)
            }
            objc_setAssociatedObject(self, &AssociatedKeys.ActionKey, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            guard let wrapper = objc_getAssociatedObject(self, &AssociatedKeys.ActionKey) as? ActionWrapper else {
                return nil
            }
            return wrapper.action
        }
    }
    
    @objc func performAction() {
        guard let action = action else {
            return
        }
        action()
    }
}

extension UIButton {
    func applyInnerShedow () {
        
        self.layer.cornerRadius = self.cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: self.cornerRadius)
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowOpacity = 0.5
        layer.shadowPath = shadowPath.cgPath
        layer.shadowRadius = 1
    }
    
    func addTopBorder(with color: UIColor, of borderWidth: CGFloat) {
        let border: CALayer = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: borderWidth)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorder(with color: UIColor, of borderWidth: CGFloat) {
        let border: CALayer = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - borderWidth, width: self.frame.size.width, height: borderWidth)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorder(with color: UIColor, of borderWidth: CGFloat) {
        let border: CALayer = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addRightBorder(with color: UIColor, of borderWidth: CGFloat) {
        let border: CALayer = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - borderWidth, y: 0, width: borderWidth, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func  setButtonEdgeInsets() {//its set to button title left
        self.imageEdgeInsets = UIEdgeInsetsMake(0, +( self.titleLabel?.frame.size.width)!+5, 0, 0);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, -( self.imageView?.frame.size.width)!, 0, 0);
    }
    
    
    private struct AssociatedKey {
        
        static var badgeLabel           = "mz_UIButton.badgeLabel"
        static var badgeString          = "mz_UIButton.badgeString"
        static var badgeEdgeInsets      = "mz_UIButton.badgeEdgeInsets"
        static var badgeBackgroundColor = "mz_UIButton.badgeBackgroundColor"
        static var badgeTextColor       = "mz_UIButton.badgeTextColor"
        
    }
    
    fileprivate var badgeLabel: UILabel {
        get {
            if let obj  = objc_getAssociatedObject(self, &AssociatedKey.badgeLabel)  {
                return obj as! UILabel
            }else {
                let aLabel  = UILabel()
                objc_setAssociatedObject(self, &AssociatedKey.badgeLabel, aLabel, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return aLabel
            }
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.badgeLabel, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.draw(self.frame)
        }
    }
    
    public var badgeString: String? {
        get {
            if let obj  = objc_getAssociatedObject(self, &AssociatedKey.badgeString)  {
                return obj as? String
            }else {return nil }
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.badgeString, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setupBadgeViewWithString(badgeText: newValue)
        }
    }
    
    public var badgeBackgroundColor : UIColor {
        
        get {
            if let obj  = objc_getAssociatedObject(self, &AssociatedKey.badgeBackgroundColor)  {
                return obj as! UIColor
            }else {
                objc_setAssociatedObject(self, &AssociatedKey.badgeBackgroundColor, UIColor.red, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return UIColor.red
            }
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.badgeBackgroundColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            badgeLabel.backgroundColor = newValue
        }
    }
    
    public var badgeTextColor: UIColor {
        
        get {
            if let obj  = objc_getAssociatedObject(self, &AssociatedKey.badgeTextColor)  {
                return obj as! UIColor
            }else {
                objc_setAssociatedObject(self, &AssociatedKey.badgeTextColor, UIColor.white, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return UIColor.white
            }
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.badgeTextColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            badgeLabel.textColor = newValue
        }
    }
    
    fileprivate func setupBadgeViewWithString(badgeText: String?) {
        badgeLabel.clipsToBounds = true
        badgeLabel.text = badgeText
        badgeLabel.font = UIFont.systemFont(ofSize: 12)
        badgeLabel.textAlignment = .center
        badgeLabel.sizeToFit()
        let badgeSize = badgeLabel.frame.size
        
        let height = max(20, Double(badgeSize.height) + 5.0)
        let width = max(height, Double(badgeSize.width) + 10.0)
        
        var vertical: Double?, horizontal: Double?
        let badgeInset = UIEdgeInsets.zero
        vertical = Double(badgeInset.top) - Double(badgeInset.bottom)
        horizontal = Double(badgeInset.left) - Double(badgeInset.right)
        
        let x = (Double(bounds.size.width) - 10 + horizontal!)
        let y = -(Double(badgeSize.height) / 2) - 10 + vertical!
        badgeLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        
        setupBadgeStyle()
        addSubview(badgeLabel)
        
        if let text = badgeText {
            if text == "" || text == "0" {
                badgeLabel.isHidden = true
            }else {
                badgeLabel.isHidden = false
            }
        } else {
            badgeLabel.isHidden = true
        }
    }
    fileprivate func setupBadgeStyle() {
        
        badgeLabel.textAlignment       = .center
        badgeLabel.backgroundColor     = badgeBackgroundColor
        badgeLabel.textColor           = badgeTextColor
        badgeLabel.layer.cornerRadius  = badgeLabel.bounds.size.height / 2
    }
}

public enum InputType {
    case picker, datePicker, imagePicker
}
extension UIButton {
    
    private struct PickerAssociatedKeys {
        static var PickerActionKey = "ActionKey"
        static var TextFieldKey = "TextFieldKey"
    }
    
    private var tempTextfield: UITextField? {
        set(newValue) {
            guard let tempTextfield = newValue else {
                return
            }
            self.removeTextField()
            self.customizeTextField(textField: tempTextfield)
            self.addSubview(tempTextfield)
            objc_setAssociatedObject(self, &PickerAssociatedKeys.TextFieldKey, tempTextfield, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            guard let tempTextfield = objc_getAssociatedObject(self, &PickerAssociatedKeys.TextFieldKey) as? UITextField else {
                return nil
            }
            return tempTextfield
        }
    }
    
    func customizeTextField(textField:UITextField) {
        textField.frame = self.bounds//CGRect(origin: CGPoint(x:0, y:0), size: self.size)
        textField.textColor = UIColor.clear
        textField.tintColor = UIColor.clear
        textField.backgroundColor = UIColor.clear
        textField.isHidden = true
    }
    
    private func removeTextField () {
        guard let tempTextfield  = self.tempTextfield else {
            return
        }
        objc_removeAssociatedObjects(tempTextfield)
        tempTextfield.removeFromSuperview()
    }
    
    open func picker() -> UIPickerView? {
        guard let tempTextfield  = self.tempTextfield, let picker  = tempTextfield.inputView as? UIPickerView else {
            return nil
        }
        return picker
    }

    func setInputType(inputType:InputType, withAction action:@escaping ButtonAction)  {
        switch inputType {
        case .picker: 
            self.setInputTyePicker()
            self.pickerAction = action
        default:break
        }
    }
    
    fileprivate func setInputTyePicker() {
        self.tempTextfield = UITextField()
        guard let tempTextfield = self.tempTextfield else {
            return
        }
        let pickerView  : UIPickerView = UIPickerView()
        tempTextfield.inputView = pickerView
        self.setToolbar(for: tempTextfield)
    }
    
    fileprivate func setToolbar(for tempTextfield:UITextField) {
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 30))
        toolbar.barStyle = UIBarStyle.default
        toolbar.tintColor = UIColor.black
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.inputAccessoryViewDidFinish(_:)))
        doneButton.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.black], for: .normal)
        let items = [spaceButton, doneButton]
        toolbar.setItems(items, animated: true)
        
        tempTextfield.inputAccessoryView = toolbar
    }
    @objc fileprivate func inputAccessoryViewDidFinish(_ sender:AnyObject) {
        guard let tempTextfield = self.tempTextfield else {
            return
        }
        self.isSelected = false
        tempTextfield.resignFirstResponder()
    }
    
    private class PickerActionWrapper {
        let action: ButtonAction
        init(action: @escaping ButtonAction) {
            self.action = action
        }
    }
    
    private var pickerAction: ButtonAction? {
        
        set(newValue) {
            removeTarget(self, action: #selector(performPickerAction), for: .touchUpInside)
            var wrapper: PickerActionWrapper? = nil
            if let newValue = newValue {
                wrapper = PickerActionWrapper(action: newValue)
                addTarget(self, action: #selector(performPickerAction), for: .touchUpInside)
            }
            objc_setAssociatedObject(self, &PickerAssociatedKeys.PickerActionKey, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            guard let wrapper = objc_getAssociatedObject(self, &PickerAssociatedKeys.PickerActionKey) as? PickerActionWrapper else {
                return nil
            }
            return wrapper.action
        }
    }
    
    @objc fileprivate func performPickerAction() {
        
        self.isSelected  = !self.isSelected
        if self.isSelected {
             self.tempTextfield?.becomeFirstResponder()
        }else {
            self.tempTextfield?.resignFirstResponder()
        }
        guard let action = pickerAction else {
            return
        }
        action()
    }
}
