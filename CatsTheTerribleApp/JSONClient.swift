//
//  JSONClient.swift
//  CatsTheTerribleApp
//
//  Created by David Rynn on 10/25/18.
//  Copyright © 2018 Rynn, David. All rights reserved.
//

import Foundation

struct JSONClient {
    let networkClient: NetworkClient
    
    func getMediaItemFromJSON(type: CallReturnType, completion: @escaping (MediaItemStruct?, JSONError?) -> Void) {
            networkClient.getJSONData(type: type) { data, response in
                guard let jsonData = data else {
                    completion(nil, .noData)
                    return
                }
                do {
                    let media = try JSONDecoder().decode(MediaItemStruct.self, from: jsonData)
                    completion(media, nil)
                } catch {
                    completion(nil, .unableToDecode)
                }
        }
    }
}

enum JSONError: Error, CustomStringConvertible {
    case noData, unableToDecode
    var description: String {
        switch self {
        case .noData:
            return "No data"
        case .unableToDecode:
            return "Unable to decode data"
        }
    }
}
