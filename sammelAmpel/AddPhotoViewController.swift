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
    
    lazy var closeButton: UIView = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.backgroundColor = .white
        
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.setTitle("Close", for: .normal)
        btn.setTitleColor(.black, for: .normal)
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
        btn.backgroundColor = .green
        
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.setTitle("Take", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        btn.addTarget(self, action: #selector(capturePhotoBtnPressed), for: .touchUpInside)
        btn.isEnabled = true
        btn.alpha = 1.0
        
        return btn

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
        
        view.addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 22).isActive = true
        closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 64).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 64).isActive = true
        
        view.addSubview(captureButton)
        captureButton.anchor(nil, left: nil, bottom: view.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 12, rightConstant: 0, widthConstant: 64, heightConstant: 64)
        captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
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
        photoInformation = PhotoInformation(image: nil, lights: nil, lightCount: nil, gyroPosition: nil, latitude: nil, longitude: nil)
        
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
        
        navigationController?.pushViewController(nextVc, animated: true)
    }
    
}

extension AddPhotoViewController: CLLocationManagerDelegate {

}

