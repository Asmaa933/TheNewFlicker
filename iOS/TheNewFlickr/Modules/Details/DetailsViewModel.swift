//
//  DetailsViewModel.swift
//  TheNewFlickr
//
//  Created by Asmaa Tarek on 20/07/2021.
//

import Foundation

class DetailsViewModel {
    
    private(set) lazy var apiCaller: ApiCallerProtocol = ApiCaller()
    var updateDropDown: (() -> ())?
    var reloadPhoto: ((Int) -> ())?
    private(set) var photoSizes = [Size]() {
        didSet {
            mapDropDownItems()
            updateDropDown?()
        }
    }
    
    private(set) var dropDownItems = [String]()
    
    let apiHandler = ApiHandler()
    func getPhotoDetails(photoId: String) {
        apiCaller.startRequest(api: apiHandler, request: NetworkingApi.getSizes(photoId: photoId), mappingClass: PhotoSizes.self, successCompletion: {[weak self] response in
            self?.photoSizes = response?.sizes?.size ?? []
        }, showLoading: true)
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
