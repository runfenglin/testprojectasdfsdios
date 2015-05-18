//
//  Comment.swift
//  TURides
//
//  Created by Dennis Hui on 13/05/15.
//
//

import UIKit

class Comment: NSObject {
    var message: String
    var toUser: User
    var fromUser: User
    
    init(fromUser: User, toUser: User, message: String) {
        self.fromUser = fromUser
        self.toUser = toUser
        self.message = message
    }
}
