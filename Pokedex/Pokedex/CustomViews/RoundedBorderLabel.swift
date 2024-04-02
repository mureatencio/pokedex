//
//  RoundedBorderLabel.swift
//  Pokedex
//

import UIKit

// A custom label with a rounded border
class RoundedBorderLabel: UILabel {
    
    // Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // Common setup code
    // Setting up the label's appearance
    private func commonInit() {
        self.backgroundColor = .clear
        self.textColor = .yellow
        self.font = UIFont.boldSystemFont(ofSize: 24)
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        self.textAlignment = .center
    }
    
    // Ensure the intrinsic content size includes the border
    override var intrinsicContentSize: CGSize {
        let originalSize = super.intrinsicContentSize
        let width = originalSize.width + 36 // Add padding horizontally
        let height = originalSize.height + 10 // Add padding vertically
        return CGSize(width: width, height: height)
    }
}
