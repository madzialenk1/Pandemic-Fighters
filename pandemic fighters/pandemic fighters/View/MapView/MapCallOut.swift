//
//  MapCallOut.swift
//  pandemic fighters
//
//  Created by Magdalena  Pękacka on 13/06/2020.
//  Copyright © 2020 Magdalena  Pękacka. All rights reserved.
//
import UIKit
import MapKit

// MARK: - It is just an example how callout should look like and how I can change its properties
extension UIViewController {
 
    func configureDetailView(annotationView: MKAnnotationView, address: String, description: String, symptoms: String,tested: String) {
        
        let rect = CGRect(origin: .init(x: 0, y: 0), size: CGSize(width: 200, height: 100))
        let snapshotView = UIView()
        snapshotView.translatesAutoresizingMaskIntoConstraints = false
        
        let labelFirst = UILabel()
        labelFirst.text = address
        labelFirst.font = UIFont(name: "Arial", size: 14)
        labelFirst.numberOfLines = 0
        labelFirst.translatesAutoresizingMaskIntoConstraints = false
        snapshotView.addSubview(labelFirst)
        
        let labelSecond = UILabel()
        labelSecond.text = description
        labelSecond.translatesAutoresizingMaskIntoConstraints = false
        labelSecond.font = UIFont(name: "Arial", size: 10)
        labelSecond.textColor = .init(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)
        labelSecond.numberOfLines = 0
        snapshotView.addSubview(labelSecond)
        
        let labelThird = UILabel()
        labelThird.text = "Symptoms: \(symptoms)"
        labelThird.font = UIFont(name: "Arial", size: 14)
        labelThird.textColor = .init(red: 254/255, green: 77/255, blue: 105/255, alpha: 1)
        labelThird.numberOfLines = 0
        labelThird.translatesAutoresizingMaskIntoConstraints = false
        snapshotView.addSubview(labelThird)
        
        let labelForth = UILabel()
        labelForth.text = "Test: \(tested)"
        labelForth.font = UIFont(name: "Arial", size: 14)
        labelForth.textColor = .init(red: 254/255, green: 77/255, blue: 105/255, alpha: 1)
        labelForth.numberOfLines = 0
        labelForth.translatesAutoresizingMaskIntoConstraints = false
        snapshotView.addSubview(labelForth)
        annotationView.detailCalloutAccessoryView = snapshotView
        
        NSLayoutConstraint.activate([
            
            snapshotView.widthAnchor.constraint(equalToConstant: rect.width),
            snapshotView.heightAnchor.constraint(equalToConstant: rect.height),
            
            labelFirst.heightAnchor.constraint(greaterThanOrEqualToConstant: 1),
            labelFirst.widthAnchor.constraint(equalToConstant: rect.width),
            labelFirst.topAnchor.constraint(equalTo: snapshotView.topAnchor, constant: 5),
            
            labelSecond.heightAnchor.constraint(greaterThanOrEqualToConstant: 1),
            labelSecond.widthAnchor.constraint(equalToConstant: rect.width),
            labelSecond.topAnchor.constraint(equalTo: labelFirst.bottomAnchor, constant: 5),
            
            labelThird.heightAnchor.constraint(greaterThanOrEqualToConstant: 1),
            labelThird.widthAnchor.constraint(equalToConstant: rect.width),
            labelThird.topAnchor.constraint(equalTo: labelSecond.bottomAnchor, constant: 5),
            
            labelForth.heightAnchor.constraint(greaterThanOrEqualToConstant: 1),
            labelForth.widthAnchor.constraint(equalToConstant: rect.width),
            labelForth.topAnchor.constraint(equalTo: labelThird.bottomAnchor, constant: 5)
            
            
        ])
    }
}

