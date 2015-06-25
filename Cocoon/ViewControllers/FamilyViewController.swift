//
//  FamilyViewController.swift
//  Cocoon
//
//  Created by Jake Trefethen on 6/23/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import UIKit

class FamilyViewController: LoadingTableViewController {
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
//        if let fam = Cocoon.user?.getFamily() {
//            self.requestData("/family/info/", parameters: ["family": fam.id] )
//        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        println("Loading")
        if let fam = Cocoon.user?.getFamily() {
            self.requestData("/family/info/", parameters: ["family": fam.id] )
        }
        
    }
    
    
    override func handleTableResponse(response: Response) {
        
        self.items.removeAll(keepCapacity: false)
        
        for kidObject in response.content!["kids"] as! NSArray {
            
            self.items.append(Link.unwrapKid(kidObject as! NSMutableDictionary))
            
        }
        
        self.items.append(Link(id: 0, type : "family.menu", displayName: "Add a Kid"))
        
        super.handleTableResponse(response)
    }
    
    override func handleTableError(error: Error) {
        
        super.handleTableError(error)
        
    }

    @IBAction func close(sender: AnyObject) {
        
        self.navigationController!.dismissViewControllerAnimated(true, completion: nil)
        
    }
    

}
