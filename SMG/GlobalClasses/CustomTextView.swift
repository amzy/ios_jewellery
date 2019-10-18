//
//  CustomTextView.swift
//  
//
//  Created by Himanshu Parashar on 27/07/15.
//  Copyright (c) 2015 syoninfomedia. All rights reserved.
//

import UIKit

class CustomTextView: UITextView {

    var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    fileprivate struct Constants {
        static let defaultiOSPlaceholderColor = UIColor(red: 0.0, green: 0.0, blue: 0.0980392, alpha: 0.22)
    }
    
    internal var placeholder: String = "" {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    internal var placeholderColor: UIColor = CustomTextView.Constants.defaultiOSPlaceholderColor {
        didSet {
            placeholderLabel.textColor = placeholderColor
        }
    }
    
    internal let placeholderLabel: UILabel = UILabel()
    
    override internal var font: UIFont! {
        didSet {
            placeholderLabel.font = font
        }
    }
    
    override internal var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel.textAlignment = textAlignment
        }
    }
    
    override internal var text: String! {
        didSet {
            textDidChange()
        }
    }
    
    override internal var attributedText: NSAttributedString! {
        didSet {
            textDidChange()
        }
    }
    
    override internal var textContainerInset: UIEdgeInsets {
        didSet {
            updateConstraintsForPlaceholderLabel()
        }
    }
    
    var placeholderLabelConstraints = [NSLayoutConstraint]()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        NotificationCenter.default.addObserver(self,
            selector: #selector(self.textDidChange),
            name: NSNotification.Name.UITextViewTextDidChange,
            object: nil)
        
        placeholderLabel.font = font
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.textAlignment = textAlignment
        placeholderLabel.text = placeholder
        placeholderLabel.numberOfLines = 0
        placeholderLabel.backgroundColor = UIColor.clear
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholderLabel)
        self.returnKeyType = .done
        updateConstraintsForPlaceholderLabel()
        
        /*
         let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 30))
        toolbar.barStyle = UIBarStyle.default
        toolbar.tintColor = UIColor.appBlue//"Done" button colour
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.inputAccessoryViewDidFinish(_:)))
        doneButton.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.appBlue], for: .normal)
        
        let items = [spaceButton, doneButton]
        toolbar.setItems(items, animated: true)
        
        self.inputAccessoryView = toolbar
         */
    }
    
    private func inputAccessoryViewDidFinish(_ sender: AnyObject) {
        self.resignFirstResponder()
    }
    
    func updateConstraintsForPlaceholderLabel() {
        var newConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(\(textContainerInset.left + textContainer.lineFragmentPadding))-[placeholder]-(\(textContainerInset.right + textContainer.lineFragmentPadding))-|",
            options: [],
            metrics: nil,
            views: ["placeholder": placeholderLabel])
        newConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(\(textContainerInset.top))-[placeholder]-(>=\(textContainerInset.bottom))-|",
            options: [],
            metrics: nil,
            views: ["placeholder": placeholderLabel])
        removeConstraints(placeholderLabelConstraints)
        addConstraints(newConstraints)
        placeholderLabelConstraints = newConstraints
    }
    
    @objc func textDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    override internal func layoutSubviews() {
        super.layoutSubviews()
        placeholderLabel.preferredMaxLayoutWidth = textContainer.size.width - textContainer.lineFragmentPadding * 2.0
    }
    
    // MARK:- Set Line View
    var linesWidth: CGFloat = 0.5 { didSet{ drawLines() } }
    var linesColor: UIColor = UIColor.lightGray { didSet{ drawLines() } }
    var leftLine: Bool = false { didSet{ drawLines() } }
    var rightLine: Bool = false { didSet{ drawLines() } }
    var bottomLine: Bool = false { didSet{ drawLines() } }
    var topLine: Bool = false { didSet{ drawLines() } }
    
    fileprivate func drawLines() {
        if bottomLine {
            let border = CALayer()
            border.frame = CGRect(x: 0.0, y: frame.size.height - linesWidth, width: frame.size.width, height: linesWidth)
            border.backgroundColor = linesColor.cgColor
            layer.addSublayer(border)
        }
        
        if topLine {
            let border = CALayer()
            border.frame = CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: linesWidth)
            border.backgroundColor = linesColor.cgColor
            layer.addSublayer(border)
        }
        
        if rightLine {
            let border = CALayer()
            border.frame = CGRect(x: frame.size.width - linesWidth, y: 0.0, width: linesWidth, height: frame.size.height);
            border.backgroundColor = linesColor.cgColor
            layer.addSublayer(border)
        }
        
        if leftLine {
            let border = CALayer()
            border.frame = CGRect(x: 0.0, y: 0.0, width: linesWidth, height: frame.size.height);
            border.backgroundColor = linesColor.cgColor
            layer.addSublayer(border)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self,
            name: NSNotification.Name.UITextViewTextDidChange,
            object: nil)
    }
}

extension CustomTextView {
    func updateAppearance(_ color: UIColor? = UIColor.lightGray) {
        //self.bottomLine = true
        //self.linesColor = color!
        self.borderWidth = 1.0
        self.borderColor = color
    }
}
