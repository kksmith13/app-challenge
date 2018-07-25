//
//  ApiClient.swift
//  SB-Photos
//
//  Created by Kyle Smith on 7/22/18.
//  Copyright © 2018 smithcoding. All rights reserved.
//

import Foundation
import UIKit

class APIClient {
    static let shared = APIClient()
    let apiKey = "d49118f7f7a943278d03ad85a4eb5201"
    
    var imageCache = NSCache<NSString, UIImage>()
    var imagesInSearch = 0
    var thumbnailImageUrl: [String] = []
    var detailedImageUrl: [String] = []
    
    func fetchImages(count: Int = 20, page: Int = 0, completion: @escaping (RawServerResponse?) -> Void) {
        // Version 7 of the API was the only thing avaiable in the 7 day trial for me
        let url = URL(string: "https://api.cognitive.microsoft.com/bing/v7.0/images/search?q=rick%20and%20morty&count=\(count)&offset=\(count * page)&mkt=en-us&safeSearch=Moderate")
        var request = URLRequest(url: url!)
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
    
    func downloadImageFromUrl(urlString: String, completion: ((_ success: Bool, _ image: UIImage?) -> Void)?) {
        
        // check the cache to see if the image is there
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            DispatchQueue.main.async {
                completion?(true, cachedImage)
            }
        } else {
            // go fetch the image
            let url = URL(string: urlString)
            var request = URLRequest(url: url!)
            request.addValue(apiKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
            
            let session = URLSession.shared
            session.downloadTask(with: url!, completionHandler: {(responseUrl, response, error) in
                let data = try? Data(contentsOf: responseUrl!)
                if let image = UIImage(data: data!) {
                    self.imageCache.setObject(image, forKey: urlString as NSString)
                    DispatchQueue.main.async {
                        completion?(true, image)
                    }
                }
            }).resume()
        }
    }
}

