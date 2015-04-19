//
//  LogoutService.swift
//  TURides
//
//  Created by Dennis Hui on 17/04/15.
//
//

import UIKit

@objc protocol LogoutServiceDelegate {
    func handleLogoutSuccess()
    optional func handleLogoutFail()
}

class LogoutService: Service {
    let url = "http://54.206.6.242/api/v1/logout.json"
    var delegate: LogoutServiceDelegate
    
    init(delegate: LogoutServiceDelegate) {
        self.delegate = delegate
    }
    
    func dispathWithParams(params: NSDictionary) {
        Command(params: params, delegate: self, url: url).post()
    }
    
    override func successCallback(responseObject: AnyObject) {
        self.delegate.handleLogoutSuccess()
    }
    
    override func failCallback(responseObject: AnyObject) {
        
    }
}
