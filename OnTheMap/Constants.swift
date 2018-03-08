//
//  Constants.swift
//  OnTheMap
//
//  Created by Shailesh Aher on 1/13/18.
//  Copyright © 2018 Shailesh Aher. All rights reserved.
//

import UIKit

struct Constants {
    typealias CompletionBlock = ((Bool,Any?,Error?) -> Void)
    typealias VoidBlock = (() -> Void)
    
    static let url = "https://parse.udacity.com"
    static let udacityUrl = "https://www.udacity.com"
    static let applicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    static let parseKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
    static let applicationIdKey = "X-Parse-Application-Id"
    static let parseRestApiKey = "X-Parse-REST-API-Key"
    
    static let URL_ERROR = "Sorry cannot able to open url provided URL"
    
    
    //MARK:- Enums
    //MARK:-
    enum ErrorCode : String {
        //Login
        case LoginFailed = "Login failed"
        
        //Network
        case Network = "No network available"
        
        //Server
        case ServerNotFound = "Server not found"
        
        //Default
        case None = "unable to reach server"
    }
}

let appDelegate = UIApplication.shared.delegate as! AppDelegate
