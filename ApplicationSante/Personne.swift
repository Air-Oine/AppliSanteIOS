//
//  Personne.swift
//  ApplicationSante
//
//  Created by Admin on 20/06/2017.
//  Copyright © 2017 AirOne. All rights reserved.
//

import Foundation

//Class unused with database persistence
extension Person {
    func getFullName(firstNameThenName: Bool = true) -> String {
        var fullName: String = ""
        
        if isFemale {
            fullName.append("Mme ")
        }
        else {
            fullName.append("Mr ")
        }
        
        if firstNameThenName {
            fullName.append(firstName! + " " + name!)
        }
        else {
            fullName.append(name! + " " + firstName!)
        }
        
        return fullName
    }
}

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
    
    
}
