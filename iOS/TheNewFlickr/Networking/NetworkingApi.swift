//
//  NetworkingApi.swift
//  TheNewFlickr
//
//  Created by Asmaa Tarek on 15/07/2021.
//

import Foundation
import Alamofire

enum NetworkingApi {
    case getSearchPhotos(page: Int)
}

extension NetworkingApi: Requestable {
    
    var path: String {
        return APIInfo.url
    }
    
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .getSearchPhotos(let page):
            return APIInfo.getSearchParams(page: page)
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        default:
            return URLEncoding.default
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        default:
            return HTTPHeaders([])
        }
    }
    
    
}
