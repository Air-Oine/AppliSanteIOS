//
//  PatientTableViewController.swift
//  ApplicationSante
//
//  Created by Admin on 20/06/2017.
//  Copyright © 2017 AirOne. All rights reserved.
//

import UIKit
import CoreData

class PatientTableViewController: UITableViewController {
    
    var displayFirstNameNameSetting: Bool = true
    
    var fetchedResultController: NSFetchedResultsController<Person>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Settings loading
        loadSettings()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //Preparing the query for getting persons
        let fetchRequest = appDelegate.dataModel.getPersonsFetchRequest()
        
        //Prepare fetch for reload data
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: "Person")
        
        fetchedResultController.delegate = self
        try! fetchedResultController.performFetch()
        
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
    }
    
    func loadPatientsStatic() {
        //Static data
        /*let chuck = Personne(name: "Norris", firstName: "Chuck", gender: .Mister)
         let superman = Personne(name: "Man", firstName: "Super", gender: .Mister)
         let wonderwoman = Personne(name: "Woman", firstName: "Wonder", gender: .Miss)
         
         patients.append(chuck)
         patients.append(superman)
         patients.append(wonderwoman)*/
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
        return fetchedResultController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "patientCell", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = fetchedResultController.object(at: indexPath).getFullName(firstNameThenName: displayFirstNameNameSetting)
        
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
                
                let patient = self.fetchedResultController.object(at: selectedIndexPath)

                //Local delete
                /*self.persistentContainer.viewContext.delete(patient)
                self.persistentContainer.commit()*/
                
                //Remote delete
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                
                let url = appDelegate!.apiUrl.appending("/").appending(String(patient.serverId))

                var request = URLRequest(url: URL(string: url)!)
                request.httpMethod = "DELETE"
                
                //Delete person on server
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

                    //If there is an error, we assume that the person is already deleted
                    if let errorMessage = error {
                        print(errorMessage)
                        
                        //Create warning pop-in
                        let alert = UIAlertController(title: "Warning", message: "The operation failed", preferredStyle: .alert)
                        
                        let actionOk = UIAlertAction(title: "OK", style: .destructive)
                        
                        alert.addAction(actionOk)
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                task.resume()
                
                self.navigationController?.popViewController(animated: true)
            }
            
            detailController.patient = fetchedResultController.object(at: selectedIndexPath)
        }
    }
}

extension PatientTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.reloadData()
    }
}

extension PatientTableViewController: CreatePatientDelegate {
 
    //Adding person to database
    func createPerson(person: Person) {
        persistentContainer.commit()
    }
}
