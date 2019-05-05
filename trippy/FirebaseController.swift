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
    override init() {
        // To use Firebase in our application we first must run the FirebaseApp configure method FirebaseApp.configure()
        // We call auth and firestore to get access to these frameworks
        authController = Auth.auth()
        database = Firestore.firestore()
        
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
    func addListener(listener: DatabaseListener) { listeners.addDelegate(listener)
//        if listener.listenerType == ListenerType.team || listener.listenerType == ListenerType.all { listener.onTeamChange(change: .update, teamHeroes: defaultTeam.heroes)
//        }
 }
    func removeListener(listener: DatabaseListener) { listeners.removeDelegate(listener)
    } }

