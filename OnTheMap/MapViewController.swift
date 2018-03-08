//
//  ViewController.swift
//  OnTheMap
//
//  Created by Shailesh Aher on 1/13/18.
//  Copyright © 2018 Shailesh Aher. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // The map. See the setup in the Storyboard file. Note particularly that the view controller
    // is set up as the map view's delegate.
    @IBOutlet weak var mapView: MKMapView!
    var locationBlock : (() -> AnyObject)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLocations()
        mapView.delegate = self
    }
    
    func addLocations() {
        let locationInput = locationBlock?()
        if let locationArray = locationInput as? [MKPointAnnotation] {
            for location in locationArray {
                mapView.addAnnotation(location)
            }
            if let annotation = locationArray.first {
                showRegion(annotation: annotation)
                navigationItem.title = annotation.title
            }
        } else if let location = locationInput as? MKPointAnnotation {
            mapView.addAnnotation(location)
            showRegion(annotation: location)
        }
        
    }
    
    func showRegion(annotation: MKPointAnnotation) {
        print("Showing region \(annotation.coordinate.latitude) \(annotation.coordinate.longitude)")
        var region = MKCoordinateRegion()
        region.center.latitude = annotation.coordinate.latitude
        region.center.longitude =  annotation.coordinate.longitude
        region.span.latitudeDelta = 0.001;
        region.span.longitudeDelta = 0.001;
        mapView.setRegion(region, animated: true)
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle ?? nil, let url = URL(string: toOpen) {
                app.open(url, options: [:], completionHandler: { (success) in
                    if !success {
                        self.showAlert(message: Constants.URL_ERROR)
                    }
                })
            } else {
                showAlert(message: Constants.URL_ERROR)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotationView")
        annotationView.canShowCallout = true
        annotationView.rightCalloutAccessoryView = UIButton.init(type: UIButtonType.detailDisclosure)
        
        return annotationView
    }
    
}
