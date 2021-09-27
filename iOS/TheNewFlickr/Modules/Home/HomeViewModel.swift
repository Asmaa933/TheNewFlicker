//
//  HomeViewModel.swift
//  TheNewFlickr
//
//  Created by Asmaa Tarek on 18/07/2021.
//

import Foundation

protocol HomeViewModelProtocol {
    var cachedSearchArray: [CachedSearch] { get }
    var hasMoreItems: Bool { get }
    var didSelectPhoto: ((Photo) -> ())? { get set }
    var reloadTableView: (() -> ())? { get set }
    
    func getSearchList()
    func searchInArray(searchText: String)
    func getPhotosCount() -> Int
    func getPhoto(at index: Int) -> Photo
    func didSelectPhoto(at index: Int)
    func getCachedSearch()
    func saveSearchResult(searchText: String)
    func removeSearchHistory()
    func removeSearch(at index: Int)
}

class HomeViewModel {

    private(set) lazy var apiCaller: ApiCallerProtocol = ApiCallerViewModel()

    private var photosArray = [Photo]()
    
    private var searchArray = [Photo]()
    
    private(set) var cachedSearchArray = [CachedSearch]() {
        didSet {
            cachedSearchArray = cachedSearchArray.reversed()
            reloadTableView?()
        }
    }
    
    private(set) var hasMoreItems = false
    private var page: Int = 1
    private var totalPages: Int = 1 {
        didSet {
            if totalPages > page {
                page += 1
                hasMoreItems = true
            }else {
                hasMoreItems = false
            }
        }
    }
    
    var isSearch = false
    var didSelectPhoto: ((Photo) -> ())?
    var reloadTableView: (() -> ())?
    let api = ApiHandler()
    
    func getSearchList() {
        apiCaller.startRequest(api: api , request: NetworkingApi.getSearchPhotos(page: page),
                     mappingClass: SearchModel.self,
                     successCompletion: {[weak self] response in
                        guard let self = self else { return }
                        self.photosArray.append(contentsOf: response?.photos?.photo ?? [])
                        self.page = response?.photos?.page ?? 1
                        self.totalPages = response?.photos?.pages ?? 1
                     }, showLoading: page == 1 )
    }
    
    func searchInArray(searchText: String) {
        searchArray = [Photo]()
        if (searchText.isEmpty){
            isSearch = false
        }else{
            isSearch = true
            searchArray = photosArray.filter {$0.title?.contains(searchText) ?? false}
        }
    }
    
    func getPhotosCount() -> Int {
        isSearch ? searchArray.count : photosArray.count
    }
    
    func getPhoto(at index: Int) -> Photo {
        isSearch ? searchArray[index] : photosArray[index]
    }
    
    func didSelectPhoto(at index: Int) {
        isSearch ? didSelectPhoto?(searchArray[index]) : didSelectPhoto?(photosArray[index])
    }
    
    func getCachedSearch() {
        cachedSearchArray = CoreDataHandler.shared.getDataFromCoreData() ?? []
    }
    
    func saveSearchResult(searchText: String) {
        if !searchText.isEmpty {
            if cachedSearchArray.filter({$0.item == searchText}).isEmpty {
                let searchItem = CachedSearch(context: CoreDataHandler.shared.getCoreDataobject())
                searchItem.item = searchText
                CoreDataHandler.shared.saveIntoCoreData(searchItem: searchItem)
            }
        }
    }
    
    func removeSearchHistory() {
        CoreDataHandler.shared.clearCoreData()
        cachedSearchArray.removeAll()
    }
    
    func removeSearch(at index: Int) {
        cachedSearchArray = CoreDataHandler.shared.deleteObjectFromCoreData(item: cachedSearchArray[index]) ?? []
    }
}
