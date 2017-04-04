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

extension Date {
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}
