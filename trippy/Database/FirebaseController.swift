//
//  FirebaseController.swift
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
    override init() {
        // To use Firebase in our application we first must run the FirebaseApp configure method FirebaseApp.configure()
        // We call auth and firestore to get access to these frameworks
        authController = Auth.auth()
        database = Firestore.firestore()
        heroList = [SuperHero]()
        defaultTeam = Team()
        super.init()
        // This will START THE PROCESS of signing in with an anonymous account
        // The closure will not execute until its recieved a message back which can be any time later authController.signInAnonymously() { (authResult, error) in
        guard authResult != nil else { fatalError("Firebase authentication failed")
        }
        // Once we have authenticated we can attach our listeners to the firebase firestore
        self.setUpListeners()
        
    } }
func setUpListeners() {
    heroesRef = database.collection("superheroes") heroesRef?.addSnapshotListener { querySnapshot, error in
        guard (querySnapshot?.documents) != nil else { print("Error fetching documents: \(error!)") return
        }
        self.parseHeroesSnapshot(snapshot: querySnapshot!) }
    teamsRef = database.collection("teams")
    teamsRef?.whereField("name", isEqualTo: DEFAULT_TEAM_NAME).addSnapshotListener { querySnapshot, error in
        guard let documents = querySnapshot?.documents else { print("Error fetching teams: \(error!)")
            return
        }
        self.parseTeamSnapshot(snapshot: documents.first!) }
}
func parseHeroesSnapshot(snapshot: QuerySnapshot) { snapshot.documentChanges.forEach { change in
    let documentRef = change.document.documentID
    let name = change.document.data()["name"] as! String
    let abilities = change.document.data()["abilities"] as! String print(documentRef)
    if change.type == .added {
        print("New Hero: \(change.document.data())") let newHero = SuperHero()
        newHero.name = name
        newHero.abilities = abilities
        newHero.id = documentRef
        heroList.append(newHero) }
    if change.type == .modified {
        print("Updated Hero: \(change.document.data())")

        let index = getHeroIndexByID(reference: documentRef)! heroList[index].name = name
        heroList[index].abilities = abilities
        heroList[index].id = documentRef
    }
    if change.type == .removed {
        print("Removed Hero: \(change.document.data())")
        if let index = getHeroIndexByID(reference: documentRef) {
            heroList.remove(at: index) }
    } }
    listeners.invoke { (listener) in
        if listener.listenerType == ListenerType.heroes || listener.listenerType == ListenerType.all {
            listener.onHeroListChange(change: .update, heroes: heroList) }
    } }
func parseTeamSnapshot(snapshot: QueryDocumentSnapshot) { defaultTeam = Team()
    defaultTeam.name = (snapshot.data()["name"] as! String) defaultTeam.id = snapshot.documentID
    if let heroReferences = snapshot.data()["heroes"] as? [DocumentReference] { // If the document has a "heroes" field, add heroes.
        for reference in heroReferences {
            let hero = getHeroByID(reference: reference.documentID) guard hero != nil else {
                continue
            }
            defaultTeam.heroes.append(hero!) }
    }
    listeners.invoke { (listener) in
        if listener.listenerType == ListenerType.team || listener.listenerType == ListenerType.all {
            listener.onTeamChange(change: .update, teamHeroes: defaultTeam.heroes) }
}

}
func getHeroIndexByID(reference: String) -> Int? { for hero in heroList {
    if(hero.id == reference) {
        return heroList.firstIndex(of: hero)
    } }
    return nil
}
func getHeroByID(reference: String) -> SuperHero? { for hero in heroList {
    if(hero.id == reference) { return hero
    } }
    return nil
}
func addSuperHero(name: String, abilities: String) -> SuperHero {
    let hero = SuperHero()
    let id = heroesRef?.addDocument(data: ["name" : name, "abilities" : abilities]) hero.name = name
    hero.abilities = abilities
    hero.id = id!.documentID
    return hero }
func addTeam(teamName: String) -> Team {
    let team = Team()
    let id = teamsRef?.addDocument(data: ["name" : teamName, "heroes": []]) team.id = id!.documentID
    team.name = teamName
    return team }
func addHeroToTeam(hero: SuperHero, team: Team) -> Bool {
    guard let hero = getHeroByID(reference: hero.id), team.heroes.count < 6 else {
        return false

    }
    team.heroes.append(hero)
    let newHeroRef = heroesRef!.document(hero.id) teamsRef?.document(team.id).updateData(["heroes" : FieldValue.arrayUnion([newHeroRef])]) return true
}
func deleteSuperHero(hero: SuperHero) {
    heroesRef?.document(hero.id).delete()
}
func deleteTeam(team: Team) {
    teamsRef?.document(team.id).delete()
}
func removeHeroFromTeam(hero: SuperHero, team: Team) {
    let index = team.heroes.index(of: hero)
    let removedHero = team.heroes.remove(at: index!)
    let removedRef = heroesRef?.document(removedHero.id)
    teamsRef?.document(team.id).updateData(["heroes": FieldValue.arrayRemove([removedRef!])]) }
func addListener(listener: DatabaseListener) { listeners.addDelegate(listener)
    if listener.listenerType == ListenerType.team || listener.listenerType == ListenerType.all { listener.onTeamChange(change: .update, teamHeroes: defaultTeam.heroes)
    }
    if listener.listenerType == ListenerType.heroes || listener.listenerType == ListenerType.all { listener.onHeroListChange(change: .update, heroes: heroList)
    } }
func removeListener(listener: DatabaseListener) {
    listeners.removeDelegate(listener)
} }

