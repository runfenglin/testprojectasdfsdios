//
//  Service.swift
//  TURides
//
//  Created by Dennis Hui on 14/04/15.
//
//

import UIKit

protocol ServiceDelegate {
    func successCallback(responseObject: AnyObject)
    func failCallback(responseObject: AnyObject)
}

class Service: NSObject, ServiceDelegate {
    func successCallback(responseObject: AnyObject) {
        assertionFailure("Must be overiden in subclass")
    }
    
    func failCallback(responseObject: AnyObject) {
        assertionFailure("Must be overiden in subclass")
    }
}
