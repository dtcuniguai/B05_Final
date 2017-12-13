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
    
    
    
    var city = ["-------","台北市","新北市","桃園市","台中市","台南市","高雄市","基隆市","新竹縣","新竹市","嘉義市","苗栗縣","彰化縣","南投縣","雲林縣","嘉義市","嘉義縣","屏東縣","宜蘭縣","花蓮縣","台東縣","澎湖縣"]
    
    //所有餐廳類別
    var ResType = ["-------","其他美食","日式料理","亞洲料理","素食","烘焙、甜點、零食","小吃","速食料理","冰品、飲料、甜湯","咖啡、簡餐、茶","燒烤類","鍋類","主題特色餐廳","異國料理","中式料理","早餐","buffet自助餐"]
    
    var sortchange = ["-------","依熱門排序","依評價排序"]
    
    var 台北市 = ["-------","中正區","大同區","中山區","松山區","大安區","萬華區","信義區","士林區","北投區","內湖區","南港區","文山區"]
    var 新北市 = ["-------","萬里區","金山區","板橋區","汐止區","深坑區","石碇區","瑞芳區","平溪區","雙溪區","貢寮區","新店區","坪林區","烏來區","永和區","中和區","土城區","三峽區","樹林區","鶯歌區","三重區","新莊區","泰山區","林口區","蘆洲區","五股區","八里區","淡水區","三芝區","石門區"]
    var 基隆市 = ["-------","仁愛區","信義區","中正區","中山區","安樂區","暖暖區","七堵區"];
    var 宜蘭縣 = ["-------","宜蘭市","頭城鎮","礁溪鄉","壯圍鄉","員山鄉","羅東鎮","三星鄉","大同鄉","五結鄉","冬山鄉","蘇澳鎮","南澳鄉"]
    var 新竹市 = ["-------","東區", "北區", "香山區"];
    var 新竹縣 = ["-------","湖口鄉","新豐鄉","新埔鎮","關西鎮","芎林鄉","寶山鄉","竹東鎮","五峰鄉","橫山鄉","尖石鄉","北埔鄉","峨眉鄉"];
    var 桃園市 = ["-------","中壢區","平鎮區","龍潭區","楊梅區","新屋區","觀音區","桃園區","龜山區","八德區","大溪區","復興區","大園區","蘆竹區"];
    var 苗栗縣 = ["-------","竹南鎮","頭份鎮","三灣鄉","南庄鄉","獅潭鄉","後龍鎮","通霄鎮","苑裡鎮","苗栗市","造橋鄉","頭屋鄉","公館鄉","大湖鄉","泰安鄉","銅鑼鄉","三義鄉","西湖鄉","卓蘭鎮"];
    var 台中市 = ["-------","中區","東區","南區","西區","北區","北屯區","西屯區","南屯區","太平區","大里區","霧峰區","烏日區","豐原區","后里區","石岡區","東勢區","和平區","新社區","潭子區","大雅區","神岡區","大肚區","沙鹿區","龍井區","梧棲區","清水區","大甲區","外埔區","大安區"];
    var 彰化縣 = ["-------","彰化市","芬園鄉","花壇鄉","秀水鄉","鹿港鎮","福興鄉","線西鄉","和美鎮","伸港鄉","員林鎮","社頭鄉","永靖鄉","埔心鄉","溪湖鎮","大村鄉","埔鹽鄉","田中鎮","北斗鎮","田尾鄉","埤頭鄉","溪州鄉","竹塘鄉","二林鎮","大城鄉","芳苑鄉","二水鄉"];
    var 南投縣 = ["-------","南投市","中寮鄉","草屯鎮","國姓鄉","埔里鎮","仁愛鄉","名間鄉","集集鎮","水里鄉","魚池鄉","信義鄉","竹山鎮","鹿谷鄉"];
    var 雲林縣 = ["-------","斗南鎮","大埤鄉","虎尾鎮","土庫鎮","褒忠鄉","東勢鄉","台西鄉","崙背鄉","麥寮鄉","斗六市","林內鄉","古坑鄉","莿桐鄉","西螺鎮","二崙鄉","北港鎮","水林鄉","口湖鄉","四湖鄉","元長鄉"];
    var 嘉義市 = ["-------","東區", "西區"];
    var 嘉義縣 = ["-------","番路鄉","梅山鄉","竹崎鄉","阿里山","中埔鄉","大埔鄉","水上鄉","鹿草鄉","太保市","朴子市","東石鄉","六腳鄉","新港鄉","民雄鄉","大林鎮","溪口鄉","義竹鄉","布袋鎮"];
    var 台南市 = ["-------","永康區","歸仁區","新化區","左鎮區","玉井區","楠西區","南化區","仁德區","關廟區","龍崎區","官田區","麻豆區","佳里區","西港區","七股區","將軍區","學甲區","北門區","新營區","後壁區","白河區","東山區","六甲區","下營區","柳營區","鹽水區","善化區","大內區","山上區","新市區","安定區"];
    var 高雄市 = ["-------","新興區","前金區","苓雅區","鹽埕區","鼓山區","旗津區","前鎮區","三民區","楠梓區","小港區","左營區","仁武區","大社區","岡山區","路竹區","阿蓮區","田寮區","燕巢區","橋頭區","梓官區","彌陀區","永安區","湖內區","鳳山區","大寮區","林園區","鳥松區","大樹區","旗山區","美濃區","六龜區","內門區","杉林區","甲仙區","桃源區","那瑪夏","茂林區","茄萣區"];
    var 屏東縣 = ["-------","屏東市","三地門","霧台鄉","瑪家鄉","九如鄉","里港鄉","高樹鄉","鹽埔鄉","長治鄉","麟洛鄉","竹田鄉","內埔鄉","萬丹鄉","潮州鎮","泰武鄉","來義鄉","萬巒鄉","崁頂鄉","新埤鄉","南州鄉","林邊鄉","東港鎮","琉球鄉","佳冬鄉","新園鄉","枋寮鄉","枋山鄉","春日鄉","獅子鄉","車城鄉","牡丹鄉","恆春鎮","滿州鄉"]
    var 台東縣 = ["-------","台東市","綠島鄉","蘭嶼鄉","延平鄉","卑南鄉","鹿野鄉","關山鎮","海端鄉","池上鄉","東河鄉","成功鎮","長濱鄉","太麻里","金峰鄉","大武鄉","達仁鄉"]
    var 花蓮縣 = ["-------","花蓮市","新城鄉","秀林鄉","吉安鄉","壽豐鄉","鳳林鎮","光復鄉","豐濱鄉","瑞穗鄉","萬榮鄉","玉里鎮","卓溪鄉","富里鄉"]
    var 澎湖縣 = ["-------","馬公市","西嶼鄉","望安鄉","七美鄉","白沙鄉","湖西鄉"]
    
    var countRow: Int =  0
    
    var statusStr :String!
    
    var pick = UIPickerView()
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "zh-Hant"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        
        
        if countRow == city.count && statusStr == "C"{
            let titleRow = city[row]
             return titleRow
        }
        
        
        if  statusStr == "D"{
            if cityTextField.text == "台北市" {
                let titleRow = 台北市[row]
                return titleRow
            }
            else if cityTextField.text == "新北市" {
                let titleRow = 新北市[row]
                return titleRow
            }
            else if cityTextField.text == "桃園市" {
                var titleRow = 桃園市[row]
                return titleRow
            }
            else if cityTextField.text == "台中市" {
                var titleRow = 台中市[row]
                return titleRow
            }
            else if cityTextField.text == "台南市" {
                var titleRow = 台南市[row]
                return titleRow
            }
            else if cityTextField.text == "高雄市" {
                var titleRow = 高雄市[row]
                return titleRow
            }
            else if cityTextField.text == "基隆市" {
                var titleRow = 基隆市[row]
                return titleRow
            }
            else if cityTextField.text == "新竹市" {
                var titleRow = 新竹市[row]
                return titleRow
            }
            else if cityTextField.text == "新竹縣" {
                var titleRow = 新竹縣[row]
                return titleRow
            }
            else if cityTextField.text == "嘉義市" {
                var titleRow = 嘉義市[row]
                return titleRow
            }
            else if cityTextField.text == "嘉義縣"{
                var titleRow = 嘉義縣[row]
                return titleRow
            }
            else if cityTextField.text == "苗栗縣"{
                var titleRow = 苗栗縣[row]
                return titleRow
                
            }
            else if cityTextField.text == "彰化縣"{
                var titleRow = 彰化縣[row]
                return titleRow
            }
            else if cityTextField.text == "南投縣"{
                var titleRow = 南投縣[row]
                return titleRow
            }
            else if cityTextField.text == "雲林縣"{
                var titleRow = 雲林縣[row]
                return titleRow
            }
            else if cityTextField.text == "屏東縣" {
                var titleRow = 屏東縣[row]
                return titleRow
            }
            else if cityTextField.text == "宜蘭縣"{
                var titleRow = 宜蘭縣[row]
                return titleRow
            }
            else if cityTextField.text == "花蓮縣"{
                var titleRow = 花蓮縣[row]
                return titleRow
            }
            else if cityTextField.text == "台東縣"{
                var titleRow = 台東縣[row]
                return titleRow
            }
            else if cityTextField.text == "澎湖縣"{
                var titleRow = 澎湖縣[row]
                return titleRow
            }
        }
            
        else if countRow == ResType.count && statusStr == "R" {
            
            let titleRow = ResType[row]
            return titleRow
            
            
        }
            
        else if countRow == sortchange.count && statusStr == "S" {
            
            let titleRow = sortchange[row]
            return titleRow
        }
        
        return ""
        
    }
    
    
    //將所選的項目輸入指定的TextField，並讓選單消失
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if countRow == city.count && statusStr == "C"{
            if city[row] == "-------"{
                self.cityTextField.text = ""
            }
            else {
                self.cityTextField.text = self.city[row]
            }
            
            if(self.cityTextField.text == ""){
                self.districtTextField.isUserInteractionEnabled = false
            }else{
                self.districtTextField.isUserInteractionEnabled = true
            }
            self.districtTextField.text = ""
            
        }
            
        else if  statusStr == "D" {
            
            if cityTextField.text == "台北市" {
                if 台北市[row] == "-------"{
                    self.districtTextField.text = ""
                }
                else {
                    self.districtTextField.text = 台北市[row]
                }
            }
            else if cityTextField.text == "新北市" {
                if 新北市[row] == "-------"{
                    self.districtTextField.text = ""
                }
                else {
                   self.districtTextField.text = 新北市[row]
                }
            }
            else if cityTextField.text == "桃園市" {
                if 桃園市[row] == "-------"{
                    self.districtTextField.text = ""
                }
                else{
                    self.districtTextField.text = 桃園市[row]
                }
                
                
            }
            else if cityTextField.text == "台中市" {
                if 台中市[row] == "-------"{
                    self.districtTextField.text = ""
                }
                else{
                    self.districtTextField.text = 台中市[row]
                }
            }
            else if cityTextField.text == "台南市" {
                if 台南市[row] == "-------"{
                    self.districtTextField.text = ""
                }
                else{
                    self.districtTextField.text = 台南市[row]
                }
            }
            else if cityTextField.text == "高雄市" {
                if 高雄市[row] == "-------"{
                    self.districtTextField.text = ""
                }
                else{
                   self.districtTextField.text = 高雄市[row]
                }
            }
            else if cityTextField.text == "基隆市" {
                if 基隆市[row] == "-------"{
                    self.districtTextField.text = ""
                }
                else{
                    self.districtTextField.text = 基隆市[row]
                }
            }
            else if cityTextField.text == "新竹市" {
                if 新竹市[row] == "-------"{
                    self.districtTextField.text = ""
                }
                else{
                    self.districtTextField.text = 新竹市[row]
                }
            }
            else if cityTextField.text == "新竹縣" {
                if 新竹縣[row] == "-------"{
                    self.districtTextField.text = ""
                }
                else{
                    self.districtTextField.text = 新竹縣[row]
                }
                
                
            }
            else if cityTextField.text == "嘉義市" {
                if 嘉義市[row] == "-------"{
                    self.districtTextField.text = ""
                }
                else{
                    self.districtTextField.text = 嘉義市[row]
                }
                
                
            }
            else if cityTextField.text == "嘉義縣"{
                if 嘉義縣[row] == "-------"{
                    self.districtTextField.text = ""
                }
                else{
                   self.districtTextField.text = 嘉義縣[row]
                }
                
                
            }
            else if cityTextField.text == "苗栗縣"{
                if 苗栗縣[row] == "-------"{
                    self.districtTextField.text = ""
                }
                else{
                    self.districtTextField.text = 苗栗縣[row]
                }
    
            }
            if cityTextField.text == "彰化縣"{
                if 彰化縣[row] == "-------"{
                    self.districtTextField.text = ""
                }
                else{
                    self.districtTextField.text = 彰化縣[row]
                }
                
                
            }
            else if cityTextField.text == "南投縣"{
                if 南投縣[row] == "-------"{
                    self.districtTextField.text = ""
                }
                else{
                    self.districtTextField.text = 南投縣[row]
                }
                
                
            }
            else if cityTextField.text == "雲林縣"{
                if 南投縣[row] == "-------"{
                    self.districtTextField.text = ""
                }
                else{
                    self.districtTextField.text = 南投縣[row]
                }
                
                
            }
            else if cityTextField.text == "屏東縣" {
                if 屏東縣[row] == "-------"{
                    self.districtTextField.text = ""
                }
                else{
                    self.districtTextField.text = 屏東縣[row]
                }
                
                
            }
            else if cityTextField.text == "宜蘭縣"{
                if 宜蘭縣[row] == "-------"{
                    self.districtTextField.text = ""
                }
                else{
                    self.districtTextField.text = 宜蘭縣[row]
                }
                
                
            }
            else if cityTextField.text == "花蓮縣"{
                if 花蓮縣[row] == "-------"{
                    self.districtTextField.text = ""
                }
                else{
                    self.districtTextField.text = 花蓮縣[row]
                }
                
                
            }
            else if cityTextField.text == "台東縣"{
                if 台東縣[row] == "-------"{
                    self.districtTextField.text = ""
                }
                else{
                    self.districtTextField.text = 台東縣[row]
                }
                
                
            }
            else if cityTextField.text == "澎湖縣"{
                if 澎湖縣[row] == "-------"{
                    self.districtTextField.text = ""
                }
                else{
                    self.districtTextField.text = 澎湖縣[row]
                }
                
                
            }
            
        }
        
            
        else if countRow == ResType.count && statusStr == "R" {
            if ResType[row] == "-------" {
                self.ResTypeTextField.text = ""
            }
            else {
                self.ResTypeTextField.text = self.ResType[row]
            }
        }
        else if countRow == sortchange.count && statusStr == "S"{
            if sortchange[row] == "-------" {
                self.sort.text = ""
            }
            else {
                self.sort.text = self.sortchange[row]
            }
        }
    }
    
    
    //點選TextField顯示相對應的選單
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.cityTextField){
            countRow = city.count
            statusStr = "C"
            
        }
        else if (textField == self.districtTextField){
            if cityTextField.text == "台北市" {
                countRow = 台北市.count
            }
            else if cityTextField.text == "新北市" {
                countRow = 新北市.count
            }
            else if cityTextField.text == "桃園市" {
                countRow = 桃園市.count
            }
            else if cityTextField.text == "台中市" {
                countRow = 台中市.count
            }
            else if cityTextField.text == "台南市" {
                countRow = 台南市.count
            }
            else if cityTextField.text == "高雄市" {
                countRow = 高雄市.count
            }
            else if cityTextField.text == "基隆市" {
                countRow = 基隆市.count
            }
            else if cityTextField.text == "新竹市" {
                countRow = 新竹市.count
            }
            else if cityTextField.text == "新竹縣" {
                countRow = 新竹縣.count
            }
            else if cityTextField.text == "嘉義市" {
                countRow = 嘉義市.count
            }
            else if cityTextField.text == "嘉義縣"{
                countRow = 嘉義縣.count
            }
            else if cityTextField.text == "苗栗縣"{
                countRow = 苗栗縣.count
            }
            else if cityTextField.text == "彰化縣"{
                countRow = 彰化縣.count
            }
            else if cityTextField.text == "南投縣"{
                countRow = 南投縣.count
            }
            else if cityTextField.text == "雲林縣"{
                countRow = 雲林縣.count
            }
            else if cityTextField.text == "屏東縣" {
                countRow = 屏東縣.count
            }
            else if cityTextField.text == "宜蘭縣"{
                countRow = 宜蘭縣.count
            }
            else if cityTextField.text == "花蓮縣"{
                countRow = 花蓮縣.count
            }
            else if cityTextField.text == "台東縣"{
                countRow = 台東縣.count
            }
            else if cityTextField.text == "澎湖縣"{
                countRow = 澎湖縣.count
            }
            statusStr = "D"
        }
            
        else if (textField == self.ResTypeTextField){
            
            countRow  = ResType.count
            statusStr = "R"
        }
        else if textField == self.sort {
            countRow = sortchange.count
            statusStr = "S"
        }
        
    }
    
    //傳數值到textSearch
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pickerBlockSegue" {
            var usesort = "2"
            let destinationController = segue.destination as! textSearch
            destinationController.city = cityTextField.text!
            destinationController.district = districtTextField.text!
            destinationController.searchType = ResTypeTextField.text!
            destinationController.textSearch = textSearchTextField.text!
            if sort.text == "依熱門排序" {
                usesort = "1"
            }
            else {
                usesort = "0"
            }
            destinationController.sort = usesort
            
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
