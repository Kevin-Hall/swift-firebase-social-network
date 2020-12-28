//
//  collectionHeader.swift
//  Quo
//
//  Created by Kevin Hall on 10/3/17.
//  Copyright © 2017 KAACK. All rights reserved.
//

import UIKit

class CollectionHeaderView: UICollectionReusableView {
    
    var textLabel: UILabel
    
    
    let screenWidth = UIScreen.main.bounds.width
    
    override init(frame: CGRect) {
        
        textLabel = UILabel()
        
        super.init(frame: frame)
        
        
        
        

        self.addSubview(textLabel)
        
        self.backgroundColor = COLOR_BG
        
        textLabel.font = UIFont(name: "Futura-Medium", size: 12)
        textLabel.textColor = COLOR_TEXT_HALF_ALPHA
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 1
        textLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: textLabel, attribute: .leading, relatedBy: .equal,
                               toItem: self, attribute: .leadingMargin,
                               multiplier: 1.0, constant: 0.0),
            
            NSLayoutConstraint(item: textLabel, attribute: .centerY, relatedBy: .equal,
                               toItem: self, attribute: .centerYWithinMargins,
                               multiplier: 1.0, constant: 0.0),
            
            NSLayoutConstraint(item: textLabel, attribute: .trailing, relatedBy: .equal,
                               toItem: self, attribute: .trailingMargin,
                               multiplier: 1.0, constant: 0.0),
            ])
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



