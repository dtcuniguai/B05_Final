//
//  commentCell.swift
//  ios1
//
//  Created by maartenwei on 2017/11/11.
//  Copyright © 2017年 Niguai. All rights reserved.
//

import UIKit

class commentCell: UITableViewCell {

    @IBOutlet weak var commentStar: CosmosView!
    @IBOutlet weak var commentID: UILabel!
    @IBOutlet weak var commentImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        commentStar.settings.updateOnTouch = false
        commentStar.settings.fillMode = .half

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
