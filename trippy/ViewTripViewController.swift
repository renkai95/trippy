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
import SwiftyJson
class ViewTripViewController: UIViewController,DatabaseListener {
    func onTripListChange(change: DatabaseChange, trips: [Trip]) {
        var x = 3
    }
    weak var originPlace : GMSPlace?
    weak var destinationPlace: GMSPlace?
    //weak var camera : GMSCameraPosition?
    //weak var mapView : GMSMapView?
    
    var mapView: GMSMapView!
    //var listenerType: ListenerType
    
    var listenerType=ListenerType.messages
    weak var databaseController: DatabaseProtocol?
    
    var passedValue:Trip!
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.getPlaceByID(originPl1aceID: passedValue.originid, destinationPlaceID: passedValue.destid)
        //let camera = GMSCameraPosition.camera(withLatitude: passedValue.originLat, longitude: passedValue.originLong, zoom: 10.0)
        //let tempmapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        //self.mapView.clear()
        self.mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 20, width: 430, height: 500), camera: GMSCameraPosition.camera(withLatitude: passedValue.originLat, longitude: passedValue.originLong, zoom: 14.0))
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
        
        
        //setUpMap()
        //view=tempmapView

        // Do any additional setup after loading the view.
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
        



