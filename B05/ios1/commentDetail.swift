//
//  commentDetail.swift
//  ios1
//
//  Created by maartenwei on 2017/11/11.
//  Copyright © 2017年 Niguai. All rights reserved.
//

import UIKit

class commentDetail: UIViewController {

    @IBOutlet weak var storeMemo: UILabel!
    @IBOutlet weak var totalLable: CosmosView!
    @IBOutlet weak var serviceStar: CosmosView!
    @IBOutlet weak var tasteStar: CosmosView!
    @IBOutlet weak var envirStar: CosmosView!
    
    @IBOutlet weak var memoLable: UILabel!
    
    var commentData: resComment!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        envirStar.settings.updateOnTouch = false
        tasteStar.settings.updateOnTouch = false
        serviceStar.settings.updateOnTouch = false
        totalLable.settings.updateOnTouch = false
        
        envirStar.settings.fillMode = .half
        tasteStar.settings.fillMode = .half
        serviceStar.settings.fillMode = .half
        totalLable.settings.fillMode = .half
        
        //storeMemo.text = commentData.store_Reply
        memoLable.text = commentData.Memo
        envirStar.rating = commentData.Score_Envir
        tasteStar.rating = commentData.Score_Taste
        serviceStar.rating = commentData.Score_Service
        totalLable.rating = commentData.Score
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
