//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Shailesh Aher on 1/13/18.
//  Copyright © 2018 Shailesh Aher. All rights reserved.
//

import UIKit

class LoginViewController : UIViewController, UITextFieldDelegate {
    
    let LOGIN_FAILED_MESSAGE = "Username or password is incorrent, login failed"
    var isMoved = false
    let moveOffset : CGFloat = 10
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBAction func loginButtonTapped(_ sender: Any) {
        userNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        let dictionary = ["username" : userNameTextField.text!,
                          "password" : passwordTextField.text!]
        
        AuthenticationHandler.shared.authenticate(dictionary: dictionary) { [weak self] (success, response, _) in
            self?.login(success: success)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func login(success: Bool) {
        mainThread { [weak self] in
            if success {
                self?.moveToMapView()
            } else {
                self?.messageLabel.text = self?.LOGIN_FAILED_MESSAGE
            }
        }
    }
    
    private func moveToMapView() {
        
        if let controller = storyboard?.instantiateViewController(withIdentifier: "MapViewController") {
            present(controller, animated: true, completion: nil)
        }
    }
    
    fileprivate func moveTextFieldsUp() {
        if !isMoved {
            UIView.animate(withDuration: 0.2, animations: {
                self.stackView.frame = CGRect(origin: CGPoint(x: self.stackView.frame.minX, y: self.stackView.frame.minY - self.moveOffset), size: self.stackView.frame.size)
            })
            
        }
        isMoved = true
    }
    
    fileprivate func moveTextDown() {
        if isMoved {
            UIView.animate(withDuration: 0.2, animations: {
                self.stackView.frame = CGRect(origin: CGPoint(x: self.stackView.frame.minX, y: self.stackView.frame.minY + self.moveOffset), size: self.stackView.frame.size)
            })
        }
        isMoved = false
    }
    
//    private func failedAnimation() {
//        let currentUserNameFieldFrame = userNameTextField.frame
//        let currentPasswordFieldFrame = passwordTextField.frame
//
//
//
//    }
//
//    private func leftDisplacedAnim(textField: UITextField, callBack: Constants.VoidBlock?) {
//        let leftFrame = CGRect(origin: CGPoint(x: -5, y: 0), size: CGSize.zero)
//        UIView.animate(withDuration: 0.2, animations: {
//            textField.frame = textField.frame + leftFrame
//        }) { (_) in
//            callBack?()
//        }
//    }
}

extension LoginViewController {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTextFieldsUp()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextDown()
    }
}
