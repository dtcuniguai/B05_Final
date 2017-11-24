//
//  AccountComment.swift
//  ios1
//
//  Created by maartenwei on 2017/11/9.
//  Copyright © 2017年 Niguai. All rights reserved.
//

import UIKit

class accountComment: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    
    
    
    @IBOutlet weak var scoreStar: CosmosView!
    @IBOutlet weak var serviceStar: CosmosView!
    @IBOutlet weak var tasteStar: CosmosView!
    @IBOutlet weak var envirStar: CosmosView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var textView: UITextView!
    
    var commentID = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        ////取得commentID\\\\\
        let urlStr = "http://140.136.150.95:3000/comment/getID".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlStr!)
        let task = URLSession.shared.dataTask(with: url!) { (data, response , error) in
            if let data = data, let dic = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [[String:Any]]{
                DispatchQueue.main.async {
                    for comment in dic{
                        self.commentID = comment["MAX(ID)+1"] as! Int
                        //print(self.commentID)
                    }
                }
            }
            
        }
        task.resume()
        //////////
        
        scoreStar.settings.fillMode = .half
        serviceStar.settings.fillMode = .half
        tasteStar.settings.fillMode = .half
        envirStar.settings.fillMode = .half
        
        /////顯示關閉pickerView的done鍵\\\\\
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(assignAccoutAction.donePressd))
        toolBar.setItems([doneButton], animated: false)
        ///////
        
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.black.cgColor
        
        textView.inputAccessoryView = toolBar
        
            
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    
    
    //上傳評論
    @IBAction func upData(_ sender: Any) {
        
        viewDidLoad()
        let urlStr = "http://140.136.150.95:3000/comment/add?content=\(textView.text!)&score=\(scoreStar.rating)&envir=\(envirStar.rating)&taste=\(tasteStar.rating)&service=\(serviceStar.rating)&storeID=\(AccountData.res_ID)&userID=\(AccountData.user_ID)&commentID=\(commentID)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let url = URL(string: urlStr!)
        let task = URLSession.shared.dataTask(with: url!) { (data, response , error) in
            if let data = data, let content = String(data: data, encoding: .utf8) {
                print(content)
                if content == "success" {
                    
                }
                else{
                    print("error")
                }
                
            }
        }
        task.resume()
    }
    
    ///關閉pickerView
    @objc func donePressd()  {
        
        view.endEditing(true)
        
    }
    
    
    
    
    
    
    

}
