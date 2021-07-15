//
//  Requestable.swift
//  TheNewFlickr
//
//  Created by Asmaa Tarek on 15/07/2021.
//

import Foundation
import Alamofire

protocol Requestable {
    var path: String {get}
    var method: HTTPMethod {get}
    var parameters:  [String: Any] {get}
    var headers: HTTPHeaders {get}
    var encoding: ParameterEncoding {get}
}
