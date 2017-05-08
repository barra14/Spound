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
import SwiftKeychainWrapper

class SignInVC: UIViewController { // Sign in ViewController

    @IBOutlet weak var emailField: login_textfield!
    @IBOutlet weak var passwordField: login_textfield!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
        // will check for string with key UID if it finds it then go straight to Feed VC if not nothing
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let _ = KeychainWrapper.stringForKey(KEY_UID){
            
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
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
                print ("Andres: User authenticated with Firebase") // Here and above is for authenticating
                //below this is to auto-sign in and save authentication
                
                if let user = user {
                self.completeSignIn(id: user.uid)
                }
            }
        })
    }

    
    @IBAction func signInTapped(_ sender: Any) {
        
        //authenticate user email with Firebase - read firebase set up to handle more login errors
        
        if let email = emailField.text, let password = passwordField.text{
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil{
                    print ("Andres: Email user authenticated with Firebase.")
                    self.completeSignIn(id: (user?.uid)!) // look over
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            print ("Andres: Unable to authenticate with Firebase using email \(error)")
                        } else {
                            print (" Andres: Successfully authenticated with Firebase")
                            // code below for auto-sign in
                            if let user = user {
                                self.completeSignIn(id: user.uid)
                            }
                        }
                    })
                }
            })
        }
    }
    
    func completeSignIn(id: String){
        let keychainResult = KeychainWrapper.setString(id, forKey: KEY_UID)
        print ("Andres: Data saved to Keychain \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
    
    
    
    
}
    
