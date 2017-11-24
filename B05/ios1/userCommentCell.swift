//
//  userCommentCell.swift
//  ios1
//
//  Created by maartenwei on 2017/11/11.
//  Copyright © 2017年 Niguai. All rights reserved.
//

import UIKit

class userCommentCell: UITableViewCell {

    
    @IBOutlet weak var storeStar: CosmosView!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var image1: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        storeStar.settings.fillMode = .half
        storeStar.settings.updateOnTouch = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
