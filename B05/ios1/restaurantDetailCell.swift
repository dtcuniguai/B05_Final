//
//  restaurantDetailCell.swift
//  ios1
//
//  Created by Set on 2017/10/10.
//  Copyright © 2017年 Niguai. All rights reserved.
//

import UIKit

class restaurantDetailCell: UITableViewCell {

    @IBOutlet var mapButton: UIButton!//地圖按鈕
    @IBOutlet var fieldLabel: UILabel!//欄位名稱
    @IBOutlet var valueLabel: UILabel!//欄位內容
    @IBOutlet var detailImage: UIImageView!//圖片
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
