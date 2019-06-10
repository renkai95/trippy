//
//  ViewTripViewController.swift
//  trippy
//
//  Created by rk on 6/5/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON
import MessageKit
import FirebaseFirestore
class ViewTripViewController: UIViewController,DatabaseListener, GMSMapViewDelegate ,  CLLocationManagerDelegate,UITextViewDelegate {
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
    var db = Firestore.firestore()

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
//        db.collection("MessageRoom").document(passedValue.docid!+passedValue.email)
//            .addSnapshotListener { documentSnapshot, error in
//                guard let document = documentSnapshot else {
//                    print("Error fetching document: \(error!)")
//                    return
//                }
//                guard let data = document.data() else {
//                    print("Document data was empty.")
//                    return
//                }
//                print("Current data: \(data)")
//                textView.text = data["Message"] as! String
//        }
        let textView = UITextView(frame: CGRect(x: 0, y: 600, width: 430, height: 500.0))
        self.automaticallyAdjustsScrollViewInsets = false
        
        //textView.center = self.view.center
        textView.textAlignment = NSTextAlignment.justified
        textView.textColor = UIColor.blue
        textView.backgroundColor = UIColor.gray
        let docRef = db.collection("MessageRoom").document(passedValue.docid!+passedValue.email)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                //var x = document.data()
                textView.text = document.data()?["Message"]  as! String
                print("Document data: \(textView.text)")
            } else {
                print("Document does not exist")
            }
        }
        
        //textView.text = db.collection("MessageRoom").document(passedValue.docid!+passedValue.email)

        textView.delegate=self
        
        self.view.addSubview(textView)
        db.collection("MessageRoom").document(passedValue.docid!+passedValue.email)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                print("Current data: \(data)")
                textView.text = data["Message"] as! String
        }
        //setUpMap()
        //view=tempmapView
        location.delegate = self
        location.requestWhenInUseAuthorization()
        location.desiredAccuracy = kCLLocationAccuracyBest
        location.startUpdatingLocation()
        // Do any additional setup after loading the view.
    }
    func textViewDidChange(_ textView: UITextView) {
        //print(textView.text)
        let docRef = db.collection("MessageRoom").document(passedValue.docid!+passedValue.email).setData([
            "Message": textView.text,

        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if (segue.identifier == "addUserSegue") {
            // initialize new view controller and cast it as your view controller
            let viewController = segue.destination as! AddUserViewController
            // your new view controller should have property that will store passed value
            
            viewController.passedValue = passedValue
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

    
   
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
/*
    func getPlaceByID(originPlaceID: String,destinationPlaceID:String){
  
        GMSPlacesClient.shared().lookUpPlaceID(originPlaceID, callback: { (place, error) -> Void in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            if let place = place {
                print(" \(originPlaceID) found")
                self.originPlace = place
                self.setUpMap()
            } else {
                print("No place details for \(originPlaceID)")
            }
            
          
        })
        
        GMSPlacesClient.shared().lookUpPlaceID(destinationPlaceID, callback: { (place, error) -> Void in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            if let place = place {
                print(" \(destinationPlaceID) found")
                print(place.coordinate)
                self.destinationPlace = place
                //self.setUpMap()
                
            } else {
                print("No place details for \(destinationPlaceID)")
            }
            
            
        })
        
  */
        



