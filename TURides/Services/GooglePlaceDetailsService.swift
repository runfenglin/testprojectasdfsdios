//
//  GooglePlaceDetailsService.swift
//  TURides
//
//  Created by Dennis Hui on 9/07/15.
//
//

import UIKit
import MapKit

protocol GooglePlaceDetailsServiceDelegate {
    func handleGooglePlaceDetailsSuccess(location: CLLocation)
}

class GooglePlaceDetailsService: Service {
    var delegate: GooglePlaceDetailsServiceDelegate
    
    init(delegate: GooglePlaceDetailsServiceDelegate) {
        self.delegate = delegate
    }
    
    struct mConstant {
        
        static let URL = "https://maps.googleapis.com/maps/api/place/details/json"
        static let VALUE_KEY = "AIzaSyAd3AhgQ1Gv-MF6DSt0qfH8Zda2Reia5tk"
        static let VALUE_RADIUS = "1000"
        
        static let KEY_LOCATION = "location"
        static let KEY_INPUT = "input"
        static let KEY_KEY = "key"
        
        static let PARAMETER_KEY_ID = "placeid"
    }
    
    func dispatch(id: NSString) {
        var params = NSMutableDictionary()
        
       
        params.setValue(id, forKey: mConstant.PARAMETER_KEY_ID)
        params.setValue(mConstant.VALUE_KEY, forKey: mConstant.KEY_KEY)
        
        Command(params: params, delegate: self, url: mConstant.URL).get()
    }
    
    override func successCallback(responseObject: AnyObject) {
        println(responseObject)
        let json = JSON(responseObject["result"]!)
        
        let lat = json["geometry"]["location"]["lat"].number!
        let lgn = json["geometry"]["location"]["lng"].number!
        
        let location:CLLocation = CLLocation(latitude: lat.doubleValue, longitude: lgn.doubleValue)

        
        var results = NSMutableArray()
        
        
        delegate.handleGooglePlaceDetailsSuccess(location)
    }

}
