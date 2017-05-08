//
//  ViewController.swift
//  Spound
//
//  Created by Andres Barrios on 5/7/17.
//  Copyright © 2017 Andres Barrios. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController { // Sign in ViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func facebookBtnTapped(_ sender: Any) {
        
        //two steps 1) authenticate with facebook 2) authenticate with Firebase
        
        let facebooklogin = FBSDKLoginManager()
        facebooklogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil{
                print(" Andres: Unable to authenticate with Facebook - \(error)")
            } else if result?.isCancelled == true{ //handles user canceling authen
                    print ("User canceled Facebook authetication")
            } else {
                print ("Andres: User authenticated with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                //done authenticating with Facebook
                
                self.firebaseAuth(credential)
                
            }
        }
    }
    
    //Firebase authentication
    
    func firebaseAuth(_ credential: FIRAuthCredential){
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in //line to authenticate with Firebase
            if error != nil {
                print ("Andres: Unable to authenticate with Firebase - \(error)")
            } else {
                
                print ("Andres: User authenticated with Firebase")
            }
        })
}
}
    
