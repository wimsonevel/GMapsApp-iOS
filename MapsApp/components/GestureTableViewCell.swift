//
//  GestureTableViewCell.swift
//  MapsApp
//
//  Created by Kwikku Nusantara on 23/05/23.
//

import Foundation
import UIKit

class GestureTableViewCell: UITableViewCell {
    var tapAction: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        self.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
                
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func cellTapped() {
        tapAction?()
    }
}
