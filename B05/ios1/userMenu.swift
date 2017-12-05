//
//  userMenu.swift
//  ios1
//
//  Created by 李季耕 on 2017/11/18.
//  Copyright © 2017年 Niguai. All rights reserved.
//

import Foundation
import UIKit

class userMenu:UITableViewController{
    
    var menuArray = [Menu]();
    var menuUrl =  "http://140.136.150.95:3000/menu/detail?storeID=14";
    var index = 0;
    
    override func viewDidLoad() {
        //super.viewDidLoad()
        viewWillAppear(true)
    }
    
    
    //Qry Menu Detail From DataBase
    //Writer : Niguai
    //Last UpdUser:Niguai
    override func viewWillAppear(_ animated: Bool) {
        menuArray.removeAll()
        let urlStr = menuUrl.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)
        let url = URL(string:urlStr!)
        let task = URLSession.shared.dataTask(with: url!) { (data, response , error) in
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
                        print(SearObj)
                    }
                    self.tableView.reloadData()
                }
            }
            
        }
        task.resume()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //table的cell數量
    //Writer : Niguai
    //Last UpdUser:Niguai
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
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
        
        let menu = menuArray[indexPath.item];
        let cell = tableView.dequeueReusableCell(withIdentifier: "userMenuCell", for: indexPath) as! userMenuCell;
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
        return cell;
        
    }
    
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "menuUpdate" {
            let destinationController = segue.destination as! menuDetail
            destinationController.MenuDetail = self.menuArray[self.index]
        }
    }*/
    
    
    
    
}


//class for tableView'Cell EleMent
//Writer : Niguai
//Last UpdUser:Niguai
class userMenuCell:UITableViewCell{
    
    @IBOutlet weak var menuName: UILabel!
    @IBOutlet weak var menuCost: UILabel!
    @IBOutlet weak var menuLeft: UILabel!
    var menuID: Int = 0
    var storeID: Int = 0
    var takeOut: String = ""
    var order_mor: String = ""
    var order_after: String = ""
    var order_even: String = ""
    var visable: String = ""
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

