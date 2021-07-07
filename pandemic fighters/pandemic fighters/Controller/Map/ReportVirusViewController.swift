//
//  ReportVirusViewController.swift
//  pandemic fighters
//
//  Created by Magdalena  Pękacka on 29/05/2020.
//  Copyright © 2020 Magdalena  Pękacka. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import SafariServices


class ReportVirusViewController: UIViewController {
    
    @IBOutlet var yellowButtons: [UIButton]!
    @IBOutlet var redButtons: [UIButton]!
    @IBOutlet var descriptionButtons: [UIButton]!
    @IBOutlet weak var locationLabel: UILabel!
    
    
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    fileprivate var tf: UITextField?
    
    var longitude = 21.2004309
    var latitude = 52.166064
    var location: CLLocation?
    
    var alert = Alert()
    var virusManager = VirusManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manageNavigationBar(name: "left")
        submitButton.layer.cornerRadius = 15
        descriptionField.textAlignment = .center
        descriptionField.layer.borderColor = UIColor.black.cgColor
        descriptionField.layer.borderWidth = 2
        descriptionField.layer.cornerRadius = 5
        makeAllUIViewsEmpty()
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        
        var tested: String = ""
        var description: String = ""
        var des: [Description] = []
        
        self.redButtons.forEach { (button) in
            if button.backgroundColor == UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1) {
                if let string = button.title(for: .normal){
                    if string == "YES" {
                        tested = "Tested"
                    }
                    else if string == "I DON'T KNOW" {
                        tested = "I don't know"
                    }
                    else {
                        tested = "Pending"
                    }
                }
            }
        }
        
        self.descriptionButtons.forEach { (button) in
            if button.backgroundColor == UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1) {
                if  button.title(for: .normal) == "Fever" {
                    description = "Fever"
                    des.append(Description(stringValue: description))
                    
                }
                
                if button.title(for: .normal) == "Cough" {
                    des.append(Description(stringValue: "Cough"))
                    
                }
                if button.title(for: .normal) == "Shortness of Breath" {
                    
                    des.append(Description(stringValue: "Shortness of Breath"))
                }
            }
        }
        
        let exactTimeInMilliseconds = Int(Date().timeIntervalSince1970)
        
        let doc = Document(fields: Fields(longitude: Itude(doubleValue: longitude), timeStamp: Description(stringValue: String(exactTimeInMilliseconds)), selfReported: SelfReported(booleanValue: true), fieldsDescription: Description(stringValue: descriptionField.text!), latitude: Itude(doubleValue: latitude), tested: Description(stringValue: tested), symptoms: Symptoms(arrayValue: ArrayValue(values: des))))
        
        self.virusManager.save(doc, completion: { result in
            switch result {
            case .success(_):
                print("wszystko ok")
            case .failure(let error):
                print(error)
                
            }
        })
        
        alert.displayLicenAgreement(message:"Confirm if you agree", fromController: self)
        makeAllUIViewsEmpty()
        
    }
    
    func makeAllUIViewsEmpty() {
        
        descriptionField.text = "Type Your Description"
        
        self.yellowButtons.forEach { (button) in
            button.layer.cornerRadius = 15
            buttonColorBorder(button)
            
        }
        self.redButtons.forEach { (button) in
            button.layer.cornerRadius = 15
            buttonColorBorder(button)
            
        }
        self.descriptionButtons.forEach { (button) in
            button.layer.cornerRadius = 15
            buttonColorBorder(button)
            
        }
        
    }
    
    @IBAction func unwindToReport( _ seg: UIStoryboardSegue) {
        
    }
    
    func buttonColorBorder(_ button : UIButton) {
        button.layer.borderWidth = 1.0
        button.layer.borderColor = CGColor(srgbRed: 55/255, green: 150/255, blue: 244/255, alpha: 1)
        button.backgroundColor = .white
        button.tintColor = .black
        
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func testButtonPressed(_ sender: UIButton) {
        
        self.redButtons.forEach { (button) in
            if button == sender {
                let backgroundColor = button.backgroundColor
                if  backgroundColor ==  .white  {
                    button.backgroundColor = .init(red: 255/255, green: 45/255, blue: 85/255, alpha: 1)
                    button.layer.borderColor = .init(srgbRed: 255/255, green: 45/255, blue: 85/255, alpha: 1)
                    button.tintColor = .white
                }
                else {
                    
                    buttonColorBorder(button)
                }
                
            } else {
                buttonColorBorder(button)
            }
        }
    }
    
    @IBAction func descriptionButtonPressed(_ sender: UIButton){
        
        self.yellowButtons.forEach { (button) in
            if button == sender {
                let backgroundColor = button.backgroundColor
                if  backgroundColor == .white  {
                    button.backgroundColor = .init(red: 255/255, green: 204/255, blue: 0/255, alpha: 1)
                    button.layer.borderColor = .init(srgbRed: 255/255, green: 204/255, blue: 0/255, alpha: 1)
                    button.tintColor = .white
                }
                else {
                    button.backgroundColor = .white
                    buttonColorBorder(button)
                }
                if button.titleLabel!.text == "NO" {
                    self.descriptionButtons.forEach { (button) in
                        button.isHidden = true
                    }
                }
                else {
                    self.descriptionButtons.forEach { (button) in
                        button.isHidden = false
                    }
                }
                
            } else {
                buttonColorBorder(button)
            }
        }
    }
    
    @IBAction func yellowDescriptionButtonPressed(_ sender: UIButton) {
        
        self.descriptionButtons.forEach { (button) in
            if button == sender {
                let backgroundColor = button.backgroundColor
                if  backgroundColor == .white  {
                    button.backgroundColor = .init(red: 255/255, green: 204/255, blue: 0/255, alpha: 1)
                    button.layer.borderColor = .init(srgbRed: 255/255, green: 204/255, blue: 0/255, alpha: 1)
                    button.tintColor = .white
                }
                else {
                    button.backgroundColor = .white
                    buttonColorBorder(button)
                }
            }
            
        }
        
    }
    
}




