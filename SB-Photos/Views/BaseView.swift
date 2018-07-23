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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
