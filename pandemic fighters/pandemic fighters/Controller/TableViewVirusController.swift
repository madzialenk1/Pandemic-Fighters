//
//  TableViewVirusController.swift
//  pandemic fighters
//
//  Created by Magdalena  Pękacka on 07/06/2020.
//  Copyright © 2020 Magdalena  Pękacka. All rights reserved.
//

import UIKit
import CoreLocation

class TableViewVirusController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var recentDateButton: UIButton!
    @IBOutlet weak var closestLocationButton: UIButton!
    
    
    var cells = [TableManager]()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        addButton.layer.cornerRadius = 15
        recentDateButton.layer.cornerRadius = 15
        closestLocationButton.layer.cornerRadius = 15
        closestLocationButton.layer.borderColor = UIColor.systemPink.cgColor
        closestLocationButton.layer.borderWidth = 2
        recentDateButton.layer.borderColor = UIColor.systemPink.cgColor
        recentDateButton.layer.borderWidth = 2
        tableView.register(UINib(nibName: "TableVirusCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tableView.reloadData()
        
        
    }
    
    func changeButtonColor(button: UIButton, sender: UIButton){
        button.backgroundColor = .white
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemPink.cgColor
        sender.backgroundColor = .systemPink
        sender.layer.borderColor = UIColor.systemPink.cgColor
        
    }
    
    @IBAction func closestLocationButton(_ sender: UIButton) {
        
        changeButtonColor(button: recentDateButton, sender: sender)
        sortClosestLocation()
    }
    
    @IBAction func recentDateButton(_ sender: UIButton) {
        
        changeButtonColor(button: closestLocationButton, sender: sender)
        sortDate()
    }
    
    func sortDate(){
        
        cells.sort(by: {$0.data > $1.data})
        tableView.reloadData()
        
    }
    
    func sortClosestLocation(){
        
                locationManager.requestAlwaysAuthorization()
                locationManager.requestWhenInUseAuthorization()
                if CLLocationManager.locationServicesEnabled() {
                    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                    locationManager.startUpdatingLocation()
                }
        guard let myLocation: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
        let latitude = myLocation.latitude
        let longitude = myLocation.longitude
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        cells.sort(by: {$0.location.distance(from: location) < $1.location.distance(from: location)})
        tableView.reloadData()
    }
    
    
}

extension TableViewVirusController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! TableVirusCell
        
        cell.addressLabel.text = cells[indexPath.row].address ?? ""
        cell.dataLabel.text = self.cells[indexPath.row].dataFormatted
        cell.descriptionLabel.text = self.cells[indexPath.row].description
        
        cell.textLabel?.numberOfLines = 0
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.textLabel?.font = UIFont(name: "Verdana", size: 20)
        return cell
    }
}

extension TableViewVirusController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}











