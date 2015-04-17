//
//  RegistrationService.swift
//  TURides
//
//  Created by Dennis Hui on 14/04/15.
//
//

import UIKit

protocol RegistrationServiceDelegate {
    func handleRegistrationSuccess()
    func handleRegistrationFail()
}

class RegistrationService: Service {
    let url = ""
    var delegate: RegistrationServiceDelegate

    init(delegate: RegistrationServiceDelegate) {
        self.delegate = delegate;
    }
    
    func dispatch(userID: NSString) {
        var params = ["UserID": userID] as NSDictionary
        let command = Command(params: params, delegate: self, url: url)
        command.get()
    }
    
    override func successCallback(responseObject: AnyObject) {
        self.delegate.handleRegistrationSuccess()
    }
    
    override func failCallback(responseObject: AnyObject) {
        self.delegate.handleRegistrationFail()
    }
}
