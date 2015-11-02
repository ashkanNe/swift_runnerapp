//
//  MemberDetailCell.swift
//  RunnerApp
//
//  Created by Prescott | Neshagaran on 9/17/15.
//  Copyright (c) 2015 Prescott | Neshagaran. All rights reserved.
//

import UIKit

class MemberDetailCell: UITableViewCell {
    
    @IBOutlet var nameLbl : UILabel!
    @IBOutlet var aliasLbl : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
