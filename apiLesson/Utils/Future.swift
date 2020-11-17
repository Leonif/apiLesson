//
//  Future.swift
//  apiLesson
//
//  Created by Leonid Nifantyev on 09.11.2020.
//

import Foundation

//class Future<T> {
//    typealias FutureResult = Result<T, VKError>
//    typealias Callback = ((FutureResult) -> Void)
//    
//    var result: FutureResult? {
//        didSet {
//            guard let result = result else { return }
//            callbackList.forEach { callback in
//                callback(result)
//            }
//        }
//    }
//    
//    private var callbackList: [Callback] = []
//    
//    func add(callback: @escaping Callback) {
//        callbackList.append(callback)
//    }
//}
//
//
//extension Future {
//    func map<NewType>(with clousure: @escaping (T) throws -> NewType) -> Future<NewType> {
//        let promise = Promise<NewType>()
//        add { (result) in
//            switch result {
//            case let .success(value):
//                do {
//                    let mappedValue = try clousure(value)
//                    promise.fullfill(with: mappedValue)
//                } catch  {
//                    promise.reject(with: VKError.uknown)
//                }
//            case let .failure(error):
//                promise.reject(with: error)
//            }
//        }
//        
//        return promise
//    }
//}
//
//
//
//class Promise<T>: Future<T> {
//    
//    func fullfill(with value: T) {
//        result = .success(value)
//    }
//    
//    func reject(with error: VKError) {
//        result = .failure(error)
//    }
//}
