//
//  TUTableViewCellType1TableViewCell.swift
//  TURides
//
//  Created by Dennis Hui on 16/04/15.
//
//

import UIKit

class TUTableViewCellType1TableViewCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var placeLabel1: UILabel!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var commentWrapperView: UIView!
    @IBOutlet weak var numberOfLikesLabel: UILabel!
    
    func imageTapped() {
        likeImageView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.likeImageView.transform = CGAffineTransformIdentity;
            }) { (Bool finished) -> Void in
                self.likeImageView.alpha = 1.0
                self.likeImageView.userInteractionEnabled = false
        }
        
        let number = numberOfLikesLabel.text!.toInt()
        let number2 = number! + 1
        
        numberOfLikesLabel.text = String(number2)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "imageTapped")
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        likeImageView.addGestureRecognizer(tapGesture)
        likeImageView.userInteractionEnabled = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
