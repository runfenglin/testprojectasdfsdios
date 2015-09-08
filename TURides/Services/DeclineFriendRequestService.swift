//
//  DeclineFriendRequestService.swift
//  TURides
//
//  Created by Dennis Hui on 2/08/15.
//
//

import UIKit

protocol DeclineAddFriendRequestServiceDelegate {
    func handleDeclineAddFriendRequestSuccess()
    func handleDeclineAddFriendRequestFail()
}

class DeclineFriendRequestService: Service {
    struct mConstant {
        static let URL = "friend/decline.json"
        static let LOADING_MESSAGE = "Loading..."
    }
    
    var delegate: DeclineAddFriendRequestServiceDelegate
    
    init(delegate: DeclineAddFriendRequestServiceDelegate) {
        self.delegate = delegate
    }
    
    func dispathWithParams(params: NSDictionary) {
        Command(params: params, delegate: self, url: mConstant.URL).post()
    }
    
    override func successCallback(responseObject: AnyObject) {
        delegate.handleDeclineAddFriendRequestSuccess()
    }
    
    override func failCallback(responseObject: AnyObject) {
        delegate.handleDeclineAddFriendRequestSuccess()
    }
}
