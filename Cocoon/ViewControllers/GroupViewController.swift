//
//  GroupViewController.swift
//  Cocoon
//
//  Created by Jake Trefethen on 7/1/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import UIKit

class GroupViewController: LoadingTableViewController {

    var id = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Viewing group with id: ")
        println(id)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        requestData("/group/info/", parameters: ["group": id] )
        
    }
    
    override func handleTableResponse(response: Response) {
        
        items.append(Link(id: 0, type: "fuck", displayName: "FUCK"))
        
        super.handleTableResponse(response)
        
    }
    
    override func handleTableError(error: Error) {
        
        super.handleTableError(error)
        
    }
    
    @IBAction func close(sender: AnyObject) {
        navigationController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setGroup(id: Int) {
        self.id = id
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

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
