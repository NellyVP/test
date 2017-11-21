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
    static let sharedInstance = MySuperCache()
    
    func findMFSImageWithId(imageId: String) -> MFSImage? {
        var retuningImage: MFSImage!

        if (self.imagesCache.count == 0) {
            return nil
        }
        else {
            var discard = false
            for eachImage in self.imagesCache {
                if eachImage.imageID == imageId {
                    //image found
                    //check the max age - if its an old photo - discard and get a new one
                    self.discardImageOverMaxAgeLimit(image: eachImage, completion: { (imageDiscarded) in
                        discard = imageDiscarded
                        if (discard) {
                            var imagesCacheCopy = [MFSImage]()
                            let lockQueue = DispatchQueue(label: "self")
                            
                            lockQueue.sync {
                                imagesCacheCopy = self.imagesCache
                            }
                            DispatchQueue.global(qos: .userInitiated).async { // 1
                                //Order the cache array based on the least used image
                                if let index = imagesCacheCopy.index(of:eachImage) {
                                    imagesCacheCopy.remove(at:(index))
                                }
                                
                                DispatchQueue.main.async { // 2
                                    let lockQueue = DispatchQueue(label: "self")
                                    lockQueue.sync {
                                        self.imagesCache = imagesCacheCopy
                                    }
                                }
                            }
                        }
                        else {
                            retuningImage = eachImage
                            retuningImage.accessCount = Int(retuningImage.accessCount! + 1)
                            retuningImage.lastAccessTime = NSDate()
                            if (UIImage(data:retuningImage.imageData! as Data) != nil) {
                                self.delegate?.get(imageAtURLString: imageId) { returnedImage in
                                }
                            }
                        }
                        
                    })
                }
            }
        }
        return retuningImage
    }
    
    func addImageToCache(image: MFSImage) -> Void {
        self.checkTodiscardOverCacheLimit()
        image.accessCount = Int(image.accessCount! + 1)
        image.lastAccessTime = NSDate()
        imagesCache.append(image)
    }
    func checkTodiscardOverCacheLimit() -> Void {
        var imagesCacheCopy = [MFSImage]()
        imagesCacheCopy = imagesCache
        if (imagesCacheCopy.count < kMaxNumberOfItems) {
            return
        }
        DispatchQueue.global(qos: .userInitiated).async { // 1
            //Order the cache array based on the least used image
            imagesCacheCopy.sort(by: { $0.accessCount < $1.accessCount })
            imagesCacheCopy.remove(at:(0))
        }
        DispatchQueue.main.async { // 2
            let lockQueue = DispatchQueue(label: "self")
            lockQueue.sync {
                self.imagesCache = imagesCacheCopy
            }
        }
    }
    func discardImageOverMaxAgeLimit(image: MFSImage, completion: @escaping (_ imageDiscarded: Bool) -> Void) {
        //if imageMax age is gone - then discharge it
        let kDiscardInterval = image.maxAge
        let discardNeed = image.lastAccessTime!.timeIntervalSinceNow < -kDiscardInterval!
        completion (discardNeed)
    }
}
