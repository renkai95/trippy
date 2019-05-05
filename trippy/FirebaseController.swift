//
//  trippy.swift
//  trippy
//
//  Created by rk on 4/5/19.
//  Copyright © 2019 Monash University. All rights reserved.
//


import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class FirebaseController: NSObject,DatabaseProtocol{
    var listeners = MulticastDelegate<DatabaseListener>()
    var authController: Auth
    var database: Firestore
    var tripsRef: CollectionReference?
    var tripRef: CollectionReference?
    var tripList: [Trip]
    override init() {
        // To use Firebase in our application we first must run the FirebaseApp configure method FirebaseApp.configure()
        // We call auth and firestore to get access to these frameworks
        authController = Auth.auth()
        database = Firestore.firestore()
         self.tripList = [Trip]()
        super.init()
        self.setUpListeners()
       
        // This will START THE PROCESS of signing in with an anonymous account
        // The closure will not execute until its recieved a message back which can be any time later

        // Once we have authenticated we can attach our listeners to the firebase firestore
        //self.setUpListeners()
        
    }
    
    func addTrip(tripToAdd:Trip){
        let trip = tripToAdd
        var docRef: DocumentReference? = nil
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyyHHmmss"
        let datecode = formatter.string(from: date)
//        docRef = database.collection("yeet").addDocument(data:[
//            "the":1]){ err in
//                if let err = err {
//                    print("Error adding document: \(err)")
//                } else {
//                    print("Document added with ID: \(docRef!.documentID)")
//                }}
//        
        docRef = database.collection("Trips").addDocument(data:[
            "userid":trip.uid,
            "docid":datecode,
            "title":trip.title,
            "origin":trip.origin,
            "destination":trip.destination
                ]){ err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(docRef!.documentID)")
                }
    }
    
            }
           
 
    func setUpListeners() {
        tripRef = database.collection("Trips");
        tripsRef?.addSnapshotListener { querySnapshot, error in
            guard (querySnapshot?.documents) != nil else {
                print("Error fetching documents: \(error!)")
                return
                
            }
}
}
    func parseTripsSnapshot(snapshot: QuerySnapshot) { snapshot.documentChanges.forEach { change in
        let documentRef = change.document.documentID
        let title = change.document.data()["title"] as! String
        let origin = change.document.data()["origin"] as! String
        let destination = change.document.data()["destination"] as! String
        let uid = change.document.data()["uid"] as! String
        //let abilities = change.document.data()["abilities"] as! String print(documentRef)
        if change.type == .added {
            print("New Task: \(change.document.data())")
            let newTrip = Trip(uid:uid,title:title,origin:origin,destination:destination)

            tripList.append(newTrip) }

 }
        listeners.invoke { (listener) in
            if listener.listenerType == ListenerType.trips || listener.listenerType == ListenerType.all {
                listener.onTripListChange(change: .update, trips: tripList) }
        } }
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        listener.onTripListChange(change: .update, trips: tripList)
    }
    func removeListener(listener: DatabaseListener) { listeners.removeDelegate(listener)
    } }


