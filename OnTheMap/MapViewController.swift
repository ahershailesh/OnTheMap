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
    
//    func addAnnotations(student: Student) {
//        let annotation = MKPointAnnotation()
//        annotation.set(student: student)
//        studentLocations.append(annotation)
//    }
    
    func showRegion(annotation: MKPointAnnotation) {
        print("Showing region \(annotation.coordinate.latitude) \(annotation.coordinate.longitude)")
        var region = MKCoordinateRegion()
        region.center.latitude = annotation.coordinate.latitude
        region.center.longitude =  annotation.coordinate.longitude
        region.span.latitudeDelta = 0.001;
        region.span.longitudeDelta = 0.001;
        mapView.setRegion(region, animated: true)
    }
    
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//        let reuseId = "pin"
//        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
//
//        if pinView == nil {
//            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//            pinView!.canShowCallout = true
//            pinView!.pinTintColor = .red
//            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//        }
//        else {
//            pinView!.annotation = annotation
//        }
//
//        return pinView
//    }
//
//
//    // This delegate method is implemented to respond to taps. It opens the system browser
//    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
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
    
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        if let urlString = view.annotation?.subtitle, let url = URL(string: urlString!) {
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        }
//    }
}
