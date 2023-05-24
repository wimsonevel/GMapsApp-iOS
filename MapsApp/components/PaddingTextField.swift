//
//  PaddingTextField.swift
//  MapsApp
//
//  Created by Kwikku Nusantara on 23/05/23.
//

import Foundation
import UIKit

class PaddedTextField: UITextField {
    let padding: CGFloat = 10
        
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += padding
        return rect
    }
}
