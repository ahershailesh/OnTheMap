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
    var loggedInStudent = Student()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        addProgressBar()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
        
//        progressBar.translatesAutoresizingMaskIntoConstraints = false
//
//        var constrain : NSLayoutConstraint
//        constrain = NSLayoutConstraint(item: progressBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: HEIGHT_WIDTH)
//        loadingWindow.addConstraint(constrain)
//
//        constrain = NSLayoutConstraint(item: progressBar, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: HEIGHT_WIDTH)
//        loadingWindow.addConstraint(constrain)
//
//        loadingWindow.frame = window?.frame ?? CGRect.zero
//
//        progressBar.center = loadingWindow.center
        progressBar.startAnimating()
    }
}
