//
//  SlideShowController.swift
//  MyFirstSlideshow
//
//  Created by Nilofar Vahab poor on 18/10/2017.
//  Copyright © 2017 Yoti. All rights reserved.
//

import Foundation
import UIKit

class MFSController: NSObject, MySuperCacheProtocol {
    
    func get(imageAtURLString imageURLString: String, completionBlock: @escaping (UIImage?) -> Void) {
        if let foundImage = MySuperCache.sharedInstance.findMFSImageWithId(imageId: imageURLString) {
            if let image = UIImage(data:foundImage.imageData! as Data) {
                completionBlock (image)
            }
        }
        else {
            let currentImageURL = NSURL(string:imageURLString)
            currentImageURL?.fetchImage(completion: { (image) in
                MySuperCache.sharedInstance.addImageToCache(image: image)
                if let image = UIImage(data:image.imageData! as Data) {
                    completionBlock (image)
                }
            })
        }
    }
}
