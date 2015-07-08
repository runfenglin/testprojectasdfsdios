//
//  PickDriverTableViewCell.swift
//  TURides
//
//  Created by Dennis Hui on 5/07/15.
//
//

import UIKit

class PickDriverTableViewCell: UITableViewCell {

  
    @IBOutlet var iconImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(user: User) {
        iconImageView.image = user.profileIcon
        nameLabel.text = user.name
    }

}
