//
//  CreateTripService.swift
//  TURides
//
//  Created by Dennis Hui on 28/05/15.
//
//

import UIKit

protocol CreateTripServiceDelegate {
    func handleCreateTripSuccess()
    func handleCreateTripFail()
}

class CreateTripService: Service {
    struct mConstant {
        static let url = "http://54.206.6.242/app_dev.php/en/api/v1/trip/create.json"
        static let LOADING_MESSAGE = "Loading..."
        static let PARAMETER_KEY_GROUP = "group"
        static let PARAMETER_KEY_DEPARTURE = "departure"
        static let PARAMETER_KEY_DEPARTURE_ID = "departureReference"
        static let PAREMETER_KEY_DESTINATION = "destination"
        static let PAREMETER_KEY_DESTINATION_ID = "destinationReference"
        static let PAREMETER_KEY_TIME = "time"
        static let PAREMETER_KEY_COMMENT = "comment"
        static let PAREMETER_KEY_VISIBILITY = "visibility"
        
    }
    
    var delegate: CreateTripServiceDelegate
    
    init(delegate: CreateTripServiceDelegate) {
        self.delegate = delegate
    }
    
    func dispathWithParams(params: NSDictionary) {
        Command(params: params, delegate: self, url: mConstant.url).post()
    }
    
    override func successCallback(responseObject: AnyObject) {
        
    }
    
    override func failCallback(responseObject: AnyObject) {
        
    }
}
