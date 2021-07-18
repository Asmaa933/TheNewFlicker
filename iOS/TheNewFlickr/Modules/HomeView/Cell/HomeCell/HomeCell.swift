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
        searchPhoto.layer.cornerRadius = 15
    }
    
    func configureCell(photo: Photo) {
        guard let serverId = photo.server,
              let id = photo.id,
              let secret = photo.secret
        else { return }
        let imageUrl = APIInfo.imageURL + serverId + "/\(id)_\(secret).jpg"
        searchPhoto.sd_setImage(with: URL(string: imageUrl),
                                placeholderImage: #imageLiteral(resourceName: "placeHolder"))
    }
    
}
