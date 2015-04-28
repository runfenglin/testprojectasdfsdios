//
//  CheckInActivity.swift
//  TURides
//
//  Created by Dennis Hui on 24/04/15.
//
//

import UIKit

class CheckInActivity: BaseActivity {
    var placeID: String
    var placeDisplayName: String
    
    init(placeID: String, placeDisplayName: String, user: User) {
        self.placeDisplayName = placeDisplayName
        self.placeID = placeID
        
        super.init(user: user)
    }
}
