//
//  NetworkBasic.swift
//  SeSAC3Week10
//
//  Created by 선상혁 on 2023/09/19.
//

import Foundation
import Alamofire

enum SeSACError: Int, Error, LocalizedError {
    case unauthorized = 401
    case permissionDenied = 403
    case invalidServer = 500
    case missingParamter = 400
    
    var errorDescription: String {
        switch self {
        case .unauthorized:
            return "인증 정보가 없습니다"
        case .permissionDenied:
            return "권한이 없습니다"
        case .invalidServer:
            return "서버 점검 중입니다"
        case .missingParamter:
            return "검색어를 입력해주세요"
        }
    }
}

final class NetworkBasic {
    
    static let shared = NetworkBasic()
    
    private init() {}
    
    func request(api: UnsplashAPI, query: String, completion: @escaping (Result<Photo, SeSACError>) -> Void ) { // search photo
        
        AF.request(api.endpoint, method: api.method, parameters: api.query, encoding: URLEncoding(destination: .queryString), headers: api.header).responseDecodable(of: Photo.self) { response in
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

    func random(api: UnsplashAPI, completion: @escaping (Result<PhotoResult, SeSACError>) -> Void) { // random photo
        
        AF.request(api.endpoint, method: api.method, headers: api.header).responseDecodable(of: PhotoResult.self) { response in
            switch response.result {
            case .success(let data): completion(.success(data))
            case .failure(_):
                let statusCode = response.response?.statusCode ?? 500
                guard let error = SeSACError(rawValue: statusCode) else { return }
                completion(.failure(error))
            }
        }
    }
    
    func detailPhoto(api: UnsplashAPI, id: String, completion: @escaping (Result<PhotoResult, SeSACError>) -> Void) {
        
        AF.request(api.endpoint, method: api.method, headers: api.header).responseDecodable(of: PhotoResult.self) { response in
            switch response.result {
            case .success(let data): completion(.success(data))
            case .failure(_):
                let statusCode = response.response?.statusCode ?? 500
                guard let error = SeSACError(rawValue: statusCode) else { return }
                completion(.failure(error))
            }
        }
    }
}
