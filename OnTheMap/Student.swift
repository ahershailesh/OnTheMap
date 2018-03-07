//
//  Student.swift
//  OnTheMap
//
//  Created by Shailesh Aher on 1/14/18.
//  Copyright © 2018 Shailesh Aher. All rights reserved.
//

import UIKit
import MapKit

struct Student {
    var createdAt : String?
    var firstName : String?
    var lastName : String?
    var latitude : NSNumber?
    var longitude : NSNumber?
    var mapString : String?
    var mediaURL : String?
    var objectId : String?
    var uniqueKey : String?
    var updatedAt : String?
    
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
    
    func getParamDictionary() -> [String: Any] {
        let dict : [String: Any] = ["uniqueKey" :   uniqueKey ?? "",
                                    "firstName" :   firstName ?? "",
                                    "lastName"  :   lastName ?? "",
                                    "mapString" :   mapString ?? "",
                                    "mediaURL"  :   mediaURL ?? "",
                                    "latitude"  :   latitude ?? 0,
                                    "longitude" :   longitude ?? 0]
        return dict
    }
    
    init(dictionary: [String: Any]) {
        createdAt = dictionary["createdAt"] as? String
        firstName = dictionary["firstName"] as? String
        lastName = dictionary["lastName"] as? String
        latitude = dictionary["latitude"] as? NSNumber
        longitude = dictionary["longitude"] as? NSNumber
        mapString = dictionary["mapString"] as? String
        mediaURL = dictionary["mediaURL"] as? String
        objectId = dictionary["objectId"] as? String
        uniqueKey = dictionary["uniqueKey"] as? String
        updatedAt = dictionary["updatedAt"] as? String
    }
}
