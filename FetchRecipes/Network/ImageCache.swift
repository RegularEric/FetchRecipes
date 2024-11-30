//
//  ImageCache.swift
//  FetchRecipes
//
//  Created by Eric Chang on 11/29/24.
//

import Foundation
import SwiftUI

protocol ImageCaching {
  func fetchImage(for url: URL) async -> UIImage?
}

final class ImageCache: ImageCaching {
  private let cacheQueue = DispatchQueue(label: "com.fetchRecipes.imagecache.queue")
  private var memoryCache = NSCache<NSURL, UIImage>()
  private let fileManager = FileManager.default
  private let diskCacheURL: URL
  
  init() {
    let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
    diskCacheURL = cacheDirectory.appendingPathComponent("ImageCache")
    
    if !fileManager.fileExists(atPath: diskCacheURL.path) {
      try? fileManager.createDirectory(at: diskCacheURL, withIntermediateDirectories: true, attributes: nil)
    }
  }
  
  func fetchImage(for url: URL) async -> UIImage? {
    if let image = getImage(for: url) {
      return image
    } else if let newImage = await getNewImage(for: url) {
      return newImage
    }
    return nil
  }
}

extension ImageCache {
  private func getImage(for url: URL) -> UIImage? {
    if let image = memoryCache.object(forKey: url as NSURL) {
      return image
    }
    
    let diskURL = diskCacheURL.appendingPathComponent(cacheKey(for: url))
    if let image = UIImage(contentsOfFile: diskURL.path) {
      memoryCache.setObject(image, forKey: url as NSURL)
      return image
    }
    return nil
  }
  
  private func getNewImage(for url: URL, retries: Int = 3) async -> UIImage? {
    for attempt in 1...retries {
      do {
        /// Time saver!
        /// We can also pass in the NetworkClient here if we want to avoid URLSession everywhere since network calls are not part of disk caching.
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let uiImage = UIImage(data: data) else { throw NetworkError.invalidData }
        saveImage(uiImage, for: url)
        return uiImage
      } catch {
        if attempt == retries {
          print("Failed after \(retries) attempts: \(error.localizedDescription)")
        }
      }
    }
    return nil
  }
  
  private func saveImage(_ image: UIImage, for url: URL) {
    cacheQueue.async {
      self.memoryCache.setObject(image, forKey: url as NSURL)
      let diskURL = self.diskCacheURL.appendingPathComponent(self.cacheKey(for: url))
      if let data = image.jpegData(compressionQuality: 1.0) {
        try? data.write(to: diskURL)
      }
    }
  }
  
  private func cacheKey(for url: URL) -> String {
    url.absoluteString.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? url.absoluteString
  }
}

extension ImageCache {
#if DEBUG
  func saveImageForTesting(_ image: UIImage, for url: URL) {
    memoryCache.setObject(image, forKey: url as NSURL)
  }
#endif
}
