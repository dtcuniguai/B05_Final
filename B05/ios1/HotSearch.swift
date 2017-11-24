////
////  HotSearch.swift
////  ios1
////
////  Created by 李季耕 on 2017/9/6.
////  Copyright © 2017年 Niguai. All rights reserved.
////
//
//import Foundation
//import UIKit
//import Firebase
//
////Basic For Class
//class HotSearch:UICollectionViewController{
//
//    var FirebaseRestaurantArr:[Restaurant_Hot] = [];
//
//    var hotSearchRef:DatabaseReference!
//
//    var documentDictionary:String = {
//        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true);
//        let imageFileDictionary = paths[0];
//        return imageFileDictionary;
//        //return NSTemporaryDirectory();
//    }();
//
//    override func viewDidLoad() {
//        //Load Data From Firebase into Struct
//        hotSearchRef = Database.database().reference(withPath: "Hot_Search")
//        hotSearchRef.observe(.value) {  (dataSnapshot:DataSnapshot) in
//            for hotSearchSnap in dataSnapshot.children.allObjects{
//                let hotSearchSnap = hotSearchSnap as! DataSnapshot;
//                let hotSear = hotSearchSnap.value as![String:String]
//                let SearObj = Restaurant_Hot(Name: hotSear["Address"]!,ResType: hotSear["Cost"]!,ResImage: hotSear["Name"]!,ResEvlate:hotSear["Phone"]!,ResID:hotSear["Type"]!);
//                self.FirebaseRestaurantArr.append(SearObj);
//            }
//            self.collectionView?.reloadData();
//
//        }
//
//
//    }
//}
//
//
////Initial CollectionView
//extension HotSearch{
//
//
//    //Giving How Many Cell in View
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
//        return FirebaseRestaurantArr.count;
//        //return 6;
//    }
//
//    //Giving value in Cell
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
//        let restaurant = FirebaseRestaurantArr[indexPath.item];
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectCell", for: indexPath) as! HotSear_Cell;
//        //cell.Res_Name.text = restaurant.Name;
//        //cell.Res_Phone.text = restaurant.Phone;
//        //cell.Res_Type.text = restaurant.Rest_Type;
//        //let imagePath = "\(documentDictionary)/\(restaurant.Image)";
//        //if FileManager.default.fileExists(atPath: imagePath){
//            //cell.Res_Img.image = UIImage.init(contentsOfFile: imagePath);
//        //}else{
//            //cell.Res_Img.image = UIImage.init(named: "photoalbum");
//            //cell.activityIndicator.startAnimating();
//            //downloadFirebaseImage(imageName: restaurant.Image,indexPath: indexPath,cell:cell);
//        }
//        return cell;
//    }
//
//    //not use
//    func collectionView(collectionView: UICollectionView,
//                        didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        print("你選擇了第 \(indexPath.section + 1) 組的")
//        //print("第 \(indexPath.item + 1) 張圖片")
//    }
//
//    //
//    func downloadFirebaseImage(imageName name:String,indexPath:IndexPath,cell:HotSear_Cell){
//        let imageRef = Storage.storage().reference(withPath: "HotSearch/images/\(name)");
//        let imageLocalPath = "\(documentDictionary)/\(name)";
//        print("The Path is :\(imageLocalPath)")
//        let imageLocalPathUrl = URL.init(fileURLWithPath: imageLocalPath);
//        imageRef.write(toFile: imageLocalPathUrl) { (url, error) in
//            cell.activityIndicator.stopAnimating();
//            self.collectionView!.reloadItems(at: [indexPath]);
//        }
//    }
//
//
//}
//
//
///*
// Class : Class For Init collectionViewCell
// Writer: Nigaui
// Func  : Init basic Item connect to MainStoryBoard
// Return: none
// */
//class HotSear_Cell:UICollectionViewCell{
//    @IBOutlet weak var Res_Name: UILabel!
//    @IBOutlet weak var Res_Phone: UILabel!
//    @IBOutlet weak var Res_Type: UILabel!
//    @IBOutlet var Res_Img: UIImageView!
//    @IBOutlet weak var activityIndicator:UIActivityIndicatorView!;
//}
//
//
//
//
//
