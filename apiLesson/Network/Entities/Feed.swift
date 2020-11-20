//
//  Feed.swift
//  apiLesson
//
//  Created by Leonid Nifantyev on 16.11.2020.
//

// MARK: - Response
struct Feed: Codable {
    let items: [ResponseItem]

    enum CodingKeys: String, CodingKey {
        case items
    }
}



// MARK: - ResponseItem
struct ResponseItem: Codable {
    var text: String?
    var photoUrl: String?
    
    init(from decoder: Decoder) throws {
        let mainContainer = try decoder.container(keyedBy: MainKeys.self)
        let attachments = try mainContainer.decodeIfPresent([Attachment].self, forKey: .attachments)
        if let attch = attachments?.first, let urlString = attch.photo?.photo130 {
            photoUrl = urlString
        }
        text = try mainContainer.decodeIfPresent(String.self, forKey: .text)
    }
    
    enum MainKeys: String, CodingKey {
        case text
        case attachments

    }
}


// MARK: - Attachment
struct Attachment: Codable {
    let type: String
    let photo: Photo?
    
    enum CodingKeys: String, CodingKey {
        case type
        case photo
    }
}

// MARK: - Comments
struct Comments: Codable {
    let count, canPost: Int
    let groupsCanPost: Bool

    enum CodingKeys: String, CodingKey {
        case count
        case canPost = "can_post"
        case groupsCanPost = "groups_can_post"
    }
}


// MARK: - Photo
struct Photo: Codable {
    let albumId, date, id, ownerId: Int
    let hasTags: Bool
    let accessKey: String?
    let height, width: Int?
    let photo130, photo604, photo75: String?
    let postId: Int?
    let text: String
    let userId: Int?

    enum CodingKeys: String, CodingKey {
        case albumId = "album_id"
        case date, id
        case ownerId = "owner_id"
        case hasTags = "has_tags"
        case accessKey = "access_key"
        case height
        case photo130 = "photo_130"
        case photo604 = "photo_604"
        case photo75 = "photo_75"
        case postId = "post_id"
        case text
        case userId = "user_id"
        case width
    }
}

// MARK: - CopyHistoryPostSource
struct CopyHistoryPostSource: Codable {
    let type: String
}

enum PostTypeEnum: String, Codable {
    case friend = "friend"
    case post = "post"
}

// MARK: - Likes
struct Likes: Codable {
    let count, userLikes, canLike, canPublish: Int

    enum CodingKeys: String, CodingKey {
        case count
        case userLikes = "user_likes"
        case canLike = "can_like"
        case canPublish = "can_publish"
    }
}
