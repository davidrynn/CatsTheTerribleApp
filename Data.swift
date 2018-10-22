//
//  MediaFile.swift
//  CatsTheTerribleApp
//
//  Created by Rynn, David on 10/22/18.
//  Copyright © 2018 Rynn, David. All rights reserved.
//

import UIKit

protocol MediaHashable {
    var string: String { get set }
    var image: UIImage? { get set }
    
}

struct Data: MediaHashable {
    var string: String
    var image: UIImage?
}
