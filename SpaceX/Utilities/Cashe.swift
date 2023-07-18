//
//  Cashe.swift
//  SpaceX
//
//  Created by Helia Fathi on 7/18/23.
//

import UIKit

protocol PhotoInteractor {
    var createDate: String { get }
    var filename: String { get }
    func downloadPhoto(completion: @escaping (UIImage?, Error?) -> Void)
    func cancelDownloading()
}

class PhotoInteractorImpl: PhotoInteractor {
    
    // MARK: - Public Properties
    
    let createDate: String
    let filename: String
    
    // MARK: - Constructors
    
    init(createDate: String, thumbUrl: URL , filename: String) {
        self.createDate = createDate
        self.thumbUrl = thumbUrl
        self.filename = filename
        
    }
    
    // MARK: - Public Methods
    
    func downloadPhoto(completion: @escaping (UIImage?, Error?) -> Void) {
        if let cachedResponse = PhotoInteractorImpl.cache.cachedResponse(for: URLRequest(url: thumbUrl)),
           let image = UIImage(data: cachedResponse.data) {
            completion(image, nil)
            return
        }
        
        imageDataTask = URLSession.shared.dataTask(with: thumbUrl) { [weak self] (data, _, error) in
            self?.imageDataTask = nil
            
            if let error = error {
                DispatchQueue.main.async { completion(nil, error) }
                return
            }
            
            guard let data = data, let image = UIImage(data: data), error == nil else { return }
            DispatchQueue.main.async { completion(image, nil) }
        }
        
        imageDataTask?.resume()
        
    }
    
    func cancelDownloading() {
        imageDataTask?.cancel()
    }
    
    // MARK: - Private Properties
    
    private let thumbUrl: URL
    private var imageDataTask: URLSessionDataTask?
    private static let cache = URLCache(
        memoryCapacity: 500 * 1024 * 1024,
        diskCapacity: 1000 * 1024 * 1024,
        diskPath: "photo"
    )
    
}
