//
//  CreateCheckInService.swift
//  TURides
//
//  Created by Dennis Hui on 30/04/15.
//
//

import UIKit

@objc protocol CreateCheckInServiceDelegate {
    func handleCreateCheckInServiceSuccess()
    optional func handleCreateCheckInServiceFail()
}

class CreateCheckInService: Service {
   
    var delegate: CreateCheckInServiceDelegate
    
    struct mConstant {
        static let URL = "checkin/create.json"
        static let PARAMETER_KEY_COMMENT = "comment"
        static let PARAMETER_KEY_PLACE_ID = "checkinReference"
        static let PARAMETER_KEY_PLACE_NAME = "checkinName"
    }
    
    init(delegate: CreateCheckInServiceDelegate) {
        self.delegate = delegate
    }
    
    func dispathWithParams(params: NSDictionary) {
        Command(params: params, delegate: self, url: mConstant.URL).post()
    }
    
    override func successCallback(responseObject: AnyObject) {
        println(responseObject)
    }
    
    override func failCallback(responseObject: AnyObject) {
        
    }
    
}
