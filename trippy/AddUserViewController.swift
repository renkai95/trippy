//
//  AddUserViewController.swift
//  trippy
//
//  Created by rk on 9/6/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit

import Firebase
import GoogleSignIn
import GooglePlaces
class AddUserViewController: UIViewController {
    @IBOutlet weak var userOutlet: UITextField!
    weak var databaseController:DatabaseProtocol?
    var passedValue:Trip!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //load database listener
        let appDelegate=UIApplication.shared.delegate as! AppDelegate
        databaseController=appDelegate.databaseController
        // Do any additional setup after loading the view.
    }
    

    @IBAction func addUser(_ sender: Any) {
        if userOutlet.text != "" {
            let _ = databaseController!.addUser(email: userOutlet.text!, trip: passedValue)
        }
        else{
            displayMessage(title: "Error", message: "Need user")
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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

}
