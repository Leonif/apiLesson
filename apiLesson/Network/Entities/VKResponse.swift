//
//  VKResponse.swift
//  apiLesson
//
//  Created by Leonid Nifantyev on 09.11.2020.
//

import Foundation

struct VKResponse<T: Codable>: Codable {
    let data: T
    
    enum CodingKeys: String, CodingKey {
        case data = "response"
    }
}


// MARK: - Response
struct ApiEror: Codable {
    let error: ApiError

    enum CodingKeys: String, CodingKey {
        case error = "error"
    }
}

// MARK: - Error
struct ApiError: Codable {
    let errorCode: Int
    let errorMsg: String
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case errorMsg = "error_msg"
    }
}

enum VKError: Error, LocalizedError {
    case uknown
    
    var errorDescription: String? {
        return "turn on VPN"
    }
}
