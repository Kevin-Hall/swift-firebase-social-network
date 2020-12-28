//
//  TrendingVC.swift
//  Quo
//
//  Created by Kevin Hall on 12/7/16.
//  Copyright © 2016 Kevin Hall. All rights reserved.
//

import Foundation
import UIKit

class UploadVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = COLOR_BG
        self.navigationItem.title = "Upload"
        
        
        self.view.addSubview(postButton)
        self.view.addSubview(cancelButton)
        
        
        let path = UIBezierPath(roundedRect:self.view.bounds,byRoundingCorners:[.topLeft,.topRight],cornerRadii: CGSize(width: 10 , height:  10))
        let maskLayer = CAShapeLayer()
        maskLayer.fillColor = UIColor.black.cgColor
        
        maskLayer.path = path.cgPath
        self.view.layer.mask = maskLayer
        self.navigationController?.view.layer.mask = maskLayer

    }
    
    override func viewWillLayoutSubviews() {
        postButton.frame = CGRect(x: self.view.bounds.width/2 - 50, y: self.view.bounds.height - 150, width: 100, height: 20)
        cancelButton.frame = CGRect(x: self.view.bounds.width/2 - 200, y: self.view.bounds.height - 40, width: 400, height: 40)
    }
    
    @objc func cancelAction() {
        self.dismiss(animated: true) {
            
        }
    }
    
    
    func postAction() {
        self.dismiss(animated: true) {
            
        }
    }
    
    
    let postButton: UIButton = {
        let button = UIButton()
        button.setTitle("Post", for: .normal)
        button.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        button.setTitleColor(COLOR_BG, for: .normal)
        button.backgroundColor = COLOR_TEXT
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.layer.cornerRadius = 2
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        button.setTitleColor(COLOR_BG, for: .normal)
        button.backgroundColor = COLOR_TEXT
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 11)
        button.layer.cornerRadius = 2
        return button
    }()
}
