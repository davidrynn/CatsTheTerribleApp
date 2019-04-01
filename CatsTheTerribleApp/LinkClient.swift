//
//  LinkClient.swift
//  CatsTheTerribleApp
//
//  Created by David Rynn on 10/25/18.
//  Copyright © 2018 Rynn, David. All rights reserved.
//

import Foundation
struct LinkClient {
    let networkClient: NetworkClient
    
    func getImageDataFromLink(url: URL, completion: @escaping (Foundation.Data?, Error?)->()) {
        networkClient.getLinkData(url: url) { data, responseError in
            completion(data, responseError)
        }
    }
}
