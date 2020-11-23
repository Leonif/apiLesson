//
//  AsyncImageView.swift
//  apiLesson
//
//  Created by Leonid Nifantyev on 23.11.2020.
//

import UIKit
import CoreImage

final class AsyncImageView: UIImageView {
    
    private var _image: UIImage?
    
    override var image: UIImage? {
        get {
            return _image
        }
        set {
            _image = newValue
            layer.contents = .none
            
            guard let image = newValue else { return }
            DispatchQueue.global(qos: .userInitiated).async {
                let decodedCGIImage = self.decode(image)
                DispatchQueue.main.async {
                    self.layer.contents = decodedCGIImage
                }
            }
        }
    }
    
    
    private func decode(_ image: UIImage) -> CGImage? {
        guard let newImage = image.cgImage else { return nil }
        
        if let cachedImage = AsyncImageView.cache.object(forKey: image) {
            return (cachedImage as! CGImage)
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: .none, width: newImage.width, height: newImage.height, bitsPerComponent: 8, bytesPerRow: newImage.width * 8, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
        let imgRect = CGRect(x: 0, y: 0, width: newImage.width, height: newImage.height)
        let maxDimension = CGFloat(max(newImage.width, newImage.height))
        let cornerRaduisPath = UIBezierPath(roundedRect: imgRect, cornerRadius: maxDimension/2).cgPath
        context?.addPath(cornerRaduisPath)
        context?.clip()
        context?.draw(newImage, in: CGRect(x: 0, y: 0, width: newImage.width, height: newImage.height))
        
        guard let drawnImage = context?.makeImage() else { return .none }
        AsyncImageView.cache.setObject(drawnImage, forKey: image)
        return drawnImage
        
    }
}


extension AsyncImageView {
    private struct Cache {
        static var instance = NSCache<AnyObject, AnyObject>()
    }
    
    class var cache: NSCache<AnyObject, AnyObject> {
        get { return Cache.instance }
        set { Cache.instance = newValue}
    }
}
