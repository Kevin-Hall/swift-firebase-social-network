//
//  CustomField.swift
//  Quo
//
//  Created by Kevin Hall on 11/29/16.
//  Copyright © 2016 KAACK. All rights reserved.
//

import Foundation
import UIKit
import TextFieldEffects


class CustomField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }
}
