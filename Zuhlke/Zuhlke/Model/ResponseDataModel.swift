//
//  ResponseDataModel.swift
//  Zuhlke
//
//  Created by #HellRaiser on 21/08/20.
//  Copyright © 2020 asharpvan. All rights reserved.
//

import UIKit
import Foundation
import MapKit

class ResponseDataModel: NSObject, Codable {

    //MARK: - Variables
    let items: [ItemsDataModel]?
    
    enum CodingKeys : String, CodingKey {
        case items = "items"
    }
    
    // MARK: - Initialization Function
    init(withItemsArray items: [ItemsDataModel]) {
        self.items = items
    }
    
    //MARK: - Class Methods
    class func convert(fromJSONData data: Data?) -> ResponseDataModel? {
        guard let dataObject = try? JSONDecoder().decode(ResponseDataModel.self, from: data!) else {
            debugPrint("Error: Couldn't decode data into WMShiftDetails")
            return nil
        }
        return dataObject
    }
    
    //MARK: - Public Object Methods
    public func extractAllCameraInfo() -> [CameraDataModel] {
        guard let arrayOfCameraInfo = self.items?[0].fetchCameraDetails() else {
            //No Camera Info found return Empty Array
            return []
        }
        return arrayOfCameraInfo
    }
}
