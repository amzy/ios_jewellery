//
//  LinkTextView.swift
//  Nafas
//
//  Created by Amzad Khan on 01/05/17.
//  Copyright © 2017 SyonInfomedia. All rights reserved.
//

import Foundation
import UIKit

protocol LinkTextViewDelegate{
    
    func textViewLinkPressed(textView:UITextView, text:String)
}

class LinkTextView: UITextView, UITextViewDelegate {
    
    var linkDelegate:LinkTextViewDelegate!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.isEditable                     = false
        self.isSelectable                   = true
        self.isUserInteractionEnabled       = true
        self.dataDetectorTypes              = .link
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator   = false
        self.isScrollEnabled                = false
        self.contentOffset                  = CGPoint.zero
        self.contentInset                   = UIEdgeInsets.zero
        self.textContainerInset             = UIEdgeInsets.zero
        self.scrollIndicatorInsets          = UIEdgeInsets.zero
        //self.textContainer.lineFragmentPadding = 0
        
        self.linkTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: #colorLiteral(red: 0.1856297851, green: 0.3833171725, blue: 0.6116526127, alpha: 1)]
        self.delegate = self
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    override var canBecomeFirstResponder: Bool {
        return false
    }
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if let url  = URL.absoluteString.removingPercentEncoding {
            if url.hasPrefix(Constants.kAppDisplayName) {
                let decodedText  = URL.lastPathComponent
                guard  self.linkDelegate != nil else {
                    return false
                }
                self.linkDelegate.textViewLinkPressed(textView: self, text: decodedText)
            }
        }
        return false
    }
}

extension NSMutableAttributedString {
    
    func setTextAsLink(textToFind:String! , withLink:NSURL! = nil) ->Bool {
        guard textToFind != nil else {
            return false
        }
        let range:NSRange = self.mutableString.range(of: textToFind, options: NSString.CompareOptions.caseInsensitive)
        if range.location == NSNotFound {
            return false
        }else {
            if  withLink == nil {
                let urlEncodedQuery = (Constants.kAppDisplayName + "://" + textToFind).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                let url:NSURL = NSURL(string: urlEncodedQuery!)!
                self.addAttribute(NSAttributedStringKey.link, value: url, range: range)
            }else{
                self.addAttribute(NSAttributedStringKey.link, value: withLink, range: range)
            }
            return true
        }
    }
}


import UIKit

class TextViewAutoHeight: UITextView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        isScrollEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(updateHeight), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }
    
    @objc func updateHeight() {
        // trigger your animation here
         var newFrame = frame

         let fixedWidth = frame.size.width
         let newSize = sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
         
         newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
         self.frame = newFrame
        
        // suggest searching stackoverflow for "uiview animatewithduration" for frame-based animation
        // or "animate change in intrinisic size" to learn about a more elgant solution :)
    }
}

