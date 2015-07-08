//
//  Session.swift
//  TURides
//
//  Created by Dennis Hui on 18/04/15.
//
//

import UIKit

class Session {

    static let sharedInstance = Session()
    var me: User?
    var friends: [User]?
    
    init() {
        
    }
    
//    class var sharedInstance :Session {
//        struct Singleton {
//            static let instance = Session()
//            var me: User
//
//        }
//        
//        return Singleton.instance
//    }
    
    
}