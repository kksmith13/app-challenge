//
//  OptionsCell.swift
//  storeApp
//
//  Created by Kyle Smith on 1/8/17.
//  Copyright © 2017 Codesmiths. All rights reserved.
//

import UIKit

class ImageCell: BaseCVCell {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .black
        return iv
    }()
    
    override func setupCell() {
        super.setupCell()
        
        addSubview(imageView)
        _ = imageView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 1, bottomConstant: 2, rightConstant: 1, widthConstant: 0, heightConstant: 0)
    }
}
