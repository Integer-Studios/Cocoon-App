//
//  GroupsViewController.swift
//  Cocoon
//
//  Created by Jake Trefethen on 6/30/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import UIKit

class GroupsViewController: LoadingTableViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
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
    
    
    override func handleTableResponse(response: Response) {
        
        self.items.removeAll(keepCapacity: false)
        
        for groupObject in response.content!["groups"] as! NSArray {
            
            items.append(Link.unwrapGroup(groupObject as! NSMutableDictionary))
            
        }
        
        items.append(Link(id: 0, type: "groups.menu", displayName: "Create A Group"))
        
        super.handleTableResponse(response)
    }
    
    override func handleTableError(error: Error) {
        
        super.handleTableError(error)
        
    }
    
}
