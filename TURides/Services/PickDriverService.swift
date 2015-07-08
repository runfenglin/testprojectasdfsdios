//
//  PickDriverService.swift
//  TURides
//
//  Created by Dennis Hui on 5/07/15.
//
//

import UIKit

protocol PickDriverServiceDelegate {
    func handlePickDriverSuccess()
    func handlePickDriverFaile()
}

class PickDriverService: Service {
    var delegate: PickDriverServiceDelegate
    
    struct mConstant {
        static let url = "http://54.206.6.242/app_dev.php/en/api/v1/user/pick/driver/{id}.json"
        static let LOADING_MESSAGE = "Loading..."
    }
    
    init(delegate: PickDriverServiceDelegate) {
        self.delegate = delegate
    }
    
    func dispathWithParams(params: NSDictionary) {
        let id = params.objectForKey("id") as! String
        let url = mConstant.url.stringByReplacingOccurrencesOfString("{id}", withString: id, options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        Command(params: NSDictionary(), delegate: self, url: url).get()
    }
    
    override func successCallback(responseObject: AnyObject) {
        self.delegate.handlePickDriverSuccess()
    }
}
