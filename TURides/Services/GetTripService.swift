//
//  GetTripService.swift
//  TURides
//
//  Created by Dennis Hui on 7/06/15.
//
//

import UIKit

protocol GetTripServiceDelegate {
    func handleGetTripSuccess(trips: [Trip])
    func handleGetTripFail()
}

class GetTripService: Service {
    struct mConstant {
        static let URL = "trip/request.json"
        static let LOADING_MESSAGE = "Loading..."
        
    }
    var delegate: GetTripServiceDelegate
    var tripsArray: [Trip]
    
    init(delegate: GetTripServiceDelegate) {
        self.delegate = delegate
        self.tripsArray = Array()
    }
    
    func dispathWithParams(params: NSDictionary) {
        TULog.Log("Getting Friends' Trip Requests")
        Command(params: params, delegate: self, url: mConstant.URL).get()
    }
    
    override func successCallback(responseObject: AnyObject) {
        
        let json = JSON(responseObject)
        if let tripsArray = json.array {
            TULog.Log("NUMBER OF FRIENS'S TRIP REQUESTS FOUND: \(tripsArray.count)")
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
                
                let numberOfOffers: NSNumber! = tripDict["offer_count"].number
                
                let tripID: NSNumber! = tripDict["id"].number
                
                let trip: Trip = Trip(tripID: tripID, orgnizer: user, departure: departure, destination: destination, departureTime: date)
                self.tripsArray.append(trip)
            }
        }
        
        delegate.handleGetTripSuccess(self.tripsArray)
    }
    
    override func failCallback(responseObject: AnyObject) {
        delegate.handleGetTripFail()
    }
}
