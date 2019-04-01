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

struct MediaItemStruct: Codable {
    let id: String?
    let url: String?
    let breeds: [String]?
    let categories: [String]?
}
