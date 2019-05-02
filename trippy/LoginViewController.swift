//
//  LoginViewController.swift
//  trippy
//
//  Created by rk on 2/5/19.
//  Copyright © 2019 Monash University. All rights reserved.
// Implements login page

import UIKit
import GoogleSignIn
import Firebase
import Google

class LoginViewController: UIViewController,GIDSignInUIDelegate {


    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func didTapSignOut(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
    }
}
