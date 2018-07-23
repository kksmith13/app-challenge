//
//  ViewController.swift
//  SB-Trial
//
//  Created by Kyle Smith on 7/20/18.
//  Copyright © 2018 smithcoding. All rights reserved.
//

import UIKit

class ImageGridViewController: UIViewController {
    
    lazy var mainView: ImageGridView = {
        let v = ImageGridView()
        v.imageGridViewController = self
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

