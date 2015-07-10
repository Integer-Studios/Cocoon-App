//
//  SearchGroupsController.swift
//  Cocoon
//
//  Created by Jake Trefethen on 7/8/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import UIKit

class SearchGroupsController: UITableViewController, UISearchBarDelegate {

//    
//    Variables
//    
    
    var items : [Link] = []
    
//    
//    Requests
//
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
            
            if count(searchText) == 0 {
                
                self.items.removeAll(keepCapacity: false)
                self.tableView.reloadData()
                
            }
            else if count(searchText) > 1 {
                
                Cocoon.requestManager.sendRequest("/group/search/", parameters: ["search" : searchText], debug:true, responseHandler: handleGroupSearchResponse, errorHandler: handleGroupSearchError)
                
            }
            
    }
    
//
//    Response Handlers
//
    
    func handleGroupSearchResponse(response: Response) {
        
        self.items.removeAll(keepCapacity: false)
        
        for groupObject in response.content!["results"] as! NSArray {
            
            items.append(Link.unwrapGroup(groupObject as! NSMutableDictionary))
            
        }
        
        self.tableView.reloadData()
        
    }
    
    func handleGroupSearchError(error: Error) {
        
        println("Error loading group search results")
        
    }
    
//
//    UI Configuration
//    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = items[indexPath.row].displayName
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        items[indexPath.row].open(self)
        
    }

}
