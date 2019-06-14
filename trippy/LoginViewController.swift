//
//  LoginViewController.swift
//  trippy
//
//  Created by rk on 2/5/19.
//  Copyright © 2019 Monash University. All rights reserved.
// Implements login page

import UIKit
import GoogleSignIn
import FirebaseAuth
//import Firebase

class LoginViewController: UIViewController,GIDSignInUIDelegate {
    var handle: AuthStateDidChangeListenerHandle?
    @IBOutlet weak var signOut: UIButton!
    @IBOutlet weak var loginState: UILabel!
    var login:Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        //check if logged in
        handle = Auth.auth().addStateDidChangeListener({(auth,user) in
            if user != nil{
                self.loginState.text = "Logged in!"
            }
            else{
                self.loginState.text = "Please log in"
            }
        })
        // Do any additional setup after loading the view.
    }
    //shared Trips
    @IBAction func sharedTrips(_ sender: Any) {
        if (Auth.auth().currentUser?.uid != nil)  {
            self.performSegue(withIdentifier: "sharedTripSegue", sender: nil)
            
        }
            
        else{
            self.displayMessage(title: "ERROR", message: "Please Google Sign in first!")
        }
    }
    //login to view your own trips
    @IBAction func loginPrepare(_ sender: UIButton) {
        print("ohno")
        //print(Auth.auth().currentUser?.uid)
        

        if (Auth.auth().currentUser?.uid != nil)  {
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
            
        }
        
        else{
            self.displayMessage(title: "ERROR", message: "Please Google Sign in first!")
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
    //signout
    @IBAction func didTapSignOut(_ sender: AnyObject) {
        print("signedout")
        GIDSignIn.sharedInstance().signOut()
        do{
            try Auth.auth().signOut()

        }
        catch{
            print("cannot log out")
        }
        login = false
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//
//        let initialViewController = storyboard.instantiateViewController(withIdentifier: "loginNav")
//
//        self.present(initialViewController, animated: false)
    }
    func displayMessage(title:String,message:String){
        let alertController=UIAlertController(title:title,message:message,preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title:"Dismiss",style:UIAlertAction.Style.default,handler:nil))
        self.present(alertController,animated:true,completion: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
}
