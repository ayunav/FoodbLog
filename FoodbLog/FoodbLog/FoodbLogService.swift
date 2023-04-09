//
//  FoodbLogService.swift
//  FoodbLog
//
//  Created by Ikmal Azman on 09/04/2023.
//  Copyright © 2023 Ayuna Vogel. All rights reserved.
//

import Foundation

enum FoodbLogService {
    case searchRestaurant(query:String, latitute: String, longitude: String)
}

extension FoodbLogService : APIService {
    var baseURL : APIProvider {
        switch self {
        case .searchRestaurant:
            return .foursquare
        }
    }
    
    var endpoint : String {
        switch self {
        case .searchRestaurant(let query, let latitute, let longitude):
            return createEndpoint("search?query=\(query)&ll=\(latitute)%2C\(longitude)&radius=30000")
        }
    }
    
    func createEndpoint(_ endpoint : String)->String {
        switch self {
        case .searchRestaurant:
            return "\(baseURL.url)places/\(endpoint)"
        }
    }
}
