//
//  UpdateDeviceTokenService.swift
//  TURides
//
//  Created by Dennis Hui on 22/06/15.
//
//

import UIKit

protocol UpdateDeviceTokenServiceDelegate {
    func updateDeviceTokenSuccess()
    func updateDeviceTokenFail()
}

class UpdateDeviceTokenService: Service {
    
    var delegate: UpdateDeviceTokenServiceDelegate
    
    init(delegate: UpdateDeviceTokenServiceDelegate) {
        self.delegate = delegate
    }
    
    struct mConstant {
        static let url = "http://54.206.6.242/app_dev.php/en/api/v1/user/device/token.json"
        static let LOADING_MESSAGE = "Loading..."
    }
    
    func dispathWithParams(params: NSDictionary) {
        Command(params: params, delegate: self, url: mConstant.url).post()
    }
    
    override func successCallback(responseObject: AnyObject) {
        delegate.updateDeviceTokenSuccess()
    }
    
    override func failCallback(responseObject: AnyObject) {
        delegate.updateDeviceTokenFail()
    }
}
