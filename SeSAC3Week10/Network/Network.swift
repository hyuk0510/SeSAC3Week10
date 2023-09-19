//
//  Network.swift
//  SeSAC3Week10
//
//  Created by 선상혁 on 2023/09/19.
//

import Foundation
import Alamofire

class Network {
    static let shared = Network()
    
    private init() {}
    
    func request<T: Decodable>(type: T.Type, api: UnsplashAPI, completion: @escaping (Result<T, SeSACError>) -> Void ) { // search photo
        
        AF.request(api.endpoint, method: api.method, parameters: api.query, encoding: URLEncoding(destination: .queryString), headers: api.header).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(_):
                let statusCode = response.response?.statusCode ?? 500
                guard let error = SeSACError(rawValue: statusCode) else { return }
                
                completion(.failure(error))
            }
        }
    }
}
