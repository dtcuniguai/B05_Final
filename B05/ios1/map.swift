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
    var Res_X: Double = 0.0
    var Res_Y: Double = 0.0
    var DetailUseMap = false
    var userGPS_x = 121.4316
   
    var userGPS_y = 25.0355
    
    
    override func viewDidLoad() {
        //super.viewDidLoad()

        self.locationManager.requestWhenInUseAuthorization()//要求現在存取使用者當前位置的權限
        self.locationManager.requestAlwaysAuthorization()//要求隨時存取使用者當前位置的權限
        
        //添加餐廳地標（大頭針）
        if restaurant != nil{
            DetailUseMap = true
            if let loc_X = restaurant?.Res_X, let loc_Y = restaurant?.Res_Y {
                Res_X = Double(loc_X)
                Res_Y = Double(loc_Y)
            }
            
            let restaurantAnnotation = MKPointAnnotation()
            restaurantAnnotation.title = restaurant?.Name
            restaurantAnnotation.subtitle = restaurant?.ResAddress
            restaurantAnnotation.coordinate = CLLocationCoordinate2D(latitude: Res_Y, longitude: Res_X)
            self.mapView.addAnnotation(restaurantAnnotation)
            
            let region =
                MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: Res_Y, longitude: Res_X), 500, 500)
            mapView.setRegion(region, animated: true)
            
            
            
        }
        else {
            
            
            //userGPS_y = (mapView.userLocation.location?.coordinate.latitude)!
            //userGPS_x = (mapView.userLocation.location?.coordinate.longitude)!
            
            if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
                var resPinArray = [pinMapAnnotation]()
                
                let circle = MKCircle(center:CLLocationCoordinate2DMake(userGPS_y, userGPS_x), radius: 2000)
                mapView.add(circle)
                
                let urlStr = "http://140.136.150.95:3000/map?X=\(userGPS_x)&Y=\(userGPS_y)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                let url = URL(string: urlStr!)
                let task = URLSession.shared.dataTask(with: url!) { data,response,error in
                if let data = data, let dic = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [[String:Any]]{
                            print("1")
                            for GPS in dic {
             
                                let res_Title = GPS["Name"] as! String
                                let res_adr = GPS["res_Address"] as! String
                                let res_x = GPS["res_LNG"] as! Double
                                let res_y = GPS["res_LAT"] as! Double
                                
                                print(res_x)
                                
                                resPinArray += [pinMapAnnotation(title: res_Title, subtitle: res_adr, coordinate: CLLocationCoordinate2DMake(res_y, res_x))]
                                
                            }
                    }
                    self.mapView.addAnnotations(resPinArray)
                }
             task.resume()
            
            
                
            
            }
        
            mapView.delegate = self
        }
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
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        //取得目前的座標位置
        let c = locations[0] as! CLLocation;
        userGPS_x = c.coordinate.latitude
        userGPS_x = c.coordinate.longitude
        //c.coordinate.latitude 目前緯度
        //c.coordinate.longitude 目前經度
        let nowLocation = CLLocationCoordinate2D(latitude: c.coordinate.latitude, longitude: c.coordinate.longitude);
        
        //將map中心點定在目前所在的位置
        
        //span是地圖zoom in, zoom out的級距
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(nowLocation, 1500, 1500), animated: true)
        
        
        
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay.isKind(of: MKCircle.self){
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.fillColor = UIColor.red.withAlphaComponent(0.1)
            circleRenderer.strokeColor = UIColor.red
            circleRenderer.lineWidth = 1
            return circleRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
}



