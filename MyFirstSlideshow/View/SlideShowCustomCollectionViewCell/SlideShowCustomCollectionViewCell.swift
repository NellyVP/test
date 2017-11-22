//
//  SlideShowCustomCollectionViewCell.swift
//  MyFirstSlideshow
//
//  Created by Nilofar Vahab poor on 21/11/2017.
//  Copyright © 2017 Yoti. All rights reserved.
//

import UIKit
protocol SlideShowCustomCellClassDelegate: class {
    func downloadImage(_ cell: SlideShowCustomCollectionViewCell?)
}

class SlideShowCustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imgView:UIImageView!
    @IBOutlet var downloadButton:UIButton!
    @IBOutlet var urlLabel: UILabel!
    weak var delegate: SlideShowCustomCellClassDelegate?

    override func awakeFromNib() {
        self.layer.borderWidth = 2
        self.layer .makeShadedRounded(withCornerRadius: 5.0, borderColor: UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0))
        downloadButton.layer .makeShadedRounded(withCornerRadius: 5.0, borderColor: UIColor.lightGray)
        downloadButton.layer.borderWidth = 2
        
        imgView.layer .makeShadedRounded(withCornerRadius: 5.0, borderColor: UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0))
        imgView.layer.borderWidth = 2
        imgView.contentMode = .scaleAspectFit
    }
    
    func updateCellWithImage(image:MFSImage) {
        self.imgView.image = UIImage(data:image.imageData! as Data)
        self.urlLabel.text  = String(format:"URL: %@", image.imageID!)

    }
    @IBAction func downloadButtonTapped() {
        delegate?.downloadImage(self)
    }
}
