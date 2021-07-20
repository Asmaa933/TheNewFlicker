//
//  DetailsViewController.swift
//  TheNewFlickr
//
//  Created by Asmaa Tarek on 20/07/2021.
//

import UIKit

class DetailsViewController: BaseViewController {

    // 0 creator 1 title 2 date
    @IBOutlet private var labelsArray: [UILabel]!
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var dropDown: CustomDropDown!
    @IBOutlet private weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var widthConstraint: NSLayoutConstraint!
    
    private let viewModel = DetailsViewModel()
    var selectedPhoto: Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupView()
    }
    
    @IBAction private func closeAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}

fileprivate extension DetailsViewController {
    
    func setupViewModel() {
        setupViewModel(viewModel: viewModel)
        
        viewModel.updateDropDown = {[weak self]  in
            self?.setupDropDown()
        }
        
        viewModel.reloadPhoto = {[weak self] index in
            self?.setupPhotoSize(at: index)
        }
        viewModel.getPhotoDetails(photoId: selectedPhoto?.id ?? "")
    }
    
    func setupView() {
        labelsArray[0].text = selectedPhoto?.owner
        labelsArray[1].text = selectedPhoto?.title
        labelsArray[2].text = selectedPhoto?.owner
        let imageUrl = APIInfo.imageURL + (selectedPhoto?.server ?? "") + "/\(selectedPhoto?.id ?? "")_\(selectedPhoto?.secret ?? "").jpg"
        photoImageView.sd_setImage(with: URL(string: imageUrl),
                                placeholderImage: #imageLiteral(resourceName: "placeHolder"))
    }
    
    func setupDropDown() {
        dropDown.dropMenuItems = viewModel.dropDownItems
        dropDown.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openDropDown)))
        dropDown.dropMenu.selectionAction = {[weak self] (index: Int, item: String) in
            self?.dropDown.text = item
            self?.dropDown.showLabel()
            self?.viewModel.selectSize(at: index)
        }
    }
    
    @objc func openDropDown() {
        dropDown.dropMenu.show()
    }
    
    func setupPhotoSize(at index: Int) {
        var width = CGFloat(viewModel.photoSizes[index].width ?? 150)
        if width > view.frame.size.width {
            width = view.frame.size.width
        }
        widthConstraint.constant = width
        heightConstraint.constant = CGFloat(viewModel.photoSizes[index].height ?? 150)
        photoImageView.sd_setImage(with: URL(string: viewModel.photoSizes[index].source ?? ""),
                                   placeholderImage: #imageLiteral(resourceName: "placeHolder"))
    }
}
