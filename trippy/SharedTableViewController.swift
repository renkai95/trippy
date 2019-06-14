//
//  TripListTableViewController.swift
//  trippy
//
//  Created by rk on 2/5/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import FirebaseAuth
class SharedTableViewController: UITableViewController,UISearchResultsUpdating,DatabaseListener {


    
    
    var listenerType=ListenerType.users
    var authController: Auth!
    var value:Trip!
    let SECTION_TRIP=0;
    let SECTION_COUNT=1;
    let CELL_TRIP="sharedTripCell"
    let CELL_COUNT="sharedTripCountCell"
    var allTrips: [Trip]=[]
    var filteredTrips: [Trip]=[]
    
    //var listenerType=ListenerType.tasks
    //weak var addTaskDelegate:AddTaskDelegate?
    weak var databaseController: DatabaseProtocol?
    override func viewDidLoad() {
        authController = Auth.auth()
        super.viewDidLoad()
        filteredTrips=allTrips
        print(allTrips)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController=appDelegate.databaseController
        let searchController = UISearchController(searchResultsController: nil);
        searchController.searchResultsUpdater=self
        searchController.obscuresBackgroundDuringPresentation=false
        searchController.searchBar.placeholder="Search Trips"
        navigationItem.searchController=searchController
        //definesPresentationContext=true
    }
    
    // MARK: - Table view data source
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText=searchController.searchBar.text?.lowercased(),searchText.count>0{
            filteredTrips=allTrips.filter({(trip:Trip)->Bool in
                return (trip.title.lowercased().contains(searchText))
            })
        }
        else{
            filteredTrips=allTrips
        }
        tableView.reloadData();
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    func onUserListChange(change: DatabaseChange, trips: [Trip]) {
        updateSearchResults(for: navigationItem.searchController!)
        allTrips=trips
        filteredTrips = allTrips
        
    }
    func onTripListChange(change:DatabaseChange,trips:[Trip]){
//        allTrips=trips.filter({(trip:Trip)->Bool in
//            return (trip.uid==Auth.auth().currentUser!.uid)
//        })
//        updateSearchResults(for: navigationItem.searchController!)
        var x = 3
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section==SECTION_TRIP{
            return filteredTrips.count
        }
        else{
            return 1
        }
        // #warning Incomplete implementation, return the number of rows
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let tripCell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        if indexPath.section==SECTION_TRIP{
            let tripCell=tableView.dequeueReusableCell(withIdentifier: CELL_TRIP, for: indexPath) as! SharedTableViewCell
            let trip=filteredTrips[indexPath.row]
            tripCell.sharedTitleOutlet.text=trip.title
            tripCell.sharedOriginOutlet.text=trip.origin
            tripCell.sharedDestinationOutlet.text = trip.destination
            tripCell.sharedUserOutlet.text = trip.email
            
            //titleCell.dueOutlet.text=date2String(task.duedate!)
            
            return tripCell
            
        }
            // Configure the cell...
        else if indexPath.section==SECTION_COUNT{
            let countCell=tableView.dequeueReusableCell(withIdentifier: CELL_COUNT, for: indexPath)
            countCell.textLabel?.text="\(allTrips.count) tasks in the database"
            countCell.selectionStyle = .none
            return countCell
        }
        return tableView.dequeueReusableCell(withIdentifier: CELL_COUNT, for: indexPath)
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section==SECTION_COUNT{
            tableView.deselectRow(at: indexPath, animated: false)
            return
        }
        // Return false if you do not want the specified item to be editable.
        
        let trips=filteredTrips[indexPath.row]
        print(trips.title)
        value=trips
        performSegue(withIdentifier: "viewTripSegue", sender: self)
        return
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
        
    }
    
    func onTripList(change:DatabaseChange,trips:[Trip]){
        allTrips=trips
        updateSearchResults(for: navigationItem.searchController!)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }

    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if (segue.identifier == "viewTripSegue") {
            // initialize new view controller and cast it as your view controller
            let viewController = segue.destination as! ViewUserTripViewController
            // your new view controller should have property that will store passed value
            print(value.title)
            viewController.passedValue = value
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    func addTrip(newTrip: Trip) -> Bool {
        allTrips.append(newTrip)
        filteredTrips.append(newTrip)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row:filteredTrips.count-1,section:0)], with: .automatic)
        tableView.endUpdates()
        tableView.reloadSections([SECTION_COUNT], with: .automatic)
        return true
    }
    
    
    func displayMessage(title:String,message:String){
        let alertController=UIAlertController(title:title,message:message,preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title:"Dismiss",style:UIAlertAction.Style.default,handler:nil))
        self.present(alertController,animated:true,completion: nil)
    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
