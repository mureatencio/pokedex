//
//  PokemonViewModel.swift
//  Pokedex
//

import Foundation

class PokemonViewModel {
    private var service: APIServiceProtocol
    private var pokemon: Pokemon?
    
    var onDataLoaded: (() -> Void)?
    var showErrorAlert: ((String) -> Void)?
    
    init(service: APIServiceProtocol = APIService(), url: String) {
        self.service = service
        fetchPokemonDetails(from: url)
    }
    
    private func fetchPokemonDetails(from url: String) {
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
    var DisplayName: String {
        pokemon?.name.capitalized ?? ""
    }
    
    var displayIdentifier: String {
        "\(NSLocalizedString("Property_ID", comment: "Id title") ): \(pokemon?.identifier ?? 0)"
    }
    
    var imageUrl: URL? {
        URL(string: pokemon?.sprites.frontDefault ?? "")
    }
    
    var displayBaseExperience: String {
        "\(NSLocalizedString("Property_BaseXP", comment: "Base XP title")): \(pokemon?.baseExperience ?? 0) XP"
    }
    
    var displayHeight: String {
        "\(NSLocalizedString("Property_Height", comment: "Height title")): \(pokemon?.height ?? 0) dm"
    }
    
    var displayWeight: String {
        "\(NSLocalizedString("Property_Weight", comment: "Weight title")): \(pokemon?.weight ?? 0) kg"
    }
    
    var displayTypes: String {
        "\(NSLocalizedString("Property_Types", comment: "Types title")): \(pokemon?.types.map { $0.type.name.capitalized }.joined(separator: ", ") ?? "")"
    }
}
