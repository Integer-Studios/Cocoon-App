//
//  TodoCell.swift
//  Cocoon
//
//  Created by Jake Trefethen on 7/13/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import UIKit

class TodoCell: UITableViewCell {

    @IBOutlet var title: UILabel!
    @IBOutlet var kidName: UILabel!
    
    @IBOutlet var profilePicture: UIImageView!
    
    @IBOutlet var badgeImage: UIImageView!
    @IBOutlet var badgeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
