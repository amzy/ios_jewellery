//
//  BannerCell.swift
//  EzyParent
//
//  Created by Himanshu Parashar on 28/12/16.
//  Copyright © 2016 SyonInfomedia. All rights reserved.
//

import UIKit

public extension Identifiers {
    static let kBannerCell    = "BannerCell"
}

class BannerCell: UICollectionViewCell {
    @IBOutlet weak var gradientImage: UIImageView!
    @IBOutlet weak var image: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
