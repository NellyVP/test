//
//  NSURL+MFSRequestURL.swift
//  MyFirstSlideshow
//
//  Created by Nilofar Vahab poor on 18/10/2017.
//  Copyright © 2017 Yoti. All rights reserved.
//

import Foundation

extension NSURL {

    typealias ImageCacheCompletion = (MFSImage) -> Void
    typealias fetchImageCompletionHandler = (_ data :Data, _ response: URLResponse, _ error: NSError ) -> Void
    
    func fetchImage(completion: @escaping ImageCacheCompletion) {
        let task = URLSession.shared.dataTask(with: self as URL) {
            data, response, error in
            if error == nil {
                if let  data = data {
                    let httpResponse = response as! HTTPURLResponse
                    var maxAgeDoubleValue = 0.0
                    if let contentType = httpResponse.allHeaderFields["Cache-Control"] as? String {
                        // use contentType here
                        if let maxAgeString = contentType.components(separatedBy: "=").last {
                            if let maxAge = maxAgeString.components(separatedBy: ",").first {
                                maxAgeDoubleValue = (maxAge as NSString).doubleValue
                            }
                        }
                    }

                    let image = MFSImage (imgID: self.absoluteString!, imgData: data as NSData, preAccessTime: Date() as NSDate, numberOfRetrieval: 1, cachePeriod:maxAgeDoubleValue)
                    DispatchQueue.main.async {
                        completion(image)
                    }
                }
            }
        }
        task.resume()
    }
}

