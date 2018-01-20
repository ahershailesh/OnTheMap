//
//  Student.swift
//  OnTheMap
//
//  Created by Shailesh Aher on 1/14/18.
//  Copyright © 2018 Shailesh Aher. All rights reserved.
//

import UIKit
import MapKit

class Student: NSObject {
    @objc var createdAt : String?
    @objc var firstName : String?
    @objc var lastName : String?
    @objc var latitude : NSNumber?
    @objc var longitude : NSNumber?
    @objc var mapString : String?
    @objc var mediaURL : String?
    @objc var objectId : String?
    @objc var uniqueKey : String?
    @objc var updatedAt : String?
    
    var fullName : String {
        return (firstName ?? "") + " " + (lastName ?? "")
    }
    
    var shortForm : String {
        return (firstName?.firstCharString ?? "") + " " + (lastName?.firstCharString ?? "")
    }
    
    func getAnnotation() -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        let lat = latitude?.doubleValue ?? 0.0
        let long = longitude?.doubleValue ?? 0.0
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        annotation.title = fullName
        annotation.subtitle = mediaURL
        return annotation
    }
}
