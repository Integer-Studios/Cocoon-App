//
//  GroupViewController.swift
//  Cocoon
//
//  Created by Jake Trefethen on 6/30/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController {
    
    var id = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Viewing group with id: ")
        println(id)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close(sender: AnyObject) {
            navigationController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setGroup(id: Int) {
        self.id = id
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
