//
//  CustomTextField.swift
//
//
//  Created by Amzad Khan on 17/07/15.
//  Copyright (c) 2015 syoninfomedia. All rights reserved.
//

import UIKit

public enum TextInputType : String {
    case text
    case picker
    case time // Displays hour, minute, and optionally AM/PM designation depending on the locale setting (e.g. 6 | 53 | PM)
    case date // Displays month, day, and year depending on the locale setting (e.g. November | 15 | 2007)
    case dateAndTime // Displays date, hour, minute, and optionally AM/PM designation depending on the locale setting (e.g. Wed Nov 15 | 6 | 53 | PM)
}
let formatter = DateFormatter()

open class CustomTextField: UITextField {
    fileprivate let borderTop = CALayer()
    fileprivate let borderLeft = CALayer()
    fileprivate let borderBottom = CALayer()
    fileprivate let borderRight = CALayer()
    open var paddingTop:      CGFloat = 0
    open var paddingLeft:     CGFloat = 8
    open var paddingBottom:   CGFloat = 0
    open var paddingRight:    CGFloat = 8 //24 For cross button
    
    open var borderWidth: CGFloat = 0 {
        didSet { layer.borderWidth = borderWidth }
    }
    
    open var borderColor: UIColor? {
        didSet { layer.borderColor = borderColor?.cgColor }
    }
    
    // MARK:- Set Placeholder Color
    open var placeholderColor: UIColor = UIColor(red: 0.0, green: 0.0, blue: 0.0980392, alpha: 0.22) {
        didSet{ changeAttributedPlaceholderColor() }
    }
    
    fileprivate func changeAttributedPlaceholderColor() {
        if (self.attributedPlaceholder?.length != nil) {
            if self.responds(to: #selector(getter: UITextField.attributedPlaceholder)) {
                
                self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: placeholderColor])
            }
        }
    }
    
    // MARK:- Set Placeholder New Bounds
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    open override var keyboardType: UIKeyboardType {
        didSet {
            if  keyboardType == .numberPad {
                self.setDoneButton()
            }
        }
    }
    fileprivate func newBounds(_ bounds: CGRect) -> CGRect {
        var newBounds = bounds
        newBounds.origin.x += paddingLeft
        newBounds.origin.y += paddingTop
        newBounds.size.height -= paddingTop + paddingBottom
        newBounds.size.width -= paddingLeft + paddingRight
        return newBounds
    }
    // MARK:- Set Line View
    // Set Lines in UITextField like Material design in Android
    
    open var linesWidth: CGFloat = 0.5 { didSet{ drawLines() } }
    open var linesColor: UIColor = UIColor.lightGray { didSet{ drawLines() } }
    open var leftLine: Bool   = false { didSet{ drawLines() } }
    open var rightLine: Bool  = false { didSet{ drawLines() } }
    open var bottomLine: Bool = false { didSet{ drawLines() } }
    open var topLine: Bool    = false { didSet{ drawLines() } }
    
    fileprivate func drawLines() {
        if bottomLine {
            //let border = CALayer()
            borderBottom.frame = CGRect(x: 0.0, y: frame.size.height - linesWidth, width: frame.size.width, height: linesWidth)
            borderBottom.backgroundColor = linesColor.cgColor
            layer.addSublayer(borderBottom)
        }
        
        if topLine {
            //let border = CALayer()
            borderTop.frame = CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: linesWidth)
            borderTop.backgroundColor = linesColor.cgColor
            layer.addSublayer(borderTop)
        }
        
        if rightLine {
            //let border = CALayer()
            borderRight.frame = CGRect(x: frame.size.width - linesWidth, y: 0.0, width: linesWidth, height: frame.size.height);
            borderRight.backgroundColor = linesColor.cgColor
            layer.addSublayer(borderRight)
        }
        
        if leftLine {
            //let border = CALayer()
            borderLeft.frame = CGRect(x: 0.0, y: 0.0, width: linesWidth, height: frame.size.height);
            borderLeft.backgroundColor = linesColor.cgColor
            layer.addSublayer(borderLeft)
        }
    }
    
    // MARK:- Set toolbar with Done button
    open var isDoneButton: Bool = false { didSet{ setDoneButton() } }
    // MARK:- Set Input Type
    open var textInputType: TextInputType = .text {
        didSet {
            switch textInputType {
            case .text: break
            case .picker:
                self.setInputTyePicker()
            case .time:
                self.setInputTyeDatePicker(mode: .time)
            case .date:
                self.setInputTyeDatePicker(mode: .date)
            case .dateAndTime:
                self.setInputTyeDatePicker(mode: .dateAndTime)
            }
        }
    }
    
}

public extension CustomTextField {
    
    public func updateAppearance(_ color: UIColor? = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)) {
        self.bottomLine = true
        self.linesWidth = 1.0
        self.linesColor = color!
        //self.placeholderColor = color!
        //self.paddingLeft = 10
        //self.paddingRight = 0
    }
    
    public func setLeftView(of image: UIImage!) {
        
        //setting left image
        self.paddingLeft = 36
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 26, height: 40))
        let paddingImage = UIImageView()
        paddingImage.image = image
        paddingImage.contentMode = .left
        paddingImage.frame = CGRect(x: 8, y: 0, width: 18, height: 40)
        paddingView.addSubview(paddingImage)
        self.leftView = paddingView
        self.leftView?.isUserInteractionEnabled = false
        self.leftViewMode = UITextFieldViewMode.always
    }
    
    public func setRightViewImage(_ textFieldImg: UIImage!) {
        
        //setting right image
        self.paddingRight = 20
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let arraowBtn  =  UIButton(type: .custom)
        arraowBtn.backgroundColor = UIColor.clear
        arraowBtn.tintColor = UIColor.clear
        arraowBtn.setTitle("", for: .normal)
        arraowBtn.frame = paddingView.frame
        
        arraowBtn.addTarget(self, action: #selector(self.becomeFirstResponder), for: .touchUpInside)
        let paddingImage = UIImageView()
        paddingImage.image = textFieldImg
        paddingImage.frame = CGRect(x: 6, y: 6, width: 10, height: 10)
        paddingView.addSubview(paddingImage)
        paddingView.addSubview(arraowBtn)
        
        self.rightView = paddingView
        self.rightViewMode = UITextFieldViewMode.always
    }
}

extension UITextField {
    
    open var picker:UIPickerView! {
        
        guard let picker = self.inputView as? UIPickerView else {
            return nil
        }
        return picker
    }
    open var datePicker:UIDatePicker! {
        guard let picker = self.inputView as? UIDatePicker else {
            return nil
        }
        return picker
    }
    open func isInputView(view:UIPickerView) -> Bool {
        return self.inputView == view
    }
}

extension CustomTextField {
    
    fileprivate func setDoneButton() {
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 40))
        toolbar.barStyle = UIBarStyle.default
        toolbar.tintColor = UIColor.black
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.inputAccessoryViewDidFinish(_:)))
        doneButton.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.black], for: .normal)
        let items = [spaceButton, doneButton]
        toolbar.setItems(items, animated: true)
        self.inputAccessoryView = toolbar
    }
    // MARK:- Set Picker
    fileprivate func setInputTyePicker() {
        if self.picker == nil  {
            let pickerView  : UIPickerView = UIPickerView()
            self.inputView = pickerView
            pickerView.tag = self.tag
            self.isDoneButton = true
            self.setRightViewImage(#imageLiteral(resourceName: "ic_keyboard_arrow_down"))
        }
    }
    
    // MARK:- Set Date Picker
    fileprivate func setInputTyeDatePicker(mode:UIDatePickerMode) {
        if self.datePicker !== nil || self.datePicker?.datePickerMode != mode {
            let datePickerView  : UIDatePicker = UIDatePicker()
            datePickerView.datePickerMode = mode
            let currentDate: Date = Date()
            //datePickerView.maximumDate = Calendar.current.date(byAdding: .year, value: -16, to: Date())
            datePickerView.minimumDate = currentDate
            self.inputView = datePickerView
            datePickerView.tag = self.tag
            datePickerView.addTarget(self, action: #selector(self.updateDatePickerTextField(_:)), for: UIControlEvents.valueChanged)
            self.isDoneButton = true
        }
    }
    
    
    @objc func updateDatePickerTextField(_ sender: UIDatePicker) {
        
        switch sender.datePickerMode {
        case .time:
            formatter.dateFormat = "hh:mm a"//"MM-dd-yyyy"
        case .date:
            formatter.dateFormat = "dd-MM-yyyy"//"MM-dd-yyyy"
        case .dateAndTime:
            formatter.dateFormat = "dd-MM-yyyy HH:mm"//"MM-dd-yyyy"
        case .countDownTimer: break
        }
        self.text = formatter.string(from: sender.date)
    }
    
    @objc func inputAccessoryViewDidFinish(_ sender:AnyObject) {
        if let datePicker = self.datePicker  {
            self.updateDatePickerTextField(datePicker)
        }else if let picker = self.picker {
            let row = picker.selectedRow(inComponent: 0)
            if row <= 0  {
                picker.selectRow(0, inComponent: 0, animated: true)
                picker.delegate?.pickerView!(picker, didSelectRow: 0, inComponent: 0)
            }
        }
        self.resignFirstResponder()
    }
}


