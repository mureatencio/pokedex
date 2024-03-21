//
//  ImageLoader.swift
//  Pokedex
//

import Kingfisher
import UIKit

// Utility class to load images from a URL into a UIImageView
class ImageLoader {
    static func loadImage(urlString: String?, into imageView: UIImageView) {
        // Define a default placeholder image
        let defaultPlaceholder = UIImage(named: "pokeball")
        
        guard let urlString = urlString, let url = URL(string: urlString) else {
            imageView.image = defaultPlaceholder
            return
        }
        imageView.kf.setImage(with: url, placeholder: defaultPlaceholder, options: [.transition(.fade(0.2))])
    }
}
