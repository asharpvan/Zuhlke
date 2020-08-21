//
//  MapScreen.swift
//  Zuhlke
//
//  Created by #HellRaiser on 21/08/20.
//  Copyright © 2020 asharpvan. All rights reserved.
//

import UIKit
import MapKit

class MapScreen: UIViewController {
    
    struct MapScreenConstant {
        static let successAlertTitle = "Alert"
        static let alertOKButtonTitle = "Ok"
    }
    
    var viewModel : MapScreenViewModel!
    
    private lazy var mapView : MKMapView = {
        let mapView = MKMapView(frame: .zero)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        mapView.register(CustomCalloutView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        return mapView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init()  {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = MapScreenViewModel()
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupBinding()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.fetchSingaporeTrafficCamera()
    }
    private func setupUI() {
        self.view.addSubview(mapView)
    }
    
    private func configureUI() {
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func setupBinding() {
        guard let viewModel = self.viewModel else { print("error fetching viewmodel"); return }
        
        viewModel.annotations.bindAndFireEvent { [weak self] (array) in
            guard let self = self else { return }
            self.mapView.addAnnotations(array)
        }
        
        viewModel.hasError.bindAndFireEvent { [weak self] (error) in
            guard let self = self, let error = error else { return }
            let subtitle = self.viewModel.processErrorReceived(error: error)
            self.showAlert(withTitle: MapScreenConstant.successAlertTitle, andSubtitle: subtitle)
        }
    }

    private func showAlert(withTitle title: String, andSubtitle message: String, handler: ((_ isOK : Bool) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: MapScreenConstant.alertOKButtonTitle, style: UIAlertAction.Style.default, handler: { (userAction) in
            DispatchQueue.main.async {
                self.viewModel.stopDowloadingSpinner()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension MapScreen: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let view = view as? CustomCalloutView else { return }
        self.viewModel.userDidSelectPin(view: view)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        self.viewModel.userDidDeselectPin()
    }
}
