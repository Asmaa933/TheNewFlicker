//
//  HomeCell.swift
//  TheNewFlickr
//
//  Created by Asmaa Tarek on 18/07/2021.
//

import UIKit
import SDWebImage

class HomeCell: UICollectionViewCell {

    @IBOutlet private weak var searchPhoto: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        cornerForImage()
    }

    func configureCell(photo: Photo) {
        searchPhoto.setImageWith(url: photo.getImageUrl())
    }

    private func cornerForImage() {
        searchPhoto.layer.cornerRadius = 15
    }

}
