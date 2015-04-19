//
//  FacebookLoginService.swift
//  TURides
//
//  Created by Dennis Hui on 17/04/15.
//
//

import UIKit

@objc protocol FacebookLoginServiceDelegate {
    func handleFacebookLoginSuccess(apikey: NSString)
    optional func handleFacebookLoginFail()
}

class FacebookLoginService: Service {
    
    static let PARAMETER_KEY_USERNAME = "username"
    static let PARAMETER_KEY_TOKEN = "token"
    static let PARAMETER_KEY_EMAIL = "email"
    
    
    let url = "http://54.206.6.242/api/v1/login/facebook.json"
    var delegate: FacebookLoginServiceDelegate
    
    init(delegate: FacebookLoginServiceDelegate) {
        self.delegate = delegate
    }
    
    func dispathWithParams(params: NSDictionary) {
        Command(params: params, delegate: self, url: url).post()
    }
    
    override func successCallback(responseObject: AnyObject) {
        let response = responseObject as! NSDictionary
        let apikey: String? = response.objectForKey(Constant.KEYCHAIN_KEY_APIKEY) as? String
        self.delegate.handleFacebookLoginSuccess(apikey!)
    }
    
    override func failCallback(responseObject: AnyObject) {
        
    }
}
