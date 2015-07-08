//
//  FriendTableViewCell.swift
//  TURides
//
//  Created by Dennis Hui on 7/07/15.
//
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    
    @IBOutlet var profileIconImageView: UIImageView!
    @IBOutlet var friendNameLabel: UILabel!
    
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
    }

}
