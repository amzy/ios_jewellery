//
//  UIScrollView.swift
//  PocketSeed
//
//  Created by Amzad Khan on 20/07/17.
//  Copyright © 2017 Prakash Bhadrecha. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
    var currentPage: Int {
        return Int((self.contentOffset.x + (0.5*self.frame.size.width))/self.frame.width)+1
    }
}
