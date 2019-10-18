//
//  UIView+NSLayout.swift
//
//  Created by Amzad Khan on 26/07/17.
//  Copyright © 2017 Amzad Khan. All rights reserved.
//

import Foundation
import UIKit

public enum Edge:Int {
    
    case left
    case right
    case top
    case bottom
    case leading
    case trailing
    
    var value:NSLayoutAttribute {
        
        switch self {
        case .left:     return NSLayoutAttribute.left
        case .right:    return NSLayoutAttribute.right
        case .top:      return NSLayoutAttribute.top
        case .bottom:   return NSLayoutAttribute.bottom
        case .leading:  return NSLayoutAttribute.leading
        case .trailing: return NSLayoutAttribute.trailing
        }
    }
}
public enum Axis:Int {
    
    case centerX
    case centerY
    
    var value:NSLayoutAttribute {
        switch self {
        case .centerX:  return NSLayoutAttribute.centerX
        case .centerY:  return NSLayoutAttribute.centerY
        }
    }
}
public enum Dimension:Int {
    
    case width
    case height
    
    var value:NSLayoutAttribute {
        switch self {
        case .width:    return NSLayoutAttribute.width
        case .height:   return NSLayoutAttribute.height
        }
    }
}

public extension UIView  {

    @discardableResult func autoAlignAxis(axis:Axis, toView:UIView? = nil, offset:CGFloat = 0.0) ->Bool {
        guard let parent  = self.superview else {return false}
        if let view = toView {
            if view == parent {
                let centerX = NSLayoutConstraint(item: self, attribute: axis.value, relatedBy: .equal, toItem: view, attribute: axis.value, multiplier: 1, constant: offset)
                parent.addConstraint(centerX)
            }else if let otherParent  = view.superview, parent ==  otherParent  {
                let centerX = NSLayoutConstraint(item: self, attribute: axis.value, relatedBy: .equal, toItem: view, attribute: axis.value, multiplier: 1, constant: offset)
                parent.addConstraint(centerX)
            }else { return false }
        }else {
            let centerX = NSLayoutConstraint(item: self, attribute: axis.value, relatedBy: .equal, toItem: parent, attribute: axis.value, multiplier: 1, constant: offset)
            parent.addConstraint(centerX)
        }
        return true
    }
    
    @discardableResult func autoPinEdge(edge:Edge, offset:CGFloat = 0.0, relatedBy:NSLayoutRelation = .equal)->Bool {
        return self.autoPinEdge(edge: edge, toEdge: edge)
    }
    
    @discardableResult func autoPinEdge(edge:Edge,  toEdge:Edge, toView:UIView? = nil, offset:CGFloat = 0.0, relatedBy:NSLayoutRelation = .equal) ->Bool {
        guard let parent  = self.superview else {return false}
        if let view = toView {
            if view == parent {
                let const = NSLayoutConstraint(item: self, attribute: edge.value, relatedBy: relatedBy, toItem: parent, attribute: toEdge.value, multiplier: 1, constant: offset)
                parent.addConstraint(const)
            }else if let otherParent  = view.superview, parent ==  otherParent  {
                let const = NSLayoutConstraint(item: self, attribute: edge.value, relatedBy: relatedBy, toItem: view, attribute: toEdge.value, multiplier: 1, constant: offset)
                parent.addConstraint(const)
            }else { return false }
        }else {
            let const = NSLayoutConstraint(item: self, attribute: edge.value, relatedBy: relatedBy, toItem: parent, attribute: toEdge.value, multiplier: 1, constant: offset)
            parent.addConstraint(const)
        }
        return true
    }
    
    @discardableResult func autoSetDimension(dimension:Dimension, value:CGFloat, relatedBy:NSLayoutRelation = .equal) ->Bool {
        let const = NSLayoutConstraint(item: self, attribute: dimension.value, relatedBy: relatedBy, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: value)
        self.addConstraint(const)
        return true
    }
    @discardableResult func autoEqualDimension(dimension:Dimension, view:UIView) ->Bool {
        guard let parent  = self.superview, let otherParent  = view.superview, parent ==  otherParent else {return false}
        let const = NSLayoutConstraint(item: self, attribute: dimension.value, relatedBy: .equal, toItem: view, attribute: dimension.value, multiplier: 1, constant: 0)
        parent.addConstraint(const)
        return true
    }
}
