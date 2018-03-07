//
// StudentListViewController.swift
//  OnTheMap
//
//  Created by Shailesh Aher on 1/14/18.
//  Copyright © 2018 Shailesh Aher. All rights reserved.
//

import UIKit

class StudentListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var studentsArray = [Student]()
    let handler = StudentLocationHandler.shared
    
    let studentCell = "StudentTableViewCell"
    override func viewDidLoad() {
        setUI()
        handler.delegate = self
        handler.refresh()
    }

    override func viewWillAppear(_ animated: Bool) {
        handler.refresh()
    }
    
    private func setUI() {
        register()
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.title = "Students"
        
        let postLocation = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(postLocationPopup))
        navigationItem.rightBarButtonItem = postLocation
        
        let logoutButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(logout))
        navigationItem.leftBarButtonItem = logoutButton
    }
    
    @objc private func postLocationPopup() {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "MapViewController") as? MapSearchViewController{
            let navC = UINavigationController(rootViewController: controller)
            navigationController?.present(navC, animated: true, completion: {
                controller.checkWithPreviousLocations()
            })
        }
    }
    
    private func register() {
        tableView.register(UINib(nibName: studentCell, bundle: nil), forCellReuseIdentifier: studentCell)
    }

    @objc private func logout() {
        AuthenticationHandler.shared.deAuthenticate { [weak self] (success, _, _) in
            appDelegate.loggedInStudent.objectId = nil
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    private func reloadData() {
        mainThread { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
}

extension StudentListViewController : LocationDelegate {
    
    func studentLocationListLoaded(studentsInformation: [Student]) {
        reloadData()
    }
}

extension StudentListViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return handler.studentInformation?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: studentCell) as? StudentTableViewCell{
            if let item = handler.studentInformation?[indexPath.row] {
                cell.student = item
            }
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        return UITableViewCell()
    }
}

extension StudentListViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let student = handler.studentInformation?[indexPath.row] {
            if let controller = storyboard?.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController{
                controller.locationBlock = {
                    return student.getAnnotation()
                }
                navigationController?.pushViewController(controller, animated: true)
            }
        }
    }

}

