//
//  DetailViewController.swift
//  ApplicationSante
//
//  Created by Admin on 20/06/2017.
//  Copyright © 2017 AirOne. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var avatar: UIImageView!

    var patient: Personne!
    
    var methodDelete: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Interface
        let buttonDelete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector
            (deletePatient))
        self.navigationItem.rightBarButtonItem = buttonDelete
        
        //Loading person informations
        self.title = patient.getFullName()
        
        if patient.gender == .Mister {
            avatar.image = #imageLiteral(resourceName: "Android")
        }
        else {
            avatar.image = #imageLiteral(resourceName: "Android-female")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func deletePatient() {
        
        let alert = UIAlertController(title: "Confirmation", message: "Voulez-vous vraiment supprimer cette personne ?", preferredStyle: .alert)
    
        let actionOk = UIAlertAction(title: "OK", style: .destructive) { (actionOk) in
            self.methodDelete?()
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .destructive)

        alert.addAction(actionOk)
        alert.addAction(actionCancel)
        
        self.present(alert, animated: true, completion: nil)
    }

}

