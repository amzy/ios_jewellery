//
//  Created by Amzad Khan on 11/08/15.
//  Copyright (c) 2015 Syon Infomedia. All rights reserved.
//


import UIKit

//import AlamofireImage

import SDWebImage
extension UIImageView {
    
    fileprivate func loadImageFromSDWebImage(with url:URL, placeholder: UIImage?, handler:((_ image:UIImage?, _ error:Error?)->Void)?) {
        
        self.sd_setImage(with: url, placeholderImage: placeholder, options: [], completed: { (image, error, type, url) in
            guard let anImage = image else {
                if handler != nil  { handler!(nil, error) }
                else {
                }
                
                return
            }
            if handler != nil  { handler!(anImage, nil) }
        })
    }
}
/*
extension UIImageView {
    fileprivate func loadImageFromAlamofire(with url:URL, placeholder: UIImage?, handler:((_ image:UIImage?, _ error:Error?)->Void)?) {
        
        self.af_setImage(withURL: url, placeholderImage: placeholder, filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.noTransition, runImageTransitionIfCached: false) { (dataResponse) in
            guard let image = dataResponse.result.value else {
                if handler != nil  { handler!(nil, dataResponse.result.error) }
                return
            }
            self.image = image
            if handler != nil  { handler!(image, nil) }
        }
    }
}
 */

enum DownloaderType:Int {
    case urlRequest = 0, alamofireImage = 1, sdWebImage = 2
    static var type:DownloaderType {
        if (ClassFromString(string: "ImageDownloader")) != nil {
            return .alamofireImage
        }else if (ClassFromString(string: "SDWebImageDownloader")) != nil {
            //SDWebImageDownloader Class is declared and available in SDWebImage
            return .sdWebImage
        }else {
            return .urlRequest
        }
    }
}

let kAlamofireImage =  DownloaderType.type == .alamofireImage ? true : false
let kSDWebImage     =  DownloaderType.type == .sdWebImage ? true : false


public func ClassFromString(string:String) -> AnyClass! {
    guard let classObj = NSClassFromString(string) else {
        return nil
    }
    return classObj
}


public extension UIImageView {
    
    public var tint: UIColor {
        set {
            self.image = self.image!.withRenderingMode(.alwaysTemplate)
            self.tintColor = newValue
        }
        get {
            return self.tint
        }
    }
}
////pod "MBCircularProgressBar"
extension UIImageView {
    
    private struct AssociatedKey {
        
        static var activityIndicator  = "mz_activity"
        static var circularProgress  = "mz_circular"
    }
    
    public var activityIndicator: UIActivityIndicatorView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.activityIndicator) as? UIActivityIndicatorView
        }
        set(newValue) {
            
            guard let activity = newValue else {
                return
            }
            
            if let activityView = self.viewWithTag(2000) as? UIActivityIndicatorView {
                activityView.removeFromSuperview()
            }
            
            activity.color = UIColor.white
            
            let height = NSLayoutConstraint(item:activity, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: 20)
            let width = NSLayoutConstraint(item: activity, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: 20)
            
            activity.addConstraints([height, width])
            self.addSubview(activity)
            
            let centerX = NSLayoutConstraint(item: activity, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
            let centerY = NSLayoutConstraint(item: activity, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
            self.addConstraints([centerX,centerY])
            
            activity.startAnimating()
            objc_setAssociatedObject(self, &AssociatedKey.activityIndicator, activity, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func imageWithURL(url: URL, placeholder: UIImage?, handler:((_ image:UIImage?, _ error:Error?)->Void)?) {
        
        
        self.loadImageFromSDWebImage(with: url, placeholder: placeholder, handler: handler)
        //#if ClassFromString(string: "ImageDownloader") != nil
         
       // #endif
            
        /*if (ClassFromString(string: "ImageDownloader")) != nil {
            //ImageDownloader Class is declared and available in ALmofireImage
            self.loadImageFromAlamofire(with: url, placeholder: placeholder, handler: handler)
        }else if (ClassFromString(string: "SDWebImageDownloader")) != nil {
            //SDWebImageDownloader Class is declared and available in SDWebImage
            self.loadImageFromSDWebImage(with: url, placeholder: placeholder, handler: handler)
        }else {
            self.loadImageFromURLRequest(with: url, placeholder: placeholder, handler: handler)
        }
         */
    }
    
    
    fileprivate func loadImageFromURLRequest(with url:URL, placeholder: UIImage?, handler:((_ image:UIImage?, _ error:Error?)->Void)?) {
        
        let request = URLRequest(url: url)
        
        let task : URLSessionDownloadTask = URLSession.shared.downloadTask(with: request) { (url, response, error) in
            guard let fileURL  = url , let anImage  = UIImage(contentsOfFile: fileURL.path) else {
                if handler != nil  { handler!(nil, error) }
                return
            }
            DispatchQueue.main.async(execute: {
                self.image = anImage
                if handler != nil  {handler!(anImage, nil) }
            })
        }
        task.resume()
    }
}






