//
//  UIViewController.swift
//
//  Created by Himanshu Parashar on 06/01/16.
//  Copyright © 2016 syoninfomedia. All rights reserved.
//

import UIKit
import MessageUI
//import SlideMenuControllerSwift
import Social

// MARK: Keyboard Events
public extension UIViewController {
    
    func startObservingKeyboardEvents() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWasShown(_:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillBeHidden(_:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    func stopObservingKeyboardEvents() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWasShown(_ notification: Notification) {
        
    }
    
    @objc func keyboardWillBeHidden(_ notification: Notification) {
        
    }
    
}

//MARK:- Email Invite
extension UIViewController : MFMailComposeViewControllerDelegate {
    
    func openMailComposer(toRecipent emailId: String? = "", subject: String, message: String? = "") {
        
        let mailCompose = MFMailComposeViewController()
        guard MFMailComposeViewController.canSendMail() else {
            return
        }
        
        mailCompose.mailComposeDelegate = self
        mailCompose.setSubject(subject)
        mailCompose.setMessageBody(subject, isHTML: true)
        if let id = emailId {
            mailCompose.setToRecipients([id])
        }
        present(mailCompose, animated: true) {
            
        }
    }
    
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
            
        case .sent:
            Global.showAlert(message: "Mail sent successfully")
        case .saved:
            print("You saved a draft of this email")
        case .cancelled:
            print("You cancelled sending this email.")
        case .failed:
            Global.showAlert(message: "Mail failed: \([error!.localizedDescription])")
        }
        dismiss(animated: true, completion: nil)
    }
}


// MARK: -  Social Share
extension UIViewController {
    func socialShare(title: String?, image: UIImage?, url: URL?) {
        
        var items = [Any]()
        
        if let title = title {
            items.append(title)
        }
        if let image = image {
            items.append(image)
        }
        if let url = url {
            items.append(url)
        }
        
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
        
        //(UIActivityType?, Bool, [Any]?, Error?) -> Swift.Void
        activityVC.completionWithItemsHandler = {(activityType, completed: Bool, returnedItems:[Any]?, error: Error?) in
            
            // Return if cancelled
            guard completed == true else {
                return
            }
            //activity complete
            printDebug("Done")
            
        }
    }
}

extension UIViewController {
    
    func showAlertWith(Title:String?,message:String?) {
        let alertVC = UIAlertController(title: Title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction( title: "OK", style:.default, handler: nil)
        alertVC.addAction(okAction)
        present( alertVC, animated: true, completion: nil)
    }
}


// MARK: Get Previous ViewController

extension UIViewController {
    
    func getPreviousViewController() -> UIViewController? {
        guard let _ = self.navigationController else {
            return nil
        }
        guard let viewControllers = self.navigationController?.viewControllers else {
            return nil
        }
        guard viewControllers.count >= 2 else {
            return nil
        }
        return viewControllers[viewControllers.count - 2]
    }
}

extension UIViewController : MFMessageComposeViewControllerDelegate {
    
    func sendMessage(message:String, contacts:[String]?) {
        let messageVC = MFMessageComposeViewController()
        messageVC.body = message
        messageVC.recipients = contacts // Optionally add some tel numbers
        messageVC.messageComposeDelegate = self
        present(messageVC, animated: true, completion: nil)
        
    }
    // Conform to the protocol
    // MARK: - Message Delegate method
    public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
        case  .cancelled:
            print("message canceled")
        case .failed:
            print("message failed")
            Global.showAlert(message: "Failed to send Invitation!")
        case .sent:
            print("message sent")
            Global.showAlert(message: "Invitation has been sent!")
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension UIViewController {
    
    func dialNumber(number : String) {
        if let url = URL(string: "tel://\(number)"),
            UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            // add error message here
        }
    }
    
    
    func whatsup(share message:String, completionHandler:((_ finish:Bool)->Void)? = nil) {
        
        let urlWhats = "whatsapp://send?text=\(message)"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            
            guard let url =  urlString.makeURL() else  {
                if completionHandler != nil {
                    completionHandler!(false)
                }
                return
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, completionHandler: { (completed) in
                    if completionHandler != nil {
                        completionHandler!(completed)
                    }else {
                        Global.showAlert(message: "Please install watsapp")
                    }
                })
            } else if UIApplication.shared.openURL(url) {
                completionHandler!(true)
            }else {
                print("Please install watsapp")
                completionHandler!(false)
            }
        }
    }
}
extension UIViewController {
    func notificationButton() -> UIBarButtonItem {
        let rightBtn2 = UIButton(type: UIButtonType.system)
        rightBtn2.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        rightBtn2.tintColor = UIColor.white
        rightBtn2.setImage(UIImage(named: "notification"), for:UIControlState.normal)
        rightBtn2.addTarget(self, action: #selector(self.didTapNotification), for: .touchUpInside)
        let rightbarButton2 = UIBarButtonItem(customView: rightBtn2)
        return rightbarButton2
    }
    @objc func didTapNotification() {
        //        let vc = NotificationVC.storyboardInstance()
        //        let nav = UINavigationController(rootViewController: vc)
        //        self.present(nav, animated: true, completion: nil)
    }
}

// MARK: - *****************FOR DESELECT VALUE FROM AN ARRAY*************************
extension UIViewController {
    //    func
    //    addon.options.forEach { $0.isSelected = false }
}
