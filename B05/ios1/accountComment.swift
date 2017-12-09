//
//  AccountComment.swift
//  ios1
//
//  Created by maartenwei on 2017/11/9.
//  Copyright © 2017年 Niguai. All rights reserved.
//

import UIKit
import Firebase
class accountComment: UIViewController, UITextFieldDelegate, UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate{

    
    
    
    @IBOutlet weak var scoreStar: CosmosView!
    @IBOutlet weak var serviceStar: CosmosView!
    @IBOutlet weak var tasteStar: CosmosView!
    @IBOutlet weak var envirStar: CosmosView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var image: UIImageView!
    let imagePicker = UIImagePickerController()
    var selectimage : UIImage?
    @IBOutlet weak var textView: UITextView!
    
    
    var commentID = 0
    var Ok = 0
    override func viewDidLoad() {
        
        super.viewDidLoad()
        imagePicker.delegate = self
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
                    ///////
                    let uniqueString = NSUUID().uuidString
                    let account = AccountData.user_ID
                    let store = AccountData.res_ID
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
                                let databaseRef = Database.database().reference().child("comment_Store").child(String(store)).child(String(account)).child(uniqueString)
                                databaseRef.setValue(uploadImageUrl, withCompletionBlock: { (error, dataRef) in
                                    if error != nil {
                                        print("Database Error: \(error!.localizedDescription)")
                                    }
                                    else {
                                        print("圖片已儲存")
                                        self.Ok = 1
                                    }
                                })
                            }
                        })
                    }
                    ///////
                    if(self.Ok==1){
                        let alert = UIAlertController(title: "評論", message: "新增成功", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {  (action) in
                            
                            self.navigationController?.popViewController(animated: true)
                            
                            alert.dismiss(animated: true, completion: nil)
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                }
                else{
                    //print("error")
                    print(self.textView.text!)
                    print(self.scoreStar.rating)
                    print(self.envirStar.rating)
                    print(self.tasteStar.rating)
                    print(self.serviceStar.rating)
                    print(AccountData.user_ID)
                    print(AccountData.res_ID)
                    print(self.commentID)
                    
                }
                
            }
        }
        task.resume()
    }
    
    ///關閉pickerView
    @objc func donePressd()  {
        
        view.endEditing(true)
        
    }
    
    @IBAction func choosePic(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("OK")
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image.contentMode = .scaleAspectFit
            image.image = pickedImage
            selectimage = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
