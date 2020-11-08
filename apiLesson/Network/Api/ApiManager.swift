//
//  ApiManager.swift
//  apiLesson
//
//  Created by Leonid Nifantyev on 28.09.2020.
//

import Foundation
import SwiftKeychainWrapper

class ApiManager {
    static let session = ApiManager()
    
    var token: String {
        get {
            KeychainWrapper.standard.string(forKey: "vk-api-token") ?? ""
        }
        set {
            KeychainWrapper.standard.set(newValue, forKey: "vk-api-token")
        }
    }
    var userId: String {
        get {
            KeychainWrapper.standard.string(forKey: "vk-api-user-id") ?? ""
        }
        set {
            KeychainWrapper.standard.set(newValue, forKey: "vk-api-user-id")
        }
    }
    
    func eraseAll() {
        KeychainWrapper.standard.removeAllKeys()
    }
    
    private init() {}
    
}
