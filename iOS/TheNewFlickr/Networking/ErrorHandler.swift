//
//  ErrorHandler.swift
//  TheNewFlickr
//
//  Created by Asmaa Tarek on 15/07/2021.
//

import Foundation

enum ErrorHandler: String, Error {
    case noInternetConnection = "No Internet Connection"
    case generalError = "Something went wrong, try again"
}
