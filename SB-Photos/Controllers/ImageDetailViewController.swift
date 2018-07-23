//
//  ImageDetailViewController.swift
//  SB-Photos
//
//  Created by Kyle Smith on 7/22/18.
//  Copyright © 2018 smithcoding. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController {
    
    lazy var mainView: ImageDetailView = {
        let v = ImageDetailView()
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = mainView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
