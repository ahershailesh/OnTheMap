//
//  StudentLocationHandler.swift
//  OnTheMap
//
//  Created by Shailesh Aher on 1/14/18.
//  Copyright © 2018 Shailesh Aher. All rights reserved.
//

import UIKit

protocol LocationDelegate {
    func studentLocationListLoaded(studentsInformation : [Student])
}

class StudentLocationHandler: NSObject {
    
    var delegate : LocationDelegate?
    
    static let shared = StudentLocationHandler()
    var studentInformation : [Student]?
    
    //MARK: API call
    private func fetchLocations() {
        ParseHandler.shared.getStudentList { [weak self] (success, response, _) in
            if success, let list = response as? [Student] {
                self?.studentInformation = list
                self?.delegate?.studentLocationListLoaded(studentsInformation: list)
            }
        }
    }
    
    //MARK: Public Functions
    func refresh() {
        fetchLocations()
    }
}
