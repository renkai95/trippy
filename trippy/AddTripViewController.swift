//
//  AddTripViewController.swift
//  trippy
//
//  Created by rk on 4/5/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit

class AddTripViewController: UIViewController {
    weak var databaseController:DatabaseProtocol?
    @IBOutlet weak var titleOutlet: UITextField!
    @IBOutlet weak var originOutlet: UITextField!
    @IBOutlet weak var destinationOutlet: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate=UIApplication.shared.delegate as! AppDelegate
        databaseController=appDelegate.databaseController
        // Do any additional setup after loading the view.
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
