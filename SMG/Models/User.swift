//
//  User.swift
//
//  Created by Amzad Khan on 15/10/15.
//  Copyright © 2015 Amzad Khan. All rights reserved.
//

import UIKit
import ObjectiveC

extension AppDelegate {
    private struct AssociatedKey {
        static var user  = "mz_User"
    }
    var user: User! {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.user) as? User
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKey.user, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}



public enum SocialType :String {
    case email      = "email"
    case facebook   = "facebook"
    case twitter    = "twitter"
}


//MARK:- User Profile Model
class User: NSObject {
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName
        case email
        case gender
        case dob
    }
    
    //MARK:- Properties
    var socialType  = SocialType.email
    var avatar          :Photo?
    var id              :String?
    var email           :String?
    
    var name            :String?
    var firstName       :String?
    var lastName        :String?
    var fullName        :String?

    var phone           :String?
    var gender          :String?
    var dob             :String?
    var cartCount       :String? = "0"
    
    var accessToken     :String?

    var isSelected      = false
    var isPhoneVerfied  = false
    var isVarifyAccount = false
    
    var avatarCover    :Photo?
    
    var firmName:String?
    var gstNo:String?
    var designation:String?
    var firmAddress:String?
   
    
    // MARK: - Intializer
    override init() {
    }
    
    convenience init(attributes: [String: Any]) {
        self.init()
        
        /*-----------------------------------------------------------------------------
         This code reads the singleton's properties from NSUserDefaults.
         -----------------------------------------------------------------------------*/
        
        id          = attributes["userId"]           as? String ?? ""
        dob         = attributes["age_range_name"]   as? String ?? ""
        email       = attributes["email"]            as? String ?? ""
        fullName    = attributes["user_name"]        as? String ?? ""
        firstName   = attributes["first_name"]       as? String ?? ""
        lastName    = attributes["last_name"]        as? String ?? ""
        name        = attributes["userName"]         as? String ?? ""
       
        
        if let imagePath =  attributes["user_avatar"] as? String ,let url = imagePath.makeURL(){
            let photo = Photo()
            photo.url = url
            self.avatar = photo
        }
        if let imagePath =  attributes["coverpic"] as? String ,let url = imagePath.makeURL(){
            let photo = Photo()
            photo.url = url
            self.avatarCover = photo
        }
        
        
        phone           = attributes["mobile_number"]       as? String ?? ""
        accessToken     = attributes["user_token"]          as? String ?? ""

        gender          = attributes["gender"]              as? String ?? ""
        isVarifyAccount = Int(any: attributes["status"]) == 1 ? true : false
        
    }
    
    static func parse(json:[String:Any])-> User {
        
        let user = User()
        user.id          = json["user_id"] as? String ?? ""
        user.gstNo       = json["gst_no"] as? String ?? ""
        user.designation = json["designation"] as? String ?? ""
        user.firmName    = json["frim_name"] as? String ?? ""
        user.phone       = json["mobile"] as? String ?? ""
        user.email       = json["email"] as? String ?? ""
        user.cartCount   = json["cart_count"] as? String ?? ""
        
        if let obj       = json["user_avatar"] as? String, let url = obj.makeURL() {
            let photo = Photo()
            photo.url = url
            user.avatar = photo
        }
        
        user.name = json["name"] as? String ?? ""
        return user
    }
    
    static func parseUserData(json:[String:Any])-> User {

        let user = User()
        user.id = json["user_id"] as? String ?? ""
        if let obj = json["user_avatar"] as? String, let url = obj.makeURL() {
            let photo = Photo()
            photo.url = url
            user.avatar = photo
        }
        
        user.name = json["user_name"] as? String ?? ""
        return user
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        id  = aDecoder.decodeObject(forKey: "id")  as? String
        
        if let avatarURL  = aDecoder.decodeObject(forKey: "avatar")           as? URL {
            let photo = Photo()
            photo.url = avatarURL
            avatar = photo
        }
        
        name     = aDecoder.decodeObject(forKey: "name")           as? String
        fullName = aDecoder.decodeObject(forKey: "fullName")       as? String
        firstName = aDecoder.decodeObject(forKey: "firstName")      as? String
        lastName = aDecoder.decodeObject(forKey: "lastName")       as? String
        email    = aDecoder.decodeObject(forKey: "email")          as? String
        accessToken  = aDecoder.decodeObject(forKey: "accessToken")    as? String
        firmAddress = aDecoder.decodeObject(forKey: "firmAddress") as? String
        
        isPhoneVerfied = aDecoder.decodeBool(forKey: "isPhoneVerfied")
        isVarifyAccount = aDecoder.decodeBool(forKey: "isVarifyAccount")
        if let data = UserDefaults.standard.data(forKey: "userImage") {
            if let photo = UIImage(data: data) {
                let photo = Photo(photo)
                avatar = photo
            }
        }
        
    }
    
    func uploadData()->[String:String] {
        return ["name":fullName ?? "",
        "email":email ?? "",
        "gst_no": gstNo ?? "",
        "frim_name":firmName ?? "",
        "designation":designation ?? "",
        "mobile":phone ?? "",
        "user_id":id ?? "",
        "address":firmAddress ?? ""]
    }
}

 // MARK: - Fetch and Save User

extension User:NSCoding {
    
    func encode(with aCoder: NSCoder) {
        
        if id != nil { aCoder.encode(id, forKey: "id") }
        if name != nil { aCoder.encode(name, forKey: "name") }
        if fullName != nil { aCoder.encode(fullName, forKey: "fullName") }
        if firstName != nil { aCoder.encode(firstName, forKey: "firstName") }
        if lastName != nil { aCoder.encode(lastName, forKey: "lastName") }
        if email != nil { aCoder.encode(email, forKey: "email") }
        if firmAddress != nil {aCoder.encode(firmAddress, forKey: "firmAddress")}
        if accessToken != nil { aCoder.encode(accessToken, forKey: "accessToken") }
        if isVarifyAccount { aCoder.encode(isVarifyAccount, forKey: "isVarifyAccount") }
        if isPhoneVerfied { aCoder.encode(isPhoneVerfied, forKey: "isVarifyAccount") }
        
        if let image  = self.avatar?.image, let data = UIImageJPEGRepresentation(image, 1) {
            UserDefaults.standard.set(data, forKey: "userImage")
            UserDefaults.standard.synchronize()
        }
        if let avatarURL  =  avatar?.url {
           aCoder.encode(avatarURL, forKey: "avatar")
        }
    }
    
    func saveUser() {
        let data  = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.set(data, forKey: Constants.kAppDisplayName+"user")
        UserDefaults.standard.synchronize()
    }
    static func isUserLogin() -> User! {
        if let data = UserDefaults.standard.object(forKey: Constants.kAppDisplayName+"user") as? Data {
            let unarc = NSKeyedUnarchiver(forReadingWith: data)
            return unarc.decodeObject(forKey: "root") as? User
        } else {
            return nil
        }
    }
}

extension User {
    var isLoginUser:Bool {
        guard self.id != nil else {return false}
        guard Constants.kAppDelegate.user.id != nil else {return false}
        return  self.id == Constants.kAppDelegate.user.id
    }
    static func isLoginUserID(id:String) -> Bool {
        guard let userID  = Constants.kAppDelegate.user.id  else {return false}
        return id == userID
    }
}


// Other user refrences in application
enum Availability {
    case online, offline, away
    var color:UIColor {
        switch self {
        case .online:
            return UIColor(red: 103/255.0, green: 169/255.0, blue: 50/255.0, alpha: 1)
        case .away:
            return UIColor(red: 254/255.0, green: 225/255.0, blue: 48/255.0, alpha: 1)
        default:
            return UIColor(red: 145/255.0, green: 147/255.0, blue: 133/255.0, alpha: 1)
        }
    }
}


struct ChatUser {
    
    var id:String?
    var name:String?
    var status = Availability.offline
    var image:String?
    var lastMessage:String?
    
    static func parse(json:[String:Any]) ->ChatUser {
        
        var chatUser  = ChatUser()
        chatUser.id  =  json["id"] as? String ?? ""
        chatUser.name = json["n"] as? String
        chatUser.lastMessage = json["s"] as? String ?? ""
        chatUser.image = json["a"] as? String
  
        let type = json["s"] as? String ?? "offline"
        if type == "available" {
            chatUser.status = Availability.online
        }else if type == "away" {
            chatUser.status = Availability.away
        }
        return chatUser
    }
}
