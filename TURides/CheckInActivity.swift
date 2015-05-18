//
//  CheckInActivity.swift
//  TURides
//
//  Created by Dennis Hui on 24/04/15.
//
//

import UIKit

class CheckInActivity: BaseActivity {
    var place: GooglePlace
    var message: String?
    var numberOfLikes: NSNumber
    var comments: [Comment]
    
    init(user: User, id: String, place: GooglePlace, numberOfLikes: NSNumber) {
        self.place = place
        self.comments = Array()
        self.numberOfLikes = numberOfLikes
        super.init(user: user, id: id)
    }
}