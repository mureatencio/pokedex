//
//  PokemonListViewModel.swift
//  Pokedex
//

import Foundation

class PokemonListViewModel {
    
    private var service: APIServiceProtocol
    
    init(service: APIServiceProtocol = APIService() ) {
        self.service = service
    }
    
    var isFetchingData = false

    var hasReachedEnd: Bool {
        return reachEnd
    }
    private var reachEnd = false
    
    var reloadTableView: (() -> Void)?
    
    var pokemonViewModels: [PokemonViewModel] = [] {
        didSet {
            reloadTableView?()
        }
    }
  
    func getPokemonList() {
        guard !isFetchingData && !reachEnd else { return }
        isFetchingData = true
        
        service.getPokemonCharacters(offset: pokemonViewModels.count) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isFetchingData = false
                switch result {
                case .success(let pokemonResponse):
                    self.pokemonViewModels.append(contentsOf: pokemonResponse.results.map(PokemonViewModel.init))
                    self.reachEnd = pokemonResponse.next == nil
                case .failure(let error):
                    print(error)
                    // TODO: Handle error, e.g., by showing an alert or a placeholder view
                }
            }
        }
    }

}

struct PokemonViewModel {
    
    fileprivate let pokemon: Pokemon
    
    var name: String {
        pokemon.name
    }
    
    var url: String {
        pokemon.url
    }
    
}
