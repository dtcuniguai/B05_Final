//
//  orderListView.swift
//  ios1
//
//  Created by maartenwei on 2017/12/8.
//  Copyright © 2017年 Niguai. All rights reserved.
//

import UIKit

class orderListView: UITableViewController {
    
    var orderID = 0
    var resName = ""
    var OrderListView = [OrderlistView]()
    var total = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        var urlStr =    "http://140.136.150.95:3000/orderlist/detail/user?orderID=\(orderID)".addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)
        var url = URL(string:urlStr!)
        var task = URLSession.shared.dataTask(with: url!) { (data, response , error) in
            if let data = data, let dic = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [[String:Any]]{
                DispatchQueue.main.async {
                    for menu in dic {
                        let SearObj = OrderlistView(name: menu["name"] as! String,
                                                    number:menu["number"] as! Int,
                                                    price:menu["price"] as! Int,
                                                    totalPrice:menu["Totalprice"] as! Int
                        );
                        self.OrderListView.append(SearObj);
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
        
        
        return OrderListView.count + 2
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 100.0;
    }
    
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "seeOrder" ) as! orderListViewCell
        print (OrderListView.count)
        if indexPath.item == 0{
            cell.valueLabel.text = "店名："
            cell.totalPrice.text = resName
            cell.fieldLabel.isHidden = true
            cell.label1.isHidden = true
            cell.label2.isHidden = true
            cell.number.isHidden = true
        }
        else if indexPath.item == OrderListView.count + 1{
            cell.valueLabel.text = "總金額："
            cell.totalPrice.text = String(total)
            cell.fieldLabel.isHidden = true
            cell.label1.isHidden = true
            cell.label2.isHidden = true
            cell.number.isHidden = true
        }
        else{
            cell.fieldLabel.isHidden = false
            cell.label1.isHidden = false
            cell.label2.isHidden = false
            cell.number.isHidden = false
            let Data = OrderListView[indexPath.item - 1 ]
            cell.fieldLabel.text = Data.name
            cell.valueLabel.text = String( Data.price) + "元"
            cell.number.text = String(Data.number) + "份"
            cell.totalPrice.text = "單筆消費：" + String(Data.totalPrice) + "元"
        }
        
        
        
        return cell;
        
    }

}

class orderListViewCell: UITableViewCell {
    
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet weak var fieldLabel: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
