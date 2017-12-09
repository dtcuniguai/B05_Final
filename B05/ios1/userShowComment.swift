//
//  showComment.swift
//  ios1
//
//  Created by maartenwei on 2017/11/11.
//  Copyright © 2017年 Niguai. All rights reserved.
//

import UIKit
import Firebase
class userShowComment: UIViewController, UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate{
    
   
    
    
    @IBOutlet weak var upDataButton: UIButton!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var totalStar: CosmosView!
    @IBOutlet weak var serviceStar: CosmosView!
    @IBOutlet weak var tasteStar: CosmosView!
    @IBOutlet weak var envirStar: CosmosView!
    @IBOutlet weak var store_ReplyLable: UILabel!
    @IBOutlet weak var comment_Pic: UIImageView!
    let imagePicker = UIImagePickerController()
    var selectimage : UIImage?
    var pkey : String?
    var i = 0
    var showCommentDataArray: userComment!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        memoTextView.text = showCommentDataArray.Memo
        totalStar.rating = showCommentDataArray.Score
        envirStar.rating = showCommentDataArray.Score_Envir
        serviceStar.rating = showCommentDataArray.Score_Service
        tasteStar.rating = showCommentDataArray.Score_Taste
        //store_ReplyLable.text = showCommentDataArray.Memo
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(assignAccoutAction.donePressd))
        toolBar.setItems([doneButton], animated: false)
        
        memoTextView.delegate = self
        memoTextView.inputAccessoryView = toolBar
        
        memoTextView.layer.borderWidth = 1
        memoTextView.layer.borderColor = UIColor.black.cgColor
        
        if (i == 0){
            print("In")
             let uid = AccountData.user_ID
             let sid = showCommentDataArray.StoreID
             var us = String(describing: uid)
             var ss = String(describing: sid)
            print(us)
            print(ss)
            var databaseRef = Database.database().reference()
            databaseRef.child("comment_Account").child(us).child(ss).observe(DataEventType.value, with:{
                snapshot in
                let value = snapshot.value as? [String : AnyObject]
                let vkey = value?.keys.first
                print(vkey)
                self.pkey = vkey
                let vurl = value![vkey!]
                let url = URL(string: vurl as! String)
                self.comment_Pic.downloadedFrom(url: url!)
            })
            
            i = 1 + 1
        }
        
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
                    let uniqueString = NSUUID().uuidString
                    let account = AccountData.user_ID
                    let store = self.showCommentDataArray.StoreID
                    let storageRef1 = Storage.storage().reference().child("comment_Account").child(String(account)).child(String(store)).child("\(uniqueString).png")
                    let storageRef2 = Storage.storage().reference().child("comment_Store").child(String(store)).child(String(account)).child("\(uniqueString).png")
                    if let uploadData = UIImagePNGRepresentation(self.selectimage!) {
                        storageRef1.putData(uploadData, metadata: nil, completion: { (data, error) in
                            if error != nil {
                                print("Error: \(error!.localizedDescription)")
                                return
                            }
                            if let uploadImageUrl = data?.downloadURL()?.absoluteString {
                                print("Photo Url: \(uploadImageUrl)")
                                let imageRef = Database.database().reference().child("comment_Account").child(String(account)).child(String(store))
                                imageRef.child(self.pkey!).removeValue(completionBlock: { (error, refer) in
                                    if error != nil {
                                        print("失敗")
                                    } else {
                                        print(refer)
                                        print("刪除成功")
                                        //self.viewDidLoad();
                                    }
                                })
                                
                                let databaseRef = Database.database().reference().child("comment_Account").child(String(account)).child(String(store)).child(uniqueString)
                                databaseRef.setValue(uploadImageUrl, withCompletionBlock: { (error, dataRef) in
                                    if error != nil {
                                        print("Database Error: \(error!.localizedDescription)")
                                    }
                                    else {
                                        print("圖片已儲存")
                                    }
                                })
                            }
                        })
                        storageRef2.putData(uploadData, metadata: nil, completion: { (data, error) in
                            if error != nil {
                                print("Error: \(error!.localizedDescription)")
                                return
                            }
                            if let uploadImageUrl = data?.downloadURL()?.absoluteString {
                                print("Photo Url: \(uploadImageUrl)")
                                if let uploadImageUrl = data?.downloadURL()?.absoluteString {
                                    print("Photo Url: \(uploadImageUrl)")
                                    let imageRef = Database.database().reference().child("comment_Store").child(String(store)).child(String(account))
                                    imageRef.child(self.pkey!).removeValue(completionBlock: { (error, refer) in
                                        if error != nil {
                                            print("失敗")
                                        } else {
                                            print(refer)
                                            print("刪除成功")
                                            //self.viewDidLoad();
                                        }
                                    })
                                }
                                let databaseRef = Database.database().reference().child("comment_Store").child(String(store)).child(String(account)).child(uniqueString)
                                databaseRef.setValue(uploadImageUrl, withCompletionBlock: { (error, dataRef) in
                                    if error != nil {
                                        print("Database Error: \(error!.localizedDescription)")
                                    }
                                    else {
                                        print("圖片已儲存")
                                    }
                                })
                            }
                        })
                    }
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
    @IBAction func changePic(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("OK")
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            comment_Pic.contentMode = .scaleAspectFit
            comment_Pic.image = pickedImage
            selectimage = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }

    
}
