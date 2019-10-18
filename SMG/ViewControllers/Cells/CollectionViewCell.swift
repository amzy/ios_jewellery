//
//  CollectionViewCell.swift
//
//  Created by Amzad Khan on 21/08/18.
//  Copyright © 2018 Amzad Khan. All rights reserved.
//

import Foundation
import UIKit

public extension Identifiers {
    static let kProductCell    = "ProductCell"
    static let kImageCell    = "ImageCell"
    
}

class ProductCell: UICollectionViewCell {
    
    @IBOutlet weak var image            : UIImageView!
    @IBOutlet weak var lblCode          : UILabel!
    @IBOutlet weak var lblPurity        : UILabel!
    @IBOutlet weak var lblWeight        : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(data:Product)  {
        if let url = data.featuredImgURL.makeURL() {
            self.image?.imageWithURL(url: url, placeholder: #imageLiteral(resourceName: "noImg"), handler: nil)
        }
        lblCode?.text = ": " + "\(data.sku ?? "")"
        lblPurity?.text = ": " + "\(data.purity ?? "")"
        if let weight = data.weight {
            lblWeight?.text = ": " +  "\(weight)"
        }else {
            lblWeight?.text = ": "
        }
    }
}


class DataCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var textDescription: LinkTextView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var btnDetailsData: UIButton!
}

class ImageCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
}
