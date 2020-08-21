//
//  MapScreenViewModel.swift
//  Zuhlke
//
//  Created by #HellRaiser on 21/08/20.
//  Copyright © 2020 asharpvan. All rights reserved.
//

import UIKit

protocol MapScreenViewModelProtocol {
    
    var repository: Repository! { get set }
    var annotations: PSBindable<Array<CustomPin>> { get set }
    var selectedCustomPin: CustomCalloutView? { get set }
    var hasError: PSBindable<NetworkError?> { get set }

    func fetchSingaporeTrafficCamera()
    func userDidSelectPin(view: CustomCalloutView)
    func stopDowloadingSpinner()
    func processErrorReceived(error: NetworkError) -> String
}

class MapScreenViewModel: NSObject, MapScreenViewModelProtocol {
    var selectedCustomPin: CustomCalloutView? = nil
    var repository: Repository! = Repository()
    var annotations: PSBindable<Array<CustomPin>> = PSBindable<Array<CustomPin>>(Array<CustomPin>())
    var hasError: PSBindable<NetworkError?> = PSBindable<NetworkError?>(nil)

    //MARK: - init methods
    override init() {
        super.init()
    }
    
    //MARK: - public methods
    func fetchSingaporeTrafficCamera() {
        self.repository.callSingaporeTrafficCameraAPI { (result) in
            switch result {
            case .success(let clockInDetails):
                var arrayOfCards = Array<CustomPin>()
                for item in clockInDetails.extractAllCameraInfo() {
                    let pin = CustomPin(withCameraInfo: item)
                    arrayOfCards.append(pin)
                }
                self.annotations.value.append(contentsOf: arrayOfCards)
            case.failure(let error):
                print(error)
                self.hasError.value = error
            }
        }
    }
    
    func userDidSelectPin(view: CustomCalloutView) {
        
        self.selectedCustomPin = view
        
        guard let view = self.selectedCustomPin , let annotation = view.annotation as? CustomPin, let url = annotation.cameraInfo.fetchCameraImageURL() else { return }
        
        view.updateSpinner(toState: true)
        
        self.repository.fetchCameraImage(url: url) { (result) in
            switch result {
            case .success(let image):
                view.updateImage(image: image)
            case.failure(let error):
                print(error)
                self.hasError.value = error
            }
        }
    }
    
    func stopDowloadingSpinner() {
        guard let view = self.selectedCustomPin else { return }
        view.stopUpdateImage()
    }
    
    func userDidDeselectPin() {
        self.selectedCustomPin = nil
    }
    
    func processErrorReceived(error: NetworkError) -> String {
        switch error {
        case .badURL:
            return "Bad URL. Please check the URL passed"
        case .networkError(error: let error):
            return error
        case .badResponseError:
            return "Response received from server is not in the correct format"
        case .parsingError:
            return "Couldnt Parse Data"
        case .imageConversionError:
            return "Something went wrong while downloading the image"
        }
    }
}
