//
//  FocusView.swift
//  sammelAmpel
//
//  Created by Patrick Valenta on 12.04.17.
//  Copyright © 2017 Patrick Valenta. All rights reserved.
//

import UIKit

class FocusView: UIView {
    
    let hCenterLine: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let vCenterLine: UIView = {
       let v = UIView()
        v.backgroundColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
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
        
        setupViews()
    }
    
    private func setupViews() {
        addSubview(hCenterLine)
        addSubview(vCenterLine)
        
        hCenterLine.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        hCenterLine.anchor(nil, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 8, widthConstant: 0, heightConstant: 1)
        
        vCenterLine.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        vCenterLine.anchor(topAnchor, left: nil, bottom: bottomAnchor, right: nil, topConstant: 8, leftConstant: 0, bottomConstant: 8, rightConstant: 0, widthConstant: 1, heightConstant: 0)
    }
    
    public func getCenterPosition() -> CGPoint {
        var centerPoint = CGPoint.zero
        centerPoint.x = frame.origin.x + PhotoInformation.FOCUS_WIDTH / 2
        centerPoint.y = frame.origin.y + PhotoInformation.FOCUS_HEIGHT / 2
        
        return centerPoint
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
