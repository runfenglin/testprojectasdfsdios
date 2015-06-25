//
//  Trip.swift
//  TURides
//
//  Created by Dennis Hui on 8/06/15.
//
//

import UIKit

class Trip: NSObject {
    var tripID: NSNumber
    var departure: GooglePlace
    var destination: GooglePlace
    var numberOfOffers: Int
    var isGroupTrip: Bool
    var orgnizer: User
    var departureTime: NSDate
    
    init(tripID: NSNumber, orgnizer: User, departure: GooglePlace, destination: GooglePlace, numberOfOffers: Int, isGroupTrip: Bool, departureTime: NSDate) {
        self.departure = departure
        self.destination = destination
        self.numberOfOffers = numberOfOffers
        self.isGroupTrip = isGroupTrip
        self.orgnizer = orgnizer
        self.departureTime = departureTime
        self.tripID = tripID
    }
}
