//
//  NetworkRequest.swift
//  YAPAPP
//
//  Created by Tantia, Himanshu on 28/7/20.
//  Copyright © 2020 Himanshu Tantia. All rights reserved.
//

import Foundation

enum RequestError : Error {
    case flickrEndpoint
    case requestFailed(Error)
    case unknown
}

//Depending on the use case, we can define a method in an extension instead of defining a whole class for handing network requests. This is also easily testable and infact reduces the complexity.
extension URLSession {
    
    func request(_ endpoint: FlickrEndpoint, handler completionHandler: @escaping (Result<Data, RequestError>) -> Void) {
        guard let url = endpoint.url else {
            return completionHandler(.failure(RequestError.flickrEndpoint))
        }
        
        let task = self.dataTask(with: url) { data, response, error in
            if let err = error {
                completionHandler(.failure(.requestFailed(err)))
            }
            guard let reqData = data else {
                return completionHandler(.failure(.unknown))
            }
            completionHandler(.success(reqData))
        }
        task.resume()
    }
}
