//
//  LoginViewController.swift
//  pandemic fighters
//
//  Created by Magdalena  Pękacka on 20/05/2020.
//  Copyright © 2020 Magdalena  Pękacka. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import MapKit
class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailtextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var emailView: UIView!
    
    var userNotLoggedIn: Bool = true
    var alert = Alert()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manageNavigationBar(name: "left")
        
        loginButton.layer.cornerRadius = 15
        signUpButton.layer.cornerRadius = 15
        self.signUpButton.layer.borderWidth = 2.0
        self.signUpButton.layer.borderColor = CGColor(srgbRed: 55/255, green: 150/255, blue: 244/255, alpha: 1)
       
    }

    
    override func viewWillAppear(_ animated: Bool) {
        passwordTextField.text = ""
        emailtextField.text = ""
        userNotLoggedIn = true
    }
    
    //MARK: - Login Button disabled while empty place
    @objc func textFieldDidChange(_ sender: UITextField) {
        if passwordTextField.text == "" || emailtextField.text == "" {
            loginButton.isEnabled = false;
        }else{
            loginButton.isEnabled = true;
        }
    }
    
    //MARK: - Text fields highlighted
    @IBAction func emailTextFieldPressed() {
        emailView.layer.borderColor = UIColor.black.cgColor
        emailView.layer.cornerRadius = 30
        emailView.layer.borderWidth = 2
        emailtextField.textAlignment = .left
    }
    
    @IBAction func emailTextFieldChanged() {
        emailView.layer.borderColor = UIColor.white.cgColor
        emailtextField.textAlignment = .center
  
    }
    
    @IBAction func passwordTextFieldChanged() {
        passwordView.layer.borderColor = UIColor.white.cgColor
        passwordTextField.textAlignment = .center
        
    }
    
    @IBAction func passwordTextFieldPressed() {
        passwordView.layer.borderColor = UIColor.black.cgColor
        passwordView.layer.cornerRadius = 30
        passwordView.layer.borderWidth = 2
        passwordTextField.textAlignment = .left
    }
    
    //MARK: - Log in
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        showSpinner()
        
        if let email = emailtextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
                
                if let e = error {
                    self.removeSpinner()
                    self.alert.createAlert(title: "Error", message: e.localizedDescription,fromController: self)
                    return
                    
                } else {
                    self.userNotLoggedIn = false
                    self.removeSpinner()
                
                    self.performSegue(withIdentifier: "ToMap", sender: self)
                }
            }
        }
    }
 
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toRegister", sender: self)
    }
    
    // MARK: - Prevent from segue being performed while the password is wrong
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if userNotLoggedIn {
            return false
        }
        return true
    }
}
