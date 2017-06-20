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
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
