//
//  DetailsViewModel.swift
//  TheNewFlickr
//
//  Created by Asmaa Tarek on 20/07/2021.
//

import Foundation

protocol DetailsViewModelProtocol {
    
    var apiCaller: ApiCallerProtocol { get }
    var selectedPhoto: Photo? { get  }
    var updateDropDown: (() -> ())? { get  set}
    var reloadPhoto: ((Int) -> ())? { get set}
    var photoSizes: [Size] { get }
    var dropDownItems: [String] { get }
    
    func getPhotoDetails(photoId: String)
    func selectSize(at index: Int)
}

class DetailsViewModel {
    
    private(set) lazy var apiCaller: ApiCallerProtocol = ApiCaller()
    private let apiHandler = ApiHandler()

    private(set) var selectedPhoto: Photo?
    
    init(selectedPhoto: Photo?) {
        self.selectedPhoto = selectedPhoto
    }

    var updateDropDown: (() -> ())?
    var reloadPhoto: ((Int) -> ())?
    private(set) var photoSizes = [Size]() {
        didSet {
            mapDropDownItems()
            updateDropDown?()
        }
    }
    
    private(set) var dropDownItems = [String]()
}

extension DetailsViewModel: DetailsViewModelProtocol {
    
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
