//
//  CardView.swift
//  Kassimbaba Rider
//
//  Created by Himanshu Parashar on 21/02/17.
//  Copyright © 2017 SyonInfomedia. All rights reserved.
//

import UIKit

@IBDesignable
class CardView: UIView {
    //@IBInspectable var cornerRadius: CGFloat = 2
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 0
    @IBInspectable var shadowColor: UIColor? = UIColor.black
    @IBInspectable var shadowOpacity: Float = 0.5
    @IBInspectable var shadowRadius: CGFloat = 3.0
    
    override func layoutSubviews() {
        
        
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
        layer.shadowRadius = shadowRadius
 
        
        
        //self.addShadowWithRoundedCorners()
    }
    private func addShadowWithRoundedCorners() {
        if let contents = self.layer.contents {
            
            self.layer.masksToBounds = false
            self.layer.sublayers?.filter{ $0.frame.equalTo(self.layer.bounds) }
                .forEach{ $0.cornerRadius = self.cornerRadius }
            
            self.layer.contents = nil
            
            if let sublayer = self.layer.sublayers?.first,
                sublayer.name == "ContentLayer" {
                
                sublayer.removeFromSuperlayer()
            }
            
            let contentLayer = CALayer()
            contentLayer.name = "ContentLayer"
            contentLayer.contents = contents
            contentLayer.frame = bounds
            contentLayer.cornerRadius = cornerRadius
            contentLayer.masksToBounds = true
            
            self.layer.insertSublayer(contentLayer, at: 0)
        }
    }

}

extension CALayer {
    func addShadow() {
        self.shadowOffset = .zero
        self.shadowOpacity = 0.5
        self.shadowRadius = 3
        self.shadowColor = UIColor.black.cgColor
        self.masksToBounds = false
        
        if cornerRadius != 0 {
            addShadowWithRoundedCorners()
        }
    }
    private func addShadowWithRoundedCorners() {
        if let contents = self.contents {
            
            masksToBounds = false
            sublayers?.filter{ $0.frame.equalTo(self.bounds) }
                .forEach{ $0.roundCorners(radius: self.cornerRadius) }
            
            self.contents = nil
            
            if let sublayer = sublayers?.first,
                sublayer.name == "ContentLayer" {
                
                sublayer.removeFromSuperlayer()
            }
            
            let contentLayer = CALayer()
            contentLayer.name = "ContentLayer"
            contentLayer.contents = contents
            contentLayer.frame = bounds
            contentLayer.cornerRadius = cornerRadius
            contentLayer.masksToBounds = true
            
            insertSublayer(contentLayer, at: 0)
        }
    }
    func roundCorners(radius: CGFloat) {
        self.cornerRadius = radius
        if shadowOpacity != 0 {
            addShadowWithRoundedCorners()
        }
    }
}

