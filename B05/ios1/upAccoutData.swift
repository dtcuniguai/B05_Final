//
//  upAccoutData.swift
//  ios1
//
//  Created by maartenwei on 2017/10/17.
//  Copyright © 2017年 Niguai. All rights reserved.
//

import UIKit
import Firebase

class upAccoutData: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var userPic: UIImageView!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var careerField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var user_Pic: UIImageView!    
    let imagePicker = UIImagePickerController()
    var selectimage : UIImage?
    var pkey : String?
    var i = 0
    var userData = ["name":"", "career":"", "phone":""]
    var ID = 0
    //let refUserData = Database.database().reference().child("Accout")
    
    var careerArray = ["學生","老師","公務員","軍人","工程師","司機","建築師","金融業","服務業","餐飲業","政治家"]
    
    let pick = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        pick.dataSource = self
        pick.delegate = self
        pick.showsSelectionIndicator = true
        
        /////在pickView上建立一個Done的開關\\\\
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(assignAccoutAction.donePressd))
        toolBar.setItems([doneButton], animated: false)
        /////\\\\\\\\
        
        userNameField.delegate = self
        phoneField.delegate = self
        phoneField.keyboardType = .numberPad
        careerField.inputView = pick
        careerField.inputAccessoryView = toolBar
        phoneField.inputAccessoryView = toolBar
        userNameField.text = userData["name"]
        careerField.text = userData["career"]
        phoneField.text = userData["phone"]
        
        print(i)
        if (i == 0){
            print("IN")
            var  account = accountDetail.acc
            //var account = "qq@gmail.com"
            var str = account?.components(separatedBy: "@")
            account = str?[0]
            print(account)
            var databaseRef = Database.database().reference()
            databaseRef.child("user").child(account!).observe(DataEventType.value, with:{
                snapshot in
                let value = snapshot.value as? [String : AnyObject]
                let vkey = value?.keys.first
                self.pkey = vkey
                print(vkey)
                let vurl = value![vkey!]
                print(vurl)
                let url = URL(string: vurl as! String)
                self.user_Pic.downloadedFrom(url: url!)
            })
            i = 1 + 1
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //點擊button上傳更改後的資料
    @IBAction func upData(_ sender: Any) {
        
        
        let urlStr = "http://140.136.150.95:3000/user/update?id=\(ID)&name=\(userNameField.text!)&career=\(careerField.text!)&phone=\( phoneField.text!)&userPic=".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let url = URL(string: urlStr!)
        let task = URLSession.shared.dataTask(with: url!) { (data, response , error) in
            if let data = data, let content = String(data: data, encoding: .utf8) {
                
                if content == "success" {
                    print("OK")
                    print(self.pkey)
                    let uniqueString = NSUUID().uuidString
                    //var account = self.userNameField.text
                    var account = "qq@gmail.com"
                    var str = account.components(separatedBy: "@")
                    account = str[0]
                    let storageRef = Storage.storage().reference().child("user").child(account).child("userPic").child("\(uniqueString).png")
                    if(self.selectimage != nil){
                        if let uploadData = UIImagePNGRepresentation(self.selectimage!) {
                            // 這行就是 FirebaseStorage 關鍵的存取方法。
                            storageRef.putData(uploadData, metadata: nil, completion: { (data, error) in
                                if error != nil {
                                    // 若有接收到錯誤，我們就直接印在 Console 就好，在這邊就不另外做處理。
                                    print("Error: \(error!.localizedDescription)")
                                    return
                                }
                                // 連結取得方式就是：data?.downloadURL()?.absoluteString。
                                if let uploadImageUrl = data?.downloadURL()?.absoluteString {
                                    /*
                                     let imageRef = Database.database().reference().child("user").child(account)
                                     imageRef.child("userPic").removeValue(completionBlock: { (error, refer) in
                                     if error != nil {
                                     print("失敗")
                                     } else {
                                     print(refer)
                                     print("刪除成功")
                                     //self.viewDidLoad();
                                     }
                                     })*/
                                    
                                    print("Photo Url: \(uploadImageUrl)")
                                    let databaseRef = Database.database().reference().child("user").child(account).child("userPic")
                                    
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
                        
                    }
                    
                    /////創建成功訊息\\\\\\
                    let alert = UIAlertController(title: "更新訊息", message: "更新成功", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {  (action) in
                        
                        self.performSegue(withIdentifier: "gotoAccountDatail", sender: nil)
                        
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
    
    
    //選單地列數
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        
        return 1
        
    }
    //選單上要有幾個選項
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return careerArray.count
        
    }
    
    //將Array的值傳入選單
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let titleRow = careerArray[row]
        
        return titleRow
        
    }
    
    //點擊選單後要做的動作
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        careerField.text = careerArray[row]
        
    }
    
    ///點擊background輸入介面消失
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    
    //點擊鍵盤上return鍵盤關閉
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
       
        userNameField.resignFirstResponder()
        return true
    }
    
    
    //讓pickView消失
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
            user_Pic.contentMode = .scaleAspectFit
            user_Pic.image = pickedImage
            selectimage = pickedImage
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
