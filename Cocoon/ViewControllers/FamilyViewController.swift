//
//  FamilyViewController.swift
//  Cocoon
//
//  Created by Jake Trefethen on 6/23/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import UIKit

class FamilyViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var addCodeLabel: UILabel!
    
    var addCode : String = ""
    var kids : [Link] = []
    var vehicles : [Link] = []
    
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
            requestData("/family/info/", parameters: ["family": fam.id])
        }
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 2
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return kids.count
        case 1:
            return vehicles.count
        default:
            println("no case for section \(section)")
            return 0
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var links : [Link] = []
        
        switch indexPath.section {
        case 0:
            links = kids
            break
        case 1:
            links = vehicles
            break
        default:
            println("no case for section \(indexPath.section)")
            break
        }
        
        var link = links[indexPath.row]
        
        if link.type != "family.menu" {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("itemCell", forIndexPath: indexPath) as! ButtonCell
            cell.setButtonLink(link, viewController: self)
            cell.displayName?.text = link.displayName
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("addCell", forIndexPath: indexPath) as! ButtonCell
            cell.setButtonLink(link, viewController: self)
            cell.displayName?.text = link.displayName
            return cell
            
        }
        
        
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("sectionHeader") as! SingleTitleHeader
        
        switch (section) {
        case 0:
            cell.displayName?.text = "My Kids"
            break
        case 1:
            cell.displayName?.text = "My Vehicles"
            break
        default:
            cell.displayName?.text = "Unknown"
            break
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.section {
        case 0:
            kids[indexPath.row].open(self)
            break
        case 1:
            vehicles[indexPath.row].open(self)
            break
        default:
            println("no case for section \(indexPath.section)")
            break
        }
        
    }
    
    @IBAction func newCode(sender: AnyObject) {
        
        Cocoon.requestManager.sendRequest("/family/generate/", parameters: NSMutableDictionary(), responseHandler: handleNewCodeResponse, errorHandler: handleNewCodeError)
        
    }
    
    func handleNewCodeResponse(response: Response) {
        
        addCode = response.content!["add-token"] as! String
        addCodeLabel.text = "Your family's add code is \(addCode)"
        
    }
    
    func handleNewCodeError(error: Error) {
        
        
    }
    
    
    func requestData(request: String, parameters : NSMutableDictionary, debug: Bool = false) {
        
        Cocoon.requestManager.sendRequest(request, parameters: parameters, debug: debug, responseHandler: handleTableResponse, errorHandler: handleTableError)
        
    }
    
    
    func handleTableResponse(response: Response) {
        
        addCode = response.content!["add-token"] as! String
        addCodeLabel.text = "Your family's add code is \(addCode)"
        
        self.kids.removeAll(keepCapacity: false)
        
        for kidObject in response.content!["kids"] as! NSArray {
            
            kids.append(Link.unwrapKid(kidObject as! NSMutableDictionary))
            
        }
        
        kids.append(Link(id: 0, type: "family.menu", displayName: "Add A Kid"))
        
        self.vehicles.removeAll(keepCapacity: false)
        
        for vehicleObject in response.content!["vehicles"] as! NSArray {
            
            vehicles.append(Link.unwrapVehicle(vehicleObject as! NSMutableDictionary))
            
        }
        
        vehicles.append(Link(id: 1, type: "family.menu", displayName: "Add A Vehicle"))
        
        self.tableView.reloadData()
    }
    
    func handleTableError(error: Error) {
        
        
    }
    

}
