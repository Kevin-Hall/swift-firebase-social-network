//
//  DashboardVC.swift
//  Quo
//
//  Created by Kevin Hall on 12/6/16.
//  Copyright © 2016 KAACK. All rights reserved.
//

import UIKit
import PageMenu

class DashBoardVC: UIViewController {

    var pageMenu : CAPSPageMenu?
    var controllerArray : [UIViewController] = []
    
    let controller = FriendsFeedVC()
    let controller2 = FriendsFeedVC()
    let controller3 = FriendsFeedVC()
    let controller4 = FriendsFeedVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barStyle = .black
        //self.navigationController?.hidesBarsOnSwipe = true

        
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "Group 2"), for: UIControlState.normal)
        button.addTarget(self, action:#selector(self.upload), for: UIControlEvents.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        
        let gridButton = UIButton.init(type: .custom)
        gridButton.setImage(UIImage.init(named: "grid"), for: UIControlState.normal)
        gridButton.addTarget(self, action:#selector(self.changeGrid), for: UIControlEvents.touchUpInside)
        gridButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30) //CGRectMake(0, 0, 30, 30)
        let barButton2 = UIBarButtonItem.init(customView: gridButton)
        self.navigationItem.leftBarButtonItem = barButton2
        
        
        setupPages()
        
        
    }
    
    @objc func upload() {
        let vc = UploadVC()
        self.present(vc, animated: true) {
        }
    }
    
    @objc func changeGrid() {
        
        if !controller.isViewLoaded{
            controller.loadViewIfNeeded()
        }
        if !controller2.isViewLoaded{
            controller2.loadViewIfNeeded()
        }
        if !controller3.isViewLoaded{
            controller3.loadViewIfNeeded()
        }
        if !controller4.isViewLoaded{
            controller4.loadViewIfNeeded()
        }
        
            //controller.changegrid()
            //controller2.changegrid()
            //controller3.changegrid()
            //controller4.changegrid()
    }
    
    func setupPages() {
        // Array to keep track of controllers in page menu

        
        
        controller.title = "Today"
        controllerArray.append(controller)
        
        
        controller2.title = "oct 2"
        controllerArray.append(controller2)
        
        
        controller3.title = "oct 1"
        controllerArray.append(controller3)
        
        
        controller4.title = "sep 30"
        controllerArray.append(controller4)
        
        // Customize page menu here or use default settings by sending nil for 'options' in the init
        let parameters: [CAPSPageMenuOption] = [
            .menuItemSeparatorWidth(1.3),
            .useMenuLikeSegmentedControl(true),
            .menuItemSeparatorPercentageHeight(0.1),
            .selectedMenuItemLabelColor(COLOR_TEXT),
            .viewBackgroundColor(COLOR_BG),
            .scrollMenuBackgroundColor(COLOR_BG),
            .menuItemSeparatorColor(UIColor.clear),
            .menuItemWidthBasedOnTitleTextWidth(false),
            .centerMenuItems (true),
            .useMenuLikeSegmentedControl (true),
            .menuHeight (20),
            .menuMargin(10),
            //.hideTopMenuBar(true),
            .bottomMenuHairlineColor (COLOR_BG),
            .selectionIndicatorColor (COLOR_TEXT_HALF_ALPHA),
            .selectionIndicatorHeight (1),
            .menuItemFont(UIFont.systemFont(ofSize: 10))
            //.menuItemFont(UIFont(name: "Futura-Medium", size: 11)!)
        ]
        
        // Initialize page menu with controller array, frame, and optional parameters
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 0.0,width:  self.view.frame.width,height: self.view.frame.height), pageMenuOptions: parameters)
        
        self.view.addSubview(pageMenu!.view)
    }

    
    func hideTabBar() {
        var frame = self.tabBarController?.tabBar.frame
        frame = frame?.offsetBy(dx: 0, dy: (self.tabBarController?.tabBar.frame.height)!)
        UIView.animate(withDuration: 0.4, animations: {
            self.tabBarController?.tabBar.frame = frame!
        })
    }
    
    func showTabBar()  {
        var frame = self.tabBarController?.tabBar.frame
        frame = frame?.offsetBy(dx: 0, dy: -(self.tabBarController?.tabBar.frame.height)!)
        UIView.animate(withDuration: 0.4, animations: {
            self.tabBarController?.tabBar.frame = frame!
        })
    }
}
