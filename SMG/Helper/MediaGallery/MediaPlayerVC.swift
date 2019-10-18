//
//  MediaPlayerVC.swift
//
//  Created by Amzad Khan on 08/12/17.
//  Copyright © 2017 Amzad Khan. All rights reserved.
//

import UIKit

import AVFoundation
import AVKit

public typealias DismissHandler = (_ index:Int)->UIView?
class MediaPlayerVC: UIViewController {
    
    fileprivate var interactiveDismissal: Bool = false
    @IBOutlet weak var pageContentViewTop: NSLayoutConstraint!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var contentView: UIView!
    //MARK:- Create with Nib Insnstance
    static func nibInstance() -> MediaPlayerVC {
        return MediaPlayerVC(nibName: "MediaPlayerVC", bundle: Bundle.main)
    }
    //MARK:- Variables Declaration.
    var selectedIndex:Int  = 0
    var dataSource = [MediaViewable]()
    var isVideoPresent = false
    var dismissHandler:DismissHandler?
    var currentIndex:Int {
        guard let page = self.pageViewController.viewControllers?.first as? Pageable else { return 0}
        return page.pageIndex
    }
     //MARK:- Statusbar Methods.
    var statusBarShouldBeHidden = false
    
    @IBOutlet var pageViewController: UIPageViewController!
    
    var currentMediaView:UIView? {
        guard let page = self.pageViewController.viewControllers?.first as? Pageable else { return nil}
        return page.mediaView
    }
    var currentMediaVC:UIViewController? {
        guard let page = self.pageViewController.viewControllers?.first  else { return nil}
        return page
    }
    
    override var prefersStatusBarHidden: Bool {
        return statusBarShouldBeHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    static func mediaPlayer(with mediaData: [MediaViewable], initialIndex:Int = 0, referenceView: UIView? = nil, dismissHandler:@escaping DismissHandler) -> MediaPlayerVC {
        
        let player = MediaPlayerVC.nibInstance()
        player.selectedIndex = initialIndex
        player.dataSource = mediaData
        player.dismissHandler = dismissHandler
        player.transitionAnimator.startingView = referenceView
        player.transitionAnimator.endingView = player.view
        
        return player
    }

    //MARK:- Transitioning ---
    let transitionAnimator = TransitionAnimator()
    let interactiveAnimator = InteractionAnimator()
    
    fileprivate(set) lazy var singleTapGestureRecognizer: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(self.handleSingleTapGestureRecognizer(_:)))
    }()
    fileprivate(set) lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        return UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGestureRecognizer(_:)))
    }()
    
    func hideStatusbar() {
        // Hide the status bar
        statusBarShouldBeHidden = true
        UIView.animate(withDuration: 0.25) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    func showStatusbar() {
        // Show the status bar
        statusBarShouldBeHidden = false
        UIView.animate(withDuration: 0.25) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    //MARK:- UIViewController override Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.setTopNavigation(for: [.dismiss])
        view.tintColor = UIColor.white
        view.backgroundColor = UIColor.black
        self.configPageController()
        self.setAccessoryViews(hidden: true)
        pageViewController.view.backgroundColor = UIColor.clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // This fix issue that navigationBar animate to up
        // when presentingViewController is UINavigationViewController
        statusBarShouldBeHidden = true
        UIView.animate(withDuration: 0.25) { () -> Void in
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupInitilView()
    }
    // MARK: - setup Initial View Methode.
    private func setupInitilView() {
        self.view.layoutIfNeeded()
    }
    
    //MARK:- Button Actions
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    //MARK:- Memory Handler Methode.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    open override func dismiss(animated flag: Bool, completion: (() -> Void)?) {
        if presentedViewController != nil {
            super.dismiss(animated: flag, completion: completion)
            return
        }
        var startingView: UIView?
        if self.currentMediaView != nil {
            startingView = self.currentMediaView
        }
        transitionAnimator.startingView = startingView
        transitionAnimator.endingView = dismissHandler?(currentIndex)
        
        let overlayWasHiddenBeforeTransition = self.navigationBar.isHidden
        self.setAccessoryViews(hidden: true)
       
        
        super.dismiss(animated: flag) { () -> Void in
            let isStillOnscreen = self.view.window != nil
            if isStillOnscreen && !overlayWasHiddenBeforeTransition {
                self.setAccessoryViews(hidden: false)
            }
        }
        super.dismiss(animated: flag) { () -> Void in}
    }
}

// MARK: - Page View Controller Data Source
extension MediaPlayerVC: UIPageViewControllerDataSource {
    
    func configPageController() {
        
        modalPresentationStyle = .custom
        transitioningDelegate = self
        modalPresentationCapturesStatusBarAppearance = true

        //Loaded From Nib
       // self.pageViewController.setViewControllers([self.viewControllerAtIndex(index: 0)], direction: .forward, animated: true, completion: nil)
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageViewController.dataSource = self
        self.pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        let pageView = self.pageViewController.view
        
        self.addChildViewController(self.pageViewController)
        self.contentView.addSubview(pageView!)
        
        let top         = NSLayoutConstraint(item: pageView!, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1, constant: 0)
        let bottom      = NSLayoutConstraint(item: pageView!, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1, constant: 0)
        let trailing    = NSLayoutConstraint(item: pageView!, attribute: .trailing, relatedBy: .equal, toItem: self.contentView, attribute: .trailing, multiplier: 1, constant: 0)
        let leading     = NSLayoutConstraint(item: pageView!, attribute: .leading, relatedBy: .equal, toItem: self.contentView, attribute: .leading, multiplier: 1, constant: 0)
        self.contentView.addConstraints([top, bottom, leading,trailing])
        
        self.pageViewController.view.addGestureRecognizer(panGestureRecognizer)
        self.pageViewController.view.addGestureRecognizer(singleTapGestureRecognizer)
        
        self.pageViewController.didMove(toParentViewController: self)
        self.pageViewController.setViewControllers([self.viewControllerAtIndex(index: selectedIndex)], direction: .forward, animated: true, completion: nil)
        self.transitionAnimator.endingView = self.currentMediaView
 
    }
    
    func restartAction(sender: AnyObject) {
        self.pageViewController.setViewControllers([self.viewControllerAtIndex(index: 0)], direction: .forward, animated: true, completion: nil)
    }
    func viewControllerAtIndex(index: Int) -> UIViewController {
        if (dataSource.count == 0) || (index >= dataSource.count) {
            return UIViewController()
            // Media Not Available
        }
        
        var returnValue:UIViewController = ImageMediaVC.nibInstance()
        let mediaData = dataSource[index]
        
        if let type = mediaData.dataType {
            switch type {
            case .image:
                let imageVC = ImageMediaVC.nibInstance()
                imageVC.media = mediaData
                imageVC.page = index
                returnValue = imageVC
            case .video, .audio:
                if let url = mediaData.url {
                    try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: [])
                    
                    let playerItem = AVPlayerItem(url: url)
                    let player = AVPlayer(playerItem: playerItem)
                    player.volume = 1.0
                    let streamPlayer =  AVPlayerViewController()
                    streamPlayer.player = player
                    
                    streamPlayer.page = "\(index)"
                    returnValue = streamPlayer
                }
                
                //streamPlayer.player = player
/*
                let videoVC = VideoMediaVC.nibInstance()
                videoVC.media       = mediaData
                videoVC.pageIndex   = index
                /*
                videoVC.topBar.isHidden     = self.navigationBar.isHidden
                videoVC.bottomBar.isHidden  = self.navigationBar.isHidden */
                returnValue = videoVC

                
            case .audio:
                let audioVC = AudioMediaVC.nibInstance()
                audioVC.media       = mediaData
                audioVC.page   = index
                /*
                audioVC.topBar.isHidden      = self.navigationBar.isHidden
                audioVC.bottomBar.isHidden   = self.navigationBar.isHidden */
                returnValue =  audioVC
  */
            }
 
        }
        return returnValue
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! Pageable
        var index = vc.pageIndex as Int
        if (index == 0 || index == NSNotFound) {
            return nil
        }
        index -= 1
        return self.viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! Pageable
        var index = vc.pageIndex as Int
        if (index == NSNotFound) {
            return nil
        }
        index += 1
        if (index == dataSource.count) {
            return nil
        }
        return self.viewControllerAtIndex(index: index)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return dataSource.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
    }
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            // Get current controller
            if let pageVC = self.currentMediaVC as? Pageable {
               self.selectedIndex =  pageVC.pageIndex
            }
        }
    }
}

 // MARK: - UIViewControllerTransitioningDelegate

extension MediaPlayerVC : UIViewControllerTransitioningDelegate {
    
    public  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionAnimator.dismissing = false
        return transitionAnimator
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionAnimator.dismissing = true
        return transitionAnimator
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if interactiveDismissal {
            transitionAnimator.endingViewForAnimation = transitionAnimator.endingView?.tranSnapshotView()
            interactiveAnimator.animator = transitionAnimator
            interactiveAnimator.shouldAnimateUsingAnimator = transitionAnimator.endingView != nil
            interactiveAnimator.viewToHideWhenBeginningTransition = transitionAnimator.startingView != nil ? transitionAnimator.endingView : nil
            
            return interactiveAnimator
        }
        return nil
    }
}

extension MediaPlayerVC {
    // MARK: - Gesture Recognizers
    
    @objc fileprivate func handleSingleTapGestureRecognizer(_ gestureRecognizer: UITapGestureRecognizer) {
        self.setAccessoryViews(hidden: !self.navigationBar.isHidden)
    }
    
    @objc fileprivate func handlePanGestureRecognizer(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began {
            interactiveDismissal = true
            dismiss(animated: true, completion: nil)
        } else {
            interactiveDismissal = false
            interactiveAnimator.handlePanWithPanGestureRecognizer(gestureRecognizer, viewToPan: pageViewController.view, anchorPoint: CGPoint(x: view.bounds.midX, y: view.bounds.midY))
        }
    }
}

extension MediaPlayerVC {
    func setAccessoryViews(hidden:Bool) {
        self.navigationBar.isHidden = hidden
        self.navigationBar.isTranslucent = true
        if hidden {
            pageContentViewTop.constant =  0
        }else {
            pageContentViewTop.constant =  44
        }
        self.view.layoutIfNeeded()
        if let currentController = self.currentMediaVC {
            if currentController is VideoMediaVC {
                let videoVC =  currentController as! VideoMediaVC
                videoVC.topBar.isHidden = hidden
                videoVC.bottomBar.isHidden = hidden
            }else if currentController is AudioMediaVC {
                let audioVC =  currentController as! AudioMediaVC
                audioVC.topBar.isHidden = hidden
                audioVC.bottomBar.isHidden = hidden
            }
        }
    }
}
