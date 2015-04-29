//
//  GooglePlaceSearchNearByService.swift
//  TURides
//
//  Created by Dennis Hui on 29/04/15.
//
//

import UIKit

@objc protocol GooglePlaceSearchNearByServiceDelegate {
    func handleGooglePlaceSearchSuccess(results: NSArray)
    optional func handleGooglePlaceSearchFail()
}

class GooglePlaceSearchNearByService: Service {
    
    var delegate: GooglePlaceSearchNearByServiceDelegate
    
    struct mConstant {
        static let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
        static let VALUE_KEY = "AIzaSyAd3AhgQ1Gv-MF6DSt0qfH8Zda2Reia5tk"
        static let VALUE_RADIUS = "1000"
        
        static let KEY_LOCATION = "location"
        static let KEY_RADIUS = "radius"
        static let KEY_KEY = "key"
        
        static let PARAMETER_KEY_ID = "id"
        static let PARAMETER_KEY_NAME = "name"
        static let PARAMETER_KEY_ADDRESS = "vicinity"
        static let PARAMETER_KEY_RESULT = "results"
    }
    
    init(delegate: GooglePlaceSearchNearByServiceDelegate) {
        self.delegate = delegate
    }
    
    func dispatch(location: NSString) {
        var params = NSMutableDictionary()
        
        params.setValue(mConstant.VALUE_KEY, forKey: mConstant.KEY_KEY)
        params.setValue("-36.78, 174.71", forKey: mConstant.KEY_LOCATION)
        params.setValue(mConstant.VALUE_RADIUS, forKey: mConstant.KEY_RADIUS)
       
        Command(params: params, delegate: self, url: mConstant.url).get()
    }
    
    override func successCallback(responseObject: AnyObject) {
        let response = responseObject as! NSDictionary
        let reuslts: NSArray = response.objectForKey(mConstant.PARAMETER_KEY_RESULT) as! NSArray
        var places = NSMutableArray();
        
        for item in reuslts {
            let id: String? = item.objectForKey(mConstant.PARAMETER_KEY_ID) as? String
            let name: String? = item.objectForKey(mConstant.PARAMETER_KEY_NAME) as? String
            let address: String? = item.objectForKey(mConstant.PARAMETER_KEY_ADDRESS) as? String
            
            if id != nil || id!.isEmpty || name != nil || name!.isEmpty {
                let place = GooglePlace(id: id!, name: name!, address: address!)
                
                places.addObject(place)
            }
        }
        
        delegate.handleGooglePlaceSearchSuccess(places)
    }
    
    override func failCallback(responseObject: AnyObject) {
        
    }
}
