//
//  SearchFriendsService.swift
//  TURides
//
//  Created by Dennis Hui on 2/08/15.
//
//

import UIKit

protocol SearchFriendsServiceDelegate {
    func handleSearchFriendsSuccess(friends: NSArray)
    func handleSearchFriendsFail()
}

class SearchFriendsService: Service {
    struct mConstant {
        static let url = "http://54.206.6.242/app_dev.php/en/api/v1/friend/search.json"
        static let LOADING_MESSAGE = "Loading..."
        static let KEY_KEYWORD = "keyword"
    }
    
    var delegate: SearchFriendsServiceDelegate
    
    init(delegate: SearchFriendsServiceDelegate) {
        self.delegate = delegate
    }
    
    func dispathWithParams(params: NSDictionary) {
        Command(params: params, delegate: self, url: mConstant.url).post()
    }
    
    override func successCallback(responseObject: AnyObject) {
        let json = JSON(responseObject)
        var friends: [User] = []
        if let friendsArray = json.array {
            
            for userDict in friendsArray {
                let id = userDict["id"].string!
                let name = userDict["name"].string!
                //let email = userDict["email"].string!
                let profileIconString = userDict["avatar"].string!
                let decodedData = NSData(base64EncodedString: profileIconString, options: NSDataBase64DecodingOptions(rawValue: 0))
                var decodedimage = UIImage(data: decodedData!)
                let user = User(id: id, name: name, email: "", profileIcon: decodedimage!)
                friends.append(user)
            }
        }

        delegate.handleSearchFriendsSuccess(friends)
    }
    
    override func failCallback(responseObject: AnyObject) {
        delegate.handleSearchFriendsFail()
    }
}
