//
//  ImageViewModel.swift
//  CatsTheTerribleApp
//
//  Created by David Rynn on 10/24/18.
//  Copyright © 2018 Rynn, David. All rights reserved.
//

import UIKit


struct ImageViewModel {
    
    let imagingService: ImagingService
    
    func getImage(type: CallReturnType, completion: @escaping ImageClosure) {
        imagingService.getImage(type: type) { image, error in
            completion(image, error)
        }
    }
}

struct MediaItemsArrayStruct: Codable {
    
}

struct MediaItemStruct: Codable {
    let id: String?
    let url: String?
    let breeds: [String]?
    let categories: [String]?
  //  "id":"af","url":"https://24.media.tumblr.com/ZabOTt2mpdqnm6k4JXjnAe7D_500.jpg","breeds":[],"categories":[]}]
    enum CodingKeys: String, CodingKey {
        //Encoding/decoding will only include the properties defined in this enum, rest will be ignored
        case id, url, breeds, categories
    }
}
