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
    
    init(user: User) {
        self.user = user
        super.init()
    }
    
}


