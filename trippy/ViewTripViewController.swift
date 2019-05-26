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
class ViewTripViewController: UIViewController,GMSMapViewDelegate,DatabaseListener {
    func onTripListChange(change: DatabaseChange, trips: [Trip]) {
        var x = 3
    }
    weak var originPlace : GMSPlace?
    weak var destinationPlace: GMSPlace?
    //weak var camera : GMSCameraPosition?
    //weak var mapView : GMSMapView?
    
    @IBOutlet weak var mapView: GMSMapView!
    //var listenerType: ListenerType
    
    var listenerType=ListenerType.messages
    weak var databaseController: DatabaseProtocol?
    
    var passedValue:Trip!
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.getPlaceByID(originPl1aceID: passedValue.originid, destinationPlaceID: passedValue.destid)
        let camera = GMSCameraPosition.camera(withLatitude: passedValue.originLat, longitude: passedValue.originLong, zoom: 10.0)
        let tempmapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.mapView.clear()
        self.view.addSubview(tempmapView)
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
        



