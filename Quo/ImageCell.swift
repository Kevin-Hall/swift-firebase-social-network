//
//  ImageCell.swift
//  Quo
//
//  Created by Kevin Hall on 9/26/17.
//  Copyright © 2017 Kevin Hall. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    var nameLabel: UILabel!
    var postLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = false
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        
//        nameLabel = UILabel()
//        nameLabel.text = "Kevin Hall"
//        nameLabel.font = UIFont.init(name: "Futura-MediumItalic", size: 9)
//        nameLabel.textColor = UIColor.white
//        contentView.addSubview(nameLabel)

        

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var frame = imageView.frame
        frame.size.height = 330
        frame.size.width = 180
        frame.origin.x = 10
        frame.origin.y = 0
        imageView.frame = frame
        
        //postLabel.frame = CGRect(x: 60, y: 15, width: 300, height: 30)
        //nameLabel.frame = CGRect(x: 1, y: 15, width: 300, height: 15)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

