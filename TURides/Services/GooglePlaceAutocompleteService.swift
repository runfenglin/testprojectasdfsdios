//
//  GooglePlaceAutocompleteService.swift
//  TURides
//
//  Created by Dennis Hui on 19/05/15.
//
//

import UIKit

protocol GooglePlaceAutocompleteServiceDelegate {
    func handleGooglePlaceAutocompleteSuccess(locations: NSArray)
}

class GooglePlaceAutocompleteService: Service {
    var delegate: GooglePlaceAutocompleteServiceDelegate
    
    init(delegate: GooglePlaceAutocompleteServiceDelegate) {
        self.delegate = delegate
    }
    
    struct mConstant {
        static let url = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
        static let VALUE_KEY = "AIzaSyAd3AhgQ1Gv-MF6DSt0qfH8Zda2Reia5tk"
        static let VALUE_RADIUS = "1000"
        
        static let KEY_LOCATION = "location"
        static let KEY_INPUT = "input"
        static let KEY_KEY = "key"
        
        static let PARAMETER_KEY_ID = "id"
        static let PARAMETER_KEY_NAME = "name"
        static let PARAMETER_KEY_ADDRESS = "vicinity"
        static let PARAMETER_KEY_RESULT = "results"
    }
    
    func dispatch(queryString: NSString) {
        var params = NSMutableDictionary()
        
        params.setValue(mConstant.VALUE_KEY, forKey: mConstant.KEY_KEY)
        params.setValue("67 Tamahere", forKey: mConstant.KEY_INPUT)
        params.setValue("country:nz", forKey: "components")
        
        Command(params: params, delegate: self, url: mConstant.url).get()
    }
    
    override func successCallback(responseObject: AnyObject) {
        println(responseObject)
        let json = JSON(responseObject["predictions"]!)
        var results = NSMutableArray()
        if let locationsArray = json.array {
            for locationDic in locationsArray {
                results.addObject(locationDic["description"].string!)
            }
        }
        
        delegate.handleGooglePlaceAutocompleteSuccess(results)
    }

}
