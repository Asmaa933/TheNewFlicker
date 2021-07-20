//
//  Constants.swift
//  TheNewFlickr
//
//  Created by Asmaa Tarek on 14/07/2021.
//

import Foundation

struct APIInfo {
    static let url = "https://www.flickr.com/services/rest/"
    static let imageURL = "https://live.staticflickr.com/"
    static let key = "94b0a1ad9d4f1aebf9f2f2c006fb4c65"
    static let secret = "c21744829fca03e7"
    
    static func getSearchParams(page: Int) -> [String: String] {
        return ["method": "flickr.photos.search",
                "api_key": key,
                "text": "cat",
                "format": "json",
                "nojsoncallback": "1",
                "page": page.description
        ]
    }
    
    static func getSizesParams(photoId: String) -> [String: String] {
        return ["method": "flickr.photos.getSizes",
                "api_key": key,
                "photo_id": photoId,
                "text": "cat",
                "format": "json",
                "nojsoncallback": "1"
        ]
    }
}
