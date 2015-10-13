//
//  AdminViewController.swift
//  Cocoon
//
//  Created by Jake Trefethen on 7/9/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import UIKit

class AdminViewController: UITableViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    var id = -1
    var name = ""
    var info = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        refreshInfo()

    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 0
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
        
    }

    @IBAction func editInfo(sender: AnyObject) {
        
        //open an edit page
        print("So you want to edit this huh?")
        
    }
    
    @IBAction func close(sender: AnyObject) {
        
        navigationController!.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func setGroup(groupView: GroupViewController) {
        
        id = groupView.id
        name = groupView.name
        info = groupView.info
        
    }
    
    func refreshInfo() {
        
        nameLabel?.text = name
        infoLabel?.text = info
        
    }

}
