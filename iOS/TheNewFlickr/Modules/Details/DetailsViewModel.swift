//
//  DetailsViewModel.swift
//  TheNewFlickr
//
//  Created by Asmaa Tarek on 20/07/2021.
//

import Foundation

class DetailsViewModel: BaseViewModel {
    
    var updateDropDown: (() -> ())?
    var reloadPhoto: ((Int) -> ())?
    private(set) var photoSizes = [Size]() {
        didSet {
            mapDropDownItems()
            updateDropDown?()
        }
    }
    
    private(set) var dropDownItems = [String]()
    
    
    func getPhotoDetails(photoId: String) {
        startRequest(request: NetworkingApi.getSizes(photoId: photoId),
                     mappingClass: PhotoSizes.self) {[weak self] response in
            self?.photoSizes = response?.sizes?.size ?? []
        }
    }
    
    func selectSize(at index: Int) {
        reloadPhoto?(index)
    }
}

fileprivate extension DetailsViewModel {
    
    func mapDropDownItems() {
        dropDownItems = photoSizes.map {"\($0.width ?? 150) X \($0.height ?? 150)"}
    }
}
