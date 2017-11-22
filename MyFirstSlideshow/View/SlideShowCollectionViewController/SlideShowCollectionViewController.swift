//
//  SlideShowCollectionViewController.swift
//  MyFirstSlideshow
//
//  Created by Nilofar Vahab poor on 21/11/2017.
//  Copyright © 2017 Yoti. All rights reserved.
//

import UIKit

private let reuseIdentifier = "SlideShowCustomCollectionViewCell"

class SlideShowCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, SlideShowCustomCellClassDelegate {

    @IBOutlet var collectionView: UICollectionView!
    let controller = MFSController()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
        let indexPathForFirstRow = NSIndexPath(item: 0, section: 0)
        self.downloadImage(self.collectionView .cellForItem(at: indexPathForFirstRow as IndexPath) as? SlideShowCustomCollectionViewCell)
    }
    // MARK: UICollectionViewDataSource

     func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return controller.images.count
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height:380)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SlideShowCustomCollectionViewCell
        cell.delegate = self
        return cell
    }
    
    func downloadImage(_ cell: SlideShowCustomCollectionViewCell?) {
        if ((cell?.imgView.image) != nil) {
            cell?.imgView.image = nil
        }

        let indexPath = collectionView.indexPath(for: cell!)
        controller.get(imageAtURLString: controller.images[(indexPath?.row)!]) { (image) in
            UIView.animate(withDuration: 2.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            cell?.updateCellWithImage(image: image!)
            }, completion: nil)
        }
    }
}

