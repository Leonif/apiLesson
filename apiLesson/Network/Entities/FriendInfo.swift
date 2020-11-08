//
//  FriendInfo.swift
//  apiLesson
//
//  Created by Leonid Nifantyev on 09.11.2020.
//

import Foundation

// MARK: - Response
struct FriendList: Codable {
    let friendIds: [Int]

    enum CodingKeys: String, CodingKey {
        case friendIds = "items"
    }
}


// MARK: - ResponseElement
struct FriendInfo: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let canAccessClosed: Bool
    let isClosed: Bool
    let photo50: String
    let verified: Int

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case id = "id"
        case lastName = "last_name"
        case canAccessClosed = "can_access_closed"
        case isClosed = "is_closed"
        case photo50 = "photo_50"
        case verified = "verified"
    }
}
