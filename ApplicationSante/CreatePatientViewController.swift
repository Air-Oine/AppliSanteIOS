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
    
    @IBOutlet weak var progressbar: UIProgressView!
    
    weak var delegate: CreatePatientDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //We save the new person
    @IBAction func onTapSave(_ sender: UIButton) {
        let firstName = firstNameText.text ?? ""
        let name = nameText.text ?? ""
        let genderValue = genderSwitch.selectedSegmentIndex
        var isFemale: Bool
        if genderValue == 0 {
            isFemale = true
        }
        else {
            isFemale = false
        }
        
        var personValid = true
        
        //Coloring background for show error if not filled
        if firstName == "" {
            firstNameText.backgroundColor = .red
            personValid = false
        }
        if name == "" {
            nameText.backgroundColor = .red
            personValid = false
        }
        
        if personValid {
            //Instanciating the person
            let newPerson = Person(entity: Person.entity(), insertInto: persistentContainer.viewContext)
            newPerson.firstName = firstName
            newPerson.name = name
            newPerson.isFemale = isFemale
            
            //Call the delegate for insert the person in database
            delegate?.createPerson(person: newPerson)
            
            //Simulating creation task, with a progress bar
            DispatchQueue.global(qos: .userInitiated).async {
                for _ in 0..<100 {
                    //Simulating task
                    Thread.sleep(forTimeInterval: 0.02)
                    
                    //Show the progress
                    DispatchQueue.main.async {
                        self.progressbar.progress += 0.01
                    }
                }
                
                DispatchQueue.main.async {
                    //Close the view
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}

protocol CreatePatientDelegate: AnyObject {
    
    func createPerson(person: Person)
}
