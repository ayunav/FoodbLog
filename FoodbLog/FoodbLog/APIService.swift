//
//  APIService.swift
//  FoodbLog
//
//  Created by Ikmal Azman on 09/04/2023.
//  Copyright © 2023 Ayuna Vogel. All rights reserved.
//

import Foundation

protocol APIService {
    var baseURL : APIProvider {get}
    var endpoint : String {get}
    func createEndpoint(_ endpoint : String)-> String
}

enum APIProvider {
    case foursquare
    case fork2forkCA
    case unsplash
}

extension APIProvider {
    var url : String {
        switch self {
        case .foursquare:
            return "https://api.foursquare.com/v3/"
        case .fork2forkCA :
            return "https://food2fork.ca/api/recipe/"
        case .unsplash:
            return "https://api.unsplash.com/"
        }
    }
}
