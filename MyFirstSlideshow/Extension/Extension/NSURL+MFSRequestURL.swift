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

    func fetchImage(completion: @escaping ImageCacheCompletion) {
        let task = URLSession.shared.dataTask(with: self as URL) {
            data, response, error in
            if error == nil {
                if let  data = data {
                    let httpResponse = response as! HTTPURLResponse
                    print("response is --->" , httpResponse.description)

                    let field = httpResponse.allHeaderFields["NAME_OF_FIELD"]
                    
                    let responseData = String(data: data, encoding: String.Encoding.utf8)

                    let image = MFSImage (imgID: self.absoluteString!, imgData: data as NSData, preAccessTime: Date() as NSDate, numberOfRetrieval: 1)
                    DispatchQueue.main.async {
                        completion(image)
                    }
                }
            }
        }
        task.resume()
    }
}

