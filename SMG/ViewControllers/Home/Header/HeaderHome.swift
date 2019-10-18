//
//  TitleHeader.swift
//
//  Created by Amzad Khan on 11/05/17.
//  Copyright © 2017 Syon. All rights reserved.
//

import UIKit
public extension Identifiers {
    static let kCategoryHeader      = "HeaderHome"
    
}


protocol HeaderDelegate:NSObjectProtocol {
    func didTapViewAll(_ sender: UIView)
}

class HeaderHome: UITableViewHeaderFooterView {
    @IBOutlet weak var headerTitle:UILabel!
    @IBOutlet weak var headerCount:UILabel!

    @IBOutlet weak var headerViewAll: UIButton!
    @IBOutlet weak var headerView: UIView!
    
    weak var delegate: HeaderDelegate!
    
    @IBAction func tabOnViewAll(_ sender: Any) {
        delegate?.didTapViewAll(self)
    }
}
