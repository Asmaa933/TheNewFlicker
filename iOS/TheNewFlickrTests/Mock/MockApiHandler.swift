//
//  MockApiHandler.swift
//  TheNewFlickrTests
//
//  Created by Asmaa Tarek on 15/07/2021.
//

import Foundation
import PromiseKit
@testable import TheNewFlickr

class MockApiHandler {
    var shouldReturnError: Bool
    var error: ErrorHandler?
    
    init(shouldReturnError: Bool, error: ErrorHandler? = nil) {
        self.shouldReturnError = shouldReturnError
        self.error = error
    }
}


extension MockApiHandler: ApiHandlerProtocol {
    func fetchData<T: Decodable>(request: Requestable, mappingClass: T.Type) -> Promise<T> {
        return Promise<T> { seal in
            if shouldReturnError {
                seal.reject(error!)
            } else {
                do {
                    guard let jsonData = "\(request.parameters)".data(using: .utf8) else {
                        seal.reject(ErrorHandler.generalError)
                        return}
                    let search = try JSONDecoder().decode(T.self, from: jsonData)
                    seal.fulfill(search)
                } catch {
                    seal.reject(ErrorHandler.generalError)
                }
            }
        }
    }
}


