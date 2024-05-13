//
//  NetworkService.swift
//  CryptoListers
//
//  Created by Vaishnav on 13/05/24.
//

import Foundation

class NetworkService {
    
    static let sharedInstance = NetworkService()
    
    private init() { }
    
    // MARK: - Network Calls
    
    func getCryptoData(completion: @escaping (Result<[DataResponseModel], ErrorMessage>) -> Void) {
        
        performRequest(endpoint: .getData) { result in
            switch result {
            case .success(let apiResponse):
                completion(.success(apiResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Private helper method
    
    private func performRequest(endpoint: EndPoints, completion: @escaping(Result<[DataResponseModel], ErrorMessage>) -> Void) {
        URLSession.shared.dataTask(with: endpoint.url) { data, response, error in
            if let _ = error {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let apiResponse = try JSONDecoder().decode([DataResponseModel].self, from: data)
                completion(.success(apiResponse))
            } catch {
                completion(.failure(.invalidData))
            }
        }.resume()
    }
    
}
