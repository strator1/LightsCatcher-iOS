//
//  HomeTabBarController.swift
//  sammelAmpel
//
//  Created by Patrick Valenta on 03.04.17.
//  Copyright © 2017 Patrick Valenta. All rights reserved.
//

import UIKit
import CoreLocation

class HomeTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    let capturePhotoNavController: UINavigationController = {
        return UINavigationController(rootViewController: AddPhotoViewController())
    }()
    
    lazy var cameraButton: UIButton = {
        let btn = UIButton(type: .system)
        
        btn.setImage(#imageLiteral(resourceName: "camera"), for: .normal)
//        btn.translatesAutoresizingMaskIntoConstraints = false
        
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.setTitle("Kamera", for: .normal)
        btn.addTarget(self, action: #selector(menuButtonAction), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        let rankingViewController = UINavigationController(rootViewController: RankingViewController())
        rankingViewController.tabBarItem.title = ""
        rankingViewController.tabBarItem.tag = 0
        
        viewControllers = [rankingViewController]
        view.addSubview(cameraButton)
        setupMiddleButton()
        selectedViewController = rankingViewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupMiddleButton()
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController.tabBarItem.tag == 0 {
            print("present camera")
        }
    }
    
    func setupMiddleButton() {
        cameraButton.frame = CGRect(x: 0, y: 0, width: 64, height: 48)
        
        var menuButtonFrame = cameraButton.frame
        menuButtonFrame.origin.y = view.bounds.height - menuButtonFrame.height
        menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
        cameraButton.frame = menuButtonFrame
        
        
        
        cameraButton.centerImageAndTitle(withSpacing: 4)
        
        view.layoutIfNeeded()
    }
    
    func menuButtonAction() {
        present(capturePhotoNavController, animated: true, completion: nil)
    }
    
}
