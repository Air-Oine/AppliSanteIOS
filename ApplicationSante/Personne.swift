//
//  Personne.swift
//  ApplicationSante
//
//  Created by Admin on 20/06/2017.
//  Copyright © 2017 AirOne. All rights reserved.
//

import Foundation

class Personne {
    enum Gender {
        case Miss
        case Mister
    }
    
    var name: String
    var firstName: String
    var gender: Gender
    
    init(name: String, firstName: String, gender: Gender) {
        self.name = name
        self.firstName = firstName
        self.gender = gender
    }
    
    func getFullName() -> String {
        var fullName: String = ""
        
        if gender == .Mister {
            fullName.append("Mr ")
        }
        else {
            fullName.append("Mme ")
        }
        
        fullName.append(firstName + " " + name)
        
        return fullName
    }
}
