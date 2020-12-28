//
//  CustomButton.swift
//  Quo
//
//  Created by Kevin Hall on 11/29/16.
//  Copyright © 2016 Kevin Hall. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        layer.shadowColor = UIColor(red: 0.3, green: 0.5, blue: 0.6, alpha: 0.6).cgColor
//        layer.shadowOpacity = 0.8
//        layer.shadowRadius = 5.0
//        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
        layer.backgroundColor = UIColor.clear.cgColor
        layer.borderWidth = 0
        layer.borderColor = UIColor.black.cgColor
        
        imageView?.contentMode = .scaleAspectFit
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //layer.cornerRadius = self.frame.width / 2
    }

}
