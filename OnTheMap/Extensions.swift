//
//  Extensions.swift
//  OnTheMap
//
//  Created by Shailesh Aher on 1/14/18.
//  Copyright © 2018 Shailesh Aher. All rights reserved.
//

import UIKit
import MapKit

func mainThread(block : Constants.VoidBlock?) {
    if Thread.isMainThread {
        block?()
    } else {
        DispatchQueue.main.sync {
            block?()
        }
    }
}

let colorList : [UIColor] = [UIColor.blue,
                             UIColor.black,
                             UIColor.brown,
                             UIColor.cyan,
                             UIColor.gray,
                             UIColor.green,
                             UIColor.magenta,
                             UIColor.orange,
                             UIColor.purple]

extension Dictionary {
    func json() -> String? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: self, options: []) {
            return String(data: jsonData, encoding: .utf8)
        }
        return nil
    }
}


extension NSObject {
    func map(dictionary: [String: Any]) {
        let keyArray = propertyNames()
        for key in keyArray {
            if let value = dictionary[key] as? String{
                setValue(value, forKey: key)
            }
        }
    }
    
    private func propertyNames() -> [String] {
        return Mirror(reflecting: self).children.flatMap { $0.label }
    }
}

extension UIColor {
    static var random : UIColor {
        let randomNumber = Int(arc4random()) % colorList.count
        return colorList[randomNumber]
    }
    
    func isLight() -> Bool {
        let components = cgColor.components
        let brightness = ((components![0] * 299) + (components![0] * 587) + (components![0] * 114)) / 1000
        return brightness > 0.5
    }
}

extension String {
    var firstCharString : String {
        guard let char = first else {
            return ""
        }
        return "\(char)"
    }
}
