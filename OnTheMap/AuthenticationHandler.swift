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
            let task = session.dataTask(with: request) { data, response, error in
                var string : String?
                let success = error == nil
                if success {
                    let range = Range(5..<data!.count)
                    let newData = data?.subdata(in: range) /* subset response data! */
                    string = String(data: newData!, encoding: .utf8)!
                    print(string)
                }
                completionBlock?(success, string as AnyObject, error)
            }
            task.resume()
        }
    }
    
    func deAuthenticate() {
        
    }

}
