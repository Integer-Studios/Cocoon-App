//
//  GroupsViewController.swift
//  Cocoon
//
//  Created by Jake Trefethen on 6/30/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import UIKit

class GroupsViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate  {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var items : [Link] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        requestData("/user/groups/", parameters: NSMutableDictionary())
        
    }
    
    func handleTableResponse(response: Response) {
        
        self.items.removeAll(keepCapacity: false)
        
        for groupObject in response.content!["groups"] as! NSArray {
            
            items.append(Link.unwrapGroup(groupObject as! NSMutableDictionary))
            
        }
        
        items.append(Link(id: 0, type: "groups.menu", displayName: "Create A Group"))
        
        self.tableView.reloadData()
    }
    
    func handleTableError(error: Error) {
        
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("itemCell", forIndexPath: indexPath) as! ButtonCell
        cell.setButtonLink(items[indexPath.row], viewController: self)
        cell.displayName?.text = items[indexPath.row].displayName
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        items[indexPath.row].open(self)
        
    }
    
    func requestData(request: String, parameters : NSMutableDictionary, debug: Bool = false) {
        
        Cocoon.requestManager.sendRequest(request, parameters: parameters, debug: debug, responseHandler: handleTableResponse, errorHandler: handleTableError)
        
    }
    
}
