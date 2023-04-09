//
//  HttpClient.swift
//  FoodbLog
//
//  Created by Ikmal Azman on 09/04/2023.
//  Copyright © 2023 Ayuna Vogel. All rights reserved.
//

import Foundation

final class HttpClient {
    
    private let session : URLSessionContract
    
    init(session: URLSessionContract = URLSession.shared) {
        self.session = session
    }
    
    func performRequest<Element:Decodable>(_ request : URLRequest,
                                           _ model : Element.Type,
                                           _ completion : @escaping (Result<Element, Error>)->Void) {
        
        downloadData(withURLRequest: request) { result in
            switch result {
            case .success(let data):
                do {
                    let object = try self.processData(data, model)
                    completion(.success(object))
                } catch {
                    completion(.failure(error))
                }
                
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
    func downloadData(withURLRequest request : URLRequest, _ completion : @escaping (Result<Data, Error>)-> Void) {
        let task = session.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let data = data else {return}
            completion(.success(data))
        }
        task.resume()
    }
    
    func processData<Element:Decodable>(_ data : Data, _ model : Element.Type) throws -> Element {
        let decoder = JSONDecoder()
        let content = try decoder.decode(model, from: data)
        return content
    }
}
