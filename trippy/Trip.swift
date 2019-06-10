//
//  Trip.swift
//  trippy
//
//  Created by rk on 5/5/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import GooglePlaces
class Trip: NSObject {
    var title: String
    var origin: String
    var destination: String
    var uid: String
    var originid: String
    var destid: String
    var originLong: Double
    var originLat:Double
    var destLong:Double
    var destLat: Double
    var email: String
    var docid: String?
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
