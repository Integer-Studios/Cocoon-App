//
//  IconCell.swift
//  Cocoon
//
//  Created by Jake Trefethen on 7/13/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import UIKit

class IconCell: UITableViewCell {

    @IBOutlet var iconImage: UIImageView!
    @IBOutlet var displayName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
