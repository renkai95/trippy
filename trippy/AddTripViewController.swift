//
//  AddTripViewController.swift
//  trippy
//
//  Created by rk on 4/5/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import GooglePlaces
import FirebaseFirestore

class AddTripViewController: UIViewController ,GIDSignInUIDelegate,CLLocationManagerDelegate{
    weak var databaseController:DatabaseProtocol?
    @IBOutlet weak var titleOutlet: UITextField!
    @IBOutlet weak var originOutlet: UITextField!
   
    @IBOutlet weak var destinationOutlet: UITextField!
    var originPlaceID: String!
    var finishedPlaceID: String!
    var placesClient: GMSPlacesClient!
    let locationManager = CLLocationManager()
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var originPlaceLong : Double?
    var originPlaceLat : Double?
    //var db = Firestore.firestore()
    var destinationPlaceLong : Double?
    var destinationPlaceLat : Double?
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate=UIApplication.shared.delegate as! AppDelegate
        databaseController=appDelegate.databaseController
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .notDetermined
        {
            locationManager.requestAlwaysAuthorization()
        }
        placesClient = GMSPlacesClient.shared()
        
        //       self.addToNavbar()
        //        self.addToSubview()
        self.addToPopover()

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //
    // Present the Autocomplete view controller when the textField is tapped.
    func addToNavbar(){
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self as! GMSAutocompleteResultsViewControllerDelegate
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
        
    }
    
    func addToSubview(){
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self as! GMSAutocompleteResultsViewControllerDelegate
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        let subView = UIView(frame: CGRect(x: 0, y: 65.0, width: 350.0, height: 45.0))
        
        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        //definesPresentationContext = true
    }
    
    func addToPopover(){
        //https://developers.google.com/places/ios-sdk/autocomplete adapted from
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self as! GMSAutocompleteResultsViewControllerDelegate
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        // Add the search bar to the right of the nav bar,
        // use a popover to display the results.
        // Set an explicit size as we don't want to use the entire nav bar.
        searchController?.searchBar.frame = (CGRect(x: 0, y: 0, width: 250.0, height: 44.0))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: (searchController?.searchBar)!)
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        // Keep the navigation bar visible.
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.modalPresentationStyle = .popover
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        print(status)
    }
    
//
    @IBAction func addTrip(_ sender: Any) {
        if titleOutlet.text != "" {
            let newTrip = Trip(uid:Auth.auth().currentUser!.uid,title:titleOutlet.text!,origin:originOutlet.text!,destination:destinationOutlet.text!,originid:originPlaceID,destid:finishedPlaceID,originLong:originPlaceLong!,originLat:originPlaceLat!,destLong:destinationPlaceLong!,destLat:destinationPlaceLat!,email:Auth.auth().currentUser!.email!)
            
          
            let _ = databaseController!.addTrip(tripToAdd:newTrip)
            displayMessage(title: "Trip Added!", message: "You can return or add another trip")
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func displayMessage(title: String, message: String) {
        // Setup an alert to show user details about the Person
        // UIAlertController manages an alert instance
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        titleOutlet.resignFirstResponder()
        originOutlet.resignFirstResponder()
        destinationOutlet.resignFirstResponder()
    }
    func textFieldShouldReturn(userText: UITextField!)-> Bool{
        userText.resignFirstResponder()
        return true
    }

}
extension AddTripViewController: GMSAutocompleteResultsViewControllerDelegate {
    //adapted from https://developers.google.com/places/ios-sdk/autocomplete
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        if originOutlet.text == ""{
            originOutlet.text=place.formattedAddress
            originPlaceID = place.placeID
            originPlaceLong = place.coordinate.longitude
            originPlaceLat = place.coordinate.latitude
        }
        else {
            if destinationOutlet.text == "" {
            destinationOutlet.text = place.formattedAddress
            finishedPlaceID = place.placeID
            destinationPlaceLong = place.coordinate.longitude
            destinationPlaceLat = place.coordinate.latitude
            }}
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(place.attributions)")
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
