//
//  orderlistDetailCell.swift
//  ios1
//
//  Created by Set on 10/11/2017.
//  Copyright © 2017 Niguai. All rights reserved.
//

import UIKit

class orderlistDetailCell: UITableViewCell {

    @IBOutlet weak var fieldLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
