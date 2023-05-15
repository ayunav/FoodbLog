//
//  Restaurant.swift
//  FoodbLog
//
//  Created by Ikmal Azman on 09/04/2023.
//  Copyright © 2023 Ayuna Vogel. All rights reserved.
//

import Foundation

struct RestaurantResponse : Decodable {
    let results : [Restaurant]
}

struct Restaurant : Decodable {
    let name : String?
    let location : RestaurantLocation?
}

struct RestaurantLocation : Decodable {
    let formattedAddress : String
    
    enum CodingKeys : String, CodingKey {
        case formattedAddress = "formatted_address"
    }
}
