//
//  AcceptTripService.swift
//  TURides
//
//  Created by Dennis Hui on 13/06/15.
//
//

import UIKit

protocol AcceptTripServiceDelegate {
    func handleAcceptTripSuccess()
    func handleAcceptTripFail()
}

class AcceptTripService: Service {
    struct mConstant {
        static let URL = "user/accept/request.json"
        static let LOADING_MESSAGE = "Loading..."
    }
    
    var delegate: AcceptTripServiceDelegate
    
    init(delegate: AcceptTripServiceDelegate) {
        self.delegate = delegate
    }
    
    func dispathWithParams(params: NSDictionary) {
        Command(params: params, delegate: self, url: mConstant.URL).post()
    }
    
    override func successCallback(responseObject: AnyObject) {
        delegate.handleAcceptTripSuccess()
    }
    
    override func failCallback(responseObject: AnyObject) {
        delegate.handleAcceptTripFail()
    }
}
