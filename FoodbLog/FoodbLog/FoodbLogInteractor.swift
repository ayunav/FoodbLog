//
//  FoodbLogInteractor.swift
//  FoodbLog
//
//  Created by Ikmal Azman on 09/04/2023.
//  Copyright © 2023 Ayuna Vogel. All rights reserved.
//

import Foundation

final class FoodbLogInteractorImpl {
    
    let client : HttpClient
    
    init(client: HttpClient = HttpClient()) {
        self.client = client
    }
    
    func requestRestaurantName(_ name : String,
                               _ latitute: String,
                               _ longitude:String , _ completion : @escaping (Result<RestaurantResponse, Error>)->Void) {
        print(FoodbLogService.searchRestaurant(query: name, latitute: latitute, longitude: longitude).endpoint)
        guard let url = URL(string: FoodbLogService.searchRestaurant(query: name, latitute: latitute, longitude: longitude).endpoint) else {
            return
        }
        
        let headers = [
            "accept": "application/json",
            "Authorization": "fsq330X+8o6/JsdNbbyzjYaEqXORJTZvanpmRWgb4MVsW8E="
        ]
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        client.performRequest(request, RestaurantResponse.self) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
}
