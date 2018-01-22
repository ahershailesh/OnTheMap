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
    private let udacityUrl = "https://www.udacity.com"
    let applicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    let parseKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    var serverUrl : String {
        return url + "/parse/classes/StudentLocation"
    }
    
    var userUrl : String {
        return udacityUrl + "/api/users/"
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
    
    func postLocation(paramDict: [AnyHashable: Any], completionBlock: Constants.CompletionBlock?) {
        if let url = URL(string: serverUrl) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(applicationId, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(parseKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
            request.httpBody = paramDict.json()?.data(using: .utf8)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                let success =  error == nil
                let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                print(json)
                completionBlock?(success, json??["objectId"], error)
            }
            task.resume()
        }
    }
    
    func updateLocation(objectId: String, paramDict: [AnyHashable: Any], completionBlock: Constants.CompletionBlock?) {
        let finalUrl = serverUrl + "/" + objectId
        if let url = URL(string: finalUrl) {
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(applicationId, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(parseKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
            request.httpBody = paramDict.json()?.data(using: .utf8)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                let success =  error == nil
                if success {
                    if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                        print(json)
                    }
                }
                completionBlock?(success, nil, error)
            }
            task.resume()
        }
    }
    
    func getStudentLocation(dict: [String: String], completionBlock: Constants.CompletionBlock?) {
        let pathParam = "?where=" + (dict.json()?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")
        let finalUrl = serverUrl + pathParam
        if let url = URL(string: finalUrl) {
            var request = URLRequest(url: url)
            request.addValue(applicationId, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(parseKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                let success =  error == nil
                if success {
                    if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                        print(json)
                        completionBlock?(success, json?["results"], error)
                    }
                }
                print(String(data: data!, encoding: .utf8)!)
            }
            task.resume()
        }
    }
    
    func getStudentInfo(uniqueKey : String, completionBlock: Constants.CompletionBlock?) {
        if let url = URL(string: userUrl + uniqueKey) {
            var request = URLRequest(url: url)
            request.addValue(applicationId, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(parseKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                let success =  error == nil
                let range = Range(5..<data!.count)
                let newData = data?.subdata(in: range)
                if success {
                    if let json = try? JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as? [String: Any] {
                        completionBlock?(success, json?["user"], error)
                    }
                }
                print(String(data: data!, encoding: .utf8)!)
            }
            task.resume()
        }
    }
}
