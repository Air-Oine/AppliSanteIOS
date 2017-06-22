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

    var patient: Person!
    
    var methodDelete: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Interface
        let buttonDelete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector
            (deletePatient))
        self.navigationItem.rightBarButtonItem = buttonDelete
        
        //Loading person informations
        self.title = patient.getFullName()
        
        //Default image depending on gender
        /*if patient.isFemale {
            avatar.image = #imageLiteral(resourceName: "Android-female")
        }
        else {
            avatar.image = #imageLiteral(resourceName: "Android")
        }*/
        
        guard let pictureUrl = self.patient.pictureUrl else {
            return
        }
        
        //Download image for avatar
        var urlRequest = URLRequest(url: URL(string: pictureUrl)!)
        urlRequest.httpMethod = "GET"
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                self.avatar.image = image
            }
            if error != nil {
                print(error)
            }
        }.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func deletePatient() {
        
        //Create confirmation pop-in
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

