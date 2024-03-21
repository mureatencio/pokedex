//
//  PokemonDetailsViewController.swift
//  Pokedex
//

import UIKit

class PokemonDetailsViewController: UIViewController {
    
    // MARK: - Properties
    var pokemonViewModel: PokemonViewModel!
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let idLabel = UILabel()
    private let typesLabel = UILabel()
    private let baseExperienceLabel = UILabel()
    private let heightLabel = UILabel()
    private let weightLabel = UILabel()
    private let loadingIndicator = UIActivityIndicatorView()
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupLoadingIndicator()
        setupLayout()
        initViewModel()
    }

    // MARK: - View Model setup
    
    func initViewModel() {
        pokemonViewModel.onDataLoaded = { [weak self] in
            DispatchQueue.main.async {
                self?.showActivityIndicator(false)
                self?.updateUI()
            }
        }
        pokemonViewModel.showErrorAlert = { [weak self] message in
            DispatchQueue.main.async {
                self?.showActivityIndicator(false)
                self?.showErrorAlert(message: message)
            }
        }
    }
    
    // MARK: - Autolayout setup
    
    private func setupScrollView() {
        view.backgroundColor = .white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
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
    
    // MARK: - UI Setup
    private func setupLayout() {
        // Initial setup for each UI component
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        let idLabel = UILabel()
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        heightLabel.translatesAutoresizingMaskIntoConstraints = false
        weightLabel.translatesAutoresizingMaskIntoConstraints = false
        typesLabel.translatesAutoresizingMaskIntoConstraints = false
        baseExperienceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add components to contentView
        [imageView, nameLabel, idLabel, heightLabel, weightLabel, typesLabel, baseExperienceLabel].forEach {
            contentView.addSubview($0)
        }
        
        // UI constraints
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            idLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            idLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            heightLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 10),
            heightLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            weightLabel.topAnchor.constraint(equalTo: heightLabel.bottomAnchor, constant: 10),
            weightLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            typesLabel.topAnchor.constraint(equalTo: weightLabel.bottomAnchor, constant: 10),
            typesLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            baseExperienceLabel.topAnchor.constraint(equalTo: typesLabel.bottomAnchor, constant: 10),
            baseExperienceLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
 
            contentView.bottomAnchor.constraint(equalTo: baseExperienceLabel.bottomAnchor, constant: 20)
        ])
    }
    
    // MARK: - UI updates
    
    private func updateUI() {
        self.navigationItem.title = pokemonViewModel.displayName
        nameLabel.text = pokemonViewModel.displayName
        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        idLabel.text = pokemonViewModel.displayIdentifier
        heightLabel.text = pokemonViewModel.displayHeight
        weightLabel.text = pokemonViewModel.displayWeight
        typesLabel.text = pokemonViewModel.displayTypes
        baseExperienceLabel.text = pokemonViewModel.displayBaseExperience
        ImageLoader.loadImage(urlString: pokemonViewModel.imageUrl?.absoluteString, into: imageView)
    }
    
    // MARK: - Activity Indicator visibility
    private func showActivityIndicator(_ show: Bool) {
        show ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
    }
    
    // MARK: - Error Alert management
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: NSLocalizedString("AlertTitle_ErrorDialog", comment: "Error dialog title"), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("AlertButton_Ok", comment: "Error dialog title"), style: .default, handler: { [weak self] _ in
            // Pop view since there is nothing to show
            self?.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
