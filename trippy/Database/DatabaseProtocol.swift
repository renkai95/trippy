//
//  DatabaseProtocol.swift
//  assignment2
//
//  Created by rk on 12/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import Foundation
enum DatabaseChange{
    case add
    case remove
    case update
    
}
enum ListenerType{
 
    case tasks
    case all
}
protocol DatabaseListener:AnyObject{
    var listenerType:ListenerType{get set}
    func onTaskListChange(change:DatabaseChange,tasks:[Tasks])
}
protocol DatabaseProtocol: AnyObject{
    func addTask(title:String,desc:String,status:String,duedate:NSDate)-> Tasks
    func changeStatus(task:Tasks)
    func deleteTask(task:Tasks)
    func addListener(listener:DatabaseListener)
    func removeListener(listener:DatabaseListener)
    func editTask(task:Task)
}
