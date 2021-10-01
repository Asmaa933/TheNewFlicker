//
//  SearchModel.swift
//  TheNewFlickr
//
//  Created by Asmaa Tarek on 14/07/2021.
//

import Foundation

// MARK: - SearchModel
struct SearchModel: Codable {
    let photos: Photos?
    let state: String?
    
    enum CodingKeys: String, CodingKey {
        case state = "stat"
        case photos
    }
}

// MARK: - Photos
struct Photos: Codable {
    let page, pages, perpage, total: Int?
    let photo: [Photo]?
}

// MARK: - Photo
struct Photo: Codable {
    let id, owner, secret, server: String?
    let farm: Int?
    let title: String?
    let ispublic, isfriend, isfamily: Int?
    
    func getImageUrl() -> String {
        guard let serverId = server,
                let id = id,
                let secret = secret
          else { return ""}
          return APIInfo.imageURL + serverId + "/\(id)_\(secret).jpg"
    }
}
