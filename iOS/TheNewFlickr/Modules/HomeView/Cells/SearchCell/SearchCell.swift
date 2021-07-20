//
//  SearchCell.swift
//  TheNewFlickr
//
//  Created by Asmaa Tarek on 20/07/2021.
//

import UIKit

class SearchCell: UITableViewCell {

    
    @IBOutlet private weak var itemLabel: UILabel!
    
    var text: String? {
        didSet {
            itemLabel.text = text
        }
    }
    
    var index = 0
    
    @IBAction private func deleteAction(_ sender: UIButton) {
        if let vc = self.findViewController() as? HomeViewController {
            vc.viewModel.removeSearch(at: index)
        }
    }
}
