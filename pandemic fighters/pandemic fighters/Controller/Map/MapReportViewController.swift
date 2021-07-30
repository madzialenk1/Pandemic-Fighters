//
//  MapReportViewController.swift
//  pandemic fighters
//
//  Created by Magdalena  Pękacka on 01/06/2020.
//  Copyright © 2020 Magdalena  Pękacka. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapReportViewController: UIViewController {
    var previousLocation: CLLocation?
    
    fileprivate var tf: UITextField?
    
    var longitude = 21.2004309
    var latitude = 52.16606455
    
    @IBOutlet weak var pinImage: UIImageView!
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var adressLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showGradient(gradientView: gradientView)
        manageNavigationBar(name: "left")
        confirmButton.layer.cornerRadius = 15
        mapView.delegate = self
        previousLocation = getCenterLocation(for: mapView)
        
    }
    
    
    
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        pinImage.isHidden = true
        adressLabel.text = adressTextField()
    }
    
    @IBAction func confirmButtonPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "unwindToReport", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is ReportVirusViewController
        {
            let vc = segue.destination as? ReportVirusViewController
            vc?.latitude = latitude
            vc?.longitude = longitude
            vc?.locationLabel.text = adressLabel.text
            
        }
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func getCoordinate( addressString : String,
                        completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    
                    completionHandler(location.coordinate, nil)
                    let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude )
                    let region = MKCoordinateRegion.init(center: center, latitudinalMeters: 10000, longitudinalMeters: 10000)
                    self.mapView.setRegion(region, animated: true)
                    self.latitude = location.coordinate.latitude as Double
                    self.longitude = location.coordinate.longitude as Double
                    let CLLCoordType = CLLocationCoordinate2D(latitude: self.latitude,
                                                              longitude: self.longitude)
                    let anno = MyPointAnnotation()
                    anno.coordinate = CLLCoordType
                    self.mapView.addAnnotation(anno)
                }
            }
            
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
        
    }
    
    
    func adressTextField() -> String {
        
        let alert = UIAlertController(title: "Type your adress" , message: "", preferredStyle: .alert)
        
        alert.addTextField { textField in
            self.tf = textField
            self.mapView.removeAnnotations(self.mapView.annotations)
            
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action  in
            alert.dismiss(animated: true,completion: nil)
            
            self.getCoordinate(addressString: self.tf!.text!) { (coordinate, error) in
                self.adressLabel.text = self.tf!.text!
                
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
        
        return self.tf!.text!
    }
    
}

extension MapReportViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        mapView.removeAnnotations(mapView.annotations)
        pinImage.isHidden = false
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        
        guard let previousLocation = self.previousLocation else { return }
        
        guard center.distance(from: previousLocation) > 50 else { return }
        self.previousLocation = center
        
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let _ = error {
                return
            }
            
            guard let placemark = placemarks?.first else {
                
                return
            }
            
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            
            let latitude = placemark.location!.coordinate.latitude
            let longitude = placemark.location!.coordinate.longitude
            self.longitude = longitude as Double
            self.latitude = latitude as Double
            
            // if self.pinImage.isHidden == false {
            DispatchQueue.main.async {
                self.adressLabel.text = "\(streetNumber) \(streetName)"
                
            }
            // }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? MyPointAnnotation else {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
        }
        
        annotationView?.image = UIImage(named: "virus loction")
        pinImage.isHidden = true
        
        // configureDetailView(annotationView: annotationView!)
        annotationView?.canShowCallout = true
        
        return annotationView
    }
}








