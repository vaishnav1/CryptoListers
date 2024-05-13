//
//  NetworkService.swift
//  CryptoListers
//
//  Created by Vaishnav on 13/05/24.
//

import Foundation

class NetworkService {
    
    static let sharedInstance = NetworkService()
    
    let apiToken = "37656be98b8f42ae8348e4da3ee3193f"
    let baseUrl = "https://"
    let endPointUrl = ".api.mockbin.io/"
    
    private init() { }
    
    func getCryptoData(completion: @escaping (Result<[DataResponseModel], ErrorMessage>) -> Void) {
        let endpoint = baseUrl + apiToken + endPointUrl
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(.unableToComplete))
            return
        }
        
        let _ = URLSession.shared.dataTask(with: url) { data, response, error in
            
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
                let decoder = JSONDecoder()
                let responseData = try decoder.decode([DataResponseModel].self, from: data)
                completion(.success(responseData))
            } catch {
                completion(.failure(.invalidData))
            }
        }.resume()
    }
    
}
