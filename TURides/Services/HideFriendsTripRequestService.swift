//
//  HideFriendsTripRequestService.swift
//  TURides
//
//  Created by Dennis Hui on 19/07/15.
//
//

import UIKit

protocol HideFriendsTripRequestServiceDelegate {
    func handleHideFriendsTripRequestSuccess()
    func handleHideFriendsTripRequestFail()
}

class HideFriendsTripRequestService: Service {
    struct mConstant {
        static let url = "http://54.206.6.242/app_dev.php/en/api/v1/trip/hide.json"
        static let LOADING_MESSAGE = "Loading..."
    }
    
    var delegate: HideFriendsTripRequestServiceDelegate
    
    init(delegate: HideFriendsTripRequestServiceDelegate) {
        self.delegate = delegate
    }
    
    func dispathWithParams(params: NSDictionary) {
        Command(params: params, delegate: self, url: mConstant.url).delete()
    }
    
    override func successCallback(responseObject: AnyObject) {
        delegate.handleHideFriendsTripRequestSuccess()
    }
    
    override func failCallback(responseObject: AnyObject) {
        delegate.handleHideFriendsTripRequestFail()
    }
    
}
