//
//  MapViewController.swift
//  pandemic fighters
//
//  Created by Magdalena  Pękacka on 16/05/2020.
//  Copyright © 2020 Magdalena  Pękacka. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class MapViewController: UIViewController {
    
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var radiusLabel: UILabel!
    
    var virusManager = VirusManager()
    let locationManager = CLLocationManager()
    var tableManager =  [TableManager]()
    let alert = Alert()
    let decoder = Decoder()
    var annotations: [MyPointAnnotation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        virusManager.delegete = self
        mapView.delegate = self
        manageNavigationBar(name: "left")
        showGradient(gradientView: gradientView)
        if mapView.annotations != nil {
            mapView.removeAnnotations(mapView.annotations)
        }
        virusManager.performRequest()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        mapView.showsUserLocation = false
        getCenterWarsawMap()
        if mapView.annotations != nil {
            mapView.removeAnnotations(mapView.annotations)
        }
        filterTheMap(virusLocation: annotations)
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    
    override func willMove(toParent parent: UIViewController?) {
        if parent == nil {
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if segue.destination is TableViewVirusController
        {
            let vc = segue.destination as? TableViewVirusController
            vc?.cells = tableManager
        }
        
        if segue.destination is ReportVirusViewController{
            let vc = segue.destination as! ReportVirusViewController
            if let location = locationManager.location {
                vc.location = location
            } else {
                vc.location = CLLocation(latitude: 52.2252848, longitude: 21.0091724)
            }
            self.dismiss(animated:true, completion: nil)
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
        
    }
    
    
    
    func checkLocationServices() {
        
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            
        }
    }
    
    func checkLocationAuthorization() {
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            getUserCenterLocation()
            locationManager.startUpdatingLocation()
        case .authorizedAlways:
            break
        case .denied:
            alert.createAlert(title: "Error", message: "You rejected the location ", fromController: self)
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        }
    }
    
    func getCenterWarsawMap() {
        
        let center = CLLocationCoordinate2D(latitude: 52.237049, longitude: 21.017532 )
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: 1000000, longitudinalMeters: 1000000)
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        
        checkLocationServices()
        mapView.showsUserLocation = true
        locationManager.startUpdatingLocation()
        
    }
    
    func getUserCenterLocation(){
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 10000, longitudinalMeters: 10000)
            mapView.setRegion(region, animated: true)
            
        }
    }
    
    func filterTheMap(virusLocation: [MyPointAnnotation]){
        
        let defaults = UserDefaults.standard
        
        let word = defaults.string(forKey: "showOnly")!
        
        var list1: [MyPointAnnotation] = []
        
        switch word {
        
        case "CONFIRMED":
            list1 = virusLocation.filter { (MyPointAnnotation) -> Bool in
                return (MyPointAnnotation.tested?.contains("Tested"))!
            }
            break
        case "SELF-REPORTED":
            list1 = virusLocation.filter { (MyPointAnnotation) -> Bool in
                return MyPointAnnotation.tested!.contains("Pending")
            }
            break
            
        default:
            list1 = virusLocation
            break
            
        }
        let date = defaults.value(forKey: "date") as! Int
        print(date)
        for i in list1{
            print(i.date)
        }
        
        list1 = list1.filter({ (MyPointAnnotation) -> Bool in
            return MyPointAnnotation.date! > date
        })
        print(list1)
        
        
        mapView.addAnnotations(list1)
        
    }
}
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
        }
        
        guard let annotation = annotation as? MyPointAnnotation else {
            annotationView?.image = UIImage(named: "user loction")
            return annotationView
        }
        
        if annotation.identifier == "Confirmed" {
            
            annotationView?.image = UIImage(named: "Comfirmed")
        }
        else if annotation.identifier == "SelfReported" {
            annotationView?.image = UIImage(named: "Self-Reported")
        }
        
        configureDetailView(annotationView: annotationView!, address: annotation.address ?? "Adress", description: annotation.virusDescription ?? "None", symptoms: annotation.symptoms ?? "None" ,tested: annotation.tested!)
        annotationView?.canShowCallout = true
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
        let span = mapView.region.span
        let k = span.latitudeDelta * 111
        let labelText = String(format: "%.0f", k)
        radiusLabel.text = "within \(labelText) km"
    }
}



extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
}

extension MapViewController: VirusManagerDelegete {
    
    
    func updateMapView(virusLocation: [VirusModel] ){
        
        
        let dispatchGroup = DispatchGroup()
        
        DispatchQueue.main.async {
            self.showSpinner()
        }
            
            for virusLoc in virusLocation {
                
                let anno = MyPointAnnotation()
                
                
                dispatchGroup.enter()
                
                
                Decoder.getAdress(location: CLLocation(latitude: virusLoc.latitude, longitude: virusLoc.longtitude)) {(address) in
                    
                    switch address {
                    case .success(let address):
                        anno.address = address
                    case .failure(let error):
                        dispatchGroup.leave()
                        print(error)
                        return
                    }
                    
                    
                    let CLLCoordType = CLLocationCoordinate2D(latitude: virusLoc.latitude,
                                                              longitude: virusLoc.longtitude)
                    
                    
                    if virusLoc.tested == "Tested" {
                        anno.identifier = "Confirmed"
                    } else {
                        anno.identifier = "SelfReported"
                    }
                    
                    anno.tested = virusLoc.tested
                    anno.virusDescription = virusLoc.description
                    anno.date = Int(virusLoc.data)
                    
                    var string = ""
                    
                    if let sym = virusLoc.symptoms {
                        for symptom in sym {
                            string.append(" \(symptom.stringValue)")
                        }
                    } else {
                        string = "None"
                    }
                    anno.symptoms = string
                    anno.coordinate = CLLCoordType
                    
                    self.tableManager.append(TableManager(location: CLLocation(latitude: virusLoc.latitude,longitude: virusLoc.longtitude), data: virusLoc.data, description: virusLoc.description, address: anno.address))
                    self.annotations.append(anno)
                    
                    dispatchGroup.leave()
                }
                
            }
        dispatchGroup.notify(queue: .main) {
            DispatchQueue.main.async {
                
                self.mapView.addAnnotations(self.annotations)
                self.removeSpinner()
            }
        }
    }
}

//extension MapViewController:NewCaseDelegate {
//
//    func getNewCase() {
//
//        annotations = []
//
//        if mapView.annotations != nil {
//            mapView.removeAnnotations(mapView.annotations)
//        }
//        virusManager.performRequest()
//        filterTheMap(virusLocation: annotations)
//    }
//
//
//}









