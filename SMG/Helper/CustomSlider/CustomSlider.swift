//
//  CustomSlider.swift
//
//  Created by Amzad Khan on 15/05/17.
//  Copyright © 2017 SyonInfomedia. All rights reserved.
//

import Foundation
import UIKit

public class CustomSlider: UISlider {
    
    var label: UILabel
    var labelXMin: CGFloat?
    var labelXMax: CGFloat?
    var labelText: ()->String = { "" }
    
    var decBtn: UIButton?
    var incBtn: UIButton?
    public var incrementValue: Float = 1.0
    
    public override func awakeFromNib() {
        
        label = UILabel()
        self.addTarget(self, action: #selector(onValueChanged(sender:)), for: .valueChanged)
        super.awakeFromNib()
    }
    
    required public init(coder aDecoder: NSCoder) {
        label = UILabel()
        super.init(coder: aDecoder)!
        self.addTarget(self, action: #selector(onValueChanged(sender:)), for: .valueChanged)
        
    }
    func setup(){
        
        labelXMin = frame.origin.x + 16
        labelXMax = frame.origin.x + self.frame.width - 14
        
        let labelXOffset: CGFloat       = labelXMax! - labelXMin!
        let valueOffset:    CGFloat     = CGFloat(self.maximumValue - self.minimumValue)
        let valueDifference: CGFloat    = CGFloat(self.value - self.minimumValue)
        let valueRatio: CGFloat         = CGFloat(valueDifference/valueOffset)
        let labelXPos                   = CGFloat(labelXOffset*valueRatio + labelXMin!)
        
        label.frame = CGRect(x: labelXPos, y: self.frame.origin.y - 20, width: 200, height: 20)
        //label.text  = self.value.description
        label.text = "\(Int(self.value))"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.green
        self.tintColor = UIColor.green
        self.superview!.addSubview(label)
        
        //self.addButtons()
        
    }
    func updateLabel(){
        
        label.text = labelText()
        
        let labelXOffset: CGFloat       = labelXMax! - labelXMin!
        let valueOffset: CGFloat        = CGFloat(self.maximumValue - self.minimumValue)
        let valueDifference: CGFloat    = CGFloat(self.value - self.minimumValue)
        let valueRatio: CGFloat = CGFloat(valueDifference/valueOffset)
        let labelXPos = CGFloat(labelXOffset*valueRatio + labelXMin!)
        label.frame = CGRect(x: labelXPos - label.frame.width/2, y: self.frame.origin.y - 20,  width: 200, height: 20)
        label.textAlignment = NSTextAlignment.center
        self.superview!.addSubview(label)
    }
    public override func layoutSubviews() {
        //labelText = { self.value.description }
        labelText = { "\(Int(self.value))" }
        setup()
        updateLabel()
        super.layoutSubviews()
        super.layoutSubviews()
    }
    
    @objc func onValueChanged(sender: CustomSlider){
        
        let roundedValue = round(sender.value / incrementValue) * incrementValue
        sender.value = roundedValue
        
        updateLabel()
    }

}
extension CustomSlider {
    
    func addButtons() {
        
        decBtn = UIButton(type: UIButtonType.system)
        decBtn!.setTitle("-", for: UIControlState.normal)
        decBtn!.titleLabel!.font = UIFont.systemFont(ofSize: 30)
        decBtn!.frame = CGRect(x: self.frame.origin.x - 25,  y: self.frame.origin.y+2, width: 25, height: 25)
        
        decBtn!.titleEdgeInsets     = UIEdgeInsets(top: -5, left: 0, bottom: 0, right: 0)
        decBtn!.layer.cornerRadius  = 12
        decBtn!.layer.borderWidth   = 1
        decBtn!.layer.borderColor   = UIColor.gray.cgColor
        decBtn!.addTarget(self, action: #selector(decrement(sender:)), for: UIControlEvents.touchDown)
        
        self.superview!.addSubview(decBtn!)
        
        incBtn = UIButton(type: UIButtonType.system)
        incBtn!.setTitle("+", for: UIControlState.normal)
        incBtn!.titleLabel!.font = UIFont.systemFont(ofSize: 30)
        incBtn!.frame = CGRect(x: self.frame.origin.x + self.frame.width, y:  self.frame.origin.y+2, width: 25, height: 25)
        
        incBtn!.layer.cornerRadius = 12
        incBtn!.layer.borderWidth = 1
        incBtn!.layer.borderColor = UIColor.gray.cgColor
        incBtn!.addTarget(self, action: #selector(increment(sender:)), for: UIControlEvents.touchDown)
        
        self.superview!.addSubview(incBtn!)
    }
    
    @objc func increment(sender: UIButton){
        _ = self.value
        self.value += Float(incrementValue)
        updateLabel()
    }
    @objc func decrement(sender: UIButton){
        _ = self.value
        self.value -= Float(incrementValue)
        updateLabel()
    }
}
