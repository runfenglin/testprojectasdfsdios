//
//  GetTripOffersService.swift
//  TURides
//
//  Created by Dennis Hui on 22/06/15.
//
//

import UIKit

protocol GetTripOffersServiceDelegate {
    func GetTripOffersSuccess()
    func GetTripOffersFail()
}

class GetTripOffersService: Service {
    struct mConstant {
        static let url = "http://54.206.6.242/app_dev.php/en/api/v1/user/request/{id}/offer.json"
        static let LOADING_MESSAGE = "Loading..."
    }
    
    func dispathWithParams(params: NSDictionary) {
        Command(params: params, delegate: self, url: mConstant.url).get()
    }
}
