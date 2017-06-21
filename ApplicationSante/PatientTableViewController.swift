//
//  PatientTableViewController.swift
//  ApplicationSante
//
//  Created by Admin on 20/06/2017.
//  Copyright © 2017 AirOne. All rights reserved.
//

import UIKit

class PatientTableViewController: UITableViewController {

    var patients = [Personne]()
    
    var displayFirstNameNameSetting: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        let chuck = Personne(name: "Norris", firstName: "Chuck", gender: .Mister)
        let superman = Personne(name: "Man", firstName: "Super", gender: .Mister)
        let wonderwoman = Personne(name: "Woman", firstName: "Wonder", gender: .Miss)
        
        patients.append(chuck)
        patients.append(superman)
        patients.append(wonderwoman)
        
        //Button for settings
        let buttonSettings = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector
            (showSettingsViewController))
        
        self.navigationItem.leftBarButtonItem = buttonSettings
        
        //Button for creating person
        let buttonAdd = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector
            (showCreateViewController))
        
        self.navigationItem.rightBarButtonItem = buttonAdd
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Settings loading
        loadSettings()
        
        //Refresh table view
        self.tableView.reloadData()
    }

    func showCreateViewController() {
        let controller = CreatePatientViewController(nibName: "CreatePatientViewController", bundle: nil)
        
        controller.delegate = self
        
        self.present(controller, animated: true, completion: nil)
    }
    
    func showSettingsViewController() {
        let controller = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
                
        self.present(controller, animated: true, completion: nil)
    }
    
    func loadSettings(){
        guard let displayMode = UserDefaults.standard.value(forKey: "displayListMode") as? Int else {
            return
        }
        
        if displayMode == 0 {
            displayFirstNameNameSetting = false
        }
        else {
            displayFirstNameNameSetting = true
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patients.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "patientCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = patients[indexPath.row].getFullName(firstNameThenName: displayFirstNameNameSetting)

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let detailController = segue.destination as? DetailViewController {
            guard let selectedIndexPath = tableView.indexPathForSelectedRow else {
                return
            }
            
            //Defining the method delete in detail view, for removing the Person of the list
            detailController.methodDelete = {
                self.patients.remove(at: selectedIndexPath.row)
                
                self.tableView.reloadData()
                
                self.navigationController?.popViewController(animated: true)
            }
            
            detailController.patient = patients[selectedIndexPath.row]
        }
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

extension PatientTableViewController: CreatePatientDelegate {
    
    func createPerson(person: Personne) {
        patients.append(person)
        
        self.tableView.reloadData()
    }
}
