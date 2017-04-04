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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        let rankingViewController = UINavigationController(rootViewController: RankingViewController())
        rankingViewController.tabBarItem.title = ""
        rankingViewController.tabBarItem.tag = 0
        
        viewControllers = [rankingViewController]
        
        selectedViewController = rankingViewController
        setupMiddleButton()
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController.tabBarItem.tag == 0 {
            print("present camera")
        }
    }
    
    func setupMiddleButton() {
        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 48))
        
        var menuButtonFrame = menuButton.frame
        menuButtonFrame.origin.y = view.bounds.height - menuButtonFrame.height
        menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
        menuButton.frame = menuButtonFrame
        
        view.addSubview(menuButton)
        
//        menuButton.setImage(UIImage(named: "example"), for: .normal)
        menuButton.setTitle("Test", for: .normal)
        menuButton.backgroundColor = .blue
        menuButton.addTarget(self, action: #selector(menuButtonAction), for: .touchUpInside)
        
        view.layoutIfNeeded()
    }
    
    func menuButtonAction() {
        present(capturePhotoNavController, animated: true, completion: nil)
    }
    
}
