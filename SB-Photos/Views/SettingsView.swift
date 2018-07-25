//
//  SettingsView.swift
//  SB-Photos
//
//  Created by Kyle Smith on 7/24/18.
//  Copyright © 2018 smithcoding. All rights reserved.
//

import UIKit

class SettingsView: BaseView {
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.layoutMargins = .zero
        tv.tableFooterView = UIView(frame: .zero)
        return tv
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(tableView)
        
        _ = tableView.anchor(safeAreaLayoutGuide.topAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
}
