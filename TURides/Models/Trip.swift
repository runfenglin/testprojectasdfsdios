//
//  Trip.swift
//  TURides
//
//  Created by Dennis Hui on 8/06/15.
//
//

import UIKit

class Trip: NSObject {
    var departure: GooglePlace
    var destination: GooglePlace
    var numberOfParticipants: Int
    var isGroupTrip: Bool
    var orgnizer: User
    var departureTime: NSDate
    
    init(orgnizer: User, departure: GooglePlace, destination: GooglePlace, numberOfParticipants: Int, isGroupTrip: Bool, departureTime: NSDate) {
        self.departure = departure
        self.destination = destination
        self.numberOfParticipants = numberOfParticipants
        self.isGroupTrip = isGroupTrip
        self.orgnizer = orgnizer
        self.departureTime = departureTime
    }
}
