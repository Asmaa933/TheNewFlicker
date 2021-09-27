//
//  DetailsViewController.swift
//  TheNewFlickr
//
//  Created by Asmaa Tarek on 20/07/2021.
//

import UIKit

class DetailsViewController: UIViewController {

    // 0 creator 1 title
    @IBOutlet private var labelsArray: [UILabel]!
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var dropDown: CustomDropDown!
    @IBOutlet private weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var widthConstraint: NSLayoutConstraint!
    
    private var loaderIndicator: UIActivityIndicatorView?

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
        
        viewModel.apiCaller.updateLoadingStatus = {[weak self] in
            self?.handleLoadingState()
        }
        viewModel.updateDropDown = {[weak self]  in
            self?.setupDropDown()
        }
        
        viewModel.reloadPhoto = {[weak self] index in
            self?.setupPhotoSize(at: index)
        }
        viewModel.getPhotoDetails(photoId: selectedPhoto?.id ?? "")
    }
    
    func handleLoadingState() {
        switch viewModel.apiCaller.state {
        case .loading:
            loaderIndicator = showLoading(view: dropDown)
        case .populated:
            removeLoading(loaderIndicator, from: dropDown)
            setupDropDown()
            loaderIndicator = nil
        case .empty, .error:
            removeLoading(loaderIndicator, from: dropDown)
            loaderIndicator = nil
        }
    }
    
    func setupView() {
        labelsArray[0].text = selectedPhoto?.owner
        labelsArray[1].text = selectedPhoto?.title
        let imageUrl = APIInfo.imageURL + (selectedPhoto?.server ?? "") + "/\(selectedPhoto?.id ?? "")_\(selectedPhoto?.secret ?? "").jpg"
        photoImageView.sd_setImage(with: URL(string: imageUrl),
                                placeholderImage: #imageLiteral(resourceName: "placeHolder"))
        photoImageView.layer.cornerRadius = 15
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
        widthConstraint.constant = CGFloat(viewModel.photoSizes[index].width ?? 150)
        heightConstraint.constant = CGFloat(viewModel.photoSizes[index].height ?? 150)
        photoImageView.sd_setImage(with: URL(string: viewModel.photoSizes[index].source ?? ""),
                                   placeholderImage: #imageLiteral(resourceName: "placeHolder"))
    }
}

extension DetailsViewController: LoadingProtocol {}

extension DetailsViewController: AlertProtocol {}
