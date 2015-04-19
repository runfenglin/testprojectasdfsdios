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
    var url: NSString
    
    init(params: NSDictionary, delegate: Service, url: NSString) {
        self.params = params;
        self.manager = AFHTTPRequestOperationManager()
        self.delegate = delegate
        self.url = url
    }
    
    func get() {
       // showLoading()
        

        manager.GET(
            "http://54.206.6.242//api/v1/login/facebook.json",
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
    
}
