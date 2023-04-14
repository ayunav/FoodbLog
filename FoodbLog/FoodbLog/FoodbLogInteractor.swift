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
    
    func requestRecipes(_ name : String, _ completion : @escaping (Result<RecipeResponse, Error>)->Void) {
        guard let url = URL(string: FoodbLogService.searchRecipes(query: name).endpoint) else {
            return
        }
        
        let headers = [
            "Authorization": "Token 9c8b06d329136da358c2d00e76946b0111ce2c48"
        ]
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        client.performRequest(request, RecipeResponse.self) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    func requestInstagramHastags(_ name : String, _ completion : @escaping (Result<TagResponse, Error>)->Void) {
        guard let url = URL(string: FoodbLogService.searchFoodsTag(query: name).endpoint) else {
            return
        }
        
        let request = URLRequest(url: url)
        
        client.performRequest(request, TagResponse.self) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
