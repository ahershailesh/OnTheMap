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
    
    
    var serverUrl : String {
        return Constants.url + "/parse/classes/StudentLocation"
    }
    
    var userUrl : String {
        return Constants.udacityUrl + "/api/users/"
    }
    
    func getStudentList(completionBlock: Constants.CompletionBlock?) {
        appDelegate.showLoading()
        let urlQuery = serverUrl + "?limit=100/order=-updatedAt"
        if let url = URL(string: serverUrl) {
            var request = URLRequest(url: url)
            request.addValue(Constants.applicationId, forHTTPHeaderField: Constants.applicationIdKey)
            request.addValue(Constants.parseKey, forHTTPHeaderField: Constants.parseRestApiKey)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                var success =  error == nil
                var studentList : [Student]?
                if success {
                    if let thisData = data,
                        let json = try? JSONSerialization.jsonObject(with: thisData, options: .allowFragments) as? [String: Any],
                        let array = json?["results"] as? [Any] {
                        studentList = [Student]()
                        for item in array {
                            let dict = item as! [String: Any]
                            let student = Student()
                            student.map(dictionary: dict)
                            student.latitude = dict["latitude"] as? NSNumber
                            student.longitude = dict["longitude"]  as? NSNumber
                            studentList?.append(student)
                        }
                    } else {
                        success = false
                    }
                }
                appDelegate.hideLoading()
                completionBlock?(success, studentList, error)
            }
            task.resume()
        }
    }
    
    func postLocation(paramDict: [AnyHashable: Any], completionBlock: Constants.CompletionBlock?) {
        appDelegate.showLoading()
        if let url = URL(string: serverUrl) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(Constants.applicationId, forHTTPHeaderField: Constants.applicationIdKey)
            request.addValue(Constants.parseKey, forHTTPHeaderField: Constants.parseRestApiKey)
            request.httpBody = paramDict.json()?.data(using: .utf8)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                let success =  error == nil
                var json : [String: Any]?
                if success, let thisData = data, let jsonData = try? JSONSerialization.jsonObject(with: thisData, options: .allowFragments) {
                    json = jsonData as? [String: Any]
                }
                print(json)
                completionBlock?(success, json?["objectId"], error)
                appDelegate.hideLoading()
            }
            task.resume()
        }
    }
    
    func updateLocation(objectId: String, paramDict: [AnyHashable: Any], completionBlock: Constants.CompletionBlock?) {
        appDelegate.showLoading()
        let finalUrl = serverUrl + "/" + objectId
        if let url = URL(string: finalUrl) {
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(Constants.applicationId, forHTTPHeaderField: Constants.applicationIdKey)
            request.addValue(Constants.parseKey, forHTTPHeaderField: Constants.parseRestApiKey)
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
                appDelegate.hideLoading()
            }
            task.resume()
        }
    }
    
    func getStudentLocation(dict: [String: String], completionBlock: Constants.CompletionBlock?) {
        appDelegate.showLoading()
        let pathParam = "?where=" + (dict.json()?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")
        let finalUrl = serverUrl + pathParam
        if let url = URL(string: finalUrl) {
            var request = URLRequest(url: url)
            request.addValue(Constants.applicationId, forHTTPHeaderField: Constants.applicationIdKey)
            request.addValue(Constants.parseKey, forHTTPHeaderField: Constants.parseRestApiKey)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                var success =  error == nil
                if success, let thisData =  data {
                    if let json = try? JSONSerialization.jsonObject(with: thisData, options: .allowFragments) as? [String: Any] {
                        print(json)
                        completionBlock?(success, json?["results"], error)
                    }
                } else {
                    success = false
                }
                print(String(data: data!, encoding: .utf8)!)
                appDelegate.hideLoading()
            }
            task.resume()
        }
    }
    
    func getStudentInfo(uniqueKey : String, completionBlock: Constants.CompletionBlock?) {
        appDelegate.showLoading()
        if let url = URL(string: userUrl + uniqueKey) {
            var request = URLRequest(url: url)
            request.addValue(Constants.applicationId, forHTTPHeaderField: Constants.applicationIdKey)
            request.addValue(Constants.parseKey, forHTTPHeaderField: Constants.parseRestApiKey)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                let success =  error == nil
                var json : [String: Any]?
                if let thisData = data {
                    let range = Range(5..<thisData.count)
                    let newData = thisData.subdata(in: range)
                    if success, let jsonData = try? JSONSerialization.jsonObject(with: newData, options: .allowFragments) {
                        json = jsonData as? [String: Any]
                    }
                }
                completionBlock?(success, json?["user"], error)
                appDelegate.hideLoading()
            }
            task.resume()
        }
    }
}
