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
    @IBOutlet var duration: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var link : Link? = nil
    var linkVC : UIViewController? = nil

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
        
    }

}
