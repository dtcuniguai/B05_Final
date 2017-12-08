//
//  orderListTable.swift
//  ios1
//
//  Created by maartenwei on 2017/12/8.
//  Copyright © 2017年 Niguai. All rights reserved.
//

import Foundation
import UIKit

class orderListTable: UITableViewController {

    var userOrderList = [Orderlist]()
    var flag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var urlStr =    "140.136.150.95:3000/orderlist/show/user?ID=\(AccountData.user_ID)".addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)
        var url = URL(string:urlStr!)
        var task = URLSession.shared.dataTask(with: url!) { (data, response , error) in
            if let data = data, let dic = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [[String:Any]]{
                DispatchQueue.main.async {
                    for menu in dic {
                        let SearObj = Orderlist(orderID: menu["order_ID"] as! Int,
                                                total:menu["total"] as! Int,
                                                menuID:menu["ID"] as! Int,
                                                userID:menu["order_UserID"] as! Int,
                                                storeID:menu["store_ID"] as! Int,
                                                price:menu["price"] as! Int,
                                                order_Time:menu["order_Time"] as!String,
                                                pay_Time:menu["pay_Time"] as! String,
                                                name:menu["name"] as! String
                        );
                        self.userOrderList.append(SearObj);
                        
                    }
                    self.tableView.reloadData()
                }
            }
            
        }
        task.resume()

        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var tableViewCount = 0
        
        for var i in 0...userOrderList.count{
            if  i != userOrderList.count{
                if userOrderList[i].orderID != userOrderList[i+1].orderID {
                    tableViewCount = tableViewCount + 1
                }
                
            }
        }
        
        return tableViewCount
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
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "orderListTableCell" ) as! orderListTableCell
        if userOrderList[indexPath.item].orderID != userOrderList[indexPath.item - 1].orderID || indexPath.item == 0{
            cell.resName.text = userOrderList[indexPath.item].name
            
                
        }

        
        
        
        
        return cell;
        
    }

    

}

class orderListTableCell:UITableViewCell{
    
    
    @IBOutlet weak var resImage: UIImageView!
    
    @IBOutlet weak var resName: UILabel!
    
    @IBOutlet weak var totalPrice: UILabel!
    
    @IBOutlet weak var status: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    
    
}
