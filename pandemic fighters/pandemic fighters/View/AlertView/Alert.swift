//
//  Alert.swift
//  pandemic fighters
//
//  Created by Magdalena  Pękacka on 20/05/2020.
//  Copyright © 2020 Magdalena  Pękacka. All rights reserved.
//

import UIKit
import SafariServices

class Alert: UIViewController {
    
    var delegate: SFSafariViewControllerDelegate?
    var vc = UIViewController()
    
    // MARK: - Create a basic alert
    func createAlert(title: String, message: String,fromController controller: UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true,completion: nil)
        }))
        controller.present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Create a confirmation alert while a new case is added
    func createConfirmationAlert(fromController controller: UIViewController){
        
        let alert = UIAlertController(title: "Your report is added", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Add New One", style: .default, handler: { (action) in
            alert.dismiss(animated: true,completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "See The Map", style: .default, handler: { (action) in
            
            alert.dismiss(animated: true,completion: nil)
            controller.performSegue(withIdentifier: "toUnwind", sender: self)
        }))
        controller.present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Term & Conditions alert with url displaying on Safari
    func displayLicenAgreement(message:String,fromController controller: UIViewController){
        self.vc = controller
        let attributedString = NSMutableAttributedString(string: "By clicking Submit, you agree that you read and understand our Terms & Policies.")
        let alert = UIAlertController(title: attributedString.string , message: message, preferredStyle: .alert)
        let checkAction = UIAlertAction(title: "Check", style: .default) { (action) in
            self.showSafari(for: "https://sites.google.com/view/pandemicfighters/home", controller: controller)
        }
        
        let acceptAction = UIAlertAction(title: "Accept", style: .default) { (action) -> Void in
            self.createConfirmationAlert(fromController: controller)
        }
        alert.addAction(checkAction)
        alert.addAction(acceptAction)
        controller.present(alert, animated: true,completion: nil)
        
    }
       
    func showSafari(for url: String, controller: UIViewController) {
        guard let url = URL(string: url) else { return }
        
        let safariVC = SFSafariViewController(url: url)
        safariVC.delegate = self
        controller.present(safariVC, animated: true, completion: nil)
    }

}

// MARK: - I created this delegate to handle the "Done" button being pressed because user should still confirm the T&C after checking the website.

extension Alert: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.displayLicenAgreement(message: "You have to confirm", fromController: vc )
    }
}
