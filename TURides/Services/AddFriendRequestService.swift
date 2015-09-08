//
//  AddFriendRequestService.swift
//  TURides
//
//  Created by Dennis Hui on 2/08/15.
//
//

import UIKit

protocol AddFriendRequestServiceDelegate {
    func handleAddFriendRequestSuccess()
    func handleAddFriendRequestFail()
}

class AddFriendRequestService: Service {
    struct mConstant {
        static let URL = "friend/request.json"
        static let LOADING_MESSAGE = "Loading..."
        
        static let KEY_ID = "id"
    }
    
    var delegate: AddFriendRequestServiceDelegate
    
    init(delegate: AddFriendRequestServiceDelegate) {
        self.delegate = delegate
    }
    
    func dispathWithParams(params: NSDictionary) {
        Command(params: params, delegate: self, url: mConstant.URL).post()
    }
    
    override func successCallback(responseObject: AnyObject) {
        delegate.handleAddFriendRequestSuccess()
    }
    
    override func failCallback(responseObject: AnyObject) {
        delegate.handleAddFriendRequestSuccess()
    }
}
