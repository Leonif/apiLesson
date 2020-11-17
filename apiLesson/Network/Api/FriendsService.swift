//
//  FriendsService.swift
//  apiLesson
//
//  Created by Leonid Nifantyev on 28.09.2020.
//

import Foundation
import PromiseKit

class FriendsService: NetworkService {
    
    func getFirendInfo() -> Promise<[FriendInfo]> {
        firstly {
            self.getFriendList()
        }.then { list -> Promise<[FriendInfo]> in
            self.makeRequest(method: "users.get", queryItems: [
                .init(name: "user_ids", value: list.friendIds.map {"\($0)"}.joined(separator: ",") ),
                .init(name: "fields", value: "photo_50, verified"),
                .init(name: "name_case", value: "Nom"),
            ])
        }
        
    }
    
    private func getFriendList() -> Promise<FriendList> {
        return makeRequest(method: "friends.get", queryItems: [.init(name: "count", value: "10"),])
    }
}
