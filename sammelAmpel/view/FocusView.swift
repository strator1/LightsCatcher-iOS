//
//  FocusView.swift
//  sammelAmpel
//
//  Created by Patrick Valenta on 12.04.17.
//  Copyright © 2017 Patrick Valenta. All rights reserved.
//

import UIKit

class FocusView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 5
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowRadius = 10.0
        layer.shadowOpacity = 0.9
        layer.shadowOffset = CGSize.zero
        layer.masksToBounds = false
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
