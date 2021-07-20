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
    let response = searchResponse

    override func setUpWithError() throws {
        viewModel = HomeViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }
    
    func testGetPhotos() {
        viewModel.startRequest(request: NetworkingApi.getSearchPhotos(page: 1), mappingClass: SearchModel.self) { response in
           XCTAssertTrue(response?.photos?.photo?.count == 3)
           XCTAssertTrue(response?.photos?.photo?.first?.id == "51311711581")
           XCTAssertTrue(self.viewModel.state == .populated)
        }
    }
}
