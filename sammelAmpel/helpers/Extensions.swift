//
//  Extensions.swift
//  sammelAmpel
//
//  Created by Patrick Valenta on 04.04.17.
//  Copyright © 2017 Patrick Valenta. All rights reserved.
//

import UIKit

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
            
            self.imageEdgeInsets = UIEdgeInsetsMake(-(totalHeight - imageSize.height), 6, 0, -titleSize.width)

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
