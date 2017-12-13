//
//  restaurantDetail.swift
//  ios1
//
//  Created by Set on 2017/10/10.
//  Copyright © 2017年 Niguai. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class restaurantDetail: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var restaurantImage: UIImageView!//餐廳圖片
    @IBOutlet weak var restaurantDetailTable: UITableView!//餐廳資料的table
    var restaurant: Restaurant!
    
    var commentArray = [Comment]()
    
    override func viewDidLoad() {
        
        addClicker()
        super.viewDidLoad()
        
        if restaurant.ResImage != nil {
            let url_restaurant = URL(string: restaurant.ResImage!)
            let data = try? Data(contentsOf: url_restaurant!)
            restaurantImage.image = UIImage(data: data!)
        }
        
        title = restaurant.Name
        AccountData.res_ID = restaurant.ResID
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        commentArray.removeAll()
        restaurantDetailTable.reloadData()
        let urlStr = "http:140.136.150.95:3000/comment/show/store?storeID=\(restaurant.ResID)".addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)
        let url = URL(string:urlStr!)
        let task = URLSession.shared.dataTask(with: url!) { (data, response , error) in
            if let data = data, let dic = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [[String:Any]]{
                DispatchQueue.main.async {
                    for commentData in dic {
                        
                        let commentObj = Comment(ID: commentData["ID"] as! Int,
                                                    create_UserID: commentData["create_UserID"] as! Int,
                                                    StoreID: commentData["storeID"] as! Int,
                                                    storeName: " ",
                                                    userName: commentData["user_Name"] as! String,
                                                    Memo: commentData["Memo"] as! String,
                                                    Score: commentData["Score"] as! Double,
                                                    Score_Envir: commentData["Score_Envir"] as! Double,
                                                    Score_Taste: commentData["Score_Taste"] as! Double,
                                                    Score_Service: commentData["Score_Service"] as! Double,
                                                    store_Reply: ""
                        );
                        self.commentArray.append(commentObj);
                        
                    }
                    
                    self.restaurantDetailTable.reloadData()
                }
            }
            
        }
        task.resume()
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.item < 6{
            if indexPath.item == 5{
                return 90.0
            }
            return 40.0
            
        }
        return 90.0
    }
    
    
    //cell的數量
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 6 + commentArray.count
        
    }
    
    //顯示table的內容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.item < 6 {
            let cell = restaurantDetailTable.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! restaurantDetailCell
            
            switch indexPath.row{
            case 0:
                cell.fieldLabel.text = "店名"
                cell.valueLabel.text = restaurant.Name
            case 1:
                cell.fieldLabel.text = "類別"
                cell.valueLabel.text = restaurant.ResType
            case 2:
                cell.fieldLabel.text = "電話"
                cell.valueLabel.text = restaurant.ResPhone
            case 3:
                cell.fieldLabel.text = "地址"
                cell.valueLabel.text = restaurant.ResAddress
                cell.mapButton.isHidden = false
            case 4:
                cell.fieldLabel.text = "均消"
                cell.valueLabel.text = restaurant.ResCost
            case 5:
                cell.fieldLabel.text = "店家資訊"
                cell.valueLabel.text = restaurant.ResInfo
            default:
                cell.fieldLabel.text = ""
                cell.valueLabel.text = ""
            }
            return cell
        }
        
        let comment = commentArray[indexPath.item - 6]
        let cell = restaurantDetailTable.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! commentCell
        cell.commentID.text = "\(comment.userName)"
        cell.commentStar.rating = comment.Score
        
            
        
        
        return cell
        
        
    }
    

    //設定footer
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        footerView.backgroundColor = UIColor.white
        
        return footerView
    }
    
    //傳遞資料至Map和commentDetail
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "commentSegue" {
            if let indexPath = restaurantDetailTable.indexPathForSelectedRow {
                let destinationController = segue.destination as! commentDetail
                destinationController.commentData = commentArray[indexPath.row - 6]
            }
        }
        
        if segue.identifier == "gotoOrderDetail"{
            let destinationController = segue.destination as! userMenu
            destinationController.resID = restaurant.ResID
        }
        
    }
    
    
    
    
   
    @IBAction func gotoMap(_ sender: Any) {
        
        let latitude: CLLocationDegrees = restaurant.Res_Y
        print(restaurant.Res_X)
        let longitude: CLLocationDegrees = restaurant.Res_X
        print(restaurant.Res_Y)
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = restaurant?.Name
        mapItem.openInMaps(launchOptions: options)
        
    }
    
    func addClicker(){

        let addUrl = "http://140.136.150.95:3000/click/\(restaurant.ResID)"
        let urlStr = addUrl.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)
        let url = URL(string:urlStr!)
        let task = URLSession.shared.dataTask(with: url!) { (data, response , error) in
            if let data = data, let _ = String(data: data, encoding: .utf8) {
            }
        }
        task.resume()
        
        
    }
    
    
}



class restaurantDetailCell: UITableViewCell {
    
    @IBOutlet var mapButton: UIButton!//地圖按鈕
    @IBOutlet var fieldLabel: UILabel!//欄位名稱
    @IBOutlet var valueLabel: UILabel!//欄位內容
    @IBOutlet var detailImage: UIImageView!//圖片
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}


