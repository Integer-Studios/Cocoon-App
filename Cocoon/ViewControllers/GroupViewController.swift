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
        
//        self.tableView.registerClass(EventCell.self, forCellReuseIdentifier: "eventCell")

    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        requestData("/group/events/", parameters: ["group": id] )
        //event[] {id, group, post, location, mandatory (bool), title, description, date}
        
    }
    
    
    override func handleTableResponse(response: Response) {
        
        items.removeAll(keepCapacity: false)
        
        for eventObject in response.content!["events"] as! NSArray {

            items.append(DetailedLink.unwrapEvent(eventObject as! NSMutableDictionary))
            
        }
        
        
        super.handleTableResponse(response)
    }
    
    override func handleTableError(error: Error) {
        
        super.handleTableError(error)
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //for the header
        return items.count + 1
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if (indexPath.row == 0) {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("groupHeaderCell", forIndexPath: indexPath) as! GroupHeaderCell
            cell.name?.text = "Group Name ??"
            return cell

        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("eventCell", forIndexPath: indexPath) as! EventCell
            cell.title?.text = (items[indexPath.row-1] as! DetailedLink).info[0]
            cell.date?.text = (items[indexPath.row-1] as! DetailedLink).info[1]
            return cell
            
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        return 60;
        
    }
    
    @IBAction func close(sender: AnyObject) {
        navigationController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setGroup(id: Int) {
        self.id = id
    }

}
