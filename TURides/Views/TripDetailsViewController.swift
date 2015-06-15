//
//  TripDetailsViewController.swift
//  TURides
//
//  Created by Dennis Hui on 13/06/15.
//
//

import UIKit

class TripDetailsViewController: BaseViewController {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tripDetailsLabel: UILabel!
    
    var trip: Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.None
        
//        userNameLabel.text = trip?.orgnizer.name
//        userImageView.image = trip?.orgnizer.profileIcon
//        var label = "From: \(trip?.departure.name)\nTo: \(trip?.destination.name)\nPick up time: \(trip)"
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
