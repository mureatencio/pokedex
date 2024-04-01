//
//  Coordinator.swift
//  Pokedex
//

import UIKit

// MARK: Coordinator protocol
protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    func start()
}

// MARK: MainCoordinator
// Coordinator pattern to manage navigation between view controllers
class MainCoordinator: Coordinator {
    // Child coordinator array, in case we want to add
    // more complex navigation e.g. Tabbed application
    var childCoordinators = [Coordinator]()
    
    // Main app navigation controller
    var navigationController: UINavigationController
    
    // Init with a navigation controller
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // Start the coordinator by showing the first screen
    // in this case will be PokemonListViewController
    func start() {
        let vc = PokemonListViewController(coordinator: self)
        navigationController.pushViewController(vc, animated: false)
    }
    
    // Show the details screen for a given pokemon
    // receives a PokemonViewModel object with the pokemon data
    func showPokemonDetails(with viewModel: PokemonViewModel) {
        let vc = PokemonDetailsViewController(pokemonViewModel: viewModel, coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
}

// MARK: Error handling
// Error handling methods to display alerts
extension MainCoordinator {
    // Display an alert message with the api error
    // the retryAction is a closure that will be executed when the user
    // taps the retry button
    func showRetryAlert(message: String, retryAction: @escaping () -> Void) {
        let alert = UIAlertController(title: NSLocalizedString("AlertTitle_ErrorDialog", comment: "Error dialog title"), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("AlertButton_Retry", comment: "Error dialog retry button"), style: .default, handler: { _ in
            retryAction()
        }))
        navigationController.present(alert, animated: true, completion: nil)
    }
    
    // Display an alert message with the api error, then pops navigation
    // to the previous screen
    func showDetailsErrorAlert(message: String) {
        let alert = UIAlertController(title: NSLocalizedString("AlertTitle_ErrorDialog", comment: "Error dialog title"), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("AlertButton_Ok", comment: "Error dialog title"), style: .default, handler: { [weak self] _ in
            // Pop view since there is no details to show
            self?.navigationController.popViewController(animated: true)
        }))
        navigationController.present(alert, animated: true, completion: nil)
    }
}
