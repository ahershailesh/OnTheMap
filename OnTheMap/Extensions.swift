//
//  Extensions.swift
//  OnTheMap
//
//  Created by Shailesh Aher on 1/14/18.
//  Copyright © 2018 Shailesh Aher. All rights reserved.
//

import UIKit

func mainThread(block : Constants.VoidBlock?) {
    DispatchQueue.main.sync {
        block?()
    }
}

extension Dictionary {
    func json() -> String? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: self, options: []) {
            return String(data: jsonData, encoding: .utf8)
        }
        return nil
    }
}
