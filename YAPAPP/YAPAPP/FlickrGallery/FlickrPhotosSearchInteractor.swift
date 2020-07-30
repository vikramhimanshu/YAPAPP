//
//  FlickrPhotosSearchInteractor.swift
//  YAPAPP
//
//  Created by Tantia, Himanshu on 28/7/20.
//  Copyright © 2020 Himanshu Tantia. All rights reserved.
//

import Foundation
import Combine

//The Interactor is a mediator between the presenter and the data. Interactor could have the cache component or deals with other networking aspects of the module and it largely dances to the tunes of the Presenter.
class FlickrPhotosSearchInteractor {

// We could be doing some data manipulation if required in this class.
//    private var searchResult: FlickrPhotosSearchRoot?
//    private var searchResultMetadata: FlickrPhotosSearchResult? {
//        return searchResult?.photos
//    }
    
    //Backward compatibility can be a expensive. We might potentially write extra lines of code:
    //1. Cater to our existing customers.
    //2. At times its about convenience to avoid change (Why touch when its working? - A: Because we needed to add new stuff)
    //3. Announce that old method/API/etc is being migrated to new one - like Apple does
    
    /*We can also do stuff like
    // @available(iOS 13.0, *)

    and support older version by wrapping it with

    #if canImport(SwiftUI)
     .
     .
     .
    #endif
*/
    
    @available(*, deprecated, message: "See wiki/MigratingToSwiftUI")
    //Using descriptive names acts as self-dicumentation and helps newer members wrap their head around quicker. They dont have to debug and guess as to what this could be doing. (for argument sake) Is is getting photos from cache or internet?
    func getPhotos(forSearchText text: String, page: Int, handler completionHandler: @escaping (Result<FlickrPhotosSearchResult, Error>) -> Void) {
        URLSession.shared.request(.photosSearch(withText: text, page: page)) { result in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data):
                do {
                    let searchResult:FlickrPhotosSearchRoot = try JSONDecoder().decode(FlickrPhotosSearchRoot.self, from: data)
//                    self.searchResult = searchResult
                    completionHandler(.success(searchResult.photos))
                } catch let err {
                    completionHandler(.failure(err))
                }
            }
        }
    }
    
    //Using descriptive names acts as self-dicumentation and helps newer members wrap their head around quicker. They dont have to debug and guess as to what this could be doing?
    func getPhotosFromFlickr(forSearchText text: String, page: Int) -> AnyPublisher<FlickrPhotosSearchResult, Error> {
        let endpoint = FlickrEndpoint.photosSearch(withText: text, page: page)
        
        return URLSession.shared
            .dataTaskPublisher(for: endpoint.url!)
            .tryMap { try JSONDecoder().decode(FlickrPhotosSearchRoot.self, from: $0.data).photos }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
