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
        static let URL = "user/profile.json"
    }
    
    init(delegate: GetUserProfileServiceDelegate) {
        self.delegate = delegate
    }
    
    func dispatchWithParams(params: NSDictionary) {
        Command(params: params, delegate: self, url: mConstant.URL).get()
    }
    
    override func successCallback(responseObject: AnyObject) {
        let json = JSON(responseObject)
        
        let id = json["id"].number!
        let name = json["name"].string!
        let email = json["email"].string!
        let profileIconString = json["avatar"].string!
        let decodedData = NSData(base64EncodedString: profileIconString, options: NSDataBase64DecodingOptions(rawValue: 0))
        var decodedimage = UIImage(data: decodedData!)
        
        let user = User(id: id.stringValue, name: name, email: email, profileIcon: decodedimage!)
        Session.sharedInstance.me = user
        
        
        if let friendsArray = json["friends"]["data"].array {
            var friends: [User] = []
            for userDict in friendsArray {
                let id = userDict["id"].number!
                let name = userDict["name"].string!
                //let email = userDict["email"].string!
                let profileIconString = userDict["avatar"].string!
                let decodedData = NSData(base64EncodedString: profileIconString, options: NSDataBase64DecodingOptions(rawValue: 0))
                var decodedimage = UIImage(data: decodedData!)
                let user = User(id: id.stringValue, name: name, email: "", profileIcon: decodedimage!)
                friends.append(user)
            }
            
            Session.sharedInstance.friends = friends
        }
        
        
        delegate.handleGetUserProfileServiceSucess()
    }
    
    override func failCallback(responseObject: AnyObject) {
        println(responseObject)
    }
}
