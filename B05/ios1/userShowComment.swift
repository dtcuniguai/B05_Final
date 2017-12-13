//
//  showComment.swift
//  ios1
//
//  Created by maartenwei on 2017/11/11.
//  Copyright © 2017年 Niguai. All rights reserved.
//

import UIKit

class userShowComment: UIViewController, UITextViewDelegate {
    
   
    
    
    @IBOutlet weak var upDataButton: UIButton!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var totalStar: CosmosView!
    @IBOutlet weak var serviceStar: CosmosView!
    @IBOutlet weak var tasteStar: CosmosView!
    @IBOutlet weak var envirStar: CosmosView!
    @IBOutlet weak var store_ReplyLable: UILabel!
    
    var showCommentDataArray: Comment!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memoTextView.text = showCommentDataArray.Memo
        totalStar.rating = showCommentDataArray.Score
        envirStar.rating = showCommentDataArray.Score_Envir
        serviceStar.rating = showCommentDataArray.Score_Service
        tasteStar.rating = showCommentDataArray.Score_Taste
        store_ReplyLable.text = showCommentDataArray.store_Reply
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(assignAccoutAction.donePressd))
        toolBar.setItems([doneButton], animated: false)
        
        memoTextView.delegate = self
        memoTextView.inputAccessoryView = toolBar
        
        memoTextView.layer.borderWidth = 1
        memoTextView.layer.borderColor = UIColor.black.cgColor
        
        store_ReplyLable.layer.borderWidth = 1
        store_ReplyLable.layer.borderColor = UIColor.black.cgColor
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
   
    @IBAction func upComment(_ sender: Any) {
        let urlStr = "http://140.136.150.95:3000/comment/update?content=\(memoTextView.text!)&score=\(totalStar.rating)&envir=\(envirStar.rating)&taste=\(tasteStar.rating)&service=\(serviceStar.rating)&storeID=\(showCommentDataArray.StoreID)&userID=\(AccountData.user_ID)&commentID=\(showCommentDataArray.ID)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let url = URL(string: urlStr!)
        let task = URLSession.shared.dataTask(with: url!) { (data, response , error) in
            if let data = data, let content = String(data: data, encoding: .utf8) {
                if content == "success" {
                    
                    /////創建成功訊息\\\\\\
                    let alert = UIAlertController(title: "更新訊息", message: "更新成功", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {  (action) in
 
                        self.navigationController?.popViewController(animated: true)
 
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                    //////\\\\\\\\\\\\\\\
                }
                else{
                    print("error")
                }
                
            }
        }
        task.resume()
        
        
        
    }
    
    
    @objc func donePressd() {
        
        view.endEditing(true)
    }
    

}
