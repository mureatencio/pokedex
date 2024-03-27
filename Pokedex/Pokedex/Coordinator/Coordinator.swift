//
//  Coordinator.swift
//  Pokedex
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    func start()
}

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = PokemonListViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }

    func showPokemonDetails(with viewModel: PokemonViewModel) {
        let vc = PokemonDetailsViewController(pokemonViewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }
}
