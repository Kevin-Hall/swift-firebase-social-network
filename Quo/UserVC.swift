//
//  UserVC.swift
//  Quo
//
//  Created by Kevin Hall on 12/7/16.
//  Copyright © 2016 Kevin Hall. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import SwiftKeychainWrapper
import PageMenu

class UserVC: UIViewController, CAPSPageMenuDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = COLOR_BG
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController?.isNavigationBarHidden = true

        
        // initialize the tabbed pages
        setupPages()
        
        
        let button = UIButton.init(type: .custom)
        //button.setImage(UIImage.init(named: "Group 2"), for: UIControlState.normal)
        button.setAttributedTitle(NSAttributedString.init(string: "sign out", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.3) , NSAttributedStringKey.font: UIFont(name: "Futura-Medium", size: 10)! ]), for: .normal)
        button.addTarget(self, action:#selector(signOutTapped), for: UIControlEvents.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        
        let button2 = UIButton.init(type: .custom)
        //button.setImage(UIImage.init(named: "Group 2"), for: UIControlState.normal)
        button2.setAttributedTitle(NSAttributedString.init(string: "settings", attributes: [ NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.3) , NSAttributedStringKey.font: UIFont(name: "Futura-Medium", size: 10)! ]), for: .normal)
        //button.addTarget(self, action:#selector(signOutTapped), for: UIControlEvents.touchUpInside)
        button2.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30) //CGRectMake(0, 0, 30, 30)
        let barButton2 = UIBarButtonItem.init(customView: button2)
        self.navigationItem.leftBarButtonItem = barButton2

    }
    
    @IBAction func signOutTapped(_ sender: AnyObject) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        //let keychainResult = KeychainWrapper.removeAllKeys()
        //let keychainResult = KeychainWrapper.defaultKeychainWrapper.remove(key: KEY_UID)
        print("KEV: ID removed from keychain \(keychainResult)")
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue?, sender: Any?) {
        if let destinationVC: UIViewController = segue?.destination {
            destinationVC.hidesBottomBarWhenPushed = true
            destinationVC.navigationController?.isToolbarHidden = true
        }
    }
    
    var pageMenu : CAPSPageMenu?
    
    func setupPages() {
        // Array to keep track of controllers in page menu
        var controllerArray : [UIViewController] = []
        
        let controller = ProfileVC()
        controller.title = "Kevin"
        controllerArray.append(controller)
        
        let controller2 = ActivityController()
        controller2.title = "People"
        controllerArray.append(controller2)
        
//        let controller3 = CoreVC()
//        controller3.title = "Followers"
//        controllerArray.append(controller3)
        
        let controller4 = ActivityController()
        controller4.title = "Find"
        controllerArray.append(controller4)
        
        // Customize page menu here or use default settings by sending nil for 'options' in the init
        let parameters: [CAPSPageMenuOption] = [
            .menuItemSeparatorWidth(4.3),
            .menuItemSeparatorPercentageHeight(0.1),
            .selectedMenuItemLabelColor(COLOR_LIGHTGRAY),
            .viewBackgroundColor(COLOR_BG),
            .scrollMenuBackgroundColor(UIColor.black),
            .menuItemSeparatorColor(UIColor.clear),
            .menuItemWidthBasedOnTitleTextWidth(false),
            .centerMenuItems (false),
            .useMenuLikeSegmentedControl (false),
            .menuHeight (40),
            .bottomMenuHairlineColor (COLOR_BG),
            .selectionIndicatorColor (COLOR_LIGHTGRAY),
            .selectionIndicatorHeight (0.5),
            .menuItemFont(UIFont(name: "Futura-Medium", size: 12)!)
        ]
        

        // Initialize page menu with controller array, frame, and optional parameters
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 0.0,width:  self.view.frame.width,height:  self.view.frame.height), pageMenuOptions: parameters)
        
        
        self.view.addSubview(pageMenu!.view)
        pageMenu!.delegate = self
    }
}
