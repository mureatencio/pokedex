//
//  PokemonListViewController.swift
//  Pokedex
//

import UIKit

class PokemonListViewController: UIViewController {
    // Mark: Coordinator
    let coordinator: MainCoordinator!
    
    // MARK: - Properties
    lazy var pokemonListViewModel: PokemonListViewModel = {
        PokemonListViewModel()
    }()
    
    // MARK: - UI Components
    private let tableView = UITableView()
    private let loadingIndicator = UIActivityIndicatorView()
    
    // MARK: - Init
    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = NSLocalizedString("Title_PokemonList", comment: "Main list title")
        setupTableView()
        setupLoadingIndicator()
        initViewModel()
    }
    
    // MARK: - View Model setup
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
    
    // MARK: - Autolayout setup
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
    
    // Setting up the table view properties
    private func setupTableView() {
        tableView.register(PokemonTableViewCell.self, forCellReuseIdentifier: "PokemonTableViewCell")
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
        tableView.rowHeight = 64.0
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    // MARK: - Error dialog handling
    
    private func showErrorAlert(message: String) {
        coordinator?.showRetryAlert(message: message) { [weak self] in
            self?.showActivityIndicator(true)
            self?.pokemonListViewModel.getPokemonList()
        }
    }
    
    // MARK: - Activity Indicator handling
    
    private func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= (pokemonListViewModel.pokemonViewModels.count - 1)
    }
    
    // MARK: - Activity Indicator visibility
    
    private func showActivityIndicator(_ show: Bool) {
        show ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
    }
}

// MARK: - Table View Delegates and DataSource

extension PokemonListViewController: UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonTableViewCell", for: indexPath) as? PokemonTableViewCell else {
            return UITableViewCell()
        }
        
        let viewModel = pokemonListViewModel.pokemonViewModels[indexPath.row]
        cell.configure(with: viewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedPokemonUrl = self.pokemonListViewModel.pokemonViewModels[indexPath.row].url
        coordinator?.showPokemonDetails(with: PokemonViewModel(url: selectedPokemonUrl))
    }
}
