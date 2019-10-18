//
//  AudioMediaVC.swift
//
//  Created by Amzad Khan on 08/12/17.
//  Copyright © 2017 Amzad Khan. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class AudioMediaVC: UIViewController, Pageable {
    var mediaView: UIView? {
        return mediaImage
    }
    var page:Int = 0
    var pageIndex: Int {
        return self.page
    }
    static func nibInstance() -> AudioMediaVC {
        return AudioMediaVC(nibName: "AudioMediaVC", bundle: Bundle.main)
    }
    
    //MARK:- IBOutlet Declaration
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var bottomBar: UIToolbar!
    @IBOutlet weak var mediaImage: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var currentTimeBarItem: UIButton!
    @IBOutlet weak var timeBarItem: UIButton!
    @IBOutlet weak var playerSlider: UISlider!
    @IBOutlet weak var playBarItem: UIButton!
    
    //MARK:- Variable Declaration
    var timer: Timer?
    var avPlayer: AVPlayer!
    var isPaused: Bool = false
    var playerItem:AVPlayerItem?
    var media:MediaViewable?
    var tapGesture: UITapGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.topBar.isHidden    = true
        self.bottomBar.isHidden = true
        guard let data = self.media else {return}
        self.configure(with: data)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupTimer()
    }
    override func viewWillDisappear(_ animated: Bool) {
        if self.timer != nil  {
            self.timer?.invalidate()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configure(with data:MediaViewable) {
        if let type = data.dataType, type == .audio, let url = data.url {
            self.mediaImage.image = #imageLiteral(resourceName: "soundbar")
            let asset = AVAsset(url: url)
            let keys: [String] = ["playable"]
            
            print("display loading in content view!!!!\nfetching media information..")
            asset.loadValuesAsynchronously(forKeys: keys) {
                var error: NSError? = nil
                let status: AVKeyValueStatus = asset.statusOfValue(forKey: "playable", error: &error)
                switch status {
                case .loaded:
                    print("Hide loading in content view!!!!\nfetching media information completed.")
                    self.playerItem = AVPlayerItem(asset: asset)
                    DispatchQueue.main.async {
                        self.avPlayer = AVPlayer(playerItem: self.playerItem)
                        if #available(iOS 10.0, *) {
                            self.avPlayer.automaticallyWaitsToMinimizeStalling = false
                        }
                        self.avPlayer!.volume = 1.0
                        self.setupTimer()
                    }
                case .failed:
                    print("failed invalid url or content formate. Show error!!!!!!!")
                default : break
                }
            }
        }
    }
    
    @IBAction func didTapPlay(_ sender: Any) {
    
        guard self.avPlayer != nil else { return}
        if #available(iOS 10.0, *) {
            self.togglePlayPause()
        } else {
            // showAlert "upgrade ios version to use this feature"
        }
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
}


extension AudioMediaVC {

    func play(url:URL) {
        
        self.avPlayer = AVPlayer(playerItem: AVPlayerItem(url: url))
        if #available(iOS 10.0, *) {
            self.avPlayer.automaticallyWaitsToMinimizeStalling = false
        }
        avPlayer!.volume = 1.0
        avPlayer.play()
    }
    
    @available(iOS 10.0, *)
    func togglePlayPause() {
        if avPlayer.timeControlStatus == .playing  {
            playButton.setImage(#imageLiteral(resourceName: "recording_play"), for: .normal)
            avPlayer.pause()
            isPaused = true
        } else {
            playButton.setImage(#imageLiteral(resourceName: "recording_pause"), for: .normal)
            avPlayer.play()
            isPaused = false
        }
    }
    
    @IBAction func sliderTapped(_ sender: UILongPressGestureRecognizer) {
        
        if let slider = sender.view as? UISlider {
            
            if slider.isHighlighted { return }
            let point = sender.location(in: slider)
            let percentage = Float(point.x / slider.bounds.width)
            let delta = percentage * (slider.maximumValue - slider.minimumValue)
            let value = slider.minimumValue + delta
            slider.setValue(value, animated: false)
            let seconds : Int64 = Int64(value)
            let targetTime:CMTime = CMTimeMake(seconds, 1)
            avPlayer!.seek(to: targetTime)
            if !isPaused {
                //seekLoadingLabel.alpha = 1
            }
        }
    }
}
extension AudioMediaVC {
    
    func setupTimer(){
        guard self.avPlayer != nil else {return}
        NotificationCenter.default.addObserver(self, selector: #selector(self.didPlayToEnd), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        timer = Timer(timeInterval: 0.001, target: self, selector: #selector(self.tick), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
    }
    
    @objc func didPlayToEnd() {
        //self.nextTrack()
    }
    @objc func tick(){
        guard let player = self.avPlayer else { return }
        
        if player.currentTime().seconds == 0.0 {
            //loadingLabel.alpha = 1
        }else{
            //loadingLabel.alpha = 0
        }
        if !isPaused {
            if avPlayer.rate == 0 {
                avPlayer.play()
                //seekLoadingLabel.alpha = 1
            }else{
                //seekLoadingLabel.alpha = 0
            }
        }
        
        if player.currentItem?.asset.duration  != nil {
            
            let currentTime1 : CMTime = (player.currentItem?.asset.duration)!
            let seconds1 : Float64 = CMTimeGetSeconds(currentTime1)
            let time1 : Float = Float(seconds1)
            playerSlider.minimumValue = 0
            playerSlider.maximumValue = time1
            let currentTime : CMTime = player.currentTime()
            let seconds : Float64 = CMTimeGetSeconds(currentTime)
            let time : Float = Float(seconds)
            self.playerSlider.value = time
            
            let timeText =  self.formatTimeFromSeconds(totalSeconds: Int32(Float(Float64(CMTimeGetSeconds((player.currentItem?.asset.duration)!)))))
            let currentTimeText = self.formatTimeFromSeconds(totalSeconds: Int32(Float(Float64(CMTimeGetSeconds((player.currentItem?.currentTime())!)))))
            timeBarItem.setTitle(timeText, for: .normal)
            currentTimeBarItem.setTitle(currentTimeText, for: .normal)
            
        }else{
            playerSlider.value = 0
            playerSlider.minimumValue = 0
            playerSlider.maximumValue = 0
            let timeText = "\(self.formatTimeFromSeconds(totalSeconds: Int32(CMTimeGetSeconds((avPlayer.currentItem?.currentTime())!))))"
            timeBarItem.setTitle(timeText, for: .normal)
        }
    }
    
    func formatTimeFromSeconds(totalSeconds: Int32) -> String {
        
        let seconds: Int32 = totalSeconds%60
        let minutes: Int32 = (totalSeconds/60)%60
        //let hours: Int32 = totalSeconds/3600
        return String(format: "%02d:%02d", minutes,seconds)
        //return String(format: "%02d",seconds)
    }
}
