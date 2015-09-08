//
//  GetPairedTripService.swift
//  TURides
//
//  Created by Dennis Hui on 27/06/15.
//
//

import UIKit

protocol GetPairedTripServiceDelegate {
    func handleGetPairedTripSuccess(trips: [Trip])
    func handleGetPairedTripFail()
}

class GetPairedTripService: Service {
    
    struct mConstant {
        static let URL = "user/trip.json"
        static let LOADING_MESSAGE = "Loading..."
        
    }
    
    var delegate: GetPairedTripServiceDelegate
    var tripsArray: [Trip]
    
    init(delegate: GetPairedTripServiceDelegate) {
        self.delegate = delegate
        self.tripsArray = Array()
    }
    
    func dispathWithParams(params: NSDictionary) {
        Command(params: params, delegate: self, url: mConstant.URL).get()
    }
    
    override func successCallback(responseObject: AnyObject) {
        let json = JSON(responseObject)
        if let tripsArray = json.array {
            for tripDict in tripsArray {
                let userID: NSNumber! = (tripDict["user"]["id"]).number
                let userName: String! = (tripDict["user"]["name"]).string
                let user = User(id: userID.stringValue, name: userName, email: "", profileIcon: UIImage())
                
                if let userAvatar = (tripDict["user"]["avatar"]).string {
                    let decodedData = NSData(base64EncodedString: userAvatar, options: NSDataBase64DecodingOptions(rawValue: 0))
                    user.profileIcon =  UIImage(data: decodedData!)!
                }
                
                let departureID: String! = tripDict["departure_reference"].string
                let departureName: String! = tripDict["departure"].string
                let departureAddress: String! = tripDict["departure"].string
                
                let destinationID: String! = tripDict["destination_reference"].string
                let destinationName: String! = tripDict["destination"].string
                let destinationAddress: String! = tripDict["destination"].string
                
                let departure = GooglePlace(id: departureID, name: departureName, address: departureAddress)
                let destination = GooglePlace(id: destinationID, name: destinationName, address: destinationAddress)
                
                let timeInterval: NSNumber! = tripDict["time"].number
                let date = NSDate(timeIntervalSince1970: timeInterval.doubleValue)
                
                var numberOfOffers: NSNumber? = tripDict["offer_count"].number
                
                if numberOfOffers == nil {
                    numberOfOffers = 0
                }
                
                let tripID: NSNumber! = tripDict["id"].number
                
                let trip: Trip = Trip(tripID: tripID, orgnizer: user, departure: departure, destination: destination, departureTime: date)
                trip.numberOfOffers = numberOfOffers!.integerValue
                
                if let driverID = tripDict["driver"]["id"].number {
                    let driverName: String! = (tripDict["driver"]["name"]).string
                    let user = User(id: driverID.stringValue, name: userName, email: "", profileIcon: UIImage())
                    
                    if let userAvatar = (tripDict["driver"]["avatar"]).string {
                        let decodedData = NSData(base64EncodedString: userAvatar, options: NSDataBase64DecodingOptions(rawValue: 0))
                        user.profileIcon =  UIImage(data: decodedData!)!
                    }
                    trip.driver = user
                }
                
                self.tripsArray.append(trip)
            }
        }
        
        delegate.handleGetPairedTripSuccess(self.tripsArray)

    }
}
