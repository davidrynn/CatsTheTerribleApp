//
//  NetworkClient.swift
//  CatsTheTerribleApp
//
//  Created by Rynn, David on 10/22/18.
//  Copyright © 2018 Rynn, David. All rights reserved.
//

import Foundation

// Will use https://cataas.com https://api.thecatapi.com

protocol NetworkClientProtocol {
    func getJSONData(type: CallReturnType, completion: @escaping (Foundation.Data?, ResponseError?) -> ())
//    func post(_ items: [MediaFile], completion: (ResponseError?) -> ())
}

final class NetworkClient: NetworkClientProtocol {
    
    func getJSONData(type: CallReturnType, completion: @escaping (Foundation.Data?, ResponseError?) -> ()) {
        let url = self.makeURL(type)
        startTask(url: url) { data, error in
            completion(data,error)
        }
    }
    
    func getLinkData(url: URL, completion: @escaping (Foundation.Data?, ResponseError?) -> ()) {
        startTask(url: url) { data, error in
            completion(data, error)
        }
    }
    
    private func startTask(url: URL, completion: @escaping (Foundation.Data?, ResponseError?) -> ()) {
        let session = URLSession(configuration: .default)
        var request = URLRequest(url: url)
        request.setValue("1eea119b-a1cb-44bb-94fa-1b02cbd282fa", forHTTPHeaderField: "x-api-key")
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                if let imageData = data, ((200 ... 299).contains( httpResponse.statusCode)) {
                    completion(imageData, nil)
                } else {
                    let httpError = ResponseError.networkError(code: httpResponse.statusCode)
                    completion(nil, httpError)
                }
            }
            
            if error != nil, let error = error as NSError? {
                let responseError = ResponseError.unknownNetworkError(description: error.localizedDescription)
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
        var fullURLString: String
        switch callType {
        case let .url(text):
            fullURLString = text
        default:
            fullURLString = "https://api.thecatapi.com/v1/images/search?format=json" + callType.description
        }

        guard let url = URL(string: fullURLString) else {
            fatalError("unable to build URL from string")
        }
        return url
    }
}


enum ResponseError: Error {
    case networkError(code: Int)
    case unknownNetworkError(description: String)
}

enum CallReturnType: CustomStringConvertible {
    case random
    case gif
    case tag(_ tag: String)
    case text(_ text: String)
    case url(_ text: String)
    
    var description: String {
        switch self {
        case .random:
            return "&mime_types=jpg,png"
        case .gif:
            return "&mime_types=gif"
        case let .tag(tag):
            return "cat/\(tag)"
        case let .text(text):
            return "cat/says/\(text)"
        case let .url(text):
            return text
        }
    }
}
