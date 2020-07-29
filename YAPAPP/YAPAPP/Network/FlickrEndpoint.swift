//
//  FlickrEndpoints.swift
//  YAPAPP
//
//  Created by Tantia, Himanshu on 28/7/20.
//  Copyright © 2020 Himanshu Tantia. All rights reserved.
//

import Foundation

fileprivate let flickrKey = "a3700e2783fac493a6c760151eb81a2c"
fileprivate let flickrSecret = "66fa2c8fab391f97"

//This is a clean way to both manage multiple sources and multiple APIs from the same source. 

struct FlickrEndpoint {
    let path: String = "/services/rest/"
    let queryItems: [URLQueryItem]
}

extension FlickrEndpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.flickr.com"
        components.path = path
        components.queryItems = queryItems
        
        return components.url
    }
}

extension FlickrEndpoint {
    static func photosSearch(withText text: String = "kittens", page : Int) -> FlickrEndpoint {
        return FlickrEndpoint(queryItems: [
            URLQueryItem(name: "method", value: "flickr.photos.search"),
            URLQueryItem(name: "api_key", value: flickrKey),
            URLQueryItem(name: "text", value: text),
            URLQueryItem(name: "per_page", value: String("\(100)")),
            URLQueryItem(name: "page", value: String("\(page)")),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1"),
        ])
    }
}

