//
//  CameraDataModel.swift
//  Zuhlke
//
//  Created by #HellRaiser on 21/08/20.
//  Copyright © 2020 asharpvan. All rights reserved.
//

import Foundation
import MapKit

class CameraDataModel: NSObject, Codable {
    
    let cameraId: String?
    let imageURLString: String?
    let location: LocationDataModel?
    
    enum CodingKeys : String, CodingKey {
        case imageURLString = "image"
        case location = "location"
        case cameraId = "camera_id"
        
    }
    
    init(withCameraId cameraId: String, imageURLString: String, location: LocationDataModel) {
        self.cameraId = cameraId
        self.imageURLString = imageURLString
        self.location = location
    }
    
    //MARK: - Public Object Methods
    public func fetchCameraId() -> String {
        guard let cameraId = self.cameraId else {
            return "cameraId Not Provided"
        }
        return cameraId
    }
    
    public func fetchCameraImageURL() -> URL? {
        guard let imageURLString = self.imageURLString, let url = URL(string: imageURLString) else {
            print("imageURLString Not Provided or error creating imageURL")
            return nil
        }
        return url
    }
    
    public func fetchCameraLocation() -> CLLocationCoordinate2D? {
        return self.location?.fetchCLLocationCoordinates2D()
    }
}
