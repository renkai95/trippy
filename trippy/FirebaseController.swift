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
    var tripRef: DocumentReference?
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
        //self.setUpListeners()+0.................................................................................................................0..
        
    }
    
    func addTrip(userID:String,title:String){
        var docRef: DocumentReference? = nil
        docRef = database.collection("Trips").addDocument(data:[
            "userid":userID,
            "docid":[".sv": "timestamp"],
            "title":title]){ err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(docRef!.documentID)")
                }
    }
    
            }
           
 
    func setUpListeners() {
        tripRef = database.collection("Trips").document(Auth.auth().currentUser!.uid);
        tripsRef?.addSnapshotListener { querySnapshot, error in
            guard (querySnapshot?.documents) != nil else {
                print("Error fetching documents: \(error!)")
                return
                
            }
}
}
}
