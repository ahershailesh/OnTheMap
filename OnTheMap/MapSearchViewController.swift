//
//  MapSearchViewController.swift
//  OnTheMap
//
//  Created by Shailesh Aher on 1/21/18.
//  Copyright © 2018 Shailesh Aher. All rights reserved.
//

import UIKit
import MapKit

class MapSearchViewController: MapViewController {
    
    var searchTextField = UITextField()
    var detailTextField = UITextView()
    
    let TEXTFIELD_PLACEHOLDER = "Enter Info..."
    let OVERRITE_LOCATION = "Do you want to overrite previous location"
    
    var showAnnotationsOnly = true
    
    var students : [Student] = [] {
        didSet {
            if showAnnotationsOnly {
                let annotation =  students.map { (student) -> MKPointAnnotation in
                    return student.getAnnotation()
                }
                mainThread(block: {
                    self.mapView.addAnnotations(annotation)
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchTextField)
        view.addSubview(detailTextField)
        
        searchTextField.isHidden = true
        detailTextField.isHidden = true
        
        detailTextField.autocorrectionType = .no
        detailTextField.autocapitalizationType = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        StudentLocationHandler.shared.delegate = self
        StudentLocationHandler.shared.refresh()
    }
    
    //MARK:- Add Dynamic Views
    func addSearchView() {
        addCancel()
        
        detailTextField.isHidden = true
        searchTextField.isHidden = false
        
        searchTextField.delegate = self
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraintToView(thisView: searchTextField, height: 48)
        
        searchTextField.backgroundColor = .white
        searchTextField.placeholder = "Search Location ex. Pune"
    }
    
    func checkWithPreviousLocations() {
        let uniqueKey = appDelegate.loggedInStudent.uniqueKey ?? ""
        ParseHandler.shared.getStudentLocation(dict: ["uniqueKey" : uniqueKey]) { (suceess, response, error) in
            if let responseArray = response as? [Any] {
                if responseArray.isEmpty {
                   self.addSearchView()
                } else {
                    self.showAlert()
                    if let location = responseArray.first as? [String: String] {
                        let objectId = location["objectId"]
                        appDelegate.loggedInStudent.objectId = objectId
                    }
                }
            } else {
                self.show(error: error)
            }
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Important", message: OVERRITE_LOCATION, preferredStyle: UIAlertControllerStyle.alert)
        let leftAction = UIAlertAction(title: "No", style: .cancel) { (_) in
            self.dismissCurrentController()
        }
        let rightAction = UIAlertAction(title: "Yes", style: .default, handler: nil)
        alert.addAction(leftAction)
        alert.addAction(rightAction)
        present(alert, animated: true) {
            self.addSearchView()
        }
    }
    
    private func showDetailTextView() {
        addBack()
        showDoneButton()
        
        detailTextField.text = TEXTFIELD_PLACEHOLDER
        
        searchTextField.isHidden = true
        detailTextField.isHidden = false
        
        detailTextField.delegate = self
        detailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraintToView(thisView: detailTextField, height: 80)
        
        searchTextField.backgroundColor = .white
        searchTextField.placeholder = "Search Location ex. Pune"
    }
    
    private func addConstraintToView(thisView: UIView, height: CGFloat) {
        var constraint : NSLayoutConstraint
        
        constraint = NSLayoutConstraint(item: thisView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 8)
        view.addConstraint(constraint)
        
        constraint = NSLayoutConstraint(item: thisView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 72)
        view.addConstraint(constraint)
        
        constraint = NSLayoutConstraint(item: thisView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -8)
        view.addConstraint(constraint)
        
        constraint = NSLayoutConstraint(item: thisView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height)
        view.addConstraint(constraint)
    }
    
    //MARK:- Show Navigation Button
    private func addCancel() {
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissCurrentController))
        navigationItem.leftBarButtonItem = cancel
        navigationItem.rightBarButtonItem = nil
    }
    
    private func addBack() {
        let back = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = back
    }
    
    private func showNextButton() {
        let next = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextButtonTapped))
        navigationItem.rightBarButtonItem = next
    }
    
    private func showDoneButton() {
        let submit = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(submitButtonTapped))
        navigationItem.rightBarButtonItem = submit
    }
    
    //MARK:- Navigation Button Tapped
    @objc private func nextButtonTapped() {
        showDetailTextView()
    }
    
    @objc private func dismissCurrentController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func backButtonTapped() {
        addSearchView()
    }
    
    @objc private func submitButtonTapped() {
        appDelegate.loggedInStudent.mediaURL = detailTextField.text
        preparePostLocationData()
        dismissCurrentController()
    }
    
    
    //MARK:- App functionality
    private func searchLocation(text: String) {
        appDelegate.loggedInStudent.mapString = text
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = text
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start { [weak self] (response, error) in
            if let array = response?.mapItems {
                var pointAnnotation = [MKPointAnnotation]()
                for item in array {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    pointAnnotation.append(annotation)
                }
                self?.saveLocation(coordinate: array.first?.placemark.coordinate ?? kCLLocationCoordinate2DInvalid)
                self?.mapView.showAnnotations(pointAnnotation, animated: true)
            } else {
                self?.show(error: error)
            }
        }
        showNextButton()
    }
    
    private func preparePostLocationData() {
        let uniqueKey = appDelegate.loggedInStudent.uniqueKey ?? ""
        ParseHandler.shared.getStudentInfo(uniqueKey: uniqueKey) { (success, response, _) in
            mainThread {
                if let dict = response as? [String: Any] {
                    appDelegate.loggedInStudent.lastName = dict["last_name"] as? String
                    appDelegate.loggedInStudent.firstName = dict["first_name"] as? String
                    if let objectId = appDelegate.loggedInStudent.objectId {
                        self.updateLocation(objectId: objectId, student: appDelegate.loggedInStudent)
                    } else {
                        self.postLocation(student: appDelegate.loggedInStudent)
                    }
                }
            }
        }
    }
    
    private func postLocation(student: Student) {
        let dict = student.getParamDictionary()
        ParseHandler.shared.postLocation(paramDict: dict) { (success, response, _) in
            if success, let objectId = response as? String {
                appDelegate.loggedInStudent.objectId = objectId
            }
        }
    }
    
    private func updateLocation(objectId : String, student: Student) {
         let dict = student.getParamDictionary()
        ParseHandler.shared.updateLocation(objectId: objectId, paramDict: dict) { (success, response, _) in
            
        }
    }
    
    private func saveLocation(coordinate: CLLocationCoordinate2D) {
        appDelegate.loggedInStudent.latitude = coordinate.latitude as NSNumber
        appDelegate.loggedInStudent.longitude = coordinate.longitude as NSNumber
    }
}

extension MapSearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            searchLocation(text: text)
            textField.resignFirstResponder()
        }
        return true
    }
}

extension MapSearchViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == TEXTFIELD_PLACEHOLDER {
            textView.text = ""
        }
    }
}

extension MapSearchViewController: LocationDelegate {
    func studentLocationListLoaded(studentsInformation: [Student]) {
        students = studentsInformation
    }
}
