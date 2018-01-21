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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchTextField)
        view.addSubview(detailTextField)
        
        searchTextField.isHidden = true
        detailTextField.isHidden = true
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
        ParseHandler.shared.getStudentLocation(dict: ["uniqueKey" : uniqueKey]) { (suceess, response, _) in
            if let responseArray = response as? [Any] {
                responseArray.isEmpty ? self.addSearchView() : self.showAlert()
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
        postLocation()
        dismissCurrentController()
    }
    
    
    //MARK:- App functionality
    private func searchLocation(text: String) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = text
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if let array = response?.mapItems {
                var pointAnnotation = [MKPointAnnotation]()
                for item in array {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    pointAnnotation.append(annotation)
                }
                self.mapView.showAnnotations(pointAnnotation, animated: true)
            }
        }
        
        showNextButton()
        
    }
    
    private func postLocation() {
        let uniqueKey = appDelegate.loggedInStudent.uniqueKey ?? ""
        ParseHandler.shared.getStudentInfo(uniqueKey: uniqueKey) { (success, response, _) in
            mainThread {
                if let dict = response as? [String: Any] {
                    appDelegate.loggedInStudent.lastName = dict["last_name"]
                    appDelegate.loggedInStudent.firstName = dict["first_name"]
                }
                
            }
        }
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
