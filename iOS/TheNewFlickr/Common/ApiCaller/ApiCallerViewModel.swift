//
//  ApiCallerViewModel.swift
//  TheNewFlickr
//
//  Created by Asmaa Tarek on 26/09/2021.
//

import Foundation

class ApiCallerViewModel: ApiCallerProtocol {
  
    var updateLoadingStatus: (() -> ())?
    var updateError: ((String) -> ())?
    var state: State = .empty {
        didSet {
          updateLoadingStatus?()
        }
    }
   
    func startRequest<M: Codable> (api: ApiHandlerProtocol = ApiHandler(),
                                   request: Requestable,
                                   mappingClass: M.Type,
                                   successCompletion: @escaping ((M?) -> Void),
                                   showLoading: Bool = true) {
        if showLoading {
            state = .loading
        }
        
        api.fetchData(request: request, mappingClass: mappingClass).done {[weak self] success in
            self?.changeState(state: .populated)
            successCompletion(success)
        }.catch {[weak self] error in
            self?.changeState(state: .error)
            self?.updateError?((error as? ErrorHandler)?.rawValue ?? error.localizedDescription.description)
        }
    }
    
    private func changeState(state: State) {
        self.state = state
    }
    
}
