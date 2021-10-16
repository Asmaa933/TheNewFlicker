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
    func fetchData<T: Decodable>(request: Requestable, mappingClass: T.Type) -> Promise<T>
}

class ApiHandler: ApiHandlerProtocol {
    func fetchData<T: Decodable>(request: Requestable, mappingClass: T.Type) -> Promise<T> {
        return Promise<T> { seal in
            if isNetworkConnected() {
                getRequestData(request: request).responseJSON {[weak self] response in
                    guard let self = self else { return }
                    let response = self.handleResponse(response: response, mappingClass: T.self)
                    switch response {
                    case .success(let decodedObj):
                        seal.fulfill(decodedObj)
                    case .failure(let error):
                        seal.reject(error)
                    }
                }
            } else {
                seal.reject(ErrorHandler.noInternetConnection)
            }
        }
    }
}

private extension ApiHandler {

    func isNetworkConnected() -> Bool {
        return NetworkMonitor.shared.netOn
    }

    func getRequestData(request: Requestable) -> DataRequest {
        let requestData = AF.request(request.path,
                                     method: request.method,
                                     parameters: request.parameters,
                                     encoding: request.encoding,
                                     headers: request.headers)
        return requestData
    }

    func handleResponse<T: Decodable> (response: AFDataResponse<Any>, mappingClass: T.Type) -> Swift.Result<T, Error> {
        switch response.result {

        case .success:
            guard let jsonResponse = response.data else {
                return .failure(ErrorHandler.generalError)
            }
            do {
                let decodedObj = try JSONDecoder().decode(T.self, from: jsonResponse)
                return .success(decodedObj)
            } catch let error {
                debugPrint("Error in decoding ** \n \(error.localizedDescription.description)")
                return .failure(ErrorHandler.generalError)
            }

        case .failure(let error):
            debugPrint(error.localizedDescription.description)
            return .failure(error)
        }
    }
}
