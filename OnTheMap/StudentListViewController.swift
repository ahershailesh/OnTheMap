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
    
    let studentCell = "StudentTableViewCell"
    override func viewDidLoad() {
        setUI()
        getStudentList()
    }

    private func setUI() {
        register()
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.title = "Students"
        
        let postLocation = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(postLocationPopup))
        navigationItem.rightBarButtonItem = postLocation
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

    private func getStudentList() {
        ParseHandler.shared.getStudentList { [weak self] (success, response, _) in
            if success, let list = response as? [Student] {
                self?.studentsArray = list
                self?.reloadData()
            }
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
        studentsArray = studentsInformation
        reloadData()
    }
}

extension StudentListViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: studentCell) as? StudentTableViewCell{
            cell.student = studentsArray[indexPath.row]
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        return UITableViewCell()
    }
}

extension StudentListViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let student = studentsArray[indexPath.row]
        if let controller = storyboard?.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController{
            controller.locationBlock = {
                return student.getAnnotation()
            }
            navigationController?.pushViewController(controller, animated: true)
        }
    }

}

