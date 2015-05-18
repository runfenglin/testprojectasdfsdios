//
//  BaseActivity.swift
//  TURides
//
//  Created by Dennis Hui on 24/04/15.
//
//

import UIKit

class BaseActivity: NSObject {
    var user: User
    var id: String
    
    init(user: User, id: String) {
        self.user = user
        self.id = id
        super.init()
    }
    
}


