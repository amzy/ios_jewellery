//
//  EmptyView.swift
//  SMG
//
//  Created by Amzad Khan on 11/09/18.
//  Copyright © 2018 Amzad Khan. All rights reserved.
//

import UIKit



enum EmptyViewType {
    case genericError
    case serverError
    case emptyData(UIImage, String)
}

class EmptyView: UICollectionReusableView {
    
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var emptyImage: UIImageView!
    
    class func instanceFromNib() -> EmptyView {
        return UINib(nibName: "EmptyView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EmptyView
    }
    var viewType:EmptyViewType  = .genericError {
        didSet {
            switch viewType {
            case .emptyData(let image, let message):
            self.emptyImage?.image = image
            if message.length > 0 {
                self.lblMessage?.text = message
            }
            default:break;
                
            }
        }
    }
}

class ErrorView: UICollectionReusableView {
    @IBOutlet weak var errorLabel: UILabel!
    class func instanceFromNib() -> ErrorView {
        return UINib(nibName: "ErrorView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ErrorView
    }
}

class LoadingView: UICollectionReusableView {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    class func instanceFromNib() -> LoadingView {
        return UINib(nibName: "LoadingView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! LoadingView
    }
}
