//
//  Command.swift
//  TURides
//
//  Created by Dennis Hui on 14/04/15.
//
//

import UIKit

class Command: NSObject {
    var params: NSDictionary
    var manager: AFHTTPRequestOperationManager
    var delegate: Service
    var url: String
    
    init(params: NSDictionary, delegate: Service, url: String) {
        self.params = params;
        self.manager = AFHTTPRequestOperationManager()
        if let apikey = KeyChainUtil.get(Constant.KEYCHAIN_KEY_APIKEY) {
            self.manager.requestSerializer.setValue(KeyChainUtil.get(Constant.KEYCHAIN_KEY_APIKEY), forHTTPHeaderField: "apikey")
        }
        self.delegate = delegate
        self.url = Constant.SERVICE_URL + url
    }
    
    func get() {
       // showLoading()
        

        manager.GET(
            url,
            parameters: params,
            success: {(operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                
                self.delegate.successCallback(responseObject)
            },
            failure: {(operation: AFHTTPRequestOperation!,error: NSError!) in
                println("\(error)")
            })
    }
    
    func post() {
        manager.POST(
        url as String,
        parameters: params,
        success: {(operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
            self.delegate.successCallback(responseObject)
        },
        failure: {(operation: AFHTTPRequestOperation!,error: NSError!) in
            println("\(error)")
        })

    }
    
    func delete() {
        manager.DELETE(
            url as String,
            parameters: params,
            success: {(operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                self.delegate.successCallback(responseObject)
            },
            failure: {(operation: AFHTTPRequestOperation!,error: NSError!) in
                println("\(error)")
        })
    
    }
    
}
