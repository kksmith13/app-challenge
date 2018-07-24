//
//  AlertView.swift
//  SB-Photos
//
//  Created by Kyle Smith on 7/23/18.
//  Copyright © 2018 smithcoding. All rights reserved.
//

import UIKit

class AlertView: BaseView {
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.text = "Copied to Clipboard!"
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.light)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    override func setupViews() {
        backgroundColor = .red
        addSubview(textLabel)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: textLabel)
        addConstraintsWithFormat(format: "V:[v0(24)]", views: textLabel)
        
        textLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
