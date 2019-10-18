//
//  ImageMediaVC.swift
//
//  Created by Amzad Khan on 08/12/17.
//  Copyright © 2017 Amzad Khan. All rights reserved.
//

import UIKit
import SDWebImage

class ImageMediaVC: UIViewController , Pageable {
    var page:Int = 0
    var mediaView: UIView? {
        return mediaImage
    }
    var pageIndex: Int {
        return self.page
    }
    static func nibInstance() -> ImageMediaVC {
        return ImageMediaVC(nibName: "ImageMediaVC", bundle: Bundle.main)
    }
    
    //MARK:- IBOutlet Declaration
    @IBOutlet var mediaImage: UIImageView!
    @IBOutlet var scrollVw: UIScrollView!
     var media:MediaViewable?
    
    //MARK:- Variable Declaration
    var tapGesture: UITapGestureRecognizer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        guard let data = self.media else {return}
        self.configure(with: data)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func configure(with data:MediaViewable) {
        if let type = data.dataType, type == .image, let url = data.url {
            self.scrollVw.minimumZoomScale = 1.0
            self.scrollVw.maximumZoomScale = 10
            self.scrollVw.zoomScale = 1.0;
            self.scrollVw.contentSize = self.view.frame.size
            self.mediaImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "noImg"))
        }
    }
}

//MARK:- UIScrollViewDelegate Methods.
extension ImageMediaVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mediaImage
    }
}
