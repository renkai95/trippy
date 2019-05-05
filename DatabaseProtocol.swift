//
//  DatabaseProtocol.swift
//  trippy
//
//  Created by rk on 4/5/19.
//  Copyright © 2019 Monash University. All rights reserved.
//


import Foundation
enum DatabaseChange{
    case add
    case remove
    case update
    
}
enum ListenerType{
    
    case trips
    case all
}
protocol DatabaseListener:AnyObject{
    var listenerType:ListenerType{get set}
    func onTripListChange(change:DatabaseChange,trips:[Trip])
}
protocol DatabaseProtocol: AnyObject{
//    func addTask(title:String,desc:String,status:String,duedate:NSDate)-> Tasks
//    func changeStatus(task:Tasks)
//    func deleteTask(task:Tasks)
    func addListener(listener:DatabaseListener)
    func removeListener(listener:DatabaseListener)
//    func editTask(task:Task)
    func addTrip(tripToAdd:Trip)
    
}
