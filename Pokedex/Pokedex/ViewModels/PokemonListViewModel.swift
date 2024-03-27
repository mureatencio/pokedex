//
//  PokemonListViewModel.swift
//  Pokedex
//

import Foundation

class PokemonListViewModel {
    // MARK: - Properties
    private var service: APIServiceProtocol
    private var isFetchingData = false
    private var reachEnd = false
    var pokemonViewModels: [PokemonListItemViewModel] = []
    
    // MARK: - Init
    init(service: APIServiceProtocol = APIService() ) {
        self.service = service
    }
    
    // MARK: - Closures
    var reloadTableViewRows: (([IndexPath]) -> Void)?
    var showErrorAlert: ((String) -> Void)?
    
    // MARK: - Fetch Data
    func getPokemonList() {
        guard !isFetchingData && !reachEnd else { return }
        isFetchingData = true
        let startIndex = pokemonViewModels.count
        
        service.getPokemonCharacters(offset: pokemonViewModels.count) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isFetchingData = false
                switch result {
                case .success(let pokemonResponse):
                    let newPokemons = pokemonResponse.results.map(PokemonListItemViewModel.init)
                    self.pokemonViewModels.append(contentsOf: newPokemons)
                    self.reachEnd = pokemonResponse.next == nil
                    
                    // Calculate the indices of the new rows
                    let endIndex = self.pokemonViewModels.count
                    let indexPaths = (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
                    self.reloadTableViewRows?(indexPaths)
                case .failure(let error):
                    self.showErrorAlert?(error.errorMessage)
                }
            }
        }
    }
}

// MARK: - PokemonListItemViewModel
struct PokemonListItemViewModel {
    fileprivate let pokemon: PokemonListItem
    var name: String {
        pokemon.name
    }
    var url: String {
        pokemon.url
    }
    var spriteUrl: String? {
        // Extract the Pokémon ID from the details URL
        guard let id = pokemon.url.split(separator: "/").last else { return nil }
        return "\(PokemonAPI.APISpriteURL)/\(id).png"
    }
}
