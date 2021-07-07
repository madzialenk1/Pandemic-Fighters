//
//  Spinner.swift
//  pandemic fighters
//
//  Created by Magdalena  Pękacka on 21/05/2020.
//  Copyright © 2020 Magdalena  Pękacka. All rights reserved.
//

import UIKit
import Firebase
var activeView: UIView?

extension UIViewController {
    
    // MARK: - Checker
    func showSpinner() {
        
        activeView = UIView(frame: self.view.bounds)
        activeView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.center = activeView!.center
        activityIndicator.startAnimating()
        activeView?.addSubview(activityIndicator)
        self.view.addSubview(activeView!)
    }
    
    func removeSpinner(){
        
        activeView?.removeFromSuperview()
        activeView = nil
    }
    
    //MARK: - White gradient
    func showGradient(gradientView: UIView){
        
        let maskedView = gradientView
        let gradientMaskLayer = CAGradientLayer()
        gradientMaskLayer.frame = maskedView.bounds
        gradientMaskLayer.colors = [UIColor.white.cgColor,
                                    UIColor.white.withAlphaComponent(0.8).cgColor,
                                    UIColor.white.withAlphaComponent(0.7).cgColor,
                                    UIColor.white.withAlphaComponent(0).cgColor ]
        view.layer.insertSublayer(gradientMaskLayer, at: 1)
    }
    
    //MARK: - Navigation Bar
    func manageNavigationBar(name: String) {
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let yourBackImage = UIImage(named: name)
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
    }

    


}
