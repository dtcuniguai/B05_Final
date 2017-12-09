///主頁面(頁碼代號:P1)
//Function:
//1.Qry at Firebase with hotSearch
//2.Buttom1: Goto Select Page(by using text)
//3.Buttom2: Goto Select Page(by choosing blocks)
//Action:
//While click Buttom1->Page
//While click Buttom2->Page
//While click the tableViewCell's restaurant->Page
//First Write By Niguai

import Foundation
import UIKit
import Firebase

class mainMenu:  UIViewController, UITableViewDelegate, UITableViewDataSource {
    
//Basic Init Item
    @IBOutlet weak var segm: UISegmentedControl!
    @IBOutlet weak var Activity: UIActivityIndicatorView!
    @IBOutlet weak var hotSearView: UITableView!
    var FirebaseRestaurantArr:[Restaurant] = [];
    var urlchange = "http://140.136.150.95:3000/search/hot";
    var row:Int = 0
    
    ////////////////////////////////////////////////////////////  Detail Function   ////////////////////////////////////////////////////////////

    
//assign how many cell will show in view
//Writer : Niguai
//Last UpdUser:Niguai
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FirebaseRestaurantArr.count;
    }
    
    
//assign value into cell's item
//Writer : Niguai
//Last UpdUser:Niguai
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let restaurant = FirebaseRestaurantArr[indexPath.item];
        let cell = tableView.dequeueReusableCell(withIdentifier: "hotSearCell", for: indexPath) as! hotSearchCell;
        cell.resName.text = restaurant.Name;
        cell.resType.text = restaurant.ResType;
        cell.resID.text = restaurant.ResAddress;
        
        let url_restaurant = URL(string: restaurant.ResImage!)
        let data = try? Data(contentsOf: url_restaurant!)
        cell.resImg.image = UIImage(data: data!)
        
        
        Activity.stopAnimating()
        Activity.isHidden = true
        hotSearView.isHidden = false
        
        return cell;
    }
    
    

    //assign tableView's height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 190.0;
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Change the selected background view of the cell.
        tableView.deselectRow(at: indexPath, animated: true)
        row = indexPath.row
        self.performSegue(withIdentifier: "MainGoDetail", sender: self)
    }

//Main function
//Writer : Niguai
//Last UpdUser:Niguai
    override func viewDidLoad() {
        
        self.view.addSubview(Activity)
        Activity.startAnimating()
        let urlStr = urlchange.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        let url = URL(string:urlStr!)
        let task = URLSession.shared.dataTask(with: url!) { (data, response , error) in
            if let data = data, let dic = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [[String:Any]]{
                DispatchQueue.main.async {
                    for hotSear in dic {
                        
                        let SearObj = Restaurant(ResID: hotSear["ID"] as! Int,
                                                 Name: hotSear["Name"]! as! String,
                                                 ResType:hotSear["typeName"] as! String,
                                                 ResImage:hotSear["res_Pic"] as? String,
                                                 ResPhone:hotSear["res_Tel"] as! String,
                                                 ResAddress:hotSear["res_Address"] as? String,
                                                 ResCost:hotSear["res_Cost"] as! String,
                                                 ResInfo: hotSear["res_Summary"] as! String ,
                                                 Res_X:hotSear["res_LNG"] as! Double,
                                                 Res_Y:hotSear["res_LAT"] as! Double);
                        
                        self.FirebaseRestaurantArr.append(SearObj);
                        
                    }
                    
                    self.hotSearView.reloadData()
                }
            }
            
        }
        task.resume()
        
        hotSearView.dataSource = self
        hotSearView.delegate = self
    }
    
    
    /////根據segm上的挑選顯示熱門搜尋或是評價搜尋
    @IBAction func segmAction(_ sender: Any) {
        
        if segm.selectedSegmentIndex == 0 {
            urlchange = "http://140.136.150.95:3000/search/hot"
            Activity.isHidden = false
            hotSearView.isHidden = true
            FirebaseRestaurantArr.removeAll()
            viewDidLoad()
            hotSearView.reloadData()
            print("hot")
        }
        else if segm.selectedSegmentIndex == 1 {
            urlchange = "http://140.136.150.95:3000/search/star"
            Activity.isHidden = false
            hotSearView.isHidden = true
            FirebaseRestaurantArr.removeAll()
            viewDidLoad()
            hotSearView.reloadData()
            print("star")
        }
        
    }
    
    
//Sending Value to other Page
//Writer : Niguai
//Last UpdUser:Niguai
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MainGoDetail" {
            let destinationController = segue.destination as! restaurantDetail
            destinationController.restaurant = FirebaseRestaurantArr[self.row]
        }
    }
    
}


/*
 Class : Class For Init collectionViewCell
 Writer: Nigaui
 Func  : Init basic Item connect to MainStoryBoard && It's for mainMenu.swift's hotSearchCell
 Return: type of Cell
 */
class hotSearchCell:UITableViewCell{
    
    @IBOutlet weak var resImg: UIImageView!
    @IBOutlet weak var resName: UILabel!
    @IBOutlet weak var resType: UILabel!
    @IBOutlet weak var resID: UILabel!
    @IBOutlet weak var resEvlateImg: UIImageView!
}



