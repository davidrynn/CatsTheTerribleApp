//
//  ImageViewModel.swift
//  CatsTheTerribleApp
//
//  Created by David Rynn on 10/24/18.
//  Copyright © 2018 Rynn, David. All rights reserved.
//

import UIKit

struct ImageViewModel {
    
    let networkClient: NetworkClient
    
    func getImageFromData(type: CallReturnType, data: Foundation.Data,
                          completion: @escaping (Foundation.Data?, ResponseError?)->()) throws {
//         let photoObject = try? JSONDecoder().decode(Photo.self, from: jsonData)
        let mediaItem: MediaItemStruct? =  try? JSONDecoder().decode(MediaItemStruct.self, from: data)
        if let media = mediaItem, let url = URL(string: media.urlString) {
            networkClient.getMediaData(type: type, completion: { data, response in
                completion(data, response)
            })
        }
    }
}

struct MediaItemStruct: Codable {
    let id: String
    let urlString: String
    let breeds: [String]
    let categories: [String]
    
}
