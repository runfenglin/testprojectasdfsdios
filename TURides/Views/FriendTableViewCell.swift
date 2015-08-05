//
//  FriendTableViewCell.swift
//  TURides
//
//  Created by Dennis Hui on 7/07/15.
//
//

import UIKit

protocol FriendTableViewCellDelegate {
    func didAccept(friend: User)
    func didDecline(friend: User)
}

class FriendTableViewCell: UITableViewCell {

    
    @IBOutlet var profileIconImageView: UIImageView!
    @IBOutlet var friendNameLabel: UILabel!
    
    var delegate: FriendTableViewCellDelegate?
    var user: User?
    
    @IBAction func acceptButtonTouched(sender: AnyObject) {
        delegate!.didAccept(user!)
    }
    
    @IBAction func declineButtonTouched(sender: AnyObject) {
        delegate!.didDecline(user!)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(aFriend: User) {
        profileIconImageView.image = aFriend.profileIcon
        friendNameLabel.text = aFriend.name
        user = aFriend
    }

}
