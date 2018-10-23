//
//  NetworkClient.swift
//  CatsTheTerribleApp
//
//  Created by Rynn, David on 10/22/18.
//  Copyright © 2018 Rynn, David. All rights reserved.
//

import Foundation

// Will use https://cataas.com

protocol NetworkClientProtocol {
    func getMediaItems(type: CallReturnType, completion: @escaping (Foundation.Data?, ResponseError?) -> ())
//    func post(_ items: [MediaFile], completion: (ResponseError?) -> ())
}

final class NetworkClient: NetworkClientProtocol {
    func getMediaItems(type: CallReturnType, completion: @escaping (Foundation.Data?, ResponseError?) -> ()) {
        let session = URLSession(configuration: .default)
        let url = self.makeURL(type)
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                if let imageData = data, ((200 ... 299).contains( httpResponse.statusCode)) {
                    completion(imageData, nil)
                } else {
                    let httpError = ResponseError.networkError(code: httpResponse.statusCode)
                    completion(nil, httpError)
                }

            }
            if error != nil, let error = error as NSError? {
                let responseError = ResponseError.unknownNetworkError
                completion(nil, responseError)

                }

            })
        
        task.resume()
        
    }
    
//    func post(_ items: [MediaFile], completion: (ResponseError?) ->()) {
//        let session = URLSession(configuration: .default)
//        let url = self.makeURL(.random)
//    }
    
    private func makeURL(_ callType: CallReturnType) -> URL {
        let fullURLString = "https://cataas.com/" + callType.description
        guard let url = URL(string: fullURLString) else {
            fatalError("unable to build URL from string")
        }
        return url
    }
}


enum ResponseError: Error {
    case networkError(code: Int)
    case unknownNetworkError
}

enum CallReturnType: CustomStringConvertible {
    case random
    case gif
    case tag(_ tag: String)
    case text(_ text: String)
    
    var description: String {
        switch self {
        case .random:
            return "cat"
        case .gif:
            return "cat/gif"
        case let .tag(tag):
            return "cat/\(tag)"
        case let .text(text):
            return "cat/says/\(text)"
        }
    }
}
