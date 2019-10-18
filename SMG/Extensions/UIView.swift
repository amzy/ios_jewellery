//
//  Created by Amzad Khan on 11/08/15.
//  Copyright (c) 2015 Syon Infomedia. All rights reserved.
//

import UIKit

public extension UIView {
    
    public class func loadNib<T: UIView>(_ viewType: T.Type) -> T {
        let className = String.className(viewType)
        return Bundle(for: viewType).loadNibNamed(className, owner: nil, options: nil)!.first as! T
    }
    
    public class func loadNib() -> Self {
        return loadNib(self)
    }
    
    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    public func getSnapshot(_ view: UIView) -> UIImage {
        
        var captureImage: UIImage
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, UIScreen.main.scale)
        
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        
        captureImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return captureImage
    }
    
    public func getSnapshot() -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    public func getSnapshotWithSize(_ size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        //Originaly ------self.bounds
        //For viewcontroller ------- Only
        var rect:CGRect = self.bounds
        rect.origin.y = -64
        drawHierarchy(in: rect, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    public func makeBlurView(_ view: UIView, effectStyle: UIBlurEffectStyle) {
        
        let blurEffect = UIBlurEffect(style: effectStyle) //UIBlurEffectStyle.Light
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        view.addSubview(blurEffectView)
    }
    
    public var width:      CGFloat { return self.frame.size.width }
    public var height:     CGFloat { return self.frame.size.height }
    public var size:       CGSize  { return self.frame.size}
    
    public var origin:     CGPoint { return self.frame.origin }
    public var x:          CGFloat { return self.frame.origin.x }
    public var y:          CGFloat { return self.frame.origin.y }
    public var centerX:    CGFloat { return self.center.x }
    public var centerY:    CGFloat { return self.center.y }
    
    public var left:       CGFloat { return self.frame.origin.x }
    public var right:      CGFloat { return self.frame.origin.x + self.frame.size.width }
    public var top:        CGFloat { return self.frame.origin.y }
    public var bottom:     CGFloat { return self.frame.origin.y + self.frame.size.height }
    
    public func setWidth(_ width:CGFloat) {
        self.frame.size.width = width
    }
    
    public func setHeight(_ height:CGFloat) {
        self.frame.size.height = height
    }
    
    public func setSize(_ size:CGSize) {
        self.frame.size = size
    }
    
    public func setOrigin(_ point:CGPoint) {
        self.frame.origin = point
    }
    
    public func setX(_ x:CGFloat) {
        //only change the origin x
        self.frame.origin = CGPoint(x: x, y: self.frame.origin.y)
    }
    
    public func setY(_ y:CGFloat) {
        //only change the origin x
        self.frame.origin = CGPoint(x: self.frame.origin.x, y: y)
    }
    
    public func setCenterX(_ x:CGFloat) {
        //only change the origin x
        self.center = CGPoint(x: x, y: self.center.y)
    }
    
    public func setCenterY(_ y:CGFloat) {
        //only change the origin x
        self.center = CGPoint(x: self.center.x, y: y)
    }
    
    public func roundCorner(_ radius:CGFloat) {
        self.layer.cornerRadius = radius
    }
    
    public func setTop(_ top:CGFloat) {
        self.frame.origin.y = top
    }
    
    public func setLeft(_ left:CGFloat) {
        self.frame.origin.x = left
    }
    
    public func setRight(_ right:CGFloat) {
        self.frame.origin.x = right - self.frame.size.width
    }
    
    public func setBottom(_ bottom:CGFloat) {
        self.frame.origin.y = bottom - self.frame.size.height
    }
    
    func makeCircular(borderWidth: CGFloat = 0, borderColor: UIColor = UIColor.white) {
        let radius = min(self.bounds.height, self.bounds.width) / 2.0
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
    
    func roundedCorner(borderWidth: CGFloat = 0, borderColor: UIColor = UIColor.white) {
        let radius = min(self.bounds.height, self.bounds.width) / 2.0
        self.layer.cornerRadius = radius / 5
        self.layer.masksToBounds = true
        
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
    
    func makeCircular1() {
        let cntr:CGPoint = self.center
        self.layer.borderWidth = 3.0
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = min(self.frame.size.height, self.frame.size.width) / 2.0
        self.center = cntr
        // self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
    
    func makeCircularWithShadow() {
        let cntr:CGPoint = self.center
        self.layer.cornerRadius = min(self.frame.size.height, self.frame.size.width) / 2.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 0.5
        
        self.center = cntr
        
        self.clipsToBounds = true
    }
    
    public func drawPolygon(strokeWidth width: CGFloat?, strokeColor: UIColor?) {
        
        layer.sublayers?
            .filter  { $0.name == "Polygon" }
            .forEach { $0.removeFromSuperlayer() }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.backgroundColor = UIColor.clear.cgColor
        shapeLayer.name = "Polygon"
        shapeLayer.path = UIBezierPath().getPolygon(self.frame, scale: 1, sides: 4).cgPath
        
        shapeLayer.fillRule = kCAFillRuleNonZero
        self.layer.mask = shapeLayer
        
        if let width = width, let color = strokeColor {
            shapeLayer.lineWidth = width
            shapeLayer.strokeColor = color.cgColor
            //shapeLayer.fillColor = COLOR_BLACK.CGColor
        }
    }
}

extension UIView {
    
    /// Flip view horizontally.
    func flipX() {
        transform = CGAffineTransform(scaleX: -transform.a, y: transform.d)
    }
    func flipCustomX() {
        transform = CGAffineTransform(a: transform.a, b: transform.b, c: -transform.c, d: transform.d, tx: transform.tx, ty: transform.ty)
    }
    
    /// Flip view vertically.
    func flipY() {
        transform = CGAffineTransform(scaleX: transform.a, y: -transform.d)
    }
    
}

extension UIView {
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        self.layer.add(animation, forKey: nil)
    }
    
}

extension UIView {
    
    func slideWithTransition(type: String, duration: TimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        // Create a CATransition animation
        let slideInFromLeftTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided (if any)
        /*if let delegate = completionDelegate { //uncomment this line when use
         slideInFromLeftTransition.delegate = delegate
         }*/
        
        // Customize the animation's properties
        slideInFromLeftTransition.type = kCATransitionPush
        slideInFromLeftTransition.subtype = type
        //kCATransitionFromTop, kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromBottom
        
        slideInFromLeftTransition.duration = duration
        slideInFromLeftTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        slideInFromLeftTransition.fillMode = kCAFillModeRemoved
        
        // Add the animation to the View's layer
        if type == kCATransitionFromRight {
            self.layer.add(slideInFromLeftTransition, forKey: "slideInFromRightTransition")
        } else if type == kCATransitionFromLeft {
            self.layer.add(slideInFromLeftTransition, forKey: "slideInFromLeftTransition")
        } else if type == kCATransitionFromTop {
            self.layer.add(slideInFromLeftTransition, forKey: "slideInFromTopTransition")
        } else if type == kCATransitionFromBottom {
            self.layer.add(slideInFromLeftTransition, forKey: "slideInFromBottomTransition")
        } else {
        }
    }
}

//MARK:- Nib Load Methods.
extension UIView {
    class func fromNib<T : UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}

/*extension MapSearchVC  {
 
 override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
 print("Animation stopped")
 }
 }
 
 NOTE: Call from your view controller when hide show
 
 filterView?.hidden = hidden
 //filterView.slideWithTransition(kCATransitionFromBottom)
 filterView.slideWithTransition(kCATransitionFromLeft, duration: 1.0, completionDelegate: self)
 }*/
public extension UIView {
    
    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    public func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            // Fallback on earlier versions
            UIGraphicsBeginImageContext(self.bounds.size);
            self.layer.render(in: UIGraphicsGetCurrentContext()!)
            let screenShot = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return screenShot!
        }
    }
}

//MARK:- Gradient Helper methods

public enum GradientPoint {
    
    case leftRight
    case rightLeft
    case topBottom
    case bottomTop
    case topLeftBottomRight
    case bottomRightTopLeft
    case topRightBottomLeft
    case bottomLeftTopRight
    
    func points() -> (startPoint:CGPoint, endPoint:CGPoint) {
        switch self {
        case .leftRight:
            return (startPoint: CGPoint(x: 0, y: 0.5), endPoint: CGPoint(x: 1, y: 0.5))
        case .rightLeft:
            return (startPoint: CGPoint(x: 1, y: 0.5), endPoint: CGPoint(x: 0, y: 0.5))
        case .topBottom:
            return (startPoint: CGPoint(x: 0.5, y: 0), endPoint: CGPoint(x: 0.5, y: 1))
        case .bottomTop:
            return (startPoint: CGPoint(x: 0.5, y: 1), endPoint: CGPoint(x: 0.5, y: 0))
        case .topLeftBottomRight:
            return (startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 1))
        case .bottomRightTopLeft:
            return (startPoint: CGPoint(x: 1, y: 1), endPoint: CGPoint(x: 0, y: 0))
        case .topRightBottomLeft:
            return (startPoint: CGPoint(x: 1, y: 0), endPoint: CGPoint(x: 0, y: 1))
        case .bottomLeftTopRight:
            return (startPoint: CGPoint(x: 0, y: 1), endPoint: CGPoint(x: 1, y: 0))
        }
    }
}
extension UIView {
    
    func applyLinearGradient(colors:[UIColor], locations:[NSNumber]? = [0.0,1.0], point:GradientPoint? = GradientPoint.leftRight) {
    
        self.backgroundColor = UIColor.clear
        
        
        if let layers = self.layer.sublayers {
            for layer in layers {
                if layer.name == "com.amzad.gradientLayer" {
                    layer.removeFromSuperlayer()
                }
            }
        }
        
        let gradientLayer   = CAGradientLayer()
        gradientLayer.frame = self.bounds
        let cgColors  = colors.map { (color) -> CGColor in
            return color.cgColor
        }
        gradientLayer.colors        = cgColors //[color1, color2, color3, color4]
        gradientLayer.locations     = locations //[0.0, 0.25, 0.75, 1.0]
        let points  = point!.points()
        gradientLayer.startPoint    = points.startPoint
        gradientLayer.endPoint      = points.endPoint
        gradientLayer.cornerRadius = self.cornerRadius
        gradientLayer.name = "com.amzad.gradientLayer"
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    func applyRadialGradient(colors:[UIColor], center:CGPoint = CGPoint.zero, radius:Float = 0) {
        let gradientLayer   = RadialGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors
        gradientLayer.center = center
        gradientLayer.radius = CGFloat(radius)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension UIView {
    
    func linearGradient(with color1:UIColor, color2:UIColor, vertical:Bool = false, firstColorRatio:Double = 0.5) {
        
        let gradientLayer       = CAGradientLayer()
        gradientLayer.frame     = self.bounds
        gradientLayer.colors    = [color1.cgColor, color1.cgColor]
        
        if vertical {
            gradientLayer.startPoint = CGPoint(x:0.5, y:0.0)
            gradientLayer.endPoint  = CGPoint(x:0.5, y:1.0)
        }else {
            gradientLayer.startPoint = CGPoint(x:0.0, y:0.5)
            gradientLayer.endPoint = CGPoint(x:1.0, y:0.5)
        }
        let value:Double  = 1.0 - firstColorRatio
        gradientLayer.locations = [1, 0]
        gradientLayer.locations = [0.0, NSNumber(floatLiteral: value)]
        self.layer.addSublayer(gradientLayer)
    }
}

public class RadialGradientLayer: CALayer {
    
    public var center:CGPoint = CGPoint.zero
    public var radius:CGFloat = 0
    public var colors = [UIColor]()
    
    required override public init() {
        super.init()
        needsDisplayOnBoundsChange = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required override public init(layer: Any) {
        super.init(layer: layer)
    }
    
    override public func draw(in ctx: CGContext) {
        ctx.saveGState()
        let colorSpace  = CGColorSpaceCreateDeviceRGB()
        var locations   = [CGFloat]()
        for i in 0...colors.count-1 {
            locations.append(CGFloat(i) / CGFloat(colors.count))
        }
        let cgColors  = colors.map { (color) -> CGColor in
            return color.cgColor
        }
        
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: cgColors as CFArray, locations: locations) else {
            print("Unable to create radial gradient!")
            return
        }
        
        var center = self.center
        if center == CGPoint.zero {
            center = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
        }
        var radius = self.radius
        if radius == 0 {
            radius = min(bounds.width / 2.0, bounds.height / 2.0)
        }
        ctx.drawRadialGradient(gradient, startCenter: center, startRadius: 0.0, endCenter: center, endRadius: radius, options: CGGradientDrawingOptions(rawValue: 0))
    }
}

extension UIView {
    private struct AssociatedKey {
        static var barLabel           = "mz_UIView.barLabel"
        static var isBarHidden        = "mz_UIView.isBarHidden"
    }
    
    fileprivate var bottomBar: UILabel {
        get {
            if let obj  = objc_getAssociatedObject(self, &AssociatedKey.barLabel)  {
                return obj as! UILabel
            }else {
                let aLabel  = UILabel()
                objc_setAssociatedObject(self, &AssociatedKey.barLabel, aLabel, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return aLabel
            }
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.barLabel, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.draw(self.frame)
        }
    }
    var isBottomBarHidden : Bool {
        get {
            if let obj  = objc_getAssociatedObject(self, &AssociatedKey.isBarHidden) as? String, obj == "1" {
                return true
            }else {
                return false
            }
        }
        set {
            if newValue == true {
                if self.bottomBar.superview != nil {
                    self.bottomBar.removeFromSuperview()
                }
            }else {
                if self.bottomBar.superview == nil {
                    self.addSubview(bottomBar)
                    let bottomConstraint = NSLayoutConstraint(item: bottomBar, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
                    let leading = NSLayoutConstraint(item: bottomBar, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
                    let trailing = NSLayoutConstraint(item: bottomBar, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
                    let heightConstarint = NSLayoutConstraint(item: bottomBar, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: CGFloat(0.5))
                    bottomBar.addConstraints([heightConstarint])
                    self.addConstraints([bottomConstraint,leading,trailing])
                    self.bringSubview(toFront: bottomBar);
                }
            }
            objc_setAssociatedObject(self, &AssociatedKey.isBarHidden, newValue ? "1" : "0", .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.draw(self.frame)
        }
    }
}
