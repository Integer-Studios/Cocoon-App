//
//  FamilyViewController.swift
//  Cocoon
//
//  Created by Jake Trefethen on 6/23/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import UIKit

class FamilyViewController: LoadingTableViewController {
    
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
        if let fam = Cocoon.user?.getFamily() {
            requestData("/family/info/", parameters: ["family": fam.id] )
        }
        
    }
    
    
    override func handleTableResponse(response: Response) {
        
        self.items.removeAll(keepCapacity: false)
        
        for kidObject in response.content!["kids"] as! NSArray {
            
            items.append(Link.unwrapKid(kidObject as! NSMutableDictionary))
            
        }
        
        items.append(Link(id: 0, type : "family.menu", displayName: "Add a Kid"))
        
        for vehicleObject in response.content!["vehicles"] as! NSArray {
            
            items.append(Link.unwrapVehicle(vehicleObject as! NSMutableDictionary))
            
        }
        
        items.append(Link(id: 1, type : "family.menu", displayName: "Add a Vehicle"))
        
        super.handleTableResponse(response)
    }
    
    override func handleTableError(error: Error) {
        
        super.handleTableError(error)
        
    }
    

}
