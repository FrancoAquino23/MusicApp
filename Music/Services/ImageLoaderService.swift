//
//  ImageLoaderService.swift
//  Music
//
//  Created by Fran on 18/10/25.
//

import SwiftUI
import Combine

class ImageLoaderService: ObservableObject {
    
    @Published var image: UIImage?
    private static let imageCache = NSCache<NSString, UIImage>()
    private var cancellable: AnyCancellable?
    private let urlString: String
    private var isLoading = false
    init(urlString: String) {
        self.urlString = urlString
        load()
    }
    deinit {
        cancellable?.cancel()
    }
    func load() {
        guard !isLoading else { return }
        if let cachedImage = ImageLoaderService.imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        guard let url = URL(string: urlString) else { return }
        isLoading = true
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] downloadedImage in
                guard let self = self else { return }
                if let downloadedImage = downloadedImage {
                    ImageLoaderService.imageCache.setObject(
                        downloadedImage,
                        forKey: self.urlString as NSString
                    )
                }
                self.image = downloadedImage
                self.isLoading = false
            }
    }
    func cancel() {
        cancellable?.cancel()
        isLoading = false
    }
}
