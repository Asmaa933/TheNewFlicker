//
//  HomeViewModel.swift
//  TheNewFlickr
//
//  Created by Asmaa Tarek on 18/07/2021.
//

import Foundation

class HomeViewModel: BaseViewModel {
    
    private(set) var searchArray = [Photo]() {
        didSet {
            reloadCollectionView?()
        }
    }
    
    private(set) var hasMoreItems = false
    private var page: Int = 1
    private var totalPages:Int = 1 {
        didSet {
            if totalPages > page {
                page += 1
                hasMoreItems = true
            }else {
                hasMoreItems = false
            }
        }
    }
    
    var reloadCollectionView: (() -> ())?
    
    func getSearchList() {
        startRequest(request: NetworkingApi.getSearchPhotos(page: page),
                     mappingClass: SearchModel.self,
                     successCompletion: {[weak self] response in
                        guard let self = self else { return }
                        self.searchArray.append(contentsOf: response?.photos?.photo ?? [])
                        self.page = response?.photos?.page ?? 1
                        self.totalPages = response?.photos?.pages ?? 1
                     }, showLoading: page == 1 )
    }
}
