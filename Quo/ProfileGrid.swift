//
//  ProfileGrid.swift
//  Quo
//
//  Created by Kevin Hall on 9/27/17.
//  Copyright © 2017 KAACK. All rights reserved.
//

import UIKit

class ProfileGrid: UICollectionViewFlowLayout {
    
    
    let innerSpace: CGFloat = 0
    var numberOfCellsOnRow: CGFloat = 6
    
    override init() {
        super.init()
        self.minimumLineSpacing = innerSpace
        self.minimumInteritemSpacing = innerSpace
        self.scrollDirection = .vertical
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    func itemWidth() -> CGFloat {
        return (collectionView!.frame.size.width/self.numberOfCellsOnRow)-self.innerSpace
    }
    
    override var itemSize: CGSize {
        set {
            self.itemSize = CGSize(width:itemWidth(), height:itemWidth())
        }
        get {
            return CGSize(width:itemWidth(),height:itemWidth())
        }
    }
    
}
