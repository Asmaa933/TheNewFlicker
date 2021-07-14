//
//  ApiHandler.swift
//  TheNewFlickr
//
//  Created by Asmaa Tarek on 14/07/2021.
//

import Foundation
import Alamofire
import PromiseKit

protocol ApiHandlerProtocol {
    func getPhotosSearch(page: Int) -> Promise<SearchModel>
}

class ApiHandler: ApiHandlerProtocol {
    func getPhotosSearch(page: Int) -> Promise<SearchModel> {
        return Promise<SearchModel> { seal in
            if NetworkMonitor.shared.netOn {
                AF.request(APIInfo.url,
                           method: .get,
                           parameters: APIInfo.getSearchParams(page: page),
                           encoding: URLEncoding.default,
                           headers: nil)
                    .responseJSON { response in
                        switch response.result {
                        case .success:
                            guard let jsonResponse = response.data else {
                                seal.reject(ErrorHandler.generalError)
                                return
                            }
                            do {
                                let search = try JSONDecoder().decode(SearchModel.self, from: jsonResponse)
                                seal.fulfill(search)
                            } catch (let error){
                                debugPrint("Error in decoding ** \n \(error.localizedDescription.description)")
                                seal.reject(ErrorHandler.generalError)
                            }
                        case .failure(let error):
                            debugPrint(error.localizedDescription.description)
                            seal.reject(error)
                        }
                    }
            } else {
                seal.reject(ErrorHandler.noInternetConnection)
            }
        }
    }
}
