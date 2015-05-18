//
//  GetUserProfileService.swift
//  TURides
//
//  Created by Dennis Hui on 12/05/15.
//
//

import UIKit

protocol GetUserProfileServiceDelegate {
    func handleGetUserProfileServiceSucess()
    func handleGetUserProfileServiceFail()
}

class GetUserProfileService: Service {
    var delegate: GetUserProfileServiceDelegate
    
    struct mConstant {
        static let url = "http://54.206.6.242/app_dev.php/en/api/v1/user/profile.json"
    }
    
    init(delegate: GetUserProfileServiceDelegate) {
        self.delegate = delegate
    }
    
    func dispatchWithParams(params: NSDictionary) {
        Command(params: params, delegate: self, url: mConstant.url).get()
    }
    
    override func successCallback(responseObject: AnyObject) {
        let json = JSON(responseObject)
        
        let name = json["result"]["name"].string!
        let email = json["result"]["name"].string!
        let profileIconString = json["result"]["avatar"].string!
        let decodedData = NSData(base64EncodedString: profileIconString, options: NSDataBase64DecodingOptions(rawValue: 0))
        var decodedimage = UIImage(data: decodedData!)
        
        let user = User(id: "124", name: name, email: email, profileIcon: decodedimage!)
        Session.sharedInstance.me = user
        
        delegate.handleGetUserProfileServiceSucess()
    }
    
    override func failCallback(responseObject: AnyObject) {
        println(responseObject)
    }
}
