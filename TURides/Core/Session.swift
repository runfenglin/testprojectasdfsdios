//
//  Session.swift
//  TURides
//
//  Created by Dennis Hui on 18/04/15.
//
//

import UIKit

class Session {
    
    class var sharedInstance :Session {
        struct Singleton {
            static let instance = Session()

        }
        
        return Singleton.instance
    }
    
}