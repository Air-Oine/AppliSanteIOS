//
//  SettingsViewController.swift
//  ApplicationSante
//
//  Created by Admin on 21/06/2017.
//  Copyright © 2017 AirOne. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var displayListMode: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDisplayListMode()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadDisplayListMode() {
        guard let displayMode = UserDefaults.standard.value(forKey: "displayListMode") as? Int else {
            return
        }
        
        displayListMode.selectedSegmentIndex = displayMode
    }
    
    @IBAction func save(_ sender: UIButton) {
        UserDefaults.standard.set(displayListMode.selectedSegmentIndex, forKey: "displayListMode")
        
        dismiss(animated: true, completion: nil)
    }

}
