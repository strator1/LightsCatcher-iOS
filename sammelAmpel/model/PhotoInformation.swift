//
//  PhotoInformation.swift
//  sammelAmpel
//
//  Created by Patrick Valenta on 04.04.17.
//  Copyright © 2017 Patrick Valenta. All rights reserved.
//

import UIKit
import CoreLocation

struct PhotoInformation {
    
    enum LightPhase: Int {
        case red = 0
        case green = 1
    }
    
    var image: UIImage?
    var lights: [LightPosition]?
    var lightCount: Int?
    var gyroPosition: Double?
    
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    
}
