//
//  FlickrPhotosSearch.swift
//  YAPAPP
//
//  Created by Tantia, Himanshu on 28/7/20.
//  Copyright © 2020 Himanshu Tantia. All rights reserved.
//

import Foundation
import SwiftUI

struct FlickrPhotosSearchRoot : Codable {
    let photos: FlickrPhotosSearchResult
    let stat: String
}

struct FlickrPhotosSearchResult : Codable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total : String
    let photo: [FlickrPhoto]
}

struct FlickrPhoto : Codable, Identifiable, Equatable, Hashable {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let ispublic: Int
    let isfriend: Int
    let isfamily: Int
}

extension FlickrPhoto {
    var photoUrl: URL? {
        return URL(string: "http://farm\(self.farm).static.flickr.com/\(self.server)/\(self.id)_\(self.secret).jpg")
    }
}

extension FlickrPhoto {
    var isPublic: Bool {
        return self.ispublic > 0
    }
    var isFriend: Bool {
        return self.isfriend > 0
    }
    var isFamily: Bool {
        return self.isfamily > 0
    }
}
