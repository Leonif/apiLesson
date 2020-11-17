//
//  NewsFeedService.swift
//  apiLesson
//
//  Created by Leonid Nifantyev on 16.11.2020.
//

import PromiseKit


class NewsFeedService: NetworkService {
    
    override var version: String { return "5.68" }
    
    func getFeed() -> Promise<Feed> {
        return self.makeRequest(method: "newsfeed.get", queryItems: [
            .init(name: "filters", value: "post")
        ])
    }
}
