//
//  FacebookLoginService.swift
//  TURides
//
//  Created by Dennis Hui on 17/04/15.
//
//

import UIKit

@objc protocol FacebookLoginServiceDelegate {
    func handleFacebookLoginSuccess(apikey: NSString, isNewUser: Bool)
    optional func handleFacebookLoginFail()
}

class FacebookLoginService: Service {
    
    struct mConstant {
        static let url = "http://54.206.6.242/app_dev.php/api/v1/login/facebook.json"
        static let LOADING_MESSAGE = "Logging in..."
        static let PARAMETER_KEY_FRIENDS_COUNT = "friend_count"
        static let PARAMETER_KEY_APIKEY = "apikey"
        static let PAREMETER_KEY_TOKEN = "token"
    }
    
    var delegate: FacebookLoginServiceDelegate
    
    init(delegate: FacebookLoginServiceDelegate) {
        self.delegate = delegate
    }
    
    func dispathWithParams(params: NSDictionary) {
        Command(params: params, delegate: self, url: mConstant.url).post()
    }
    
    override func successCallback(responseObject: AnyObject) {
        let response = responseObject as! NSDictionary
        let apikey: String = response.objectForKey(mConstant.PARAMETER_KEY_APIKEY) as! String
        if let friendsCount: AnyObject = response.objectForKey(mConstant.PARAMETER_KEY_FRIENDS_COUNT) {
            self.delegate.handleFacebookLoginSuccess(apikey, isNewUser: true)
        } else {
            self.delegate.handleFacebookLoginSuccess(apikey, isNewUser: false)
        }
    }
    
    override func failCallback(responseObject: AnyObject) {
        println("\(responseObject)");
        self.delegate.handleFacebookLoginFail?()
    }
}
