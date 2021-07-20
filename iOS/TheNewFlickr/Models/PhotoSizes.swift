//
//  PhotoSizes.swift
//  TheNewFlickr
//
//  Created by Asmaa Tarek on 20/07/2021.
//

import Foundation

// MARK: - PhotoSizes
struct PhotoSizes: Codable {
    let sizes: Sizes?
    let stat: String?
}

// MARK: - Sizes
struct Sizes: Codable {
    let canblog, canprint, candownload: Int?
    let size: [Size]?
}

// MARK: - Size
struct Size: Codable {
    let label: String?
    let width, height: Int?
    let source: String?
    let url: String?
    let media: Media?
}

enum Media: String, Codable {
    case photo = "photo"
}
