//
//  FiltersViewController.swift
//  pandemic fighters
//
//  Created by Magdalena  Pękacka on 18/12/2020.
//  Copyright © 2020 Magdalena  Pękacka. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController {

    
    @IBOutlet var showOnlyButtons: [UIButton]!
    @IBOutlet var addedButtons: [UIButton]!
    @IBOutlet weak var dataPicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    
    let defaults = UserDefaults.standard
    var buttons = [String: Bool]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataPicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            dataPicker.preferredDatePickerStyle = .automatic
        } else {
            // Fallback on earlier versions
        }
        dataPicker.isHidden = true
        dataPicker.maximumDate = Date()

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        startUI()
    }
    
    func startUI(){
        setRadius()
        self.manageButtons(showOnlyButtons)
        self.manageButtons(addedButtons)
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationItem.backBarButtonItem?.action = #selector(back)
    }
    @objc func back(){

    }
    
    func setRadius(){
        showOnlyButtons.forEach { (button) in
            button.layer.cornerRadius = 15
        }
        addedButtons.forEach { (button) in
            button.layer.cornerRadius = 15
        }
    }
    
    @IBAction func dataPickerChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let year: String = dateFormatter.string(from: sender.date)
        dateFormatter.dateFormat = "MM"
        let month: String = dateFormatter.string(from: sender.date)
        dateFormatter.dateFormat = "dd"
        let day: String = dateFormatter.string(from: sender.date)
        dateLabel.text = "\(day).\(month).\(year)"
        let exactTimeInMilliseconds = Int(dataPicker.date.timeIntervalSince1970)
        defaults.setValue(exactTimeInMilliseconds , forKey: "date")
        dataPicker.isHidden = true
        
        
        
        
    }
    @IBAction func addedButtonPressed(_ sender: UIButton) {
        
        dataPicker.setDate(Date(), animated: false)
        dateLabel.text = ""
        
        self.addedButtons.forEach { (button) in
            if button != sender {
                buttons[button.currentTitle!] = false
            } else {
                buttons[button.currentTitle!] = true
            }
            
            switch sender.currentTitle!{
            case "For 24 H":
                defaults.setValue(Int(Date().timeIntervalSince1970 - 86400), forKey: "date")
                break
            case "For 2 WEEKS":
                defaults.setValue(Int(Date().timeIntervalSince1970 - 1209600), forKey: "date")
                break
            default:
                dataPicker.isHidden = false
                break
            }
        }
        defaults.setValue(buttons, forKey: "buttons")
        self.manageButtons(addedButtons)
    }
    
    func manageButtons(_ buttonx:[UIButton]){
        
        
        buttons = defaults.dictionary(forKey: "buttons") as! [String: Bool]
        print(buttons)
        buttonx.forEach{ button in
            if buttons[button.currentTitle!] == true {
                button.backgroundColor = .init(red: 255/255, green: 204/255, blue: 0/255, alpha: 1)
                button.tintColor = .white
            }
            else{
                button.backgroundColor = .white
                button.tintColor = .black
            }
            
        }
    
}
    
    @IBAction func showOnlyButtonPressed(_ sender: UIButton) {
        self.showOnlyButtons.forEach { (button) in
            if button != sender {
                buttons[button.currentTitle!] = false
            } else {
                buttons[button.currentTitle!] = true
            }
        }
        let title = sender.currentTitle!
        defaults.set(title, forKey: "showOnly")
        defaults.setValue(buttons, forKey: "buttons")
        self.manageButtons(showOnlyButtons)
    }
    
    
}
