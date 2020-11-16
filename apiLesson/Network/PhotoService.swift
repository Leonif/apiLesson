//
//  PhotoService.swift
//  apiLesson
//
//  Created by Leonid Nifantyev on 13.11.2020.
//

import UIKit

class PhotoService {
    
    private let cacheLife: TimeInterval = 30 * 24 * 60 * 60
    
    var images: [String: UIImage] = [:]
    
    var urlLoaded: ((String) -> Void)?
    
    private static let pathName: String = {
    
        let pathName = "images"
        guard let cachesFolder = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return pathName
        }
        
        let url = cachesFolder.appendingPathComponent(pathName, isDirectory: true)
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        
        return pathName
    }()
    
    
    private func getFileNamePath(url: String) -> String? {
        guard let cachesFolder = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let hashName = url.split(separator: "/").last ?? "default"
        return cachesFolder.appendingPathComponent(PhotoService.pathName + "/" + hashName).path
    }
    
    private func saveImageToCache(url: String, image: UIImage) {
        guard let filename = getFileNamePath(url: url), let data = image.pngData() else { return }
        
        FileManager.default.createFile(atPath: filename, contents: data, attributes: nil)
    }
    
    private func getImageFromCache(url: String) -> UIImage? {
        guard
            let filename = getFileNamePath(url: url),
            let info = try? FileManager.default.attributesOfItem(atPath: filename),
            let creationDate = info[FileAttributeKey.modificationDate] as? Date else {
            return nil
        }
        
        
        let lifetime = Date().timeIntervalSince(creationDate)
        
        guard lifetime <= cacheLife, let image = UIImage(contentsOfFile: filename) else {
            return nil
        }
        
        DispatchQueue.main.async {
            self.images[url] = image
        }
        
        return image
    }
    
    private func loadPhoto(url: String,completion: @escaping (UIImage) -> Void) {
        var image: UIImage = UIImage()
        DispatchQueue.global().async {
            let data = try! Data(contentsOf: URL(string: url)!)
            
            DispatchQueue.main.async {
                image = UIImage(data: data)!
                self.images[url] = image
                completion(image)
            }
            
            self.saveImageToCache(url: url, image: image)
        }
    }
    
    
    func photo(url: String, completion: @escaping (UIImage) -> Void) {
        
        if let photo = images[url] {
            completion(photo)
        } else if let photo = getImageFromCache(url: url) {
            completion(photo)
        } else {
            loadPhoto(url: url, completion: completion)
        }
    }
    
}
