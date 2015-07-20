//
//  PickDriverViewController.swift
//  TURides
//
//  Created by Dennis Hui on 5/07/15.
//
//

import UIKit

class PickDriverViewController: UITableViewController, PickDriverServiceDelegate {

    var offers = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return offers.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("pick-drive-cell", forIndexPath: indexPath) as! PickDriverTableViewCell
        
        let offer = offers[indexPath.row] as! TripOffer
        cell.configureCell(offer.user)
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let offer = offers[indexPath.row] as! TripOffer
        let id = offer.id
        let params = NSMutableDictionary()
        params.setValue(id, forKey: "id")
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        PickDriverService(delegate: self).dispathWithParams(
        params)
    }
    
    func handlePickDriverSuccess() {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func handlePickDriverFaile() {
        
    }
}
