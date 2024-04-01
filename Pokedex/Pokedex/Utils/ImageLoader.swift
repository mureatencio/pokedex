//
//  ImageLoader.swift
//  Pokedex
//

import Kingfisher
import UIKit

// Utility class to load images from a URL into a UIImageView
class ImageLoader {
    // Define a default placeholder image
    static let placeholderImage = UIImage(named: "pokeball")
    
    // Load an image from a URL into an UIImageView
    static func loadImage(urlString: String?, into imageView: UIImageView) {
        // Define a default placeholder image
        let defaultPlaceholder = ImageLoader.placeholderImage
        
        guard let urlString = urlString, let url = URL(string: urlString) else {
            imageView.image = defaultPlaceholder
            return
        }
        imageView.kf.setImage(with: url, placeholder: defaultPlaceholder, options: [.transition(.fade(0.1))])
    }
}
