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
    struct mConstant {
        static let URL = "http://54.206.6.242/app_dev.php/api/v1/logout.json"
        static let LOADING_MESSAGE = "Logging out..."
    }
    
    var delegate: LogoutServiceDelegate
    
    init(delegate: LogoutServiceDelegate) {
        self.delegate = delegate
    }
    
    func dispathWithParams(params: NSDictionary) {
        Command(params: params, delegate: self, url: mConstant.URL).post()
    }
    
    override func successCallback(responseObject: AnyObject) {
        self.delegate.handleLogoutSuccess()
    }
    
    override func failCallback(responseObject: AnyObject) {
        
    }
}
