//新增會員
//Function:Create New Member Into Firebase
//Action:Create New Member And Goto MainMenu
//First Write By Niguai

import Foundation
import UIKit
import Firebase

class assignAccoutAction :UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate{
    
    @IBOutlet weak var ScrollView: UIScrollView!
    //會員帳號(登入用)
    @IBOutlet weak var accountField: UITextField!
    //會員密碼(登入用)
    @IBOutlet weak var passwordField: UITextField!
    //會員名稱
    @IBOutlet weak var userNameField: UITextField!
    //會員電話
    @IBOutlet weak var phoneField: UITextField!
    //會員性別
    @IBOutlet weak var sexualityField: UITextField!
    //會員性別選單
    //生日 年
    @IBOutlet weak var birthdayYear: UITextField!
    //職業
    @IBOutlet weak var career: UITextField!
    //類別
    @IBOutlet weak var userType: UITextField!
    
    let refUserData = Database.database().reference().child("Accout")
    
    var sexuality = ["男性","女性","中性"]
    var careerArray = ["學生","老師","公務員","軍人","工程師","司機","建築師","金融業","服務業","餐飲業","政治家"]
    var userTypeArray = ["店家","客人"]
    
    var countRow: Int =  0
    
    
    var fullDay = ""
    var birthday = [String]()
    
    var pick = UIPickerView()
    let datePick = UIDatePicker()
    
    
    //主畫面顯示
    override func viewDidLoad() {
        super.viewDidLoad();
        creatDatePicker()
        
        pick.dataSource = self
        pick.delegate = self
        pick.showsSelectionIndicator = true
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(assignAccoutAction.donePressd))
        toolBar.setItems([doneButton], animated: false)
        
        title = "會員註冊"
        
        passwordField.delegate = self
        accountField.keyboardType = .emailAddress
        accountField.delegate = self
        phoneField.keyboardType = .numberPad
        phoneField.delegate = self
        userNameField.keyboardType = .namePhonePad
        userNameField.delegate = self
        sexualityField.inputView = pick
        career.inputView = pick
        userType.inputView = pick
        phoneField.inputAccessoryView = toolBar
        sexualityField.inputAccessoryView = toolBar
        career.inputAccessoryView = toolBar
        userType.inputAccessoryView = toolBar
        
        
        
        
        
    }
    
    //創建新會員並跳至主頁面
    @IBAction func createAccout(_ sender: UIButton) {
        
        if userNameField.text != "" || accountField.text != "" || passwordField.text != ""  {
            if(passwordField.text!.characters.count>5){
                
                FirebaseAuth.Auth.auth().createUser(withEmail: accountField.text!, password: passwordField.text!){ (user,error) in
                    if error != nil {
                        self.Message(titleText: "錯誤", messageText: "此帳號已有人申請")
                    }else{
                        self.creatUserData()
                    }
                    
                }
               
            }
           else{
                self.Message(titleText: "錯誤", messageText: "密碼不可低於六個字")
            }
        }
        else {
            self.Message(titleText: "錯誤", messageText: "姓名,帳號或密碼為空白")
        }
    }
    
    
    //Create User Info
    //Focus:check textField if blank && password's textField's length must bigger than 5
    
    
    func creatUserData(){
        
        let user = Auth.auth().currentUser?.uid
        let userData = ["Email": accountField.text! as String,
                        "PassWord": passwordField.text! as String
        ]
        refUserData.child(user!).setValue(userData)
        
        //
        
        let birthday = fullDay.characters.split{$0 == "/"}.map(String.init)
        if userType.text == "客人"{
            userType.text = "S"
        }
        else{
            userType.text = "U"
        }
        if sexualityField.text == "男生"{
            sexualityField.text = "B"
        }
        else{
            sexualityField.text = "G"
        }
        
        let urlStr = "http://140.136.150.95:3000/user/register?account=\(accountField.text!)&password=\(passwordField.text!)&userType=\(userType.text!)&name=\(userNameField.text!)&gender=\(sexualityField.text!)&career=\(career.text!)&month=\(birthday[1])&day=\(birthday[0])&year=\(birthday[2])&phone=\(phoneField.text!)&userPic=".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlStr!)
        let task = URLSession.shared.dataTask(with: url!) { (data, response , error) in
            if let data = data, let content = String(data: data, encoding: .utf8) {
                
                if content.count != 0 {
                    print(content.count)
                    self.signUpMesssage()
                    print(content)
                }
                else{
                    self.Message(titleText: "錯誤", messageText: "此帳號已有人申請")
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
        
        return countRow
        
    }
    
    //將Array的值傳入選單
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if countRow == sexuality.count{
            let titleRow = sexuality[row]
            return titleRow
        }
        
         
       else if countRow == careerArray.count {
            let titleRow = careerArray[row]
            return titleRow
        }
        else if countRow == userTypeArray.count{
            let titleRow = userTypeArray[row]
            return titleRow
        }
        
        return ""
        
    }
    
    //點擊選單後要做的動作
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         if countRow == sexuality.count {
            
            self.sexualityField.text = self.sexuality[row]
            
        }
         else if countRow == careerArray.count {
            self.career.text = self.careerArray[row]
        }
         else if countRow == userTypeArray.count{
            self.userType.text = self.userTypeArray[row]
        }
        
        
    }
    
    //點選指定的textField要的事情
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        ScrollView.setContentOffset((CGPoint(x: 0, y: 120)), animated: true)
        
        if (textField == self.sexualityField){
            
            countRow = sexuality.count
            print("111111")
            
        }
        
        else if textField == self.career {
            countRow = careerArray.count
            print("2222222")
            
        }
        else if textField  == self.userType{
            countRow = userTypeArray.count
            print("3333333")
            
        }
        else if textField == self.birthdayYear{
            creatDatePicker()
        }
        else if textField == self.phoneField{
            
        }
        else if textField == self.userNameField {
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        ScrollView.setContentOffset((CGPoint(x: 0, y: -60)), animated: true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
        accountField.resignFirstResponder()
        passwordField.resignFirstResponder()
        userNameField.resignFirstResponder()
        return (true)
    }
    
    //back To login page
    @IBAction func backFronyPage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
    
    
    //Alert Message
    func Message(titleText : String, messageText : String ){
        let alert = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {  (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    ///// Ssuccess Sign UP Message
    
    func signUpMesssage() {
        
        let alert = UIAlertController(title: "登入訊息", message: "歡迎加入" + userNameField.text!, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {  (action) in
            
            let main = self.storyboard?.instantiateViewController(withIdentifier: "Menu")
            self.present(main!, animated: false, completion: nil)
            
            alert.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func creatDatePicker() {
        datePick.datePickerMode = UIDatePickerMode.date
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(assignAccoutAction.dateDonePressd))
        toolBar.setItems([doneButton], animated: false)
        
        birthdayYear.inputAccessoryView = toolBar
    
        birthdayYear.inputView = datePick
    }
    
    @objc func dateDonePressd() {
       
        
            let dateFormattet = DateFormatter()
            dateFormattet.dateStyle = .short
            dateFormattet.timeStyle = .none
            birthdayYear.text = dateFormattet.string(from: datePick.date)
            fullDay = birthdayYear.text!
            view.endEditing(true)
        
    }
    
    @objc func donePressd()  {
        view.endEditing(true)
    }
    
    
}
