//會員資料(頁碼代號:P6)
//Function:
//1.Qry at Firebase with account
//2.Qry at Firebase with account's like
//3.Upd account's like
//4.待加
//Action:
//While click Buttom1->Page
//While click Buttom2->Page
//While click the tableViewCell's restaurant->Page
//First Write By Niguai

import Foundation
import UIKit
import Firebase

class accountDetail:UIViewController{
    
    @IBOutlet weak var idLable: UILabel!
    @IBOutlet weak var careerLable: UILabel!
    @IBOutlet weak var birthDayLable: UILabel!
    @IBOutlet weak var accountLable: UILabel!
    @IBOutlet weak var userNameLable: UILabel!
    @IBOutlet weak var phoneLable: UILabel!
    @IBOutlet weak var sexualityLable: UILabel!
    
    var account = ""
    var password = ""
    
    
    
    //var userDataArray = [String:String]()
    var userDataArray = ["user_ID": "" ,"user_Account": "", "Name": "", "user_Type": "", "user_Gender": "", "user_Career": "","user_Month":"", "user_Day":"","user_Year":"","user_tel":""]
    
    
    var ID = 0
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let databaseRef = FirebaseDatabase.Database.database().reference()
        let user = Auth.auth().currentUser?.uid
        databaseRef.child("Accout").child(user!).observe(DataEventType.value, with: {
            snapshot in
            
            let value = snapshot.value as? [String: AnyObject]
            let Data_email = value?["Email"] as! String
            let Data_password = value?["PassWord"] as! String
            
            self.account = Data_email
            self.password = Data_password
            
            print(self.account)
            print(self.password)
            
            let urlStr = "http://140.136.150.95:3000/user/login?account=\(self.account)&password=\(self.password)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let url = URL(string: urlStr!)
            let task = URLSession.shared.dataTask(with: url!) { (data, response , error) in
                if let data = data, let dic = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [[String:Any]]{
                    DispatchQueue.main.async {
                        for userData in dic{
                            self.ID = userData["user_ID"]! as! Int
                            print(self.ID)
                            self.userDataArray["user_Account"] = userData["user_Account"] as? String
                            self.userDataArray["Name"] = userData["user_Name"] as? String
                            self.userDataArray["user_Type"] = userData["user_Type"] as? String
                            self.userDataArray["user_Gender"] = userData["user_Gender"] as? String
                            self.userDataArray["user_Career"] = userData["user_Career"] as? String
                            self.userDataArray["user_Day"] = userData["user_Day"] as? String
                            self.userDataArray["user_Month"] = userData["user_Month"] as? String
                            self.userDataArray["user_Year"] = userData["user_Year"] as? String
                            self.userDataArray["user_tel"] = userData["user_Tel"] as? String
                            
                        }
                        self.accountLable.text = self.userDataArray["user_Account"]
                        self.userNameLable.text = self.userDataArray["Name"]
                        self.sexualityLable.text = self.userDataArray["user_Gender"]
                        self.careerLable.text = self.userDataArray["user_Career"]
                        self.birthDayLable.text = self.userDataArray["user_Month"]! + self.userDataArray["user_Day"]! + self.userDataArray["user_Year"]!
                        self.phoneLable.text = self.userDataArray["user_tel"]
                    }
                }
                
            }
            task.resume()
            
        })
        
        
        
        
        
    }
    
    
    @IBAction func signOut(_ sender: Any) {
        
        if Auth.auth().currentUser != nil{
            
            do{
                
                try  Auth.auth().signOut()
                signOutMesssage()
                
            }catch let error as NSError{
                
                print(error.localizedDescription)
                
            }
        }
    }
    
    
    ///登出訊息
    func signOutMesssage() {
        
        let alert = UIAlertController(title: "登出訊息", message: "歡迎再度光臨", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {  (action) in
            
            let logIn = self.storyboard?.instantiateViewController(withIdentifier: "logIn")
            self.present(logIn!, animated: false, completion: nil)
            
            alert.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goUpAccoutData" {
            let destinationController = segue.destination as! upAccoutData
            destinationController.ID = ID
            destinationController.userData["name"] = userNameLable.text
            destinationController.userData["career"] = careerLable.text
            destinationController.userData["phone"] = phoneLable.text
            
        }
    }
    
    
}



    

