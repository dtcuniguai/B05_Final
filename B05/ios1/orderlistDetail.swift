//
//  orderlistDetail.swift
//  ios1
//
//  Created by Set on 07/11/2017.
//  Copyright © 2017 Niguai. All rights reserved.
//

import UIKit

class orderlistDetail: UITableViewController {

    var orderlists: Orderlist!
    
    //connect database
    //Writer : Set
    override func viewDidLoad() {
        super.viewDidLoad()
        print(orderlists.orderID)
        let urlStr = "http://140.136.150.95:3000/orderlist/detail?orderID=\(orderlists.orderID)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlStr!)
        let task = URLSession.shared.dataTask(with: url!) { (data, response , error) in
            if let data = data, let dic = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [[String:Any]]{
                DispatchQueue.main.async {
                    for detail in dic{
                        self.orderlists.menuID = (detail["ID"] as? Int)!
                        self.orderlists.menuName = (detail["name"] as? String)!
                        self.orderlists.total = (detail["number"] as? Int)!
                        self.orderlists.price = (detail["Totalprice"] as? Int)!
                        self.orderlists.updateValue = (detail["updateValue"] as? Int)!
                    }
                    self.tableView.reloadData()
                    
                }
            }
        }
        task.resume()
    }

    //doneButton Action
    //Writer : Set
    @IBAction func doneButtonAction(_ sender: Any) {
        Message()
    }
    
    //Alert Message
    //Writer : Set
    func Message(){
        let alert = UIAlertController(title: "訂單", message: "確定已完成訂單？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確定", style: .default, handler: {  (action) in
            let urlStr = "http://140.136.150.95:3000/orderlist/done?orderID=\(self.orderlists.orderID)&menuID=\(self.orderlists.menuID)&total=\(self.orderlists.updateValue)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let url = URL(string: urlStr!)
            let task = URLSession.shared.dataTask(with: url!) { (data, response , error) in
                if let data = data, let _ = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [[String:Any]]{
                }
            }
            task.resume()
            self.AlertMessage()
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .default, handler: {  (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //Alert Message
    //Writer : Set
    func AlertMessage(){
        let alert = UIAlertController(title: "訂單", message: "訂單已完成", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {  (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //cell數量
    //Writer : Set
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfCell: Int = 6
        if AccountData.user_Type == "U"{
            numberOfCell = 5
        }
        return numberOfCell
    }

    //cell content
    //Writer : Set
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderlistDetailCell", for: indexPath) as! orderlistDetailCell
        
        switch indexPath.row{
        case 0:
            var name = "訂單人"
            if AccountData.user_Type == "U"{
                name = "餐廳"
            }
            cell.fieldLabel.text = name
            cell.valueLabel.text = orderlists.userName
            cell.doneButton.isHidden = true
        case 1:
            cell.fieldLabel.text = "訂單時間"
            cell.valueLabel.text = orderlists.orderTime
            cell.doneButton.isHidden = true
        case 2:
            cell.fieldLabel.text = "菜名"
            cell.valueLabel.text = orderlists.menuName
            cell.doneButton.isHidden = true
        case 3:
            cell.fieldLabel.text = "數量"
            cell.valueLabel.text = String(orderlists.total)
            cell.doneButton.isHidden = true
        case 4:
            cell.fieldLabel.text = "總金額"
            cell.valueLabel.text = String(orderlists.price)
            cell.doneButton.isHidden = true
        case 5:
            cell.fieldLabel.isHidden = true
            cell.valueLabel.isHidden = true
        default:
            cell.fieldLabel.text = ""
            cell.valueLabel.text = ""
        }

        return cell
    }
}
