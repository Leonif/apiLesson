//
//  FriendsService.swift
//  apiLesson
//
//  Created by Leonid Nifantyev on 28.09.2020.
//

import Foundation


class FriendsService {
    
    private let baseHost: String = "api.vk.com"
    private let version: String = "5.124"
    
    func getFirendInfo(callback: @escaping (Result<[FriendInfo], VKError>) -> Void) {
        getFriendList { [unowned self] (result) in
            switch result {
            case let .success(list):
                var urlConstructor = URLComponents()
                urlConstructor.scheme = "https"
                urlConstructor.host = baseHost
                urlConstructor.path = "/method/users.get"
                
                urlConstructor.queryItems = [
                    URLQueryItem(name: "user_ids", value: list.friendIds.map {"\($0)"}.joined(separator: ",") ),
                    URLQueryItem(name: "fields", value: "photo_50,verified"),
                    URLQueryItem(name: "name_case", value: "Nom"),
                    URLQueryItem(name: "user_id", value: ApiManager.session.userId),
                    URLQueryItem(name: "access_token", value: ApiManager.session.token),
                    URLQueryItem(name: "v", value: version),
                ]
                
                let request = URLRequest(url: urlConstructor.url!)
                makeRequest(request) { result in
                    DispatchQueue.main.async { callback(result) }
                }
            case .failure:
                callback(.failure(VKError.uknown))
            }
        }
    }
    
    private func getFriendList(callback: @escaping (Result<FriendList, VKError>) -> Void) {
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = baseHost
        urlConstructor.path = "/method/friends.get"
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "count", value: "10"),
            URLQueryItem(name: "user_id", value: ApiManager.session.userId),
            URLQueryItem(name: "access_token", value: ApiManager.session.token),
            URLQueryItem(name: "v", value: version),
        ]
        
        let request = URLRequest(url: urlConstructor.url!)
        makeRequest(request, callback: callback)
    }
    
    private func makeRequest<Output: Codable>(_ request: URLRequest, callback: @escaping (Result<Output, VKError>) -> Void) {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: request) { (data, response, error) in
            let decoder = JSONDecoder()
            if let response = try? decoder.decode(VKResponse<Output>.self, from: data!) {
                callback(.success(response.data))
            } else {
                ApiManager.session.eraseAll()
                callback(.failure(VKError.uknown))
            }
            
        }
        task.resume()
    }
}
