//
//  SettingsViewController.swift
//  ApplicationSante
//
//  Created by Admin on 21/06/2017.
//  Copyright © 2017 AirOne. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    let displayListModeKey = "displayListMode"
    
    @IBOutlet weak var displayListMode: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDisplayListMode()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadDisplayListMode() {
        guard let displayMode = UserDefaults.standard.value(forKey: displayListModeKey) as? Int else {
            return
        }
        
        displayListMode.selectedSegmentIndex = displayMode
    }
    
    //OnClick on save button
    @IBAction func save(_ sender: UIButton) {
        
        //Save settings in user defaults
        UserDefaults.standard.set(displayListMode.selectedSegmentIndex, forKey: displayListModeKey)
        
        dismiss(animated: true, completion: nil)
    }

}
