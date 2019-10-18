//
//  PlayerView.swift
//
//  Created by Amzad Khan on 08/12/17.
//  Copyright © 2017 Amzad Khan. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
class PlayerView: UIImageView {
    weak var player: AVPlayer?
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}

extension AVPlayer {
    var isPlaying: Bool {
        if (self.rate != 0 && self.error == nil) {
            return true
        } else {
            return false
        }
    }
}
