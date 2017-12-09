//
//  userMenu.swift
//  ios1
//
//  Created by 李季耕 on 2017/11/18.
//  Copyright © 2017年 Niguai. All rights reserved.
//

import Foundation
import UIKit
import Firebase
class userMenu:UITableViewController{
    
    var menuArray = [Menu]()
    var orderArray = [Orderlist]()
    var menuUrl =  "http://140.136.150.95:3000/menu/detail/store?storeID=14";
    var index = 0;
    var totalPrice = 0
    var s  = 0
    var flag = 0
    var resID = 0
    static var stid :Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        print(1)
        var urlStr = menuUrl.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)
        var url = URL(string:urlStr!)
        var task = URLSession.shared.dataTask(with: url!) { (data, response , error) in
            if let data = data, let dic = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [[String:Any]]{
                DispatchQueue.main.async {
                    for menu in dic {
                        let SearObj = Menu(menuID: menu["ID"] as! Int,
                                           storeID:menu["store_ID"] as! Int,
                                           name:menu["name"] as! String,
                                           price:menu["price"] as! Int,
                                           total:menu["total"] as! Int,
                                           takeOut:menu["takeOut"] as! String,
                                           order_mor: menu["order_moring"] as! String ,
                                           order_after:menu["order_afternoon"] as! String,
                                           order_even:menu["order_evening"] as! String,
                                           visable:menu["visable"] as! String
                        );
                        self.menuArray.append(SearObj);
                        userMenu.stid = SearObj.storeID
                    }
                    if (self.flag == 0){
                        for var i in 0...self.menuArray.count - 1{
                            let data = Orderlist(orderID: 0, menuID: self.menuArray[i].menuID, userID: AccountData.user_ID, storeID: 0, total: 0)
                            self.orderArray.append(data)
                        }
                    }
                    
                    self.tableView.reloadData()
                }
            }
            
        }
        task.resume()
        
        getOrderID()
        
        let notificationName = Notification.Name("GetUpdateNoti")
        NotificationCenter.default.addObserver(self, selector: #selector(getUpdateNoti(noti:)), name: notificationName, object: nil)
        
    }
    
    
    //Qry Menu Detail From DataBase
    //Writer : Niguai
    //Last UpdUser:Niguai
    override func viewWillAppear(_ animated: Bool) {
        
        tableView.reloadData()
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //table的cell數量
    //Writer : Niguai
    //Last UpdUser:Niguai
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count + 1
    }
    
    
    //自訂tableView高度
    //Writer : Niguai
    //Last UpdUser:Niguai
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 100.0;
    }
    
    
    //顯示table的內容
    //Writer : Niguai
    //Last UpdUser:Niguai
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "orderCell" ) as! orderActionCell
        
        cell.total.text = String(totalPrice)
        if indexPath.item < menuArray.count  {
            let menu = menuArray[indexPath.item]
            let cell = tableView.dequeueReusableCell(withIdentifier: "userMenuCell") as! userMenuCell;
            cell.menuName?.text = menu.name;
            cell.menuCost?.text = String(menu.price);
            cell.menuLeft?.text = String(menu.total);
            cell.menuID = menu.menuID
            cell.storeID = menu.storeID
            cell.takeOut = menu.takeOut
            cell.order_mor = menu.order_mor
            cell.order_after = menu.order_after
            cell.order_even = menu.order_even
            cell.visable = menu.visable
            cell.quota.text = String( orderArray[indexPath.item].total )
            totalPrice = totalPrice + orderArray[indexPath.item].total * menu.price
            
            let ss = String(cell.storeID)
            let mn = String(describing: cell.menuName.text)
            let databaseRef = Database.database().reference()
            databaseRef.child("MenuDetail").child(ss).child(mn).observe(DataEventType.value, with:{
                snapshot in
                let value = snapshot.value as? [String : AnyObject]
                let vkey = value?.keys.first
                 print(vkey)
                if(vkey != nil){
                    let vurl = value![vkey!]
                    let url = URL(string: vurl as! String)
                    cell.menu_Pic.downloadedFrom(url: url!)                    
                }
                
            })
            return cell
       }
        
        
      
        return cell;
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goOrder" {
            
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! orderDetail
                destinationController.index = indexPath.row
                destinationController.menu = menuArray
                destinationController.order = orderArray
            }
        }
        
    }
    
    
    @IBAction func creatNewOrder(_ sender: Any) {
        for var i in 0...self.menuArray.count - 1{
            
            if orderArray[i].total != 0 && orderArray[i].orderID != 0 && orderArray[i].menuID != 0 && orderArray[i].userID != 0{
                let urlStr = "http://140.136.150.95:3000/orderlist/add?orderID=\(orderArray[i].orderID)&menuID=\(orderArray[i].menuID)&userID=\(orderArray[i].userID)&total=\(orderArray[i].total)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                
                let url = URL(string: urlStr!)
                let task = URLSession.shared.dataTask(with: url!) { (data, response , error) in
                    if let data = data, let _ = String(data: data, encoding: .utf8) {
                        
                    }
                }
                task.resume()
                
                orderArray[i].total = 0
            }
            
            if i == menuArray.count - 1{
                let alert = UIAlertController(title: "訂單資訊", message: "訂單完成，請到會員資料確認訂單狀態", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {  (action) in
                    
                    self.totalPrice = 0
                    self.getOrderID()
                    self.tableView.reloadData()
                    alert.dismiss(animated: true, completion: nil)
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    func getUpdateNoti(noti:Notification) {
        //接收編輯頁面回傳的資訊
        orderArray = noti.userInfo!["PASS"] as! [Orderlist]
        
    }
    
    
    func getOrderID()   {
       var urlStr = "http://140.136.150.95:3000/orderlist/getID".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        var url = URL(string: urlStr!)
        var task = URLSession.shared.dataTask(with: url!) { (data, response , error) in
            if let data = data, let dic = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [[String:Any]]{
                DispatchQueue.main.async {
                    for comment in dic{
                            for var i in 0...self.menuArray.count - 1{
                                self.orderArray[i].orderID = comment["ID"] as! Int
                            }
                            self.flag = 1
                    }
                    
                }
            }
        }
        task.resume()
    }
    
    
}


//class for tableView'Cell EleMent
//Writer : Niguai
//Last UpdUser:Niguai
class userMenuCell:UITableViewCell{
    
    @IBOutlet weak var menuName: UILabel!
    @IBOutlet weak var menuCost: UILabel!
    @IBOutlet weak var menuLeft: UILabel!    
    @IBOutlet weak var menu_Pic: UIImageView!
    @IBOutlet weak var quota: UILabel!
    
    var menuID: Int = 0
    var storeID: Int = 0
    var takeOut: String = ""
    var order_mor: String = ""
    var order_after: String = ""
    var order_even: String = ""
    var visable: String = ""
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        quota.layer.borderWidth = 1
        quota.layer.borderColor = UIColor.black.cgColor
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

class orderActionCell:UITableViewCell{
    
    
    @IBOutlet weak var total: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    
    
}
