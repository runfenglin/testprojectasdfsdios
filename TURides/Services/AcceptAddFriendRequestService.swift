//
//  AcceptAddFriendRequestService.swift
//  TURides
//
//  Created by Dennis Hui on 2/08/15.
//
//

import UIKit

protocol AcceptAddFriendRequestServiceDelegate {
    func handleAcceptAddFriendRequestSuccess()
    func handleAcceptAddFriendRequestFail()
}

class AcceptAddFriendRequestService: Service {
    struct mConstant {
        static let URL = "friend/confirm.json"
        static let LOADING_MESSAGE = "Loading..."
    }
    
    var delegate: AcceptAddFriendRequestServiceDelegate
    
    init(delegate: AcceptAddFriendRequestServiceDelegate) {
        self.delegate = delegate
    }
    
    func dispathWithParams(params: NSDictionary) {
        Command(params: params, delegate: self, url: mConstant.URL).post()
    }
    
    override func successCallback(responseObject: AnyObject) {
        delegate.handleAcceptAddFriendRequestSuccess()
    }
    
    override func failCallback(responseObject: AnyObject) {
        delegate.handleAcceptAddFriendRequestSuccess()
    }
}