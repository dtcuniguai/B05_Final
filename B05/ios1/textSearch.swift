//
//  textSearch.swift
//  ios1
//
//  Created by Set on 2017/10/10.
//  Copyright © 2017年 Niguai. All rights reserved.
//

import UIKit
import FirebaseDatabase

class textSearch: UITableViewController {
    
    

    @IBOutlet var resultsTable: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var restaurantArray = [Restaurant]()
    
    var ref = Database.database().reference()

    var city = ""
    var district = ""
    var searchType = ""
    var sort = ""
    var textSearch = ""
    
    var urlchange = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //地區搜尋
        if textSearch != "" {
         
            urlchange = "http://140.136.150.95:3000/search/text?search=\(textSearch)"
            
            title = "文字搜尋"
        }
        
        //一般搜尋
        else{
            
            urlchange = "http://140.136.150.95:3000/search/district?city=\(city)&zone=\(district)&type=\(searchType)&sort="
            title = "搜尋"
        }
        
        let urlStr = urlchange.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        let url = URL(string:urlStr!)
        let task = URLSession.shared.dataTask(with: url!) { (data, response , error) in
            if let data = data, let dic = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [[String:Any]]{
                DispatchQueue.main.async {
                    for hotSear in dic {
                        let SearObj = Restaurant(ResID: hotSear["ID"]! as! Int,
                                                 Name: hotSear["Name"]! as! String,
                                                 ResType:hotSear["typeName"] as! String,
                                                 ResImage:hotSear["res_Pic"] as? String,
                                                 ResPhone:hotSear["res_Tel"] as! String,
                                                 ResAddress:hotSear["res_Address"] as? String,
                                                 ResCost:hotSear["res_Cost"] as! String,
                                                 ResInfo: hotSear["res_Summary"] as! String ,
                                                 Res_X:hotSear["res_LNG"] as! Double,
                                                 Res_Y:hotSear["res_LAT"] as! Double);
                        self.restaurantArray.append(SearObj);
                        
                        
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


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //table的cell數量
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantArray.count
    }

    //顯示table的內容
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let restaurant = restaurantArray[indexPath.item];
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = restaurant.Name;
        cell.detailTextLabel?.text = restaurant.ResAddress;
        
        
        return cell;
    }


    //跳轉至restaurantDetail頁面且傳資料
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRestaurantDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! restaurantDetail
                destinationController.restaurant = restaurantArray[indexPath.row]
            }
        }
    }
}
