//
//  AddPhotoViewController.swift
//  sammelAmpel
//
//  Created by Patrick Valenta on 03.04.17.
//  Copyright © 2017 Patrick Valenta. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation
import SwiftyCam
import LBTAComponents

class AddPhotoViewController: SwiftyCamViewController, SwiftyCamViewControllerDelegate {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    lazy var closeButton: UIView = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.backgroundColor = .white
        btn.tintColor = .black
        
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 0.4
        
        btn.setImage(#imageLiteral(resourceName: "Delete Filled-50"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        btn.addTarget(self, action: #selector(closeBtnPressed), for: .touchUpInside)
        btn.isEnabled = true
        btn.alpha = 1.0
        
        return btn

    }()
    
    lazy var captureButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.backgroundColor = .white
        btn.tintColor = .black
        
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.setImage(#imageLiteral(resourceName: "Screenshot-50"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 0.4
        
        btn.addTarget(self, action: #selector(capturePhotoBtnPressed), for: .touchUpInside)
        btn.isEnabled = true
        btn.alpha = 1.0
        
        return btn

    }()
    
    lazy var focusView: FocusView = {
        let view = FocusView()
        return view
    }()
    
    var fvYAnchor: NSLayoutConstraint?
    var fvXAnchor: NSLayoutConstraint?

    
    let titleLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.font = UIFont.boldSystemFont(ofSize: 24)
        l.adjustsFontSizeToFitWidth = true
        l.text = "Test"
        return l
    }()
    
    let bottomContainerView: UIView = {
        let v = UIView()
        v.backgroundColor = .black
        return v
    }()
    
    let motionManager = CMMotionManager()
    var deviceMotion: CMDeviceMotion?
    
    let locationManager = CLLocationManager()
    
    var photoInformation: PhotoInformation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        // Do any additional setup after loading the view, typically from a nib.
        
        pinchToZoom = false
        cameraDelegate = self
        
        setupViews()
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func setupViews() {
        view.addSubview(bottomContainerView)
        bottomContainerView.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 100)
        
        bottomContainerView.addSubview(captureButton)
        captureButton.anchor(bottomContainerView.topAnchor, left: nil, bottom: bottomContainerView.bottomAnchor, right: nil, topConstant: 8, leftConstant: 0, bottomConstant: 8, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        captureButton.widthAnchor.constraint(equalTo: captureButton.heightAnchor, multiplier: 1).isActive = true
        
        view.addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true
        closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        
        view.addSubview(titleLabel)
        titleLabel.anchor(view.topAnchor, left: closeButton.rightAnchor, bottom: nil, right: view.rightAnchor, topConstant: 12, leftConstant: 12, bottomConstant: 0, rightConstant: 72, widthConstant: 0, heightConstant: 48)
        
        view.addSubview(focusView)
        view.bringSubview(toFront: focusView)
        
        fvXAnchor = focusView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        fvXAnchor?.isActive = true
        
        fvYAnchor = focusView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
        fvYAnchor?.isActive = true
        
        focusView.heightAnchor.constraint(equalToConstant: PhotoInformation.FOCUS_HEIGHT).isActive = true
        focusView.widthAnchor.constraint(equalToConstant: PhotoInformation.FOCUS_WIDTH).isActive = true
        
        setTitleText()
        
    }
    
    func getRandomXYOffsetForFocusView() -> CGPoint {
        let minYPos = -Int(((view.frame.height - PhotoInformation.FOCUS_HEIGHT) / 2) - 60) // 60 is headerHeight
        let yOffset = randomNumber(range: minYPos...0)
        
        let centerX = Int((view.frame.width - PhotoInformation.FOCUS_WIDTH) / 2)
        let xOffset = randomNumber(range: -centerX ... centerX)
        return CGPoint(x: xOffset, y: yOffset)
    }
    
    func setTitleText() {
        let attributes = [NSForegroundColorAttributeName: UIColor.white, NSStrokeWidthAttributeName: -2, NSStrokeColorAttributeName: UIColor.black] as [String : Any]
        titleLabel.attributedText = NSAttributedString(string: "🚦 fotografieren", attributes: attributes)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        captureButton.layer.cornerRadius = 0.5 * captureButton.bounds.size.width
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        let focusViewOffset = getRandomXYOffsetForFocusView()
        fvYAnchor?.constant = focusViewOffset.y
        fvXAnchor?.constant = focusViewOffset.x
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        photoInformation = nil
        
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates(
                to: OperationQueue.current!, withHandler: {
                    (deviceMotion, error) -> Void in
                    
                    if(error == nil) {
                        if let deviceMotion = deviceMotion {
                            self.handleDeviceMotionUpdate(withMotion: deviceMotion)
                        }
                    } else {
                        //handle the error
                    }
            })
        }
        
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        motionManager.stopDeviceMotionUpdates()
        locationManager.stopUpdatingLocation()
    }
    
    private func handleDeviceMotionUpdate(withMotion motion: CMDeviceMotion) {
        deviceMotion = motion
    }
    
    @objc private func capturePhotoBtnPressed() {
        view.isUserInteractionEnabled = false
        photoInformation = PhotoInformation(image: nil, lights: nil, lightCount: nil, gyroPosition: nil, latitude: nil, longitude: nil, focusPos: nil)
        
        photoInformation?.focusPos = focusView.frame.origin
        
        //print(motionManager.attitude.pitch)
        if let radians = deviceMotion?.attitude.pitch {
            photoInformation?.gyroPosition = (180 / Double.pi * radians)/100
        }
        
        if let location = locationManager.location {
            photoInformation?.longitude = location.coordinate.longitude
            photoInformation?.latitude = location.coordinate.latitude
        }
        
        takePhoto()
    }
    
    @objc private func closeBtnPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        photoInformation?.image = photo
        
        let nextVc = MetaInfoInputViewController()
        nextVc.photoInformation = photoInformation
        
        view.isUserInteractionEnabled = true
        navigationController?.pushViewController(nextVc, animated: true)
    }
    
}

extension AddPhotoViewController: CLLocationManagerDelegate {

}

