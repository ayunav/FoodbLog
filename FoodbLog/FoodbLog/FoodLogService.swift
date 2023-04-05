//
//  FoodLogService.swift
//  FoodbLog
//
//  Created by Ikmal Azman on 05/04/2023.
//  Copyright © 2023 Ayuna Vogel. All rights reserved.
//

import Foundation

final class FoodLogService {
    let session : URLSessionContract
    
    init(_ session : URLSessionContract = URLSession.shared) {
        self.session = session
    }
    
    private var decoder : JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func requestAPI<Element : Decodable>(for url : URLRequest, _ type : Element.Type, _ completion : @escaping ((Result<Element,Error>)->Void)) {
        session.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print("Error requesting API : \(error.localizedDescription)")
                completion(.failure(error))
            }
            
            guard let data = data else {return}
            
            do {
                let element = try self.decoder.decode(Element.self, from: data)
                completion(.success(element))
            } catch {
                print("Error to decode data : \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        .resume()
    }
}
