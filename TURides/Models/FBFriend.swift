//
//  FBFriend.swift
//  TURides
//
//  Created by Dennis Hui on 26/04/15.
//
//

import UIKit

class FBFriend {
    let name: String
    let id: String
    let iconUrl: String
    
    required init(name: String, id: String) {
        self.name = name
        self.id = id
        self.iconUrl = NSString(format: "https://graph.facebook.com/%@/picture", self.id) as String
    }
}
