//
//  ItemDataModel.swift
//  Zuhlke
//
//  Created by #HellRaiser on 21/08/20.
//  Copyright © 2020 asharpvan. All rights reserved.
//

import Foundation

class ItemsDataModel: NSObject, Codable {
  
    let cameras: [CameraDataModel]?
    
    enum CodingKeys : String, CodingKey {
        case cameras = "cameras"
    }
    
    init(withWithCameras cameras: [CameraDataModel]) {
        self.cameras = cameras
    }
    
    //MARK: - Public Object Methods
    public func fetchCameraDetails() -> [CameraDataModel]? {
        guard let cameras = self.cameras else {
            return []
        }
        return cameras
    }
}
