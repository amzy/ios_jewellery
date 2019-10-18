//
//  UIAlertController.swift
//  WhyQ
//
//  Created by Himanshu Parashar on 24/03/17.
//  Copyright © 2017 SyonInfomedia. All rights reserved.
//

import Foundation
import UIKit
extension UIAlertController {
    
    func isValidEmail(for email: String) -> Bool {
        return email.count > 0 && NSPredicate(format: "self matches %@", "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,64}").evaluate(with: email)
    }
    
    func minCount(for text: String) -> Bool {
        //return text.characters.count > 4 && text.rangeOfCharacter(from: .whitespacesAndNewlines) == nil
        return text.count > 4
    }
    
    func textDidChangeInEmailAlert() {
        if let email = textFields?[0].text,
            let action = actions.last {
            action.isEnabled = isValidEmail(for: email)
        }
    }
    
    func textDidChangeForInCountAlert() {
        if let text = textFields?[0].text,
            let action = actions.last {
            action.isEnabled = minCount(for: text)
        }
    }
}
