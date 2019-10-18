//
//  LoadMoreCollectionCell.swift
//
//  Created by Amzad Khan on 06/02/17.
//  Copyright © 2017 SyonInfomedia. All rights reserved.
//

import UIKit

class LoadMoreCollectionCell: UICollectionViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgView.cornerRadius = bgView.width / 2
        bgView.clipsToBounds = true
        activityIndicator.startAnimating()
    }

}
