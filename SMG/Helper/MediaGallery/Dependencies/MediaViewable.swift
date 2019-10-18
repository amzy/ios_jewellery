//
//  MediaViewable.swift
//
//  Created by Amzad Khan on 26/01/18.
//  Copyright © 2018 Amzad Khan. All rights reserved.
//

import Foundation

public enum MediaContentType: String {
    
    case audio = "audio"
    case image = "image"
    case video = "video"
    
    var description: String {
        let first = String(self.rawValue.prefix(1)).capitalized
        let other = String(self.rawValue.dropFirst())
        return first + other
    }
}

public protocol MediaViewable {
    var url:URL? {get}
    var thumb:URL? { get }
    var dataType:MediaContentType? { get }
}

import UIKit

/*
extension Media :MediaViewable {
    public var url: String? {
        return self.url?.a
    }
    
    public var placeholder: String? {
        <#code#>
    }
    
    public var dataType: MediaContentType? {
        <#code#>
    }
}
*/
extension UIViewController {
    class func presentGallery(from:UIViewController, imageView: UIImageView, indexPath: IndexPath?, media:[MediaViewable]) {
        let index:Int  = indexPath != nil ? indexPath!.row : 0
        let player  = MediaPlayerVC.mediaPlayer(with: media, initialIndex: index, referenceView: imageView) { (index) -> UIView? in
            return imageView
        }
        player.dataSource = media
        from.present(player, animated: true) {}
    }
    
    func presentGallery(imageView: UIImageView, indexPath: IndexPath?, media:[MediaViewable]) {
        let index:Int  = indexPath != nil ? indexPath!.row : 0
        let player  = MediaPlayerVC.mediaPlayer(with: media, initialIndex: index, referenceView: imageView) { (index) -> UIView? in
            return imageView
        }
        player.dataSource = media
        self.present(player, animated: true) {}
    }
}

