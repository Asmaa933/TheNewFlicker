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
    
    func getResponse(page: Int) -> Data? {
        var responseData: Data?
        if page == 1 {
            responseData = try? JSONSerialization.data(withJSONObject: successResponse1, options: .prettyPrinted)
        } else {
            responseData = try? JSONSerialization.data(withJSONObject: successResponse2, options: .prettyPrinted)
        }
        return responseData
    }
}


extension MockApiHandler: ApiHandlerProtocol {
    func getPhotosSearch(page: Int) -> Promise<SearchModel> {
        return Promise<SearchModel> { seal in
            if shouldReturnError {
                seal.reject(error!)
            } else {
                do {
                    let search = try JSONDecoder().decode(SearchModel.self, from: getResponse(page: page)!)
                    seal.fulfill(search)
                } catch {
                    seal.reject(ErrorHandler.generalError)
                }
            }
        }
    }
}


