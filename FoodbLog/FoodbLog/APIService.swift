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
}

extension APIProvider {
    var url : String {
        switch self {
        case .foursquare:
            return "https://api.foursquare.com/v3/"
        }
    }
}
