//
//  TripOffer.swift
//  TURides
//
//  Created by Dennis Hui on 4/07/15.
//
//

import UIKit

class TripOffer: NSObject {
    var id: String
    var user: User
    
    init(id: String, user: User) {
        self.id = id
        self.user = user
    }
}
