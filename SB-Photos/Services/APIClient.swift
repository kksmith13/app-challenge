//
//  ApiClient.swift
//  SB-Photos
//
//  Created by Kyle Smith on 7/22/18.
//  Copyright © 2018 smithcoding. All rights reserved.
//

import Foundation
import UIKit

class APIClient: Client {
    var thumbnailImage: [String] = []
    var detailedImage: [String] = []
    var gifs = false
    
    let apiKey = "d099b48b7fcc4ea78549342f36c824af"
    var imageCache = NSCache<NSString, UIImage>()
    var imagesInSearch = 0
    var nextOffset = 0
    
    func resetClient(_ gifs: Bool) {
        self.gifs = gifs
        imagesInSearch = 0
        nextOffset = 0
        imageCache.removeAllObjects()
        detailedImage.removeAll()
        thumbnailImage.removeAll()
    }
    
    func fetchImages(count: Int = 20, page: Int = 0, completion: @escaping (RawServerResponse?) -> Void) {
        // Version 7 of the API was the only thing avaiable in the 7 day trial for me
        
        var url: URL
        
        if gifs {
            url = URL(string: "https://api.cognitive.microsoft.com/bing/v7.0/images/search?q=rick%20and%20morty&count=\(count)&offset=\(nextOffset)&mkt=en-us&safeSearch=Moderate&imageType=AnimatedGif")!
        } else {
            url = URL(string: "https://api.cognitive.microsoft.com/bing/v7.0/images/search?q=cryptocurrency&count=\(count)&offset=\(nextOffset)&mkt=en-us&safeSearch=Moderate")!
        }
        
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        
        let session = URLSession.shared
        session.dataTask(with: request, completionHandler: {(data, response, error) in
            // Handle errors
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let decodedResponse = try decoder.decode(RawServerResponse.self, from: data!)
                return completion(decodedResponse)
            } catch let responseError {
                print(responseError)
                return
            }
        }).resume()
    }
    
    func fetchImageForCellAt(indexPath: IndexPath, view: ImageGridViewController.EnabledView, completion: ((_ success: Bool, _ image: UIImage?) -> Void)?) {
        // check the cache to see if the image is there
        let imageUrl = view == .grid ? thumbnailImage[indexPath.row] : detailedImage[indexPath.row]
        if let cachedImage = imageCache.object(forKey: imageUrl as NSString) {
            DispatchQueue.main.async {
                completion?(true, cachedImage)
            }
        } else {
            // go fetch the image
            let url = URL(string: imageUrl)
            var request = URLRequest(url: url!)
            request.addValue(apiKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
            
            let session = URLSession.shared
            session.downloadTask(with: url!, completionHandler: {(responseUrl, response, error) in
                let data = try? Data(contentsOf: responseUrl!)
                if let image = UIImage(data: data!) {
                    self.imageCache.setObject(image, forKey: imageUrl as NSString)
                    DispatchQueue.main.async {
                        completion?(true, image)
                    }
                }
            }).resume()
        }
    }
    
    func loadMoreImages(controller: ImageGridViewController) {
        // Handle senario where we are about to run out of images to load in
        if (controller.itemsPerPage * controller.page) > imagesInSearch {
            let countCheck = imagesInSearch - (controller.itemsPerPage * controller.page) - 1
            if countCheck > 0 {
                // itemsPerPage = countCheck
                controller.canLoadMoreImages = false
            }
        }
        
        fetchImages(count: controller.itemsPerPage, page: controller.page, completion: { (data) in
            controller.page += 1
            guard let dataPresent = data else {
                return
            }
            
            self.imagesInSearch = dataPresent.totalEstimatedMatches
            self.nextOffset     = dataPresent.nextOffset
            
            for item in dataPresent.value {
                self.thumbnailImage.append(item.thumbnailUrl.absoluteString)
                self.detailedImage.append(item.contentUrl.absoluteString)
            }
            
            controller.reloadCollectionViewData()
        })
    }
}

