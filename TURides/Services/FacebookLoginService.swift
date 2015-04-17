//
//  FacebookLoginService.swift
//  TURides
//
//  Created by Dennis Hui on 17/04/15.
//
//

import UIKit

protocol FacebookLoginServiceDelegate {
    func handleFacebookLoginSuccess()
    func handleFacebookLoginFaile()
}

class FacebookLoginService: Service {
    let url = "http://54.206.6.242/api/v1/login/facebook.json"
    var delegate: FacebookLoginServiceDelegate
    
    init(delegate: FacebookLoginServiceDelegate) {
        self.delegate = delegate
    }
    
    func dispathWithParams(params: NSDictionary) {
        Command(params: params, delegate: self, url: url).post()
    }
    
    override func successCallback(responseObject: AnyObject) {
        self.delegate.handleFacebookLoginSuccess()
    }
    
    override func failCallback(responseObject: AnyObject) {
        
    }
}
