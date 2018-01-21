//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Shailesh Aher on 1/13/18.
//  Copyright © 2018 Shailesh Aher. All rights reserved.
//

import UIKit

class LoginViewController : UIViewController, UITextFieldDelegate {
    
    let LOGIN_FAILED_MESSAGE = "Username or password is incorrect, login failed"
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
        moveTextDown()
        let dictionary = ["username" : userNameTextField.text!,
                          "password" : passwordTextField.text!]
        
        AuthenticationHandler.shared.authenticate(dictionary: dictionary) {(success, response, _) in
             mainThread {
                self.login(success: success)
                if let json = response as? [String: [String : Any]] {
                    appDelegate.loggedInStudent.uniqueKey = json["account"]?["key"] as? String ?? ""
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func login(success: Bool) {
            if success {
                moveToStudentList()
            } else {
                messageLabel.text = LOGIN_FAILED_MESSAGE
            }
    }
    
    private func moveToStudentList() {
        
        if let controller = storyboard?.instantiateViewController(withIdentifier: "StudentListViewController") {
            let navigationController = UINavigationController(rootViewController: controller)
            present(navigationController, animated: true, completion: nil)
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
}

extension LoginViewController {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTextFieldsUp()
    }
}
