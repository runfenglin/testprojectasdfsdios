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
    var numberOfOffers: Int?
    var orgnizer: User
    var departureTime: NSDate
    
    init(tripID: NSNumber, orgnizer: User, departure: GooglePlace, destination: GooglePlace, departureTime: NSDate) {
        self.tripID = tripID
        self.orgnizer = orgnizer
        self.departure = departure
        self.destination = destination
        self.departureTime = departureTime
    }
}
