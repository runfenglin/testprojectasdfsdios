//
//  TripDetailsViewController.swift
//  TURides
//
//  Created by Dennis Hui on 13/06/15.
//
//

import UIKit

class TripDetailsViewController: BaseViewController, AcceptTripServiceDelegate {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tripDetailsLabel: UILabel!
    
    var trip: Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.None
        
        userNameLabel.text = trip?.orgnizer.name
        userImageView.image = trip?.orgnizer.profileIcon
        var label = "From: \(trip!.departure.name)\nTo: \(trip!.destination.name)\nPick up time: \(trip!.departureTime)"
        tripDetailsLabel.text = label
    }
    @IBAction func acceptButtonTouched(sender: AnyObject) {
        let params = NSMutableDictionary()
        params.setValue(trip?.tripID, forKey: "trip")
        let service = AcceptTripService(delegate: self)
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        service.dispathWithParams(params)
    }
    
    func handleAcceptTripSuccess() {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
    
    func handleAcceptTripFail() {
        
    }

}
