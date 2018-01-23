//
//  AuthenticationHandler.swift
//  OnTheMap
//
//  Created by Shailesh Aher on 1/13/18.
//  Copyright © 2018 Shailesh Aher. All rights reserved.
//

import UIKit

class AuthenticationHandler: NSObject {
    
    private override init() { }
    static let shared = AuthenticationHandler()
    
    let SERVER_URL = "https://www.udacity.com"
    var sessionUrl : String {
        return SERVER_URL + "/api/session"
    }
    
    /// This function accepts username and password as keyas and corresponding user values
    ///
    /// - Parameters:
    ///   - dictionary: {\"username\": \"account@domain.com\", \"password\": \"********\"}
    ///   - completionBlock: return block with success and response.
    func authenticate(dictionary: [String: String], completionBlock: Constants.CompletionBlock?) {
        appDelegate.showLoading()
        if let  url = URL(string: sessionUrl) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            var authData = ""
            if let jsonString = dictionary.json() {
                 authData = ["udacity" : jsonString].json() ?? ""
            }
            request.httpBody = authData.data(using: .utf8)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { [weak self] data, response, error in
                var success = false
                
                let range = Range(5..<data!.count)
                let newData = data?.subdata(in: range)
                
                do {
                    let json = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as? [AnyHashable : Any]
                    print(json)
                    success = self?.isSuccessFull(dict: json) ?? false
                    completionBlock?(success, json, error)
                } catch {
                    print("cannot parse response")
                }
                appDelegate.hideLoading()
            }
            task.resume()
        } else {
            completionBlock?(false, nil, nil)
        }
    }
    
    private func isSuccessFull(dict: [AnyHashable : Any]?) -> Bool{
        guard let _ = dict?["error"] else {
            return true
        }
        return false
    }
    
    func deAuthenticate(completionBlock: Constants.CompletionBlock?) {
        if let  url = URL(string: sessionUrl) {
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            var xsrfCookie: HTTPCookie? = nil
            let sharedCookieStorage = HTTPCookieStorage.shared
            for cookie in sharedCookieStorage.cookies! {
                if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
            }
            if let xsrfCookie = xsrfCookie {
                request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            }
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                var string : String?
                let success = error == nil
                if success {
                    let range = Range(5..<data!.count)
                    let newData = data?.subdata(in: range) /* subset response data! */
                    string = String(data: newData!, encoding: .utf8)!
                    print(string!)
                }
                completionBlock?(success, string as AnyObject, error)
            }
            task.resume()
        } else {
            completionBlock?(false, nil, nil)
        }
    }
}
