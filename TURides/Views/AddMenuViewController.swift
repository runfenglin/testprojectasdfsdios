//
//  AddMenuViewController.swift
//  TURides
//
//  Created by Dennis Hui on 4/06/15.
//
//

import UIKit

protocol AddMenuViewControllerDelegate {
    func handleAddNewCheckin()
    func handleAddNewTrip()
    func handleAddNewPhoto()
}

class AddMenuViewController: UITableViewController {

    var delegate: AddMenuViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            delegate?.handleAddNewTrip()
        }
    }
}
