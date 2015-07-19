//
//  TripTableViewCell.swift
//  TURides
//
//  Created by Dennis Hui on 8/06/15.
//
//

import UIKit

class TripTableViewCell: UITableViewCell {
    @IBOutlet weak var tripRouteLabel: UILabel!
    @IBOutlet weak var tripOrgnizerImageView: UIImageView!
    @IBOutlet weak var tripTimeLabel: UILabel!

    @IBOutlet weak var numberOfParticipantsLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        numberOfParticipantsLabel.layer.cornerRadius = numberOfParticipantsLabel.frame.size.height/2
        numberOfParticipantsLabel.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCellWithTrip(trip: Trip) {
        tripOrgnizerImageView.image = trip.orgnizer.profileIcon
        
        
        
        if trip.isKindOfClass(GroupTrip) {
            let groupTrip = trip as! GroupTrip
            if groupTrip.numberOfParticipants != nil && groupTrip.numberOfParticipants > 0 {
                numberOfParticipantsLabel.text = String(groupTrip.numberOfParticipants!)
            } else {
                numberOfParticipantsLabel.hidden = true
            }
        } else {
            if trip.numberOfOffers > 0 {
                numberOfParticipantsLabel.text = String(trip.numberOfOffers!)
            } else {
                numberOfParticipantsLabel.hidden = true
            }
        }
    }

}
