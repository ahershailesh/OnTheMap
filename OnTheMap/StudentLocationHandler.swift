//
//  StudentLocationHandler.swift
//  OnTheMap
//
//  Created by Shailesh Aher on 1/14/18.
//  Copyright © 2018 Shailesh Aher. All rights reserved.
//

import UIKit

class StudentLocationHandler: NSObject {
    static let shared = StudentLocationHandler()
    var studentInformation : [Student]?
    
    //MARK: API call
    func fetchLocations(completionBlock: Constants.CompletionBlock?) {
        ParseHandler.shared.getStudentList { [weak self] (success, response, error) in
            if success, let list = response as? [Student] {
                self?.studentInformation = list
            }
            completionBlock?(success, response, error)
        }
    }
}
