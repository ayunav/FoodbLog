//
//  Tag.swift
//  FoodbLog
//
//  Created by Ikmal Azman on 14/04/2023.
//  Copyright © 2023 Ayuna Vogel. All rights reserved.
//

import Foundation

struct TagResponse : Decodable {
    let results : [Tag]
}

struct Tag : Decodable {
    let description : String
    let URL : TagImage
    
    enum CodingKeys : String, CodingKey {
        case description = "alt_description"
        case URL = "urls"
    }
}

struct TagImage : Decodable {
    let standardResolution : String
    let thumbnailResolution : String
    
    enum CodingKeys : String, CodingKey {
        case standardResolution = "regular"
        case thumbnailResolution = "thumb"
    }
}
