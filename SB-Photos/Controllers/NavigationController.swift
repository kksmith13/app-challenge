//
//  NavigationController.swift
//  SB-Trial
//
//  Created by Kyle Smith on 7/20/18.
//  Copyright © 2018 smithcoding. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    let client: Client
    
    init(client: Client) {
        self.client = client
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentMain()
    }
    
    fileprivate func presentMain() {
        perform(#selector(showMainController), with: nil, afterDelay: 0.20)
    }
    
    @objc func showMainController() {
        let imageGridController = ImageGridViewController(client: client)
        pushViewController(imageGridController, animated: true)
    }
}
