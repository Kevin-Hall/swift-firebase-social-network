//
//  ViewController.swift
//  Quo
//
//  Created by Kevin Hall on 11/29/16.
//  Copyright © 2016 Kevin Hall. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper
import TextFieldEffects

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: YoshikoTextField!
    @IBOutlet weak var pwdField: YoshikoTextField!

    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.isToolbarHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        self.hideKeyboardWhenTappedAround()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey:KEY_UID){
            print("ID found in keychain")
            performSegue(withIdentifier: "goToFeed", sender: nil)

            //emailField.font =
            //emailField.placeholderLabel.font = UIFont.init(name: "Futura Muedium", size: 10)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func FacebookLoginAction(_ sender: AnyObject) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("KEV: Unable to authenticate with Facebook - \(String(describing: error))")
            } else if result?.isCancelled == true {
                print("KEV: User cancelled Facebook authentication")
            } else {
                print("KEV: Successfully authenticated with Facebook")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
        
    }
    
    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("KEV: Unable to authenticate with Firebase - \(String(describing: error))")
            } else {
                print("KEV: Successfully authenticated with Firebase")
            }
        })
    }
    
    @IBAction func signInTapped(_ sender: AnyObject) {
        if let email = emailField.text, let pwd = pwdField.text {
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("KEV: Email user authenticated with Firebase")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(user.uid, userData: userData)
                    }
                } else {
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("KEV: Unable to authenticate with Firebase using email")
                        } else {
                            print("KEV: Successfully authenticated with Firebase")
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                self.completeSignIn(user.uid, userData: userData)
                            }
                        }
                    })
                }
            })
        }
    }
    
    func completeSignIn(_ id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseUser(uid: id, userData: userData)
        //NetService.ds.createFirbaseDBUser(uid: id, userData: userData)
        //let keychainResult = KeychainWrapper.defaultKeychainWrapper().setString(id, forKey: KEY_UID)
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)

        //let kw = KeychainWrapper()
        //let keychainResult = KeychainWrapper.init(serviceName: id, accessGroup: KEY_UID)
        //let keychainResult = KeychainWrapper.defaultKeychainWrapper.set(id, forKey: KEY_UID)
        
        print("KEV: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToFeedAnim", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue?, sender: Any?) {
        if let destinationVC: UIViewController = segue?.destination {
            //destinationVC.hidesBottomBarWhenPushed = true
            destinationVC.navigationController?.isToolbarHidden = true
            destinationVC.navigationController?.isNavigationBarHidden = false
        }
    }

}

//to hide the keybpard when tapping anywhere
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}



