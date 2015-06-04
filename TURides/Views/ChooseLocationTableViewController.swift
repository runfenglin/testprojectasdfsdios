//
//  ChooseLocationTableViewController.swift
//  TURides
//
//  Created by Dennis Hui on 21/05/15.
//
//

import UIKit

protocol ChooseLocationTableViewControllerDelegate {
    func didSelectLocation(addressLine1: NSString, addressLine2: NSString)
}

class ChooseLocationTableViewController: UITableViewController, UISearchBarDelegate, GooglePlaceAutocompleteServiceDelegate {

    var locations: NSArray?
    var delegate: ChooseLocationTableViewControllerDelegate?
    
    @IBOutlet weak var locationSearchBar: UISearchBar!
    
    //MARK: ========== View Life-cycle ==========
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        locationSearchBar.becomeFirstResponder()
    }

    // MARK: ========== Table view data source ==========
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if locations == nil {
            return 0
        } else {
            return locations!.count
        }
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        GooglePlaceAutocompleteService(delegate: self).dispatch(searchText)
    }
    
    func handleGooglePlaceAutocompleteSuccess(locations: NSArray) {
        self.locations = locations
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier") as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "reuseIdentifier")
        }
        // Configure the cell...
        let address = locations!.objectAtIndex(indexPath.row) as! NSString
        cell!.textLabel!.text = address as String

        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var address = locations!.objectAtIndex(indexPath.row) as! NSString
        
        let addressLine1 = address.substringToIndex(address.rangeOfString(",").location)
        let addressLine2 = address.substringFromIndex(address.rangeOfString(",").location + 2)
        
        delegate!.didSelectLocation(addressLine1, addressLine2: addressLine2)
        self.navigationController?.popViewControllerAnimated(true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
