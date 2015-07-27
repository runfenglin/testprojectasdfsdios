//
//  DeleteTripService.swift
//  TURides
//
//  Created by Dennis Hui on 20/07/15.
//
//

import UIKit

protocol DeleteTripServiceServiceDelegate {
    func handleDeleteTripSuccess()
    func handleDeleteTripFail()
}

class DeleteTripService: Service {
    struct mConstant {
        static let url = "http://54.206.6.242/app_dev.php/en/api/v1/user/delete/trip/{id}.json"
        static let LOADING_MESSAGE = "Loading..."
    }
    
    var delegate: DeleteTripServiceServiceDelegate
    
    init(delegate: DeleteTripServiceServiceDelegate) {
        self.delegate = delegate
    }
    
    func dispathWithParams(params: NSDictionary) {
        let id = params.objectForKey("id") as! NSNumber
        let url = mConstant.url.stringByReplacingOccurrencesOfString("{id}", withString: id.stringValue, options: NSStringCompareOptions.LiteralSearch, range: nil)
        Command(params: NSDictionary(), delegate: self, url: url).delete()
    }
    
    override func successCallback(responseObject: AnyObject) {
        delegate.handleDeleteTripSuccess()
    }
    
    override func failCallback(responseObject: AnyObject) {
        delegate.handleDeleteTripFail()
    }
}
