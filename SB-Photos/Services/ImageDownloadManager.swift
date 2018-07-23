//
//  ImageStore.swift
//  SB-Photos
//
//  Created by Kyle Smith on 7/22/18.
//  Copyright © 2018 smithcoding. All rights reserved.
//

import Foundation
import UIKit

final class ImageDownloadManager {
    static let shared = ImageDownloadManager()
    
    lazy var imageDownloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "com.sbPhotos.imageDownloadQueue"
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    var imageCache = NSCache<NSString, UIImage>()
    var imagesInSearch = 0
    var images: [UIImage] = []
    fileprivate init() { }
    
}
