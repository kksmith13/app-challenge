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
    
    var imageCache = NSCache<NSString, UIImage>()
    var imagesInSearch = 0
    var thumbnailImageUrl: [String] = []
    var detailedImageUrl: [String] = []
    fileprivate init() { }
    
}
