//進階篩選(頁碼代號:P2)
//Function:
//1.Make str to search Firebase's restaurant
//2.Return restaurant to P3
//3.Str For restaurant type
//4.Str For restaurant address
//Action:
//While click Search prepare str to P3 -> P3


import Foundation
import UIKit
import Firebase
import Speech

class pickerBlock:UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    

    @IBOutlet weak var sort: UITextField!
    
    @IBOutlet weak var sege: UISegmentedControl!
    @IBOutlet weak var sortLable: UILabel!
    //城市標籤
    @IBOutlet weak var cityLable: UILabel!
    //地區標籤
    @IBOutlet weak var districtLable: UILabel!
    //美食類別標籤
    @IBOutlet weak var ResTypeLable: UILabel!
    //顯示所選擇的城市
    @IBOutlet weak var cityTextField: UITextField!
    //顯示選擇的地區
    @IBOutlet weak var districtTextField: UITextField!
    //顯示所選擇美食種類
    @IBOutlet weak var ResTypeTextField: UITextField!
    //顯示美食種類的選單
    
    @IBOutlet weak var textSearchTextField: UITextField!
    
    @IBOutlet weak var textSearchLable: UILabel!
    //所有縣市
    
    @IBOutlet weak var mic: UIButton!
    
    
    var city = ["台北市","新北市","桃園市","台中市","台南市","高雄市","基隆市","新竹縣","新竹市","嘉義市","苗栗縣","彰化縣","南投縣","雲林縣","嘉義市","嘉義縣","屏東縣","宜蘭縣","花蓮縣","台東縣","澎湖縣"]
    //該城市的地區
    var district = [String]()
    
    //所有餐廳類別
    var ResType = ["-------","其他美食","日式料理","亞洲料理","素食","烘焙、甜點、零食","小吃","速食料理","冰品、飲料、甜湯","咖啡、簡餐、茶","燒烤類","鍋類","主題特色餐廳","異國料理","中式料理","早餐","buffet自助餐"]
    
    var sortchange = ["依熱門排序","依評價排序"]
    
    var countRow: Int =  0
    
    var pick = UIPickerView()
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "zh-Hant"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.district.append("-------")
        pick.dataSource = self
        pick.delegate = self
        pick.showsSelectionIndicator = true
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(assignAccoutAction.donePressd))
        toolBar.setItems([doneButton], animated: false)
        
        sort.text = "依熱門排序"
        self.title = "進階搜尋"
        
        textSearchTextField.delegate = self
        self.cityTextField.inputView = pick
        self.cityTextField.inputAccessoryView = toolBar
        self.districtTextField.inputView = pick
        self.districtTextField.inputAccessoryView = toolBar
        self.ResTypeTextField.inputView = pick
        self.ResTypeTextField.inputAccessoryView = toolBar
        self.sort.inputView = pick
        self.sort.inputAccessoryView = toolBar
        
        self.districtTextField.isUserInteractionEnabled = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(pickerBlock.hideKeyboard(tapG:)))
        tap.cancelsTouchesInView = false
        // 加在最基底的 self.view 上
        self.view.addGestureRecognizer(tap)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    ///根據sege上的選擇來表示文字搜尋或詳細搜尋
    @IBAction func segeAction(_ sender: Any) {
        if sege.selectedSegmentIndex == 0{
            cityLable.isHidden = true
            cityTextField.isHidden = true
            districtLable.isHidden = true
            districtTextField.isHidden = true
            ResTypeLable.isHidden = true
            ResTypeTextField.isHidden = true
            sort.isHidden = true
            sortLable.isHidden = true
            textSearchTextField.isHidden = false
            textSearchLable.isHidden = false
            ResTypeTextField.text = ""
            cityTextField.text = ""
            districtTextField.text = ""
            sort.text = ""
            
            title = "文字搜尋"
        }
        else if sege.selectedSegmentIndex == 1 {
            
            cityLable.isHidden = false
            cityTextField.isHidden = false
            districtLable.isHidden = false
            districtTextField.isHidden = false
            ResTypeLable.isHidden = false
            ResTypeTextField.isHidden = false
            sort.isHidden = false
            sortLable.isHidden = false
            textSearchTextField.isHidden = true
            textSearchLable.isHidden = true
            textSearchTextField.text = ""
            cityTextField.text = ""
            sort.text = ""
            
            title = "詳細搜尋"
        }
        
       ////////
        mic.isEnabled = false  //2
        
        speechRecognizer?.delegate = self as? SFSpeechRecognizerDelegate  //3
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in  //4
            
            var isButtonEnabled = false
            
            switch authStatus {  //5
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            OperationQueue.main.addOperation() {
                self.mic.isEnabled = isButtonEnabled
            }
        }
        ////////
    }
    
    
    //選擇選單的列數
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        
        return 1
        
    }
    
    //選擇有幾個選項
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return countRow
        
    }
    
    
    //把Array的傳入選單
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        
        
        var titleRow = self.city[row]
        
        if countRow == district.count  {
            
            titleRow = district[row]
            
            
        }
            
        else if countRow == ResType.count {
            
            titleRow = ResType[row]
            
            
        }
            
        else if countRow == sortchange.count {
            
            titleRow = sortchange[row]
        }
            
        
        
        
        
        return titleRow
        
    }
    
    
    //將所選的項目輸入指定的TextField，並讓選單消失
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if countRow == city.count{
            
            self.cityTextField.text = self.city[row]
            if(self.cityTextField.text == ""){
                self.districtTextField.isUserInteractionEnabled = false
            }else{
                self.districtTextField.isUserInteractionEnabled = true
            }
            self.districtTextField.text = ""
            //pick.isHidden = true
            
            let databaseRef = FirebaseDatabase.Database.database().reference()
            
            databaseRef.child("Address_Search").child(cityTextField.text!).observe(.value, with: {
                snapshot in
                
                self.district.removeAll()
                self.district.append("-------")
                if snapshot.exists() {
                    for a in ((snapshot.value as AnyObject).allKeys)!{
                        
                        self.district.append(a as! String)
                    }
                } else {
                    print("false")
                }
                
            })
            
            
        }
            
        else if countRow == district.count {
            
            self.district.append("-------")
            self.districtTextField.text = self.district[row]

        }
            
        else if countRow == ResType.count {
            
            self.ResTypeTextField.text = self.ResType[row]

            
        }
        else if countRow == sortchange.count {
            self.sort.text = self.sortchange[row]
            
        }
        
        
    }
    
    
    //點選TextField顯示相對應的選單
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.cityTextField){
            countRow = city.count
            
        }
        else if (textField == self.districtTextField){
            
            countRow = district.count
            
        }
            
        else if (textField == self.ResTypeTextField){
            
            countRow  = ResType.count
            
        }
        else if textField == self.sort {
            countRow = sortchange.count
        }
        
    }
    
    //傳數值到textSearch
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pickerBlockSegue" {
            
            let destinationController = segue.destination as! textSearch
            destinationController.city = cityTextField.text!
            destinationController.district = districtTextField.text!
            destinationController.searchType = ResTypeTextField.text!
            destinationController.textSearch = textSearchTextField.text!
            if sort.text == "依熱門排序" {
                sort.text = "1"
            }
            else {
                sort.text = "0"
            }
            destinationController.sort = sort.text!
            
        }
        
    }
    
    
    @objc func donePressd() {
        
            view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textSearchTextField.resignFirstResponder()
        
        return (true)
    }
    
    
    @IBAction func micAction(_ sender: Any) {
        
        
    }
    
    
    @objc func hideKeyboard(tapG:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    
    
    
}
