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
        static let URL = "trip/hide/{id}.json"
        static let LOADING_MESSAGE = "Loading..."
    }
    
    var delegate: HideFriendsTripRequestServiceDelegate
    
    init(delegate: HideFriendsTripRequestServiceDelegate) {
        self.delegate = delegate
    }
    
    func dispathWithParams(params: NSDictionary) {
        let id = params.objectForKey("id") as! NSNumber
        let url = mConstant.URL.stringByReplacingOccurrencesOfString("{id}", withString: id.stringValue, options: NSStringCompareOptions.LiteralSearch, range: nil)
        Command(params: NSDictionary(), delegate: self, url: url).delete()
    }
    
    override func successCallback(responseObject: AnyObject) {
        delegate.handleHideFriendsTripRequestSuccess()
    }
    
    override func failCallback(responseObject: AnyObject) {
        delegate.handleHideFriendsTripRequestFail()
    }
    
}
