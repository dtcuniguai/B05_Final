//
//  orderlistMainCell.swift
//  
//
//  Created by Set on 10/11/2017.
//

import UIKit

class orderlistMainCell: UITableViewCell {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var orderTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
