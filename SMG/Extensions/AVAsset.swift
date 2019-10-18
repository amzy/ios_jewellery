//
//  AVAsset.swift
//
//  Created by Amzad Khan on 3/12/18.
//  Copyright © 2018 Amzad Khan. All rights reserved.
//

import Foundation

import UIKit
import MediaPlayer

import SystemConfiguration

extension AVAsset {
    var videoThumbnail:UIImage?{
        let assetImageGenerator = AVAssetImageGenerator(asset: self)
        assetImageGenerator.appliesPreferredTrackTransform = true
        var time = self.duration
        time.value = min(time.value, 2)
        do {
            let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            let thumbNail = UIImage.init(cgImage: imageRef)
            print("Video Thumbnail genertated successfuly")
            return thumbNail
            
        } catch {
            print("error getting thumbnail video",error.localizedDescription)
            return nil
        }
        
    }
}
