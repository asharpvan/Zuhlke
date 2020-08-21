//
//  LocationDataModel.swift
//  Zuhlke
//
//  Created by #HellRaiser on 21/08/20.
//  Copyright © 2020 asharpvan. All rights reserved.
//

import Foundation
import MapKit

class LocationDataModel: NSObject, Codable {
    
    let longitude: Double?
    let latitude: Double?
    
    enum CodingKeys : String, CodingKey {
        case longitude = "longitude"
        case latitude = "latitude"
        
    }
    
    init(withLongitude longitude: Double, latitude: Double) {
        self.longitude = longitude
        self.latitude = latitude
    }
    
    //MARK: - Public Object Methods
    public func fetchCLLocationCoordinates2D() -> CLLocationCoordinate2D? {
        guard let longitude = self.longitude, let latitude = self.latitude else {
            print("longitude/Latitude Not Provided")
            return nil
        }

        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        if CLLocationCoordinate2DIsValid(coordinates) {
            return coordinates
        } else {
            print("Invalid coordinates Not Provided")
            return nil
        }
    }
}
