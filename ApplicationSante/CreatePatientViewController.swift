//
//  CreatePatientViewController.swift
//  ApplicationSante
//
//  Created by Admin on 20/06/2017.
//  Copyright © 2017 AirOne. All rights reserved.
//

import UIKit

class CreatePatientViewController: UIViewController {

    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var genderSwitch: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapSave(_ sender: UIButton) {
        let firstName = firstNameText.text ?? ""
        let name = nameText.text ?? ""
        let genderValue = genderSwitch.selectedSegmentIndex
        var gender: Personne.Gender
        if genderValue == 0 {
            gender = .Miss
        }
        else {
            gender = .Mister
        }

        //Coloring background for show error if not filled
        if firstName == "" {
            firstNameText.backgroundColor = .red
        }
        if name == "" {
            nameText.backgroundColor = .red
        }
        
        var newPerson = Personne(name: name, firstName: firstName, gender: gender)
        
        //PatientTableViewController.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
