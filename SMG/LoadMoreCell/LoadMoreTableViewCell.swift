//
//  LoadMoreTableViewCell.swift
//
//  Created by Amzad Khan on 04/04/16.
//  Copyright © 2016 Syon Infomedia. All rights reserved.
//

import UIKit

class LoadMoreTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        bgView.cornerRadius = bgView.width / 2
        bgView.clipsToBounds = true
        
        activityIndicator.startAnimating()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
