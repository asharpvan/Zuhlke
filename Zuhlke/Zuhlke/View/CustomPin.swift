//
//  CustomPin.swift
//  Zuhlke
//
//  Created by #HellRaiser on 21/08/20.
//  Copyright © 2020 asharpvan. All rights reserved.
//

import UIKit
import MapKit

class CustomPin: NSObject, MKAnnotation {
    
    //MARK: - Variables
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var cameraInfo: CameraDataModel

    //MARK: - init methods
    init(withCameraInfo cameraInfo: CameraDataModel) {
        self.cameraInfo = cameraInfo
        self.title = "Camera Id : " + cameraInfo.fetchCameraId()
        if let coordinates = cameraInfo.fetchCameraLocation() {
            self.coordinate = coordinates
        } else {
            self.coordinate = CLLocationCoordinate2DMake(0, 0)
        }
    }
}
