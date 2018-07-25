//
//  Image.swift
//  SB-Photos
//
//  Created by Kyle Smith on 7/22/18.
//  Copyright © 2018 smithcoding. All rights reserved.
//

import Foundation

struct RawServerResponse: Decodable {
    var totalEstimatedMatches: Int
    var nextOffset: Int
    var value: [ImageData]
    
    struct ImageData: Decodable {
        var thumbnailUrl: URL
        var contentUrl: URL
    }
}
