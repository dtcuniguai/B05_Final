import Foundation
import UIKit
import MapKit

/*
 餐廳用結構
 Coder:Niguai
 */
struct Restaurant{
    var ResID:Int//餐廳ID
    var Name:String//餐廳名稱
    var ResType:String//餐廳類別
    var ResImage:String?//餐廳照片名稱URL
    var ResPhone:String//餐廳電話照片URL
    var ResAddress:String?//餐廳地址
    var ResCost:String//餐廳平均消費
    var ResInfo:String//餐廳簡介
    var Res_X:Double//餐廳X軸
    var Res_Y:Double//餐廳Y軸
}


/*
評論用結構
Coder: Set
*/
struct resComment{
    var ID:Int//評論ID
    var create_UserID:Int//評論人ID
    var StoreID:Int//餐廳ID
    var Memo:String//評論
    var Score:Double//總分
    var Score_Envir:Double//環境評分
    var Score_Taste:Double//味道評分
    var Score_Service:Double//服務評分
}

/*
餐廳用結構
Coder:Niguai
*/
struct userComment{
    var ID:Int//評論ID
    var create_UserID:Int//評論人ID
    var StoreID:Int//餐廳ID
    var storeName: String //餐廳名稱
    var Memo:String//評論
    var Score:Double//總分
    var Score_Envir:Double//環境評分
    var Score_Taste:Double//味道評分
    var Score_Service:Double//服務評分
}


/*
會員基本資料用結構
Coder:Niguai
*/
struct AccountData {
    static var user_ID:Int = 0
    static var user_Account:String = ""
    static var user_Password:String = ""
    static var user_Type:String = ""
    static var user_Name:String = ""
    static var user_Gender:String = ""
    static var user_Career:String = ""
    static var user_Month:String = ""
    static var user_Day:String = ""
    static var user_Year:String = ""
    static var user_Tel:String = ""
    static var user_Pic:String = ""
    static var res_ID: Int = 0
}


// Struct For ?
// TODO:add what this struct for
// Code by Hsin
// last Update by : Hsin
class pinMapAnnotation: NSObject, MKAnnotation{
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    init(title:String,subtitle : String,coordinate : CLLocationCoordinate2D){
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        
    }
}


/*
菜單用結構
Coder:Niguai
*/
struct Menu {
    var menuID: Int
    var storeID: Int
    var name: String
    var price: Int
    var total: Int
    var takeOut: String
    var order_mor: String
    var order_after: String
    var order_even: String
    var visable: String

}


/*
FUNCTION ?
Coder:?
*/
struct Orderlist {
    var orderID: Int
    var menuID: Int
    var userID: Int
    var storeID: Int
    var total : Int
}


/*
 FUNCTION ?
 Coder:?
 */
struct OrderlistTable {
    var orderID: Int
    var total: Int
    var pay_Time: String
    var Name:String
}


/*
 FUNCTION ?
 Coder:?
 */
struct OrderlistView {
    var name: String
    var number: Int
    var price:Int
    var totalPrice:Int
}





