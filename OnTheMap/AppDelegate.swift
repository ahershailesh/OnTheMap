//
//  AppDelegate.swift
//  OnTheMap
//
//  Created by Shailesh Aher on 1/13/18.
//  Copyright © 2018 Shailesh Aher. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let loadingWindow = UIWindow(frame: UIScreen.main.bounds)
    var keyBoardNotificationViewArray = [UIView]()
    var loggedInStudent = Student(dictionary: [:])
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        addProgressBar()
        return true
    }
}

extension AppDelegate {
    func showLoading() {
        mainThread { [weak self] in
            let thisWindow = UIWindow(frame: UIScreen.main.bounds)
            self?.window?.addSubview(thisWindow)
            self?.loadingWindow.makeKeyAndVisible()
            self?.loadingWindow.windowLevel = self?.window?.windowLevel.advanced(by: +1.0) ?? .leastNormalMagnitude
        }
    }
    
    func hideLoading() {
        mainThread { [weak self] in
            self?.loadingWindow.removeFromSuperview()
            self?.loadingWindow.resignKey()
            self?.loadingWindow.windowLevel = self?.window?.windowLevel.advanced(by: -1.0) ?? .leastNormalMagnitude
        }
    }
    
    private func addProgressBar() {
        let HEIGHT_WIDTH : CGFloat = 72
        let progressBar = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: HEIGHT_WIDTH, height: HEIGHT_WIDTH))
        loadingWindow.addSubview(progressBar)
        progressBar.center = loadingWindow.center
        progressBar.color = UIColor.black
        progressBar.startAnimating()
    }
}
