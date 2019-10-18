//
//  UIApplicationDelegate.swift
//  GetTagg
//
//  Created by Sumit Agarwal on 22/08/17.
//  Copyright © 2017 Syon Infomedia. All rights reserved.
//

import Foundation
import RNNotificationView
//import MessageKit

extension AppDelegate {
    private struct AssociatedKey {
        static var token  = "mz_DeviceToken"
        static var notifications  = "mz_notifications"
    }
    var deviceID: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.token) as? String
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKey.token, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    var notificationInfo: [AnyHashable: Any]? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.notifications) as? [AnyHashable: Any]
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKey.notifications, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

import UIKit
import AudioToolbox
import UserNotifications

// MARK: - Notification Handling -------------------------------------------------------- >

public extension NSNotification.Name {
    
    static let kNotificationNoticeMessage        = Notification.Name("messageReplyNotification")
    static let kLikeBookmarkNotification         = Notification.Name("bookmarkLikeNotification")
    static let kNotificationNoticePost           = Notification.Name("noticePostNotification")
}

enum NotificationType: String {
    
    case unknown        = ""
    case broadcast      = "Broadcast"
    /*
    case chat           = "message" //Chat
    case inbox          = "message_inbox" //Message : Inbox
    case groupChat      = "chatroom_message" //Group Chat
    case typing         = "typing" // Typing user is typing in one to one chat
 */
    
    public init(rawValue: String) {
        switch rawValue {
        case "Broadcast":            self = .broadcast
            /*
        case "message":             self = .chat
        case "message_inbox":       self = .inbox
        case "chatroom_message":    self = .groupChat
        case "typing":              self = .typing
             */
        default:                    self = .unknown
        }
    }
}

extension AppDelegate  {
    
    //563465627033-ts0t03igeeif17n9k3frd8eem5o6gn4s
    
    /*
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    */
    //MARK:- Setup Push Notification Setting
    func registerForPushNotifications(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            //center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil {
                    DispatchQueue.main.async {application.registerForRemoteNotifications()}
                }
            }
        } else {
            let notificationSettings = UIUserNotificationSettings(
                types: [.badge, .sound, .alert], categories: nil)
            application.registerUserNotificationSettings(notificationSettings)
            DispatchQueue.main.async {application.registerForRemoteNotifications()}
        }
        
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    //MARK:- DeviceToken Methods
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Couldn’t register: \(error)")
        deviceID = ""
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString: String = deviceToken.reduce("") { string, byte in
            string + String(format: "%02X", byte)
        }
        deviceID = deviceToken.hexString()
        print("Got token data! (deviceToken): \(deviceTokenString)")
        self.apiUpdateDeviceDetails()
    }
    
    //MARK:- Receive Remote Notification
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print("Notification Recived:")
        print(userInfo)
        
        self.appRemoteNotificationHandelar(application.applicationState, notificationInfo: userInfo)
    }
    
    //MARK:- Notification Handelar
    func appRemoteNotificationHandelar(_ appState: UIApplicationState, notificationInfo: [AnyHashable: Any]) {
        print(notificationInfo)
        
        if let info = notificationInfo["aps"] as? [String: Any], let notificationType = info["notificationType"] as? String{
            BroadcastMesssage.createNotification(infoData: info)
            let notification = NotificationType(rawValue: notificationType)
            guard notification != .unknown else { return }
            if appState == .inactive || appState == .background {
                //Handle notification
                self.notificationAction(type: notification, info: info)
            }else {
                // User in forground Display pop and ask for action
                playSoundForNotification()
                self.notifyForgroundNotification(type: notification, info: info)
            }
        }
    }
    
    //MARK:- Forground notifications handling
    func notifyForgroundNotification(type:NotificationType, info:[AnyHashable:Any]) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        if let messageData = info["alert"] as? [String:Any]  {
            let messageTitle = messageData["title"] as? String ?? ""
            let message = messageData["body"] as? String ?? ""
            
            let notification = RNNotificationView()
            notification.titleFont      = UIFont.systemFont(ofSize: 12)
            notification.titleTextColor = UIColor.white
            notification.iconSize       = CGSize(width: 46, height: 46) // Optional setup
            notification.duration       = 0  // Auto dismiss 0 = manual dismiss
            notification.show(withImage: UIApplication.appIcon, title: messageTitle, message: message, onTap: {
                print("Did tap notification")
                //Handle notification
                self.notificationAction(type: type, info: info)
            })
        }
    }
    
    //MARK:- Action handling for notification `forground` or `backgound`
    func notificationAction( type:NotificationType, info:[AnyHashable:Any]) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        let topVC = UIApplication.topViewController() ?? UIViewController()
        switch type {
            
        /*
        case .broadcast:
            if topVC is NotificationVC {
                let vc  = topVC as! NotificationVC
                vc.reloadData()
            } else {
                let vc  = NotificationVC.storyboardInstance()
                vc.didTapNotification()
                topVC.navigationController?.pushViewController(vc, animated: true)
            }
        
        case .chat:
            NotificationCenter.default.post(name: .kUpdateChat, object: nil)
            if topVC is ChatVC {
                let vc  = topVC as! ChatVC
                vc.reloadData()
            } else {
                guard let userName = info["sender_name"] as? String, let userID = info["sender_id"] as? String else {return}
                let userImageURL  =  info["sender_image"]as? String
                
                let chatVC = ChatVC()
                chatVC.sender =  Sender(id: Constants.kAppDelegate.user.id!, displayName: Constants.kAppDelegate.user.fullName!)
                chatVC.senderImageURL = Constants.kAppDelegate.user.avatar?.url?.absoluteString
                chatVC.receiver = Sender(id: userID, displayName: userName)
                chatVC.receiverImageURL = userImageURL
                
                let nvc = UINavigationController(rootViewController: chatVC)
                topVC.present(nvc, animated: true, completion: nil)
            }
        case .inbox:
            if topVC is DirectMessageVC {
                let vc  = topVC as! DirectMessageVC
                vc.reloadData()
            } else {
                guard let userID = info["sender_id"] as? String else { return }
                
                let vc = DirectMessageVC.storyboardInstance()
                vc.receiverID = userID
                
                let nvc = UINavigationController(rootViewController: vc)
                topVC.present(nvc, animated: true, completion: nil)
            }
            
        case .groupChat:
            if topVC is GroupChatVC {
                let vc  = topVC as! GroupChatVC
                vc.reloadData()
            } else {
                guard let groupID = info["reciverCahtroomId"] as? String, let groupName  = info["reciverCahtroomName"]as? String else {return}
                let imageURL = info["sender_image"]as? String
                
                let chatVC      = GroupChatVC()
                chatVC.sender   = Sender(id: Constants.kAppDelegate.user.id!, displayName: Constants.kAppDelegate.user.fullName!)
                chatVC.senderImageURL = Constants.kAppDelegate.user.avatar?.url?.absoluteString
                chatVC.receiver = Sender(id: groupID, displayName: groupName)
                chatVC.receiverImageURL = imageURL
                
                let nvc = UINavigationController(rootViewController: chatVC)
                topVC.present(nvc, animated: true, completion: nil)
            }
        case .typing : break
        */
        default: break
        }
        
 
    }
    
    //MARK:- Play Sound For Notification
    func playSoundForNotification() {
        AudioServicesPlayAlertSound(1007)
    }
}
extension AppDelegate {
    func apiUpdateDeviceDetails(){
        if let request = API.sendDeviceID.request(method: .post, with: [String:Any]()) {
            request.responseJSON { (response) in
                API.sendDeviceID.validatedResponse(response, success: { (jsonObject) in
                    
                }, failed: { (error, json) in
                    
                })
            }
        }
    }
}
