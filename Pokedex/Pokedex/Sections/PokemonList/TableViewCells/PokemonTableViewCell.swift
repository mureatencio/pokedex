//
//  File.swift
//  Pokedex
//

import UIKit
import Kingfisher

// Custom UITableViewCell to display a Pokemon thumbnail and name
class PokemonTableViewCell: UITableViewCell {
    // UI Components
    let pokemonImageView = UIImageView()
    let nameLabel = UILabel()

    // Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Setup UI
    private func setupUI() {
        // Add subviews
        addSubview(pokemonImageView)
        addSubview(nameLabel)

        // Style the components
        pokemonImageView.contentMode = .scaleAspectFit
        nameLabel.font = .systemFont(ofSize: 24)
        
        // Layout the components
        pokemonImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Image View Constraints
            pokemonImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            pokemonImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            pokemonImageView.widthAnchor.constraint(equalToConstant: 52),
            pokemonImageView.heightAnchor.constraint(equalToConstant: 52),

            // Label Constraints
            nameLabel.leadingAnchor.constraint(equalTo: pokemonImageView.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    // Configure the cell with a ViewModel
    func configure(with viewModel: PokemonListItemViewModel) {
        nameLabel.text = viewModel.name.capitalized
        
        if let validSpriteUrl = viewModel.spriteUrl, let imageUrl = URL(string: validSpriteUrl) {
            pokemonImageView.kf.setImage(
                with: imageUrl,
                placeholder: ImageLoader.placeholderImage,
                options: [
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
        } else {
            pokemonImageView.image = ImageLoader.placeholderImage
        }
    }
}
