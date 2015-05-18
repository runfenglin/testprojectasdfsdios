//
//  User.swift
//  TURides
//
//  Created by Dennis Hui on 24/04/15.
//
//

import UIKit

class User: NSObject {
    var id: String
    var name: String
    var email: String
    var profileIcon: UIImage
    
    init(id: String, name: String, email: String, profileIcon: UIImage) {
        self.id = id
        self.name = name
        self.email = email
        self.profileIcon = profileIcon
    }
}
