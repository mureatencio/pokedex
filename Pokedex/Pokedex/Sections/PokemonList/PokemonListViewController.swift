//
//  PokemonListViewController.swift
//  Pokedex
//

import UIKit

class PokemonListViewController: UIViewController {
	private let tableView = UITableView()
	private let loadingIndicator = UIActivityIndicatorView()
    
    lazy var pokemonListViewModel: PokemonListViewModel = {
       PokemonListViewModel()
    }()

	private var showActivityIndicator: Bool = true {
		didSet {
			if showActivityIndicator {
				loadingIndicator.startAnimating()
			} else {
				loadingIndicator.stopAnimating()
			}
		}
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationItem.title = "List of Pokemons"
		setupTableView()
		setupLoadingIndicator()
        initViewModel()
	}
    
    func initViewModel() {
        pokemonListViewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.showActivityIndicator = false
                self?.tableView.reloadData()
            }
        }
        DispatchQueue.main.async {
            self.showActivityIndicator = true
        }
        pokemonListViewModel.getPokemonList()
    }
	
	private func setupLoadingIndicator() {
		loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
		loadingIndicator.hidesWhenStopped = true
		loadingIndicator.style = .medium
		view.addSubview(loadingIndicator)
		
		NSLayoutConstraint.activate([
			loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
		])
	}
	
	private func setupTableView() {
		tableView.separatorColor = .clear
		tableView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(tableView)
		
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.topAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
		])
		
		tableView.dataSource = self
        tableView.delegate = self
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 44.0
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
	}
	
	private func showErrorAlert() {
		let alert = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: .alert)
		self.present(alert, animated: true, completion: nil)
	}

}

extension PokemonListViewController: UITableViewDataSource, UITableViewDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonListViewModel.pokemonViewModels.count
	}
	
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = pokemonListViewModel.pokemonViewModels[indexPath.row].name.capitalized
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == pokemonListViewModel.pokemonViewModels.count - 1 {
            print("reach end")
            // Execute reload
            DispatchQueue.main.async {
                self.showActivityIndicator = true
            }
            pokemonListViewModel.getPokemonList()
        }
    }
    
}
