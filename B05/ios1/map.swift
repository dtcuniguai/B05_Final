//
//  map.swift
//  ios1
//
//  Created by Set on 2017/10/9.
//  Copyright © 2017年 Niguai. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class map: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var isFirstGetLocation = false
    var restaurant: Restaurant?
    var DetailUseMap = false
    var userGPS_x = 0.0
    var userGPS_y = 0.0
    var range = 0
    
    var res = [Restaurant]()
    
    
    override func viewDidLoad() {
        //super.viewDidLoad()

        self.locationManager.requestWhenInUseAuthorization()//要求現在存取使用者當前位置的權限
        self.locationManager.requestAlwaysAuthorization()//要求隨時存取使用者當前位置的權限
        
        let GPS  = CLLocationManager()
        userGPS_y = (GPS.location?.coordinate.latitude)!
        print(userGPS_y)
        userGPS_x = (GPS.location?.coordinate.longitude)!
        print(userGPS_x)
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            var resPinArray = [pinMapAnnotation]()
            
            let circle = MKCircle(center:CLLocationCoordinate2DMake(userGPS_y, userGPS_x), radius: 1500)
            mapView.add(circle)
            
            let urlStr = "http://140.136.150.95:3000/map?X=\(userGPS_x)&Y=\(userGPS_y)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let url = URL(string: urlStr!)
            let task = URLSession.shared.dataTask(with: url!) { data,response,error in
                if let data = data, let dic = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [[String:Any]]{
                    for GPS in dic {
                        
                        let SearObj = Restaurant(ResID: GPS["ID"] as! Int,
                                                 Name: GPS["Name"]! as! String,
                                                 ResType:GPS["typeName"] as! String,
                                                 ResImage:GPS["res_Pic"] as? String,
                                                 ResPhone:GPS["res_Tel"] as! String,
                                                 ResAddress:GPS["res_Address"] as? String,
                                                 ResCost:GPS["res_Cost"] as! String,
                                                 ResInfo: GPS["res_Summary"] as! String ,
                                                 Res_X:GPS["res_LNG"] as! Double,
                                                 Res_Y:GPS["res_LAT"] as! Double);
                        
                        let res_Title = GPS["Name"] as! String
                        let res_adr = GPS["res_Address"] as! String
                        let res_x = GPS["res_LNG"] as! Double
                        let res_y = GPS["res_LAT"] as! Double
                       
                        
                        resPinArray += [pinMapAnnotation(title: res_Title, subtitle: res_adr, coordinate: CLLocationCoordinate2DMake(res_y, res_x))]
                        
                        self.res.append(SearObj)
                    }
                }
                self.mapView.addAnnotations(resPinArray)
            }
            task.resume()
        }
        
        mapView.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //locationManager.startUpdatingLocation()
    }
    
    //讓地圖自動縮放至使用者位置
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation)
    {
        
        if self.isFirstGetLocation == false && DetailUseMap == false{
            isFirstGetLocation = true
            let region = MKCoordinateRegion(center:userLocation.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
            mapView.region = region
        }
        
    }
    
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay.isKind(of: MKCircle.self){
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.fillColor = UIColor.blue.withAlphaComponent(0.1)
            circleRenderer.strokeColor = UIColor.black
            circleRenderer.lineWidth = 1
            return circleRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation)
        -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }
            
            let reuserId = "pin"
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuserId)
                as? MKPinAnnotationView
            if pinView == nil {
                //创建一个大头针视图
               pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuserId)
                pinView?.canShowCallout = true
                pinView?.animatesDrop = true
                //设置大头针颜色
                //pinView?.pinTintColor = UIColor.green
                //设置大头针点击注释视图的右侧按钮样式
                pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }else{
                pinView?.annotation = annotation
                
            }
            
            return pinView
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        
        for var  i in 0...res.count {
            if (view.annotation?.title)! == res[i].Name {
                range = i
                print(range)
                break
                
            }
        }
        self.performSegue(withIdentifier: "gotoRestaurantDetail", sender: nil)
        print("点击注释视图按钮")
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(range)
        if segue.identifier == "gotoRestaurantDetail" {
            
                let destinationController = segue.destination as! restaurantDetail
                destinationController.restaurant = res[range]
            
        }
    }
}



