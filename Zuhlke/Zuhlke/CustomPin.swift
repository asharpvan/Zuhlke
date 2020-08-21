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
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var item: CameraDataModel

    init(withItem item: CameraDataModel) {
        self.item = item
        self.title = "Camera Id : " + item.fetchCameraId()
        if let coordinates = item.fetchCameraLocation() {
            self.coordinate = coordinates
        } else {
            self.coordinate = CLLocationCoordinate2DMake(0, 0)
        }
    }
}
