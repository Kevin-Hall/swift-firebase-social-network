//
//  RegisterVC.swift
//  Quo
//
//  Created by Kevin Hall on 9/20/17.
//  Copyright © 2017 KAACK. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SwiftKeychainWrapper


class RegisterVC: UIViewController {
    
    
    @IBOutlet var emailField : UITextField!
    @IBOutlet var usernameField : UITextField!
    @IBOutlet var passwordField : UITextField!
    
    @IBOutlet var createUserButton : UIButton!
    @IBAction func createAction(_ sender: AnyObject) {
        if let email = emailField.text, let pwd = passwordField.text, let username = usernameField.text {
            Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                if error != nil {
                    print("KEV: Unable to authenticate with Firebase using email")
                } else {
                    print("KEV: Successfully authenticated with Firebase")
                    if let user = user {
                        let userData = ["provider": user.providerID,"email": email,"username": username,"password": pwd,"uid" : user.uid]
                        self.completeSignIn(user.uid, userData: userData)
                    }
                }
            })
        }
    }

    
    func completeSignIn(_ id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseUser(uid: id, userData: userData)
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        
        //let kw = KeychainWrapper()
        //let keychainResult = KeychainWrapper.init(serviceName: id, accessGroup: KEY_UID)
        
        //let keychainResult = KeychainWrapper.defaultKeychainWrapper.set(id, forKey: KEY_UID)
        print("KEV: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToFeedAnim", sender: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}


