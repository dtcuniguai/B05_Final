// Login Action
// Function:初始畫面登入
// Action:會員登入，創建會員
//First Write By Niguai


import Foundation
import UIKit
import Firebase

class loginAction :UIViewController, UITextFieldDelegate{
    
    //password
    @IBOutlet weak var passwordField: UITextField!
    
    //login Email
    @IBOutlet weak var accoutField: UITextField!
    
    
    override func viewDidLoad() {
        //For Test
        title = "登入"
        self.accoutField.delegate = self
        self.passwordField.delegate = self
        passwordField.isSecureTextEntry = true
        accoutField.text = "ex@gmail.com"
        passwordField.text = "12345678"
        
        
    }
    
    
    //Action Login
    @IBAction func loginAction(_ sender: Any) {
        
        
        if(passwordField.text != "" || accoutField.text != ""){
           
            FirebaseAuth.Auth.auth().signIn(withEmail: accoutField.text!, password: passwordField.text!) { (user,error) in
                if error == nil {
                    self.userData()
                    self.signUpMesssage()
                    
                }else{
                    
                    self.Message(titleText: "Error", messageText: "Error Account Or Password")
                    self.passwordField.text = "";
                    
                }
            }
        }
            
        else  {
                self.Message(titleText: "錯誤", messageText: "帳號或密碼不可為空")
        }
    
    }
    
    
    //Alert Message
    func Message(titleText : String, messageText : String ){
        let alert = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {  (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // 登入成功訊息
    func signUpMesssage() {
        
        let alert = UIAlertController(title: "Welcome", message: "歡迎回來", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {  (action) in
            
                let main = self.storyboard?.instantiateViewController(withIdentifier: "Menu")
                self.present(main!, animated: false, completion: nil)
            
            alert.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        accoutField.resignFirstResponder()
        passwordField.resignFirstResponder()
        return (true)
    }
    
    
    func userData()  {
        let urlStr = "http://140.136.150.95:3000/user/login?account=\(accoutField.text!)&password=\(passwordField.text!)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlStr!)
        let task = URLSession.shared.dataTask(with: url!) { (data, response , error) in
            if let data = data, let dic = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [[String:Any]]{
                DispatchQueue.main.async {
                    for userData in dic{
                        AccountData.user_ID = userData["user_ID"]! as! Int
                        AccountData.user_Account = userData["user_Account"] as! String
                        AccountData.user_Name = userData["user_Name"] as! String
                        AccountData.user_Type = userData["user_Type"] as! String
                        AccountData.user_Gender = userData["user_Gender"] as! String
                        AccountData.user_Career = userData["user_Career"] as! String
                        AccountData.user_Day = userData["user_Day"] as! String
                        AccountData.user_Month = userData["user_Month"] as! String
                        AccountData.user_Year = userData["user_Year"] as! String
                        AccountData.user_Tel = userData["user_Tel"] as! String
                        
                    }
                }
            }
            
        }
        task.resume()
    }
    
    
}

