//
//  CreatePatientViewController.swift
//  ApplicationSante
//
//  Created by Admin on 20/06/2017.
//  Copyright © 2017 AirOne. All rights reserved.
//

import UIKit
import CoreData

class CreatePatientViewController: UIViewController {
    
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var genderSegment: UISegmentedControl!
    
    @IBOutlet weak var progressbar: UIProgressView!
    
    weak var delegate: CreatePatientDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.progressbar.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //We save the new person
    @IBAction func onTapSave(_ sender: UIButton) {
        
        //Get form values
        let firstName = firstNameText.text ?? ""
        let name = nameText.text ?? ""
        let genderValue = genderSegment.selectedSegmentIndex
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
            
            insertOnRemoteServer(firstName: firstName, name: name)
            
            insertOnLocalDatabase(firstName: firstName, name: name, isFemale: isFemale, persistentContainer: persistentContainer, delegate: delegate!)
            
            //Simulating creation task, with a progress bar
            self.progressbar.isHidden = false
            
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

func insertOnRemoteServer(firstName: String, name: String) {

    var json = [String: String]()
    json["surname"] = firstName
    json["lastname"] = name
    json["pictureUrl"] = "https://boygeniusreport.files.wordpress.com/2012/11/android-icon.jpg?quality=98&strip=all"
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    var request = URLRequest(url: URL(string: appDelegate!.apiUrl)!)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
    
    //Post person on server
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let errorMessage = error {
            print(errorMessage)
        }
    }
    task.resume()
}

func insertOnLocalDatabase(firstName: String, name: String, isFemale: Bool, persistentContainer: NSPersistentContainer, delegate: CreatePatientDelegate) {
    
    let newPerson = Person(entity: Person.entity(), insertInto: persistentContainer.viewContext)
    newPerson.firstName = firstName
    newPerson.name = name
    newPerson.isFemale = isFemale
    
    //Call the delegate for insert the person in database
    delegate.createPerson(person: newPerson)
}

protocol CreatePatientDelegate: AnyObject {
    
    func createPerson(person: Person)
}
