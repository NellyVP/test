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

final class MySuperCache {
    var imagesCache = [MFSImage]()
    static let sharedInstance = MySuperCache()
    
    func findImageWithId(imageID: String) -> MFSImage? {
        var retuningImage: MFSImage!
        if (self.imagesCache.count > 0) {
            for eachImage in self.imagesCache {
                if eachImage.imageID == imageID {
                    // imageFound
                    retuningImage = eachImage
                }
            }
        }
        return retuningImage
    }
    func addImageToCache(image: MFSImage) -> Void {
        if !(self.findImageWithId(imageID: image.imageID!) != nil) {
            self.checkTodiscardOverCacheLimit()
            image.accessCount = Int(image.accessCount! + 1)
            image.lastAccessTime = NSDate()
            imagesCache.append(image)
        }
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
        //What if there is no age limit?
        //Then discard the image and download again
        let kDiscardInterval = -image.maxAge!
        let lastAccessedTime = image.lastAccessTime!.timeIntervalSinceNow
        let discardNeed = lastAccessedTime < kDiscardInterval
        if (discardNeed) {
            var imagesCacheCopy = [MFSImage]()
            let lockQueue = DispatchQueue(label: "self")
            
            lockQueue.sync {
                imagesCacheCopy = self.imagesCache
            }
            DispatchQueue.global(qos: .userInitiated).async { // 1
                //Order the cache array based on the least used image
                if let index = imagesCacheCopy.index(of:image) {
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
        completion (discardNeed)
    }
}

