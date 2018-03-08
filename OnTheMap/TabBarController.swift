//
//  TabBarController.swift
//  OnTheMap
//
//  Created by Shailesh Aher on 3/8/18.
//  Copyright © 2018 Shailesh Aher. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logoutButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(logout))
        navigationItem.leftBarButtonItem = logoutButton
        
        let postLocation = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(postLocationPopup))
        navigationItem.rightBarButtonItem = postLocation
    }
    
    @objc private func logout() {
        AuthenticationHandler.shared.deAuthenticate { [weak self] (success, _, _) in
            appDelegate.loggedInStudent.objectId = nil
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func postLocationPopup() {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "MapViewController") as? MapSearchViewController{
            let navC = UINavigationController(rootViewController: controller)
            controller.showAnnotationsOnly = false
            navigationController?.present(navC, animated: true, completion: {
                controller.checkWithPreviousLocations()
            })
        }
    }
}
