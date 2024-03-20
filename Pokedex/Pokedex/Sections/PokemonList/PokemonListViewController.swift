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

    private func showActivityIndicator(_ show: Bool) {
        show ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = NSLocalizedString("Title_PokemonList", comment: "Main list title")
        setupTableView()
        setupLoadingIndicator()
        initViewModel()
    }
    
    func initViewModel() {
        pokemonListViewModel.reloadTableViewRows = { [weak self] newIndexPaths in
            DispatchQueue.main.async {
                self?.showActivityIndicator(false)
                self?.tableView.insertRows(at: newIndexPaths, with: .automatic)
            }
        }
        pokemonListViewModel.showErrorAlert = { [weak self] message in
            DispatchQueue.main.async {
                self?.showErrorAlert(message: message)
            }
        }
        DispatchQueue.main.async {
            self.showActivityIndicator(true)
        }
        pokemonListViewModel.getPokemonList()
    }
    
    private func setupLoadingIndicator() {
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .large
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
        tableView.prefetchDataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: NSLocalizedString("AlertTitle_ErrorDialog", comment: "Error dialog title"), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("AlertButton_Retry", comment: "Error dialog retry button"), style: .default, handler: { [weak self] _ in
            self?.showActivityIndicator(true)
            self?.pokemonListViewModel.getPokemonList()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= (pokemonListViewModel.pokemonViewModels.count - 1)
    }
}

extension PokemonListViewController: UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        print(indexPaths)
        if indexPaths.contains(where: isLoadingCell) {
            showActivityIndicator(true)
            pokemonListViewModel.getPokemonList()
        }
    }
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPokemonUrl = self.pokemonListViewModel.pokemonViewModels[indexPath.row].url
        let detailsVC = PokemonDetailsViewController()
        detailsVC.pokemonViewModel = PokemonViewModel(url: selectedPokemonUrl)
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
}
