//
//  Trip.swift
//  trippy
//
//  Created by rk on 5/5/19.
//  Copyright © 2019 Monash University. All rights reserved.
// This class contains the attributes that constitues a "Trip" it requires google places 

import UIKit
import GooglePlaces
class Trip: NSObject {
    var title: String //name of trip
    var origin: String // origin address
    var destination: String //destination address
    var uid: String  // userid of creator
    var originid: String  //origin placeid
    var destid: String  // destination placeid
    var originLong: Double //origin longitude
    var originLat:Double  //origin latitude
    var destLong:Double  //destination longitude
    var destLat: Double  //destination latitude
    var email: String  //email of user
    var docid: String?  // document id ,optional
    init (uid: String,title:String,origin:String,destination:String,originid:String,destid:String,originLong:Double,originLat:Double,destLong:Double,destLat:Double,email:String){
        self.title = title
        self.origin = origin
        self.destination = destination
        self.uid=uid
        self.originid = originid
        self.destid = destid
        self.originLat = originLat
        self.originLong = originLong
        self.destLat = destLat
        self.destLong = destLong
        self.email=email
    }
    init (uid: String,title:String,origin:String,destination:String,originid:String,destid:String,originLong:Double,originLat:Double,destLong:Double,destLat:Double,email:String,docid:String){
        self.title = title
        self.origin = origin
        self.destination = destination
        self.uid=uid
        self.originid = originid
        self.destid = destid
        self.originLat = originLat
        self.originLong = originLong
        self.destLat = destLat
        self.destLong = destLong
        self.email=email
        self.docid = docid
    }
}
