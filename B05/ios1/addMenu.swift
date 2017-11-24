///新增菜單
//Function:
//1.Insert new menu into database
//Writer : Niguai
//Last UpdUser :

import Foundation
import UIKit

class addMenu:UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate,UITextFieldDelegate{
    
//Basic Init Item
    @IBOutlet weak var field_Name: UITextField!
    @IBOutlet weak var field_Price: UITextField!
    @IBOutlet weak var field_Total: UITextField!
    @IBOutlet weak var field_TakeOut: UITextField!
    @IBOutlet weak var field_mor: UITextField!
    @IBOutlet weak var field_aft: UITextField!
    @IBOutlet weak var field_even: UITextField!
    @IBOutlet weak var field_visable: UITextField!
    var insertUrl =  "";
    var status = 1;
    var storeID = 1;
    
    let pickerArray = ["Y","N"]
    var statusStr :String!
    var pick = UIPickerView()
    
    
    override func viewDidLoad() {
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(assignAccoutAction.donePressd))
        toolBar.setItems([doneButton], animated: false)
        
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
        
    }
    
    
//Button Click Action to Insert Into Database
//Writer : Niguai
//Last UpdUser:Niguai
    @IBAction func insertAction(_ sender: Any) {
        
        status = 1;
        if(field_Name.text == ""){
            status = 0
        }
        if(field_Price.text == "" || isNum(str: field_Price.text!) == false){
            status = 0
        }
        if(field_Total.text == "" || isNum(str: field_Total.text!) == false){
            status = 0
        }
        if(field_TakeOut.text == ""){
            status = 0
        }
        if(field_mor.text == ""){
            status = 0
        }
        if(field_aft.text == ""){
            status = 0
        }
        if(field_even.text == ""){
            status = 0
        }
        if(field_visable.text == ""){
            status = 0
        }
        if(status != 0){
            insertUrl = "http://140.136.150.95:3000/menu/add?storeID=\(storeID)&dishName=\(field_Name.text!)&dishPrice=\(field_Price.text!)&dishTotal=\(field_Total.text!)&takeOut=\(field_TakeOut.text!)&order_moring=\(field_mor.text!)&order_afternoon=\(field_aft.text!)&order_evening=\(field_even.text!)&visable=\(field_visable.text!)"
            let urlStr = insertUrl.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)
            let url = URL(string:urlStr!)
            let task = URLSession.shared.dataTask(with: url!) { (data, response , error) in
                if let data = data, let _ = String(data: data, encoding: .utf8) {
                    //self.status = [content]
                    //print(self.status)
                }
            }
            task.resume()
            
            self.navigationController?.popViewController(animated: true)
        }else{
            self.Message(titleText: "錯誤", messageText: "欄位不得為空")
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
    
    
}
