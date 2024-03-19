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
    
    private var reachEnd = false
    
    var reloadTableView: (() -> Void)?
    
    var pokemonViewModels: [PokemonViewModel] = [] {
        didSet {
            reloadTableView?()
        }
    }
    
    func getPokemonList() {
        if !reachEnd {
            service.getPokemonCharacters(offset: pokemonViewModels.count) { result in
                switch result {
                case .success(let pokemonResponse):
                    self.pokemonViewModels.append(contentsOf: pokemonResponse.results.map(PokemonViewModel.init))
                    self.reachEnd = pokemonResponse.next == nil
                case .failure(let failure):
                    print(failure)
                    // TODO: Manage error - What to do here??
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
