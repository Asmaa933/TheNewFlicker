//
//  BaseViewModel.swift
//  TheNewFlickr
//
//  Created by Asmaa Tarek on 15/07/2021.
//

import Foundation

public enum State {
    case loading
    case error
    case empty
    case populated
}

class BaseViewModel: NSObject {
    private let api = ApiHandler()
    var updateLoadingStatus: (()->())?
    var updateError: ((String)->())?
    var logOutAlert: (() -> ())?
    var state: State = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var checkInternetConnection: (() -> ())?
    
    func startRequest<M: Codable>(request: Requestable, mappingClass: M.Type,successCompletion: @escaping((M?) -> Void), showLoading: Bool = true) {
    
        if showLoading {
            state = .loading
        }
        
        api.fetchData(request: request, mappingClass: mappingClass).done{[weak self] success in
            self?.state = .populated
            successCompletion(success)
        }.catch {[weak self] error in
            self?.state = .error
            self?.updateError?((error as? ErrorHandler)?.rawValue ?? error.localizedDescription.description)
        }
    }
}

