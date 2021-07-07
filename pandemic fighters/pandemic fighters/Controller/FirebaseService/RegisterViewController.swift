//
//  RegisterViewController.swift
//  pandemic fighters
//
//  Created by Magdalena  Pękacka on 17/05/2020.
//  Copyright © 2020 Magdalena  Pękacka. All rights reserved.
//


import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var nameView: UIView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var userNotSignedUp: Bool = true
    var alert = Alert()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manageNavigationBar(name: "left")
        signUpButton.isEnabled = false
        signUpButton.layer.cornerRadius = 15
        emailTextField.addTarget(self, action:  #selector(textFieldDidChange(_:)),  for:.editingChanged )
        passwordTextField.addTarget(self, action:  #selector(textFieldDidChange(_:)),  for:.editingChanged )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        userNotSignedUp = true
    }
    
    //MARK: - Text Fields highlited while pressing
    @IBAction func nameTextFieldPressed() {
        nameView.layer.borderColor = UIColor.black.cgColor
        nameView.layer.cornerRadius = 30
        nameView.layer.borderWidth = 2
        nameTextField.textAlignment = .left
        
    }
    
    @IBAction func nametextFieldChanged() {
        nameView.layer.borderColor = UIColor.white.cgColor
        nameTextField.textAlignment = .center
    }
    
    @IBAction func emailTextFieldPressed() {
        emailView.layer.borderColor = UIColor.black.cgColor
        emailView.layer.cornerRadius = 30
        emailView.layer.borderWidth = 2
        emailTextField.textAlignment = .left
        
    }
    
    @IBAction func emailTextFieldChnaged() {
        emailView.layer.borderColor = UIColor.white.cgColor
        emailTextField.textAlignment = .center
        
    }
    
    @IBAction func passwordTextFieldPressed() {
        passwordView.layer.borderColor = UIColor.black.cgColor
        passwordView.layer.cornerRadius = 30
        passwordView.layer.borderWidth = 2
        passwordTextField.textAlignment = .left
        
    }
    
    @IBAction func passwordTextFieledChanged() {
        passwordView.layer.borderColor = UIColor.white.cgColor
        passwordTextField.textAlignment = .center
        
    }
    
    //MARK: - SignUp button is disabled while user do not finished typing
    @objc func textFieldDidChange(_ sender: UITextField) {
        if passwordTextField.text == "" || emailTextField.text == "" {
            signUpButton.isEnabled = false;
        }else{
            signUpButton.isEnabled = true;
        }
    }
    
    //MARK: - Registration
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        showSpinner()
        guard let name = nameTextField.text else {return}
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        if name == "" {
            self.alert.createAlert(title: "Error", message: "You have to write your name", fromController: self)
            removeSpinner()
            return
        }
        if self.validate(password: password) == false {
            
            self.alert.createAlert(title: "Error", message: "Your password has to contain 1 capital letter, 1 small letter, 1 number and 8-10 characters", fromController: self)
            self.removeSpinner()
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let e = error {
                self.alert.createAlert(title: "Error", message: e.localizedDescription, fromController: self)
                self.removeSpinner()
            }
            else {
                self.userNotSignedUp = false
                self.removeSpinner()
                self.performSegue(withIdentifier: "ToMap", sender: self)
            }
        }
        
    }
    
    
    // MARK: - Prevent from segue being performed while the password is wrong
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if userNotSignedUp {
            return false
        }
        
        return true
    }
    
    // MARK: - Validation
    func validate(password: String) -> Bool {
        
        let capitalLetter  = "(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).{8,10}"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetter)
        guard texttest.evaluate(with: password) else {return false}
        
        return true
        
    }
}
