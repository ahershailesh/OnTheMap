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
    let handler = StudentLocationHandler.shared
    
    let studentCell = "StudentTableViewCell"
    override func viewDidLoad() {
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchLocation()
    }
    
    private func fetchLocation() {
        StudentLocationHandler.shared.fetchLocations { (success, response, error) in
            if !success {
                self.show(error: error)
                self.reloadData()
            }
        }
    }
    
    private func setUI() {
        register()
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.title = "Students"
    }
    
    private func register() {
        tableView.register(UINib(nibName: studentCell, bundle: nil), forCellReuseIdentifier: studentCell)
    }
    
    private func reloadData() {
        mainThread { [weak self] in
            self?.tableView.reloadData()
        }
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
        if let student = handler.studentInformation?[indexPath.row], let url = URL(string: student.mediaURL ?? "") {
            UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                if !success {
                    self.showAlert(message: Constants.URL_ERROR)
                }
            })
        } else {
            showAlert(message: Constants.URL_ERROR)
        }
    }
    
}

