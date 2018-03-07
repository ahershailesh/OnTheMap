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


extension UIViewController {
    
    func showAlert(message: String, title : String = "Important" ) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel) { (_) in
            controller.dismiss(animated: true, completion: nil)
        }
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
    }
    
    func show(error : Error?, title : String = "Error"){
        guard let error = error else {
            return
        }
        showAlert(message: get(error).rawValue, title: "Error")
    }
    
    private func get(_ error : Error) -> Constants.ErrorCode{
        
        if let err = error as? URLError{
            switch err.code {
            case URLError.Code.notConnectedToInternet, URLError.Code.cannotConnectToHost:
                return Constants.ErrorCode.Network
                
            case URLError.Code.cannotFindHost:
                return Constants.ErrorCode.ServerNotFound
            
            default:
                return Constants.ErrorCode.None
            }
        }
        return Constants.ErrorCode.None
    }
}
