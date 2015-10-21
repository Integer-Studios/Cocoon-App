//
//  OfferRideCell.swift
//  Cocoon
//
//  Created by Jake Trefethen on 10/19/15.
//  Copyright © 2015 Integer Studios. All rights reserved.
//

import UIKit

class OfferRideCell: UITableViewCell {
    
    @IBOutlet var name: UILabel!
    @IBOutlet var city: UILabel!
    @IBOutlet var duration: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var link : Link? = nil
    var linkVC : UIViewController? = nil
    var parentVC : UIViewController? = nil
    var hasOffered = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setButtonLink(link: Link, viewController: UIViewController) {
        
        self.link = link
        self.linkVC = viewController
        
    }
    
    @IBAction func buttonPressed(sender: AnyObject) {
        
        if let l = link {
            l.open(linkVC!)
        }
        
        if hasOffered {
            
            button?.setImage(UIImage(named: "add.png"), forState: UIControlState.Normal)
            duration?.textColor = UIColor(hue: 0, saturation: 71/100, brightness: 100/100, alpha: 1)
            duration?.text = "5 min"
            hasOffered = false
            
        } else {
            
            let confirmAlert = UIAlertController(title: "Offer Ride?", message: "Are you sure you want to offer a ride to Jacob?", preferredStyle: UIAlertControllerStyle.Alert)
            confirmAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
                print("Confirmed")
                self.button?.setImage(UIImage(named: "checkmark.png"), forState: UIControlState.Normal)
                self.duration?.textColor = UIColor(hue: 151/359, saturation: 75/100, brightness: 84/100, alpha: 1)
                self.duration?.text = "Ride Offered"
                self.hasOffered = true
            }))
            confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
                print("Cancelled")
            }))
            parentVC?.presentViewController(confirmAlert, animated: true, completion: nil)
            
        }
        
        
    }

}
