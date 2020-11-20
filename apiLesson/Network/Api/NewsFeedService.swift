//
//  NewsFeedService.swift
//  apiLesson
//
//  Created by Leonid Nifantyev on 16.11.2020.
//

import PromiseKit


class NewsFeedService: NetworkService {
    
    override var version: String { return "5.68" }
    
    func getFeed(startFrom: String? = nil) -> Promise<Feed> {
        
        var params: [URLQueryItem] = []
        
        if let startFrom = startFrom {
            params = [
                .init(name: "filters", value: "post"),
                .init(name: "start_from", value: startFrom)
            ]
        } else {
            params = [
                .init(name: "filters", value: "post"),
            ]
        }
        
        return self.makeRequest(method: "newsfeed.get", queryItems: params)
    }
}
