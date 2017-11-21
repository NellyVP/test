//
//  ViewController.swift
//  MyFirstSlideshow
//
//  Created by Charles Vu on 17/05/2017.
//  Copyright © 2017 Yoti. All rights reserved.
//

import UIKit

class SlideShowViewController: UIViewController, NSURLConnectionDataDelegate {
    let controller = MFSController()
    let images: Array<String> = ["https://c1.staticflickr.com/6/5615/15570202337_0e64f5046e_k.jpg",
                                 "https://c1.staticflickr.com/4/3169/2846544061_cb7c04b46f_b.jpg",
                                 "https://i.redd.it/d8q1wkgu1awy.jpg",
                                 "http://www.kapstadt.de/webcam.jpg"]
    
    var i: Int = 0
    var j: Int = 0
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    
    @IBOutlet var dots1: [UIView]?
    @IBOutlet var dots2: [UIView]?
    
    override func viewDidLoad() {
        
    }
    @IBAction func onButtonOneClicked(_ sender: UIButton) {
        sender.isEnabled = false
        let currentImage = images[i % 4]
        controller.get(imageAtURLString: currentImage, completionBlock: { (image) in
            self.image1.image = image
            sender.isEnabled = true
            for view in self.dots1! {
                if view.tag == self.i % self.images.count {
                    view.backgroundColor = UIColor.green
                } else {
                    view.backgroundColor = UIColor.gray
                }
            }
            self.i += 1
        })
    }
    
    @IBAction func onButtonTwoClicked(_ sender: UIButton) {
        let currentImage = images[j % 4]
        controller.get(imageAtURLString: currentImage, completionBlock: { (image) in
            self.image2.image = image
            
        })
        for view in dots2! {
            if view.tag == j % self.images.count {
                view.backgroundColor = UIColor.green
            } else {
                view.backgroundColor = UIColor.gray
            }
        }
        j += 1
    }
    
    @IBAction func onImageTapped(_ sender: Any) {
        
    }
}

