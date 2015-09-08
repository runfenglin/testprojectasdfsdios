//
//  GetTripOffersService.swift
//  TURides
//
//  Created by Dennis Hui on 22/06/15.
//
//

import UIKit

protocol GetTripOffersServiceDelegate {
    func GetTripOffersSuccess(offers: [TripOffer])
    func GetTripOffersFail()
}

class GetTripOffersService: Service {
    
    var delegate: GetTripOffersServiceDelegate
    var offerArray: [TripOffer]
    
    struct mConstant {
        static let URL = "user/request/{id}/offers.json"
        static let LOADING_MESSAGE = "Loading..."
    }
    
    init(delegate: GetTripOffersServiceDelegate) {
        self.delegate = delegate
        self.offerArray = [];
    }
    
    func dispathWithParams(params: NSDictionary) {
        let id = params.objectForKey("id") as! NSNumber
        let url = mConstant.URL.stringByReplacingOccurrencesOfString("{id}", withString: id.stringValue, options: NSStringCompareOptions.LiteralSearch, range: nil)
        let a = NSMutableDictionary()
        a.setValue("en", forKey: "locale")
        Command(params: a, delegate: self, url: url).get()
    }
    
    override func successCallback(responseObject: AnyObject) {
        println(responseObject)
        let json = JSON(responseObject)
        if let offersArray = json.array {
            for offerDict in offersArray {
                let userID: NSNumber! = (offerDict["user"]["id"]).number
                let userName: String! = (offerDict["user"]["name"]).string
                let user = User(id: userID.stringValue, name: userName, email: "", profileIcon: UIImage())
                if let userAvatar = (offerDict["user"]["avatar"]).string {
                    let decodedData = NSData(base64EncodedString: userAvatar, options: NSDataBase64DecodingOptions(rawValue: 0))
                    user.profileIcon =  UIImage(data: decodedData!)!
                }
                
                let tripID: NSNumber! = offerDict["id"].number
                let offer = TripOffer(id: tripID.stringValue, user: user)
                self.offerArray.append(offer)
            }
        }
        delegate.GetTripOffersSuccess(self.offerArray)
    }
    
    override func failCallback(responseObject: AnyObject) {
        
    }
}
