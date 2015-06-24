//
//  LoadingTableViewController.swift
//  Cocoon
//
//  Created by Jake Trefethen on 6/24/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import UIKit

class LoadingTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate  {

    var items : [Link] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        //requestData("fake/request", ["", ""])
        
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
        
        println("selected: \(items[indexPath.row])")
        
    }
    
    func requestData(request: String, parameters : NSMutableDictionary) {

        Cocoon.requestManager.sendRequest(request, parameters: parameters, responseHandler: handleTableResponse, errorHandler: handleTableError)
        
    }
    
    func handleTableResponse(response: Response) {
        println("responded: \(items.count)")
        self.tableView.reloadData()
    }
    
    func handleTableError(error: Error) {
        
    }

}