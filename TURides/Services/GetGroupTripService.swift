//
//  GetGroupTripService.swift
//  TURides
//
//  Created by Dennis Hui on 13/07/15.
//
//

import UIKit

protocol GetGroupTripServiceDelegate {
    func handleGetGroupTripSuccess(trips: [Trip])
    func handleGetGroupTripFail()
}

class GetGroupTripService: Service {
    
    struct mConstant {
        static let url = "http://54.206.6.242/app_dev.php/en/api/v1/trip/group.json"
        static let LOADING_MESSAGE = "Loading..."
        
    }
    
    var delegate: GetGroupTripServiceDelegate
    var tripsArray: [Trip]
    
    init(delegate: GetGroupTripServiceDelegate) {
        self.delegate = delegate
        self.tripsArray = Array()
    }
    
    func dispathWithParams(params: NSDictionary) {
        Command(params: params, delegate: self, url: mConstant.url).get()
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
                
                let numberOfParticipants: NSNumber! = tripDict["offer_count"].number
                
                var drivers: [User]! = []
                var passengers: [User]! = []
                
                if let participants = tripDict["group_users"].array {
                    for participantDict in participants {
                        let id = participantDict["id"].number
                        let userName: String! = (participantDict["name"]).string
                        let user = User(id: userID.stringValue, name: userName, email: "", profileIcon: UIImage())
                        if let userAvatar = (participantDict["avatar"]).string {
                            let decodedData = NSData(base64EncodedString: userAvatar, options: NSDataBase64DecodingOptions(rawValue: 0))
                            user.profileIcon =  UIImage(data: decodedData!)!
                        }
                        if participantDict["role"].number == 2 {
                            drivers.append(user)
                        } else if participantDict["role"].number == 4{
                            passengers.append(user)
                        }
                    }
                }
                
                let tripID: NSNumber! = tripDict["id"].number
                
                let trip: GroupTrip = GroupTrip(tripID: tripID, orgnizer: user, departure: departure, destination: destination,departureTime: date, numberOfParticipants: 3)
                if drivers.count > 0 {
                    trip.drivers = drivers
                }
                if passengers.count > 0 {
                    trip.passengers = passengers
                }
                
                trip.numberOfParticipants = drivers.count + passengers.count + 1
                self.tripsArray.append(trip)
            }
        }
        
        delegate.handleGetGroupTripSuccess(self.tripsArray)
    }
    
    override func failCallback(responseObject: AnyObject) {
        delegate.handleGetGroupTripFail()
    }
}
