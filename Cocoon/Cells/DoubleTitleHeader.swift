//
//  DoubleTitleHeader.swift
//  Cocoon
//
//  Created by Jake Trefethen on 7/20/15.
//  Copyright (c) 2015 Integer Studios. All rights reserved.
//

import UIKit

class DoubleTitleHeader: UITableViewCell {

    @IBOutlet var leftTitle: UILabel!
    @IBOutlet var rightTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
