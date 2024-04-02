//
//  PokemonViewModel.swift
//  Pokedex
//

import Foundation

class PokemonViewModel {
    // MARK: - Properties
    private var service: APIServiceProtocol
    private var pokemon: Pokemon?
    
    // MARK: - Closures
    var onDataLoaded: (() -> Void)?
    var showErrorAlert: ((String) -> Void)?
    
    // MARK: - Init
    init(service: APIServiceProtocol = APIService(), url: String) {
        self.service = service
        fetchPokemonDetails(from: url)
    }
    
    // MARK: - Fetch Data
    func fetchPokemonDetails(from url: String) {
        service.getPokemonDetails(for: url) { [weak self] detailedPokemon in
            guard let self = self else { return }
            switch detailedPokemon {
            case .success(let pokemon):
                self.pokemon = pokemon
                self.onDataLoaded?()
            case .failure(let error):
                self.showErrorAlert?(error.errorMessage)
                print(error.errorMessage)
            }
        }
    }
    
    // Computed properties
    var displayName: String {
        pokemon?.name.capitalized ?? ""
    }
    
    var displayIdentifier: String {
        "\(NSLocalizedString("Property_ID", comment: "Id title") ): \(pokemon?.identifier ?? 0)"
    }
    
    var imageUrl: URL? {
        URL(string: pokemon?.sprites.frontDefault ?? "")
    }
    
    var displayBaseExperience: String {
        "\(NSLocalizedString("Property_BaseXP", comment: "Base XP title")): \(pokemon?.baseExperience ?? 0)/360 XP"
    }
    
    var baseExperienceValue: Int {
        pokemon?.baseExperience ?? 0
    }
    
    var displayHeight: String {
        "\(NSLocalizedString("Property_Height", comment: "Height title")): \(pokemon?.height ?? 0) dm"
    }
    
    var displayWeight: String {
        "\(NSLocalizedString("Property_Weight", comment: "Weight title")): \(pokemon?.weight ?? 0) kg"
    }
    
    var displayTypes: String {
        "\(NSLocalizedString("Property_Types", comment: "Types title")): \(PokemonTypeEmojiConverter.emojis(for: pokemon?.types ?? []))"
    }
}
