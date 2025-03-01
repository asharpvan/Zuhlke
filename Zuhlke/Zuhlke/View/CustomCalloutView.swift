//
//  CustomCalloutView.swift
//  Zuhlke
//
//  Created by #HellRaiser on 21/08/20.
//  Copyright © 2020 asharpvan. All rights reserved.
//

import UIKit
import MapKit

class CustomCalloutView: MKPinAnnotationView {
    
    //MARK: - variables
    private lazy var snapshotView : UIImageView = {
        let layer = UIImageView()
        layer.translatesAutoresizingMaskIntoConstraints = false
        layer.backgroundColor = UIColor.black
        layer.contentMode = UIView.ContentMode.redraw
        layer.addSubview(self.spinner)
        return layer
    }()
    
    private lazy var spinner : UIActivityIndicatorView = {
        var spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        spinner.color = UIColor.white
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    override var annotation: MKAnnotation? {
        didSet {
            setupDetailedView()
        }
    }
    
    //MARK: - init methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        canShowCallout = true
        setupDetailedView()
    }
    
    //MARK: - private methods
    private func setupDetailedView() {
        
        let rect = CGRect(origin: .zero, size: CGSize(width: 300, height: 200))
        
        detailCalloutAccessoryView = snapshotView
        NSLayoutConstraint.activate([
            snapshotView.widthAnchor.constraint(equalToConstant: rect.width),
            snapshotView.heightAnchor.constraint(equalToConstant: rect.height),
            
            spinner.centerYAnchor.constraint(equalTo: snapshotView.centerYAnchor),
            spinner.centerXAnchor.constraint(equalTo: snapshotView.centerXAnchor)
        ])
    }
    
    private func setSpinnerVisibilty(toState state: Bool) {
        switch state {
        case true:
            self.spinner.startAnimating()
        default:
            self.spinner.stopAnimating()
        }
    }
    
    //MARK: - public methods
    func updateSpinner(toState state: Bool) {
        self.setSpinnerVisibilty(toState: state)
    }
    
    func updateImage(image: UIImage?) {
        self.setSpinnerVisibilty(toState: false)
        self.snapshotView.image = image
    }
    
    func stopUpdateImage() {
        self.setSpinnerVisibilty(toState: false)
        self.snapshotView.image = nil
    }
}
