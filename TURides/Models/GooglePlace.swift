//
//  GooglePlace.swift
//  TURides
//
//  Created by Dennis Hui on 29/04/15.
//
//

import UIKit

class GooglePlace: NSObject {
    var id: String
    var name: String
    var address: String
    
    init(id: String, name: String, address: String) {
        self.id = id
        self.name = name
        self.address = address
    }
}
