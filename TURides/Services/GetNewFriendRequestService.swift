//
//  GetNewFriendRequestService.swift
//  TURides
//
//  Created by Dennis Hui on 4/08/15.
//
//

import UIKit

protocol GetNewFriendRequestServiceDelegate {
    func handleGetNewFriendRequestSuccess(friends: NSArray)
    func handleGetNewFriendRequestFail()
}

class GetNewFriendRequestService: Service {
    struct mConstant {
        static let URL = "user/friend/request.json"
        static let LOADING_MESSAGE = "Loading..."
        
        static let KEY_ID = "id"
    }
    
    var delegate: GetNewFriendRequestServiceDelegate
    
    init(delegate: GetNewFriendRequestServiceDelegate) {
        self.delegate = delegate
    }
    
    func dispathWithParams(params: NSDictionary) {
        Command(params: params, delegate: self, url: mConstant.URL).get()
    }
    
    override func successCallback(responseObject: AnyObject) {
        let json = JSON(responseObject)
        var friends: [User] = []
        if let friendsArray = json.array {
            
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
        }

        delegate.handleGetNewFriendRequestSuccess(friends)
    }
    
    override func failCallback(responseObject: AnyObject) {
        delegate.handleGetNewFriendRequestFail()
    }
}
