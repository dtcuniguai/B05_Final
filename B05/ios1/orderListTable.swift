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

    var userOrderList = [OrderlistTable]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlStr = "http://140.136.150.95:3000/orderlist/show/user?ID=\(AccountData.user_ID)".addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)
        let url = URL(string:urlStr!)
        let task = URLSession.shared.dataTask(with: url!) { (data, response , error) in
            if let data = data, let dic = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [[String:Any]]{
                DispatchQueue.main.async {
                    for menu in dic {
                        print(1)
                        let SearObj = OrderlistTable(orderID: menu["order_ID"] as! Int,
                                                     total: menu["total"] as! Int,
                                                     pay_Time: menu["pay_Time"] as! String,
                                                     Name:menu["Name"] as! String);
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
        
        return userOrderList.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 100.0;
    }
    
    
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell =  tableView.dequeueReusableCell(withIdentifier: "orderListTableCell" ) as! orderListTableCell
            let Data = userOrderList[indexPath.item]
            cell.resName.text = Data.Name
            cell.totalPrice.text = String(Data.total) + "元"
            if Data.pay_Time == "No Value" {
                cell.status.text = "尚未完成"
            }
            else{
                cell.status.text = "完成"
            }
        
        
             return cell;
        }

        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goOrderView" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! orderListView
                destinationController.resName = userOrderList[indexPath.row].Name
                destinationController.orderID = userOrderList[indexPath.row].orderID
                destinationController.total = userOrderList[indexPath.row].total
            }
        }
        
    }

    

}

class orderListTableCell:UITableViewCell{
    
    
    
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
