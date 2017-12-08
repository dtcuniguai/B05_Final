//
//  orderDetail.swift
//  ios1
//
//  Created by maartenwei on 2017/12/5.
//  Copyright © 2017年 Niguai. All rights reserved.
//

import UIKit

class orderDetail: UIViewController {

    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var name: UILabel!
    
    var menu = [Menu]()
    var order = [Orderlist]()
    var index = 0
    var totalPrice = 0
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        name.text = menu[index].name
        price.text = String(menu[index].price)
        number.text = String(menu[index].total)
        orderNumber.text = String(order[index].total)
        totalPrice = menu[index].price * order[index].total
        total.text = String(totalPrice)
        
        number.layer.borderWidth = 1
        number.layer.borderColor = UIColor.black.cgColor
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addButton(_ sender: Any) {
        order[index].total = order[index].total + 1
        totalPrice = totalPrice + menu[index].price
        orderNumber.text = String(order[index].total)
        total.text = String(menu[index].price * order[index].total)
        
    }
    
   
    @IBAction func subButton(_ sender: Any) {
        if order[index].total != 0 {
            order[index].total = order[index].total - 1
            totalPrice = totalPrice - menu[index].price 
            orderNumber.text = String(order[index].total)
            total.text = String(menu[index].price * order[index].total)
        }
    }
    
    @IBAction func finishButton(_ sender: Any) {
        let notificationName = Notification.Name("GetUpdateNoti")
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["PASS":order])
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
