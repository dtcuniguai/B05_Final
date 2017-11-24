//更新店家菜單
//Function:
//1.Update menu into database
//Writer : Niguai
//Last UpdUser :

import Foundation
import UIKit

class menuDetail:UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate,UITextFieldDelegate{
    
    
    //Basic Init Item
    
    @IBOutlet weak var field_Name: UITextField!
    @IBOutlet weak var field_Price: UITextField!
    @IBOutlet weak var field_Total: UITextField!
    @IBOutlet weak var field_TakeOut: UITextField!
    @IBOutlet weak var field_mor: UITextField!
    @IBOutlet weak var field_aft: UITextField!
    @IBOutlet weak var field_even: UITextField!
    @IBOutlet weak var field_visable: UITextField!
    
    var updUrl :String = "";
    var status = [String]()
    var type:String!
    
    let pickerArray = ["Y","N"]
    var statusStr :String!
    var pick = UIPickerView()
    var insertUrl =  "";
    var check = 1;
    var storeID = 1;
    
    var MenuDetail:Menu!
    
    
    //Init Menu's Detail From Present Page
    //Writer : Niguai
    //Last UpdUser:Niguai
    override func viewDidLoad() {
        print(AccountData.user_ID)
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(assignAccoutAction.donePressd))
        toolBar.setItems([doneButton], animated: false)
        
        if(self.type == "U"){
            field_Name.text = MenuDetail.name
            field_Price.text = String(describing: MenuDetail.price)
            field_Total.text = String(describing: MenuDetail.total)
            field_TakeOut.text = MenuDetail.takeOut
            field_mor.text = MenuDetail.order_mor
            field_aft.text = MenuDetail.order_after
            field_even.text = MenuDetail.order_even
            field_visable.text = MenuDetail.visable
        }
        
        pick.dataSource = self
        pick.delegate = self
        pick.showsSelectionIndicator = true
        
        field_TakeOut.inputView = pick
        field_TakeOut.delegate = self
        field_mor.inputView = pick
        field_mor.delegate = self
        field_aft.inputView = pick
        field_aft.delegate = self
        field_even.inputView = pick
        field_even.delegate = self
        field_visable.inputView = pick
        field_visable.delegate = self
        field_TakeOut.inputAccessoryView = toolBar
        field_TakeOut.delegate = self
        field_mor.inputAccessoryView = toolBar
        field_aft.inputAccessoryView = toolBar
        field_even.inputAccessoryView = toolBar
        field_visable.inputAccessoryView = toolBar
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(menuDetail.hideKeyboard(tapG:)))
        tap.cancelsTouchesInView = false
        // 加在最基底的 self.view 上
        self.view.addGestureRecognizer(tap)
        
        
        
    }
    
    
    //Update Menu's Detail
    //Writer : Niguai
    //Last UpdUser:Niguai
    @IBAction func updAction(_ sender: Any) {
        
        if(self.type == "U"){
            updUrl =  "http://140.136.150.95:3000/menu/update?storeID=\(AccountData.user_ID)&dishName=\(field_Name.text!)&dishPrice=\(field_Price.text!)&dishTotal=\(field_Total.text!)&takeOut=\(field_TakeOut.text!)&order_moring=\(field_mor.text!)&order_afternoon=\(field_aft.text!)&order_evening=\(field_even.text!)&visable=\(field_visable.text!)&menuID=\(MenuDetail.menuID)"
            print(updUrl)
            let urlStr = updUrl.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)
            let url = URL(string:urlStr!)
            let task = URLSession.shared.dataTask(with: url!) { (data, response , error) in
                if let data = data, let _ = String(data: data, encoding: .utf8) {
                    
                }
            }
            task.resume()
            let _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer) in
                self.navigationController?.popToRootViewController(animated: true)
            }
        }else{
            check = 1;
            if(field_Name.text == ""){
                check = 0
            }
            if(field_Price.text == "" || isNum(str: field_Price.text!) == false){
                check = 0
            }
            if(field_Total.text == "" || isNum(str: field_Total.text!) == false){
                check = 0
            }
            if(field_TakeOut.text == ""){
                check = 0
            }
            if(field_mor.text == ""){
                check = 0
            }
            if(field_aft.text == ""){
                check = 0
            }
            if(field_even.text == ""){
                check = 0
            }
            if(field_visable.text == ""){
                check = 0
            }
            if(check != 0){
                insertUrl = "http://140.136.150.95:3000/menu/add?storeID=\(AccountData.user_ID)&dishName=\(field_Name.text!)&dishPrice=\(field_Price.text!)&dishTotal=\(field_Total.text!)&takeOut=\(field_TakeOut.text!)&order_moring=\(field_mor.text!)&order_afternoon=\(field_aft.text!)&order_evening=\(field_even.text!)&visable=\(field_visable.text!)"
                let urlStr = insertUrl.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)
                let url = URL(string:urlStr!)
                let task = URLSession.shared.dataTask(with: url!) { (data, response , error) in
                    if let data = data, let _ = String(data: data, encoding: .utf8) {
                    }
                }
                task.resume()
                
                let _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer) in
                    self.navigationController?.popToRootViewController(animated: true)
                }
                
            }else{
                self.Message(titleText: "錯誤", messageText: "欄位不得為空")
            }
            
        }
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerArray.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerArray[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if(self.statusStr == "T"){
            self.field_TakeOut.text = pickerArray[row]
            donePressd();
        }else if(self.statusStr == "M"){
            self.field_mor.text = pickerArray[row]
            donePressd();
        }else if(self.statusStr == "A"){
            self.field_aft.text = pickerArray[row]
            donePressd();
        }else if(self.statusStr == "E"){
            self.field_even.text = pickerArray[row]
            donePressd();
        }else if(self.statusStr == "V"){
            self.field_visable.text = pickerArray[row]
            donePressd();
        }else{
            statusStr = "";
        }
        
    }
    
    
    @objc func hideKeyboard(tapG:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    
    @objc func donePressd()  {
        view.endEditing(true)
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(textField == self.field_TakeOut){
            statusStr = "T";
        }else if(textField == self.field_mor){
            statusStr = "M";
        }else if(textField == self.field_aft){
            statusStr = "A";
        }else if(textField == self.field_even){
            statusStr = "E";
        }else if(textField == self.field_visable){
            statusStr = "V";
        }else{
            statusStr = "";
        }
        
        
    }
    
    
    //Return true If the input String is all Number
    //Writer : Niguai
    //Last UpdUser:Niguai
    func isNum(str:String) -> Bool {
        var TorF = true
        for eachChar in str.characters{
            if((eachChar < "0") || (eachChar > "9")){
                TorF = false
                break
            }
        }
        
        return TorF
    }
    
    
    //Alert Message
    //Writer : Hsin
    //Last UpdUser:Hsin
    func Message(titleText : String, messageText : String ){
        let alert = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {  (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    
    
    
}

