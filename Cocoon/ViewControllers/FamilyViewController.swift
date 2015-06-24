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
        println("yo")
        if let fam = Cocoon.user?.getFamily() {
            self.requestData("family/info", parameters: ["family": fam.id] )
        }
        
    }
    
    override func handleTableResponse(response: Response) {
        
        var kidsResponse = response.content!["kids"] as! NSArray
        for kidObject in kidsResponse {
            
            var kid = kidObject as! NSMutableDictionary
            self.items.append(Link(id: (kid["id"] as! String).toInt()!, type: "kid", displayName: kid["first-name"] as! String))
            
        }
        
        super.handleTableResponse(response)
    }
    
    override func handleTableError(error: Error) {
        
        super.handleTableError(error)
        
    }

    @IBAction func close(sender: AnyObject) {
        
        self.navigationController!.dismissViewControllerAnimated(true, completion: nil)
        
    }
    

}
