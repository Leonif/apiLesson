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
    
    func getFirendInfo() -> Promise<[FriendInfo]> {
        let promise = Promise<[FriendInfo]>()
        let friendListPromise = getFriendList()
        
        friendListPromise.add(callback: { [unowned self] (result) in
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
                let friendInfoPromise: Promise<[FriendInfo]> = makeRequest(request)
                friendInfoPromise.add { (result) in
                    switch result {
                    case let .success(info):
                        DispatchQueue.main.async { promise.fullfill(with: info) }
                    case let.failure(error):
                        DispatchQueue.main.async { promise.reject(with: error) }
                    }
                }
            case let .failure(error):
                DispatchQueue.main.async { promise.reject(with: error) }
            }
        })
        
        return promise
    }
    
    private func getFriendList() -> Promise<FriendList> {
        let promise = Promise<FriendList>()
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

        
        let requestPromise: Promise<FriendList> = makeRequest(request)
        requestPromise.add { (result) in
            switch result {
            case let .success(list):
                promise.fullfill(with: list)
            case let .failure(error):
                promise.reject(with: error)
            }
        }
        
        return promise
        
    }
    
    private func makeRequest<Output: Codable>(_ request: URLRequest) -> Promise<Output> {
        let promise = Promise<Output>()
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: request) { (data, response, error) in
            let decoder = JSONDecoder()
            if let response = try? decoder.decode(VKResponse<Output>.self, from: data!) {
                promise.fullfill(with: response.data)
            } else {
                ApiManager.session.eraseAll()
                promise.reject(with: VKError.uknown)
            }
        }
        task.resume()
        
        return promise
    }
}
