//
//  Client.swift
//  SB-Photos
//
//  Created by Kyle Smith on 10/11/18.
//  Copyright © 2018 smithcoding. All rights reserved.
//

import Foundation
import UIKit

protocol Client {
    var thumbnailImage: [String] { get set }
    var detailedImage: [String] { get set }
    var gifs: Bool { get set }
    
    func resetClient(_ gifs: Bool)
    func loadMoreImages(controller: ImageGridViewController)
    func fetchImageForCellAt(indexPath: IndexPath, view: ImageGridViewController.EnabledView, completion: ((_ success: Bool, _ image: UIImage?) -> Void)?)
}
