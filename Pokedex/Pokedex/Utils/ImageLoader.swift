//
//  ImageLoader.swift
//  Pokedex
//

import Kingfisher
import UIKit

class ImageLoader {
    static func loadImage(urlString: String?, into imageView: UIImageView) {
        // Define a default placeholder image
        let defaultPlaceholder = UIImage(named: "defaultPlaceholder")
        
        guard let urlString = urlString, let url = URL(string: urlString) else {
            imageView.image = defaultPlaceholder
            return
        }
        imageView.kf.setImage(with: url, placeholder: defaultPlaceholder, options: [.transition(.fade(0.2))])
    }
}
