//
//  CustomLabel.swift
//  
//
//  Created by Himanshu Parashar on 17/07/15.
//  Copyright (c) 2015 syoninfomedia. All rights reserved.
//

import UIKit

class CustomLeftTopLabel: UILabel {
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        var draw = self.textRect(forBounds: rect, limitedToNumberOfLines: self.numberOfLines)
        draw.origin = CGPoint.zero
        super.drawText(in: draw)
    }
}
