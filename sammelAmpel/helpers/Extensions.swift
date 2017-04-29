//
//  Extensions.swift
//  sammelAmpel
//
//  Created by Patrick Valenta on 04.04.17.
//  Copyright © 2017 Patrick Valenta. All rights reserved.
//

import UIKit

public func randomNumber(range: ClosedRange<Int> = 1...6) -> Int {
    let min = range.lowerBound
    let max = range.upperBound
    return Int(arc4random_uniform(UInt32(1 + max - min))) + min
}

extension UserDefaults {
    static func isFirstLaunch() -> Bool {
        let hasBeenLaunchedBeforeFlag = "hasBeenLaunchedBeforeFlag"
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: hasBeenLaunchedBeforeFlag)
        if (isFirstLaunch) {
            UserDefaults.standard.set(true, forKey: hasBeenLaunchedBeforeFlag)
            UserDefaults.standard.synchronize()
        }
        return isFirstLaunch
    }
    
    static func isFirstAmpelCapture() -> Bool {
        let key = "isFirstAmpelCapture"
        let isFirstAmpelCapture = !UserDefaults.standard.bool(forKey: key)
        if (isFirstAmpelCapture) {
            UserDefaults.standard.set(true, forKey: key)
            UserDefaults.standard.synchronize()
        }
        return isFirstAmpelCapture
    }
    
    static func isFirstAmpelTagging() -> Bool {
        let key = "isFirstAmpelTaggin"
        let isFirstAmpelTagging = !UserDefaults.standard.bool(forKey: key)
        if (isFirstAmpelTagging) {
            UserDefaults.standard.set(true, forKey: key)
            UserDefaults.standard.synchronize()
        }
        return isFirstAmpelTagging
    }
    
    static func isUserBanned() -> Bool {
        let key = "isUserBanned"
        let isUserBanned = UserDefaults.standard.bool(forKey: key)
        return isUserBanned
    }
    
    static func setUserBanned() {
        let key = "isUserBanned"
        UserDefaults.standard.set(true, forKey: key)
        UserDefaults.standard.synchronize()
    }
}

extension UIViewController {
    
    func addHideKeyboardTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard(withSender:)))
        
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard(withSender sender: AnyObject) {
        
        if let gestureRecognizer = sender as? UITapGestureRecognizer {
            view.removeGestureRecognizer(gestureRecognizer)
        }
        
        view.endEditing(true)
    }
}

extension UIButton {
    
    func centerImageAndTitle(withSpacing spacing: CGFloat) {
        
        let imageSize = self.imageView?.frame.size
        let titleSize = self.titleLabel?.frame.size
        
        if let imageSize = imageSize, let titleSize = titleSize {
            let totalHeight = imageSize.height + titleSize.height + spacing
            
            self.imageEdgeInsets = UIEdgeInsetsMake(-(totalHeight - imageSize.height), 2, 0, -titleSize.width)

            self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, -(totalHeight - titleSize.height), 0)
        }
        
    }
    
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    func setBackgroundColor(color: UIColor, forUIControlState state: UIControlState) {
        self.setBackgroundImage(imageWithColor(color: color), for: state)
    }
    
}

extension UIImage {
    
    func rotate() -> UIImage? {
        var flip:Bool = false //used to see if the image is mirrored
        var isRotatedBy90:Bool = false // used to check whether aspect ratio is to be changed or not
        
        var transform = CGAffineTransform.identity
        
        //check current orientation of original image
        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.rotated(by: CGFloat(M_PI));
            
        case .left, .leftMirrored:
            transform = transform.rotated(by: CGFloat(M_PI_2));
            isRotatedBy90 = true
        case .right, .rightMirrored:
            transform = transform.rotated(by: CGFloat(-M_PI_2));
            isRotatedBy90 = true
        case .up, .upMirrored:
            break
        }
        
        switch self.imageOrientation {
            
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            flip = true
            
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0)
            flip = true
        default:
            break;
        }
        
        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPoint(x:0, y:0), size: size))
        rotatedViewBox.transform = transform
        let rotatedSize = rotatedViewBox.frame.size
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap!.translateBy(x: rotatedSize.width / 2.0, y: rotatedSize.height / 2.0);
        
        // Now, draw the rotated/scaled image into the context
        var yFlip: CGFloat
        
        if(flip){
            yFlip = CGFloat(-1.0)
        } else {
            yFlip = CGFloat(1.0)
        }
        
        bitmap!.scaleBy(x: yFlip, y: -1.0)
        
        //check if we have to fix the aspect ratio
        if isRotatedBy90 {
            bitmap?.draw(self.cgImage!, in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.height,height: size.width))
        } else {
            bitmap?.draw(self.cgImage!, in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width,height: size.height))
        }
        
        let fixedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return fixedImage
    }
}

extension UIColor {
    static var backgroundGray: UIColor {
        //        return UIColor(red: 238/255, green: 236/255, blue: 244/255, alpha: 1)
        //        return UIColor(r: 232, g: 236, b: 241)
        return UIColor(r: 235, g: 235, b: 242)
    }
}

extension Date {
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}
