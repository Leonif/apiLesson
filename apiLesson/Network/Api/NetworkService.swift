//
//  NetworkService.swift
//  apiLesson
//
//  Created by Leonid Nifantyev on 16.11.2020.
//

import Foundation
import PromiseKit

class NetworkService {
    
    let baseHost: String = "api.vk.com"
    var version: String { return "5.124" }
    let configuration = URLSessionConfiguration.default
    
    func makeRequest<Output: Codable>(method: String, queryItems: [URLQueryItem] = []) -> Promise<Output> {
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = self.baseHost
        urlConstructor.path = "/method/\(method)"
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "user_id", value: ApiManager.session.userId),
            URLQueryItem(name: "access_token", value: ApiManager.session.token),
            URLQueryItem(name: "v", value: version),
        ]
        
        urlConstructor.queryItems?.append(contentsOf: queryItems)
        
        let request = URLRequest(url: urlConstructor.url!)
        let session = URLSession(configuration: configuration)
        
        return Promise { seal in
            let task = session.dataTask(with: request) { (data, response, apiError) in
                
                if let error = apiError {
                    seal.reject(error)
                }
                
                let decoder = JSONDecoder()
                
                do {
                    let response = try decoder.decode(VKResponse<Output>.self, from: data!)
                    seal.fulfill(response.data)
                    debugPrint(ApiManager.session.token)
                } catch let decodingError {
                    ApiManager.session.eraseAll()
                    debugPrint(decodingError)
                    seal.reject(decodingError)
                }
            }
            task.resume()
        }
    }
}
