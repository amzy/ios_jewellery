//
//  AppPlayer.swift
//  AmarFM
//
//  Created by Amzad Khan on 4/25/18.
//  Copyright © 2018 Yogesh Singh. Chauhan. All rights reserved.
//
import MediaPlayer
import AVKit
import UIKit



public protocol AppPlayerPlayable {
    var url:URL? {get}
    var artwork:URL? { get }
    var mediaType:MPMediaType? { get }
    var artist:String? {get}
    var title:String? {get}
}

public class AppPlayer: NSObject {
    /// The player.
    static let shared = AppPlayer()
    var allowBackgroundPlayback:Bool  = false {
        didSet {
            if allowBackgroundPlayback {
                do {
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
                    print("Playback OK")
                    try AVAudioSession.sharedInstance().setActive(true)
                    print("Session is Active")
                } catch {
                    print(error)
                }
            }
        }
    }
    var avPlayer:AVPlayer!
    @IBOutlet weak var mediaImage: PlayerView!
    var media:AppPlayerPlayable?
    var isPaused: Bool = false
    var playerItem:AVPlayerItem?
    var timer: Timer?
    var currentDuration:Float64 = 0
    var currentAssetDuration:Float64 = 0
    
    override init() {
        super.init()
        self.allowBackgroundPlayback  = true
        AppPlayer.configutreRemoteCommand()
       // #colorLiteral(red: 0.9137254902, green: 0.2078431373, blue: 0.1529411765, alpha: 1)  //E93527 //F0372B
    }
    

    public func configure(with data:AppPlayerPlayable) {
        
        self.currentDuration = 0
        self.currentAssetDuration = 0
        let validMediaTypes = [MPMediaType.music, MPMediaType.musicVideo, MPMediaType.anyAudio, MPMediaType.anyVideo]
        if let type = data.mediaType, validMediaTypes.contains(type), let url = data.url {
            self.updateRemoteMediaInfo(title: data.title ?? "", artist: data.artist ?? "", artwork: data.artwork)
            self.media = data
            if self.mediaImage != nil {
                self.mediaImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "noImg"))
            }
            let asset = AVAsset(url: url)
            let keys: [String] = ["playable"]
            
            print("display loading in content view!!!!\nfetching media information..")
            asset.loadValuesAsynchronously(forKeys: keys) {
                var error: NSError? = nil
                let status: AVKeyValueStatus = asset.statusOfValue(forKey: "playable", error: &error)
                switch status {
                case .loaded:
                    print("Hide loading in content view!!!!\nfetching media information completed.")
                    let assetDuration : CMTime = asset.duration
                    let assetSeconds : Float64 = CMTimeGetSeconds(assetDuration)
                    self.currentDuration = assetSeconds
            
                    self.playerItem = AVPlayerItem(asset: asset)
                    DispatchQueue.main.async {
                        
                        self.avPlayer = AVPlayer(playerItem: self.playerItem)
                        if #available(iOS 10.0, *) {
                            self.avPlayer.automaticallyWaitsToMinimizeStalling = false
                        }
                        if self.mediaImage != nil {
                            let castedLayer = self.mediaImage.layer as! AVPlayerLayer
                            castedLayer.player = self.avPlayer
                        }
                        
                        self.avPlayer!.volume = 1.0
                        //self.setupTimer()
                    }
                case .failed:
                    print("failed invalid url or content formate. Show error!!!!!!!")
                default : break
                }
            }
        }
    }
    
    func configurePlater(player:AVPlayer) {
        player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            if player.currentItem?.status == .readyToPlay {
                let time : Float64 = CMTimeGetSeconds(player.currentTime());
                self.currentDuration = time
                //let currentTime = self.formatTimeFromSeconds(totalSeconds: Int32(Float(time)))
                //self.playbackSlider!.value = Float (time);
            }
        }
    }
    
    @IBAction func didTapPlay(_ sender: Any) {
        guard self.avPlayer != nil else { return}
        self.togglePlayPause()
    }
    @IBAction func sliderValueChanged(_ sender: Any) {
        guard self.avPlayer != nil else { return }
        let value = (sender as! UISlider).value
        let seconds : Int64 = Int64(value)
        let targetTime:CMTime = CMTimeMake(seconds, 1)
        avPlayer!.seek(to: targetTime)
        if(isPaused == false){
            //seekLoadingLabel.alpha = 1
        }
    }
    deinit {
        if self.avPlayer != nil {
            self.avPlayer.pause()
            self.avPlayer = nil
        }
    }
    
    @objc func togglePlayPause() {
        if #available(iOS 10.0, *) {
            if avPlayer.timeControlStatus == .playing  {
                avPlayer.pause()
                isPaused = true
            } else {
                avPlayer.play()
                isPaused = false
            }
        } else {
            if avPlayer.isPlaying {
                avPlayer.pause()
                isPaused = true
            }else {
                avPlayer.play()
                isPaused = false
            }
            // Fallback on earlier versions
        }
    }
}

extension AppPlayer {
    
    fileprivate func formatTimeFromSeconds(totalSeconds: Int32) -> String {
        let seconds: Int32 = totalSeconds%60
        let minutes: Int32 = (totalSeconds/60)%60
        //let hours: Int32 = totalSeconds/3600
        return String(format: "%02d:%02d", minutes,seconds)
        //return String(format: "%02d",seconds)
    }
}

//Lock Screen Media Widget update
import SDWebImage
extension AppPlayer {
    
     func updateRemoteMediaInfo(title:String, artist:String, artwork:URL?) {
        
        let info:[String:Any] = [MPMediaItemPropertyTitle :title, MPMediaItemPropertyArtist : artist, MPMediaItemPropertyArtwork : "", MPNowPlayingInfoPropertyDefaultPlaybackRate : NSNumber(value: 1), MPMediaItemPropertyPlaybackDuration : CMTimeGetSeconds(CMTime())]
        
        if let artworkURL = artwork {
            SDWebImageDownloader.shared().downloadImage(with: artworkURL, options: .useNSURLCache, progress: nil, completed: { (image, data, error, ok) in
                guard let img = image else {return}
                var updatedInfo = info
                if #available(iOS 10.0, *) {
                    let artwork = MPMediaItemArtwork(boundsSize: img.size) { (inputSize) -> UIImage in
                        return img.draw(at: inputSize)
                    }
                    updatedInfo[MPMediaItemPropertyArtwork] = artwork
                } else {
                    // Fallback on earlier versions
                    updatedInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(image: img)
                }
                DispatchQueue.main.async(execute: {
                    MPNowPlayingInfoCenter.default().nowPlayingInfo = updatedInfo
                })
            })
        }
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
    }
    
    static func configutreRemoteCommand() {
        
        let commandCenter = MPRemoteCommandCenter.shared()
    
        commandCenter.previousTrackCommand.isEnabled = false;
        commandCenter.nextTrackCommand.isEnabled = false
        
        commandCenter.skipBackwardCommand.isEnabled = false
        commandCenter.skipForwardCommand.isEnabled = false
        
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget(self, action: #selector(self.togglePlayPause))
        
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget(self, action: #selector(self.togglePlayPause))
        
        /*
        
        let center = MPRemoteCommandCenter.shared()
        
        center.pauseCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            self.playandPause()
            return self.mediaplayer.state == .paused ? .success : .commandFailed
        }
        
        center.playCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            self.playandPause()
            return self.mediaplayer.state == .playing ? .success : .commandFailed
        }
        
        if #available(iOS 9.1, tvOS 9.1, *) {
            center.changePlaybackPositionCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
                self.mediaplayer.time = VLCTime(number: NSNumber(value: (event as! MPChangePlaybackPositionCommandEvent).positionTime * 1000))
                return .success
            }
        }
        
        center.stopCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            self.mediaplayer.stop()
            return .success
        }
        
        center.changePlaybackRateCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            self.mediaplayer.rate = (event as! MPChangePlaybackRateCommandEvent).playbackRate
            return .success
        }
        
        center.skipForwardCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            self.mediaplayer.jumpForward(Int32((event as! MPSkipIntervalCommandEvent).interval))
            return .success
        }
        
        center.skipBackwardCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            self.mediaplayer.jumpBackward(Int32((event as! MPSkipIntervalCommandEvent).interval))
            return .success
        }
 */
        
        
    }
    
}

private extension UIImage {
    
    func draw(at targetSize: CGSize) -> UIImage {
        
        guard !self.size.equalTo(CGSize.zero) else {
            print("Invalid image size: (0,0)")
            return self
        }
        
        guard !targetSize.equalTo(CGSize.zero) else {
            print("Invalid target size: (0,0)")
            return self
        }
        
        let scaledSize = sizeThatFills(targetSize)
        let x = (targetSize.width - scaledSize.width) / 2.0
        let y = (targetSize.height - scaledSize.height) / 2.0
        let drawingRect = CGRect(x: x, y: y, width: scaledSize.width, height: scaledSize.height)
        
        UIGraphicsBeginImageContextWithOptions(targetSize, true, 0)
        draw(in: drawingRect)
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage!
        
    }
    
    func sizeThatFills(_ other: CGSize) -> CGSize {
        guard !size.equalTo(CGSize.zero) else {
            return other
        }
        let heightRatio = other.height / size.height
        let widthRatio = other.width / size.width
        if heightRatio > widthRatio {
            return CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            return CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
    }
    
}
extension AppPlayer {
    func removeRemoteCommandCenterHandlers() {
        UIApplication.shared.endReceivingRemoteControlEvents()
    }
}
