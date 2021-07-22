//
//  HomeViewModelTests.swift
//  TheNewFlickrTests
//
//  Created by Asmaa Tarek on 21/07/2021.
//

import XCTest
@testable import TheNewFlickr

class HomeViewModelTests: XCTestCase {

    var viewModel: HomeViewModel!
    var mockApi: MockApiHandler!
    
    override func setUpWithError() throws {
        viewModel = HomeViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockApi = nil
    }
    
    func testGetPhotos() {
        viewModel.startRequest(request: NetworkingApi.getSearchPhotos(page: 1), mappingClass: SearchModel.self) { response in
           XCTAssertTrue(response?.photos?.photo?.count == 3)
           XCTAssertTrue(response?.photos?.photo?.first?.id == "51311711581")
           XCTAssertTrue(self.viewModel.state == .populated)
        }
    }
    
    func testFetchApiSuccess() {
        mockApi = MockApiHandler(shouldReturnError: false)
        mockApi.fetchData(request: NetworkingApi.getSearchPhotos(page: 1), mappingClass: SearchModel.self).done { response in
            XCTAssertTrue(response.photos?.photo?.count == 3)
            
        }.catch { error in
            XCTAssertNil(error)
        }
    }
    
    func testFetchApiFail() {
        mockApi = MockApiHandler(shouldReturnError: true, error: ErrorHandler.generalError)
        mockApi.fetchData(request: NetworkingApi.getSearchPhotos(page: 1), mappingClass: SearchModel.self).done { _ in
        }.catch { error in
            XCTAssertNotNil(error)
            XCTAssertEqual((error as! ErrorHandler).rawValue , ErrorHandler.generalError.rawValue)
        }
    }
}
