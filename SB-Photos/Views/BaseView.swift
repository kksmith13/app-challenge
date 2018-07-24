//
//  BaseView.swift
//  storeApp
//
//  Created by Kyle Smith on 1/10/17.
//  Copyright © 2017 Codesmiths. All rights reserved.
//

import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    func setupViews() { }
    
    // TODO: Animate clipboard alert
    // TODO: Handle gifs
    // TODO: Make sure images are correct - not using preloaded one
    // TODO: Prefetch?
    // TODO: Failed/Downloading/Complete?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
