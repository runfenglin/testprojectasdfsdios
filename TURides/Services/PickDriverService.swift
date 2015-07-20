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
        static let url = "http://54.206.6.242/app_dev.php/en/api/v1/user/pick/driver.json"
        static let LOADING_MESSAGE = "Loading..."
    }
    
    init(delegate: PickDriverServiceDelegate) {
        self.delegate = delegate
    }
    
    func dispathWithParams(params: NSDictionary) {
        Command(params: params, delegate: self, url: mConstant.url).post()
    }
    
    override func successCallback(responseObject: AnyObject) {
        self.delegate.handlePickDriverSuccess()
    }
}
