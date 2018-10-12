//
//  DiskClient.swift
//  SB-Photos
//
//  Created by Kyle Smith on 10/11/18.
//  Copyright © 2018 smithcoding. All rights reserved.
//

import UIKit

class DiskClient: Client {
    var thumbnailImage: [String] = []
    var detailedImage: [String] = []
    var gifs = false
    
    func resetClient(_ gifs: Bool) {
        self.gifs = gifs
    }
    
    func loadMoreImages(controller: ImageGridViewController) {
        
    }
    
    func fetchImageForCellAt(indexPath: IndexPath, view: ImageGridViewController.EnabledView, completion: ((Bool, UIImage?) -> Void)?) {
        return
    }
}
