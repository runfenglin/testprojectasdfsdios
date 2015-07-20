//
//  JoinGroupTripService.swift
//  TURides
//
//  Created by Dennis Hui on 20/07/15.
//
//

import UIKit

protocol JoinGroupTripServiceDelegate {
    func handleJoinGroupTripSuccess()
    func handleJoinGroupTripFail()
}

class JoinGroupTripService: Service {
    struct mConstant {
        static let url = "http://54.206.6.242/app_dev.php/en/api/v1/user/join/grouptrip.json"
        static let LOADING_MESSAGE = "Loading..."
    }
    
    var delegate: JoinGroupTripServiceDelegate
    
    init(delegate: JoinGroupTripServiceDelegate) {
        self.delegate = delegate
    }
    
    func dispathWithParams(params: NSDictionary) {
        Command(params: params, delegate: self, url: mConstant.url).post()
    }
    
    override func successCallback(responseObject: AnyObject) {
        delegate.handleJoinGroupTripSuccess()
    }
    
    override func failCallback(responseObject: AnyObject) {
        delegate.handleJoinGroupTripFail()
    }

}
