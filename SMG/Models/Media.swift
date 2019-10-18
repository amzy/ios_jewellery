//
//  Media.swift

//  Created by Amzad Khan on 24/01/18.
//  Copyright © 2018 Amzad Khan. All rights reserved.
//

import UIKit
import SDWebImage
import Photos


public enum MediaType {
    case none, photo, video, audio
}

protocol MediaRequirement : MediaViewable {
    var id:String? {get}
    var thumbURL:URL? {get}
    var mediaType:MediaType! {get}
    var url:URL? {get}
    var isUploaded:Bool {get}
}

extension MediaRequirement {
    
    var isUploaded:Bool {
        if self.mediaType == .photo {
            if self.url == nil { return false}
            else { return true }
        }else if self.mediaType == .video {
            guard let url  = self.url else {
                return false
            }
            if url.absoluteString.hasPrefix("file:") { return false }
            else {return true}
        }else { return false}
    }
}

extension MediaRequirement  {
    public var thumb: URL? {
        return self.thumbURL
    }
    public var dataType: MediaContentType? {
        if self.mediaType == .photo {
            return MediaContentType.image
        }else if self.mediaType == .video {
            return MediaContentType.video
        }else if self.mediaType == .audio {
            return MediaContentType.audio
        }else {
            return  MediaContentType.image
        }
    }
}

open class Photo:MediaRequirement {
    
    var image:UIImage!
    var id: String?
    var thumbURL: URL?
    var mediaType: MediaType! {
        return MediaType.photo
    }
    public var url: URL?
    var asset:PHAsset?

    var caption:String?
    
    var isLiked:Bool = false
    
    public convenience init(_ urlString:String) {
        self.init()
        self.url = urlString.makeURL()
    }
    public convenience init(_ url:URL) {
        self.init()
        self.url = url
    }
    public convenience init(_ image:UIImage) {
        self.init()
        self.image = image
    }
    convenience init(attributes: [String: Any]) {
        self.init()
        id  = attributes["id"] as? String ?? ""
        if let obj = attributes["image_url"] as? String, let url = obj.makeURL() {
            self.url = url
        }else if let obj = attributes["image"] as? String, let url = obj.makeURL()  {
            self.url = url
        }
    }
    
    static func parse(json:[String:Any]) -> Photo {
        let photo = Photo()
        photo.id = json["id"] as? String ?? ""
        if let obj = json["url"] as? String, let url = obj.makeURL() {
            photo.url = url
        }
        
        return photo
    }
}

open class Video:MediaRequirement {
    
    var id: String?
    var thumbURL: URL?
    var mediaType: MediaType! {
        return MediaType.video
    }
    public var url: URL?
    var asset:PHAsset?
    
    
    // Custom properties
    var userName:String?
    var caption:String?
    var date:String?
    var details:String?
    
    var shareURL:URL?
    var likes:String?
    var dislikes:String?
    var comments:String?
    var views:String?
    
    var isLiked:Bool = false
    
    public convenience init(_ urlString:String) {
        self.init()
        self.url = urlString.makeURL()
    }
    public convenience init(_ url:URL) {
        self.init()
        self.url = url
    }
    convenience init(attributes: [String: Any]) {
        self.init()
        id  = attributes["id"] as? String ?? ""
        if let obj = attributes["image_url"] as? String, let url = obj.makeURL() {
            self.url = url
        }else if let obj = attributes["image"] as? String, let url = obj.makeURL()  {
            self.url = url
        }
        if let obj = attributes["thumb"] as? String, let url = obj.makeURL() {
            self.thumbURL = url
        }
        
        userName    = attributes["user_name"] as? String ?? ""
        caption     = attributes["caption"] as? String ?? ""
        date        = attributes["date"] as? String ?? ""
        details     = attributes["description"] as? String ?? ""
        
    }
    static func parse(json:[String:Any]) -> Video {
        let obj = Video()
        obj.id = json["id"] as? String ?? ""
        if let data = json["url"] as? String, let url = data.makeURL() {
            obj.url = url
        }
        if let data = json["thumb"] as? String, let url = data.makeURL() {
            obj.thumbURL = url
        }
        if let data = json["shareLink"] as? String, let url = data.makeURL() {
            obj.shareURL = url
        }
        obj.caption = json["caption"] as? String ?? ""
        obj.likes = json["likes"] as? String ?? ""
        obj.dislikes = json["disliked"] as? String ?? ""
        obj.comments = json["commentCount"] as? String ?? ""
        obj.views = json["views"] as? String ?? ""
        
        obj.userName    = json["user_name"] as? String ?? ""
        obj.date        = json["date"] as? String ?? ""
        obj.details     = json["description"] as? String ?? ""
        
        return obj
    }
}

open class Media: MediaRequirement {
    
    var id: String?
    fileprivate var photo:UIImage!
    var thumbURL:URL?
    var mediaType: MediaType!
    public var url:URL?
    
    var uploadData:Any? {
        if self.mediaType == .photo {
            return photo
        }else {
            return url
        }
    }
    
    public convenience init(_ urlString:String, mediaType:MediaType = .photo) {
        self.init()
        self.url = urlString.makeURL()
        self.mediaType = mediaType
    }
    
    public convenience init(_ url:URL, mediaType:MediaType = .photo) {
        self.init()
        self.url = url
        self.mediaType = mediaType
    }
    
    public convenience init(_ image:UIImage) {
        self.init()
        self.photo = image
        self.mediaType = .photo
    }
}




public struct AppMedia: MediaRequirement {
    
    var id: String?
    fileprivate var photo:UIImage!
    var thumbURL:URL?
    var mediaType: MediaType!
    public var url:URL?
    
    var uploadData:Any? {
        if self.mediaType == .photo {
            return photo
        }else {
            return url
        }
    }
    
    public init(_ urlString:String, mediaType:MediaType = .photo) {
        self.url = urlString.makeURL()
        self.mediaType = mediaType
    }
    
    public init(_ url:URL, mediaType:MediaType = .photo) {
        self.url = url
        self.mediaType = mediaType
    }
    
    public init(_ image:UIImage) {

        self.photo = image
        self.mediaType = .photo
    }
}

