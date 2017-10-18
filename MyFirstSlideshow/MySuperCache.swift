//
//  MySuperCache.swift
//  MyFirstSlideshow
//
//  Created by Nilofar Vahab poor on 18/10/2017.
//  Copyright © 2017 Yoti. All rights reserved.
//

import Foundation
import UIKit
private let kMaxNumberOfItems: Int = 10000

protocol MySuperCacheProtocol {
    func get(imageAtURLString imageURLString: String, completionBlock: @escaping (UIImage?) -> Void)
}

final class MySuperCache {
    var delegate: MySuperCacheProtocol?
    
    var imagesCache = [MFSImage]()
    var searching = false
    
    static let sharedInstance = MySuperCache()
    
    func findMFSImageWithId(imageId: String) -> MFSImage?
    {
        if (self.imagesCache.count > 0) {
            for image in self.imagesCache {
                if imageId == image.imageID {
                    //update the accessCount and lastAccessTime
                    image.accessCount = Int(image.accessCount! + 1)
                    image.lastAccessTime = NSDate()
                    if (UIImage(data:image.imageData! as Data) != nil) {
                        self.delegate?.get(imageAtURLString: imageId) { returnedImage in
                        }
                    }
                    return image
                }
            }
        }
        return nil
    }
    
    func addImageToCache(image: MFSImage) -> Void {
        if imagesCache.count < kMaxNumberOfItems {
            image.accessCount = Int(image.accessCount! + 1)
            image.lastAccessTime = NSDate()
            imagesCache.append(image)
        }
        else {
            imagesCache.sort(by: { $0.accessCount < $1.accessCount })
            // Example 2: Sort into a new array by serial number in DECENDING order
            // newSortedArray is now in this order: [phoneThree, phoneTwo, phoneOne]
            //lowest used is in the 0 position?
            imagesCache .remove(at: 0)
            
            image.accessCount = Int(image.accessCount! + 1)
            image.lastAccessTime = NSDate()
            imagesCache.append(image)
        }
    }
}
