//
//  ImagingService.swift
//  CatsTheTerribleApp
//
//  Created by David Rynn on 10/25/18.
//  Copyright © 2018 Rynn, David. All rights reserved.
//

import UIKit

typealias ImageClosure = (UIImage?, Error?) -> ()

protocol ImagingServiceProtocol {
    func getImage(type: CallReturnType, handler: @escaping (UIImage?, Error?) -> ())
}

final class ImagingService: ImagingServiceProtocol {
    let linkClient: LinkClient
    let jSONClient: JSONClient
    
    init() {
        let networkClient = NetworkClient()
        self.linkClient = LinkClient(networkClient: networkClient)
        self.jSONClient = JSONClient(networkClient: networkClient)
    }
    
    func getImage(type: CallReturnType, handler: @escaping ImageClosure) {
        jSONClient.getMediaItemFromJSON(type: type) { mediaItem, jsonError in
            if let mediaStruct = mediaItem, let urlString = mediaStruct.url, let url = URL(string: urlString) {
                self.linkClient.getImageDataFromLink(url: url) { data, error in
                    if let imageData = data {
                        var image: UIImage?
                        switch type {
                        case .gif:
                            image = UIImage.gifImageWithData(imageData)
                        case .random, .tag, .text, .url:
                            image = UIImage(data: imageData)
                        }
                        handler(image, nil)
                    } else {
                        handler(nil, error)
                    }
                }
            }
         }
    }
}
