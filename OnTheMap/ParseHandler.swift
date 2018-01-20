//
//  ParseHandler.swift
//  OnTheMap
//
//  Created by Shailesh Aher on 1/13/18.
//  Copyright © 2018 Shailesh Aher. All rights reserved.
//

import UIKit

class ParseHandler: NSObject {
    
    static let shared = ParseHandler()
    
    private let url = "https://parse.udacity.com"
    let applicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    let parseKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    var serverUrl : String {
        return url + "/parse/classes/StudentLocation"
    }
    
    func getStudentList(completionBlock: Constants.CompletionBlock?) {
        if let url = URL(string: serverUrl) {
            var request = URLRequest(url: url)
            request.addValue(applicationId, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(parseKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                let success =  error == nil
                var studentList = [Student]()
                if success {
                    if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any],
                        let array = json!["results"] as? [Any] {
                        for item in array {
                            let dict = item as! [String: Any]
                            let student = Student()
                            student.map(dictionary: dict)
                            student.latitude = dict["latitude"] as? NSNumber
                            student.longitude = dict["longitude"]  as? NSNumber
                            studentList.append(student)
                        }
                    }
                }
                completionBlock?(success, studentList, error)
            }
            task.resume()
        }
    }
    
}
