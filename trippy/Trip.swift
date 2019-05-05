//
//  Trip.swift
//  trippy
//
//  Created by rk on 5/5/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit

class Trip: NSObject {
    var title: String
    var origin: String
    var destination: String
    var uid: String
    init (uid: String,title:String,origin:String,destination:String){
        self.title = title
        self.origin = origin
        self.destination = destination
        self.uid=uid
    }
}