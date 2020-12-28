//
//  CustomTabsVC.swift
//  Quo
//
//  Created by Kevin Hall on 12/8/16.
//  Copyright © 2016 Kevin Hall. All rights reserved.
//

import Foundation
import UIKit


class CustomTabsVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.isTranslucent = false
        let blur = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = self.tabBar.bounds
        //blurView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        //self.tabBar.addSubview(blurView)
        
        let path = UIBezierPath(roundedRect:self.tabBar.bounds,byRoundingCorners:[.bottomRight,.bottomLeft],cornerRadii: CGSize(width: 5 , height:  5))
        let maskLayer = CAShapeLayer()
        maskLayer.fillColor = COLOR_TEXT.cgColor
        maskLayer.path = path.cgPath
        
        self.tabBar.layer.mask = maskLayer
        self.tabBar.barStyle = .black
        
        for item in self.tabBar.items! as [UITabBarItem] {
            if let image = item.image {
                item.image = image.imageWithColor(color1: UIColor.white.withAlphaComponent(0.2)).withRenderingMode(.alwaysOriginal)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// for tab bar color when not selected
extension UIImage {
    func imageWithColor(color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color1.setFill()
        
        let context = UIGraphicsGetCurrentContext()! as CGContext
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0);
        context.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height) as CGRect
        context.clip(to: rect, mask: self.cgImage!)
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
