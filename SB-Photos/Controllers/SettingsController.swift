//
//  Settings.swift
//  SB-Photos
//
//  Created by Kyle Smith on 7/24/18.
//  Copyright © 2018 smithcoding. All rights reserved.
//

import UIKit

class SettingsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    lazy var mainView: SettingsView = {
        let sv = SettingsView()
        sv.tableView.delegate = self
        sv.tableView.dataSource = self
        return sv
    }()

    let cellId = "cellId"
    let navTitle = "Settings"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = navTitle
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = ""
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        cell.accessoryType = .disclosureIndicator
        
        cell.textLabel?.text = indexPath.row == 0 ? "Normal Images" : "GIFs"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let api = APIClient.shared
        api.gifs = indexPath.row == 0 ? false : true
        api.imageCache.removeAllObjects()
        api.detailedImageUrl.removeAll()
        api.thumbnailImageUrl.removeAll()
        api.imagesInSearch = 0
        api.nextOffset = 0
        
        navigationController?.popViewController(animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

