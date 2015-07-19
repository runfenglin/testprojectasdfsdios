//
//  GroupTrip.swift
//  TURides
//
//  Created by Dennis Hui on 14/07/15.
//
//

import UIKit

class GroupTrip: Trip {
    var numberOfParticipants: Int?
    var drivers: [User]?
    var passengers: [User]?
    
    init(tripID: NSNumber, orgnizer: User, departure: GooglePlace, destination: GooglePlace, departureTime: NSDate, numberOfParticipants: Int) {
        super.init(tripID: tripID, orgnizer: orgnizer, departure: departure, destination: destination, departureTime: departureTime)
        self.numberOfParticipants = numberOfParticipants
    }
}
