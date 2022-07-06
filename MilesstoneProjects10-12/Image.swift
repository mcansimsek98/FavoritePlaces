//
//  Image.swift
//  MilesstoneProjects10-12
//
//  Created by Mehmet Can Şimşek on 6.07.2022.
//

import Foundation

class Image: NSObject, Codable {
    
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.image = image
        self.name = name
    }
}
