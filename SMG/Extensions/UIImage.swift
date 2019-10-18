//
//  Created by Himanshu Parashar on 11/08/15.
//  Copyright (c) 2015 Syon Infomedia. All rights reserved.
//

import UIKit

public extension UIImage {
    
    var highestQualityJPEGData: Data { return UIImageJPEGRepresentation(self, 1.0)! }
    var highQualityJPEGData: Data    { return UIImageJPEGRepresentation(self, 0.75)!}
    var mediumQualityJPEGData: Data  { return UIImageJPEGRepresentation(self, 0.5)! }
    var lowQualityJPEGData: Data     { return UIImageJPEGRepresentation(self, 0.25)!}
    var lowestQualityJPEGData: Data  { return UIImageJPEGRepresentation(self, 0.0)! }
    
    /*convenience init?(named:String, color:UIColor) {
        self.init(named: named)
        
        DispatchQueue.main.async(execute: {
            self.imageWithTintColor(color)
        })
    }*/
    class public func image(from layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContext(layer.frame.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage!
    }
    
    public func imageWithTintColor(_ color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0);
        context?.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height) as CGRect
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    public func croppedImage(_ bound : CGRect) -> UIImage {
        let scaledBounds : CGRect = CGRect(x: bound.origin.x * self.scale, y: bound.origin.y * self.scale, width: bound.size.width * self.scale, height: bound.size.height * self.scale)
        let imageRef = (self.cgImage)?.cropping(to: scaledBounds)
        let croppedImage : UIImage! = UIImage(cgImage: imageRef!, scale: self.scale, orientation: UIImageOrientation.up)
        return croppedImage;
    }
    
    public func getImageWithColor(_ color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    public func imageWithOrientation(_ orientation : UIImageOrientation) -> UIImage {
        /*
        case Up // default orientation
        case Down // 180 deg rotation
        case Left // 90 deg CCW
        case Right // 90 deg CW
        case UpMirrored // as above but image mirrored along other axis. horizontal flip
        case DownMirrored // horizontal flip
        case LeftMirrored // vertical flip
        case RightMirrored // vertical flip
        */
        
        let orientedImage:UIImage = UIImage(cgImage: self.cgImage!, scale: self.scale, orientation: orientation)
        
        return orientedImage;
    }
    func merge(otherImage image:UIImage) -> UIImage {
        //create drawing context
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale);
        let imageSize  = image.size
        let thisSize = self.size
        
        let widthDiff = thisSize.width - imageSize.width
        let heightDiff = thisSize.height - imageSize.height
        
        let dx = widthDiff/2
        let dy = heightDiff/2

        let thisRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let imageRect = UIEdgeInsetsInsetRect(thisRect, UIEdgeInsetsMake(dy, dx, dy, dx))
        //draw
        
        self.draw(in:  thisRect)
        image.draw(in:  imageRect, blendMode: CGBlendMode.normal, alpha: 1)
        
        //capture resultant image
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        
        //return image
        return image;
    }
    
    public class func videoImage(forURL url:URL, withPlayIcon icon:Bool, hadler:@escaping ((_ image:UIImage?, _ error:Error?) ->Void)) {
        DispatchQueue.global().async {
            do {
                let imgGenerator = AVAssetImageGenerator(asset: AVAsset(url: url))
                imgGenerator.appliesPreferredTrackTransform = true
                let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
                let thumbnail = UIImage(cgImage: cgImage)
                var returnValue:UIImage = thumbnail.fixOrientation()
                if icon {
                    returnValue = thumbnail.merge(otherImage: #imageLiteral(resourceName: "btn_play"))
                }
                DispatchQueue.main.async(execute: {
                    hadler(returnValue, nil)
                    //self.btnClickHere.setTitle("", for: .normal)
                })
                // thumbnail here
            } catch let error {
                hadler(nil, error)
                print("*** Error generating thumbnail: \(error.localizedDescription)")
            }
        }
    }

    
    
    /*public func imageRotatedByDegrees(_ degrees: CGFloat, flip: Bool) -> UIImage {
        let radiansToDegrees: (CGFloat) -> CGFloat = {
            return $0 * (180.0 / CGFloat(M_PI))
        }
        let degreesToRadians: (CGFloat) -> CGFloat = {
            return $0 / 180.0 * CGFloat(M_PI)
        }
        
        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPoint.zero, size: size))
        let t = CGAffineTransform(rotationAngle: degreesToRadians(degrees));
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap?.translateBy(x: rotatedSize.width / 2.0, y: rotatedSize.height / 2.0);
        
        //   // Rotate the image context
        bitmap?.rotate(by: degreesToRadians(degrees));
        
        // Now, draw the rotated/scaled image into the context
        var yFlip: CGFloat
        
        if(flip){
            yFlip = CGFloat(-1.0)
        } else {
            yFlip = CGFloat(1.0)
        }
        
        bitmap?.scaleBy(x: yFlip, y: -1.0)
        bitmap.draw(CGImage, in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }*/
    
    /*************************************************************/
     //MARK:- Create image White Border and cornerRadius
     /*************************************************************/
    public func createWhiteBorder(_ image:UIImage, borderWidth: CGFloat, cornerRadius: CGFloat) -> UIImage {
        
        // Create a multiplier to scale up the corner radius and border
        // width you decided on relative to the imageViewer frame such
        // that the corner radius and border width can be converted to
        // the UIImage's scale.
        let multiplier:CGFloat = image.size.height/image.size.height > image.size.width/image.size.width ?
            image.size.height/image.size.height :
            image.size.width/image.size.width
        
        let borderWidthMultiplied:CGFloat = borderWidth * multiplier
        let cornerRadiusMultiplied:CGFloat = cornerRadius * multiplier
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0)
        
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height).insetBy(dx: borderWidthMultiplied / 2, dy: borderWidthMultiplied / 2), cornerRadius: cornerRadiusMultiplied)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.saveGState()
        // Clip the drawing area to the path
        path.addClip()
        
        // Draw the image into the context
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        context?.restoreGState()
        
        // Configure the stroke
        UIColor.white.setStroke()
        path.lineWidth = borderWidthMultiplied
        
        // Stroke the border
        path.stroke()
        
        let finalImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return finalImg!
    }
    
    /*************************************************************/
     //MARK:- Resize and Square UIImage
     /*************************************************************/
    public func squareImageTo(_ image: UIImage, size: CGSize) -> UIImage {
        //return resizeImage(squareImage(image), targetSize: size)
        return squareImage(resizeImage(image, targetSize: size))
    }
    
    public func squareImage(_ image: UIImage) -> UIImage {
        let originalWidth  = image.size.width
        let originalHeight = image.size.height
        
        var edge: CGFloat
        if originalWidth > originalHeight {
            edge = originalHeight
        } else {
            edge = originalWidth
        }
        
        let posX = (originalWidth  - edge) / 2.0
        let posY = (originalHeight - edge) / 2.0
        
        let cropSquare = CGRect(x: posX, y: posY, width: edge, height: edge)
        
        let imageRef = (image.cgImage)?.cropping(to: cropSquare);
        return UIImage(cgImage: imageRef!, scale: UIScreen.main.scale, orientation: image.imageOrientation)
    }
    
    public func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let imageData:Data = UIImageJPEGRepresentation(newImage!, 0.5)!
        UIGraphicsEndImageContext()
        
        return UIImage(data: imageData)!

    }
    


}
import AVFoundation

extension UIImage {
    
    func imageScaledToFit(to size: CGSize) -> UIImage {
        let scaledRect = AVMakeRect(aspectRatio: self.size, insideRect: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(size.width), height: CGFloat(size.height)))
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        draw(in: scaledRect)
        let scaledImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
    func image(scaledToWidth width: CGFloat) -> UIImage {
        let oldWidth = self.size.width
        let scaleFactor = width / oldWidth
        
        let newHeight = self.size.height * scaleFactor
        let newWidth = oldWidth * scaleFactor
        
        UIGraphicsBeginImageContext(CGSize(width:newWidth, height:newHeight))
        self.draw(in: CGRect(x:0, y:0, width:newWidth, height:newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

public extension UIImage {
    
    /// Extension to fix orientation of an UIImage without EXIF
    func fixOrientation() -> UIImage {
        
        guard let cgImage = cgImage else { return self }
        
        if imageOrientation == .up { return self }
        
        var transform = CGAffineTransform.identity
        
        switch imageOrientation {
            
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
            
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi/2))
            
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat(-Double.pi/2))
            
        case .up, .upMirrored:
            break
        }
        
        switch imageOrientation {
            
        case .upMirrored, .downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            
        case .leftMirrored, .rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
            
        case .up, .down, .left, .right:
            break
        }
        
        if let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: cgImage.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) {
            
            ctx.concatenate(transform)
            
            switch imageOrientation {
                
            case .left, .leftMirrored, .right, .rightMirrored:
                ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
                
            default:
                ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            }
            
            if let finalImage = ctx.makeImage() {
                return (UIImage(cgImage: finalImage))
            }
        }
        
        // something failed -- return original
        return self
    }
}

import Photos

extension UIImage {
    static func from(info: [String:Any]) -> UIImage? {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            return image
        }
        var imageToBeReturned: UIImage?
        if let url = info[UIImagePickerControllerReferenceURL] as? URL,
            let asset = PHAsset.fetchAssets(withALAssetURLs: [url], options: nil).firstObject {
            let manager = PHImageManager.default()
            let option = PHImageRequestOptions()
            option.isSynchronous = true
            manager.requestImage(for: asset, targetSize: CGSize(width:1000, height:1000), contentMode: .aspectFit, options: option, resultHandler:{(image: UIImage?, info: [AnyHashable : Any]?) in
                imageToBeReturned = image
            })
        }
        return imageToBeReturned
    }
}
