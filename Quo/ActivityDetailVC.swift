//
//  ExerciseDetail.swift
//  treyn
//
//  Created by Kevin Hall on 9/9/16.
//  Copyright © 2016 Kevin Hall. All rights reserved.
//

import Foundation
import UIKit



class ActivityDetail : UIViewController {
    
    
    //@IBOutlet weak var titl: UILabel!
    var picture: UIImageView!
    var desc: UILabel!
    
    //var tit = ""
    var pic = UIImageView()
    var des = ""
    
    override func viewDidLoad() {
        self.navigationItem.leftBarButtonItem?.image = nil
        
        //titl.text = tit
        picture = pic
        desc.text = des

        self.view.layer.cornerRadius = 15
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
