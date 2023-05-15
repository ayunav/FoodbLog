//
//  Recipe.swift
//  FoodbLog
//
//  Created by Ikmal Azman on 10/04/2023.
//  Copyright © 2023 Ayuna Vogel. All rights reserved.
//

import Foundation

struct RecipeResponse : Decodable {
    let results : [Recipe]
}

struct Recipe : Decodable {
    let imageURL : String
    let title : String
    let ingredients : [String]
    
    enum CodingKeys : String, CodingKey {
        case title, ingredients
        case imageURL = "featured_image"
    }
}
