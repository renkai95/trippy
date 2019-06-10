//
//  ViewUserTripViewController.swift
//  trippy
//
//  Created by rk on 10/6/19.
//  Copyright © 2019 Monash University. All rights reserved.
//


import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON
import MessageKit
class ViewUserTripViewController: UIViewController,DatabaseListener, GMSMapViewDelegate ,  CLLocationManagerDelegate {
    func onUserListChange(change: DatabaseChange, trips: [Trip]) {
        var x = 3
    }
    
    func onTripListChange(change: DatabaseChange, trips: [Trip]) {
        var x = 3
    }
    weak var originPlace : GMSPlace?
    weak var destinationPlace: GMSPlace?
    //weak var camera : GMSCameraPosition?
    //weak var mapView : GMSMapView?
    
    var mapView: GMSMapView!
    //var listenerType: ListenerType
    var location = CLLocationManager()
    var listenerType=ListenerType.messages
    weak var databaseController: DatabaseProtocol?
    
    var passedValue:Trip!
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.getPlaceByID(originPl1aceID: passedValue.originid, destinationPlaceID: passedValue.destid)
        //let camera = GMSCameraPosition.camera(withLatitude: passedValue.originLat, longitude: passedValue.originLong, zoom: 10.0)
        //let tempmapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        //self.mapView.clear()
        self.mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 20, width: 430, height: 700), camera: GMSCameraPosition.camera(withLatitude: passedValue.originLat, longitude: passedValue.originLong, zoom: 14.0))
        self.view.addSubview(mapView!)
        let path = GMSMutablePath()
        let originMarker = GMSMarker()
        originMarker.position =  CLLocationCoordinate2D(latitude:passedValue.originLat, longitude:passedValue.originLong)
        path.add(originMarker.position)
        originMarker.title = "Start"
        originMarker.snippet = passedValue.title
        originMarker.map = mapView
        let destMarker = GMSMarker()
        destMarker.position =  CLLocationCoordinate2D(latitude:passedValue.destLat, longitude:passedValue.destLong)
        path.add(destMarker.position)
        destMarker.title = "End"
        destMarker.snippet = passedValue.destination
        destMarker.map = mapView
        let mapBounds = GMSCoordinateBounds(path: path)
        let cameraUpdate = GMSCameraUpdate.fit(mapBounds)
        mapView.moveCamera(cameraUpdate)
        
        drawLine()
        let textView = UITextView(frame: CGRect(x: 0, y: 600, width: 430, height: 500.0))
        self.automaticallyAdjustsScrollViewInsets = false
        
        //textView.center = self.view.center
        textView.textAlignment = NSTextAlignment.justified
        textView.textColor = UIColor.blue
        textView.backgroundColor = UIColor.gray
        self.view.addSubview(textView)
        //setUpMap()
        //view=tempmapView
        location.delegate = self
        location.requestWhenInUseAuthorization()
        location.desiredAccuracy = kCLLocationAccuracyBest
        location.startUpdatingLocation()
        // Do any additional setup after loading the view.
    }
    
    func drawLine(){
        // function adapted from  Agus Cahyono https://github.com/balitax/Google-Maps-Direction/blob/master/Maps%20Direction/ViewController.swift
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(passedValue.originLat),\(passedValue.originLong)&destination=\(passedValue.destLat),\(passedValue.destLong)&mode=driving&key=AIzaSyDsGHdQSobzHdI1o7JaVkkjdf2c-wnFL18"
        Alamofire.request(url).responseJSON { response in
            
            do{
                let json = try! JSON(data:response.data!)
                let routes = json["routes"].arrayValue
                
                for route in routes{
                    let routePolyline = route["overview_polyline"].dictionary
                    let markers = routePolyline?["points"]?.stringValue
                    let path = GMSPath.init(fromEncodedPath:markers!)
                    let polyline = GMSPolyline.init(path:path)
                    polyline.strokeWidth = 4
                    polyline.strokeColor = UIColor.blue
                    polyline.map = self.mapView
                }
            }
            catch let error as NSError {
                print("cannot get json")
            }
            
            
        }
    }
    func getLocation(manager: CLLocationManager,didUpdateLocations locations: [CLLocation]){
        let userLocation = CLLocationCoordinate2D(latitude: locations.last!.coordinate.latitude, longitude: locations.last!.coordinate.longitude)
        let marker = GMSMarker(position: userLocation)
        marker.map = self.mapView
        location.stopUpdatingLocation()
        
    }
    
    

    
    
}