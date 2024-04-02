//
//  PokemonDetailsViewController.swift
//  Pokedex
//

import UIKit

class PokemonDetailsViewController: UIViewController {
    // Mark: Coordinator
    let coordinator: MainCoordinator!
    
    // MARK: - Properties
    let pokemonViewModel: PokemonViewModel!
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let imageView = UIImageView()
    private let nameLabel = RoundedBorderLabel()
    private let idLabel = UILabel()
    private let typesLabel = UILabel()
    private let baseExperienceLabel = UILabel()
    private let heightLabel = UILabel()
    private let weightLabel = UILabel()
    private let loadingIndicator = UIActivityIndicatorView()
    private let progressBar = CapsuleProgressBar()
    private let stackView = UIStackView()
    private let gradientLayer = CAGradientLayer()
    
    // MARK: - Init
    init(pokemonViewModel: PokemonViewModel, coordinator: MainCoordinator) {
        self.pokemonViewModel = pokemonViewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupLoadingIndicator()
        setupStackView()
        initViewModel()
        setupGradientLayer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Update the gradient layer's frame to match the view bounds
        gradientLayer.frame = view.bounds
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
    
    // MARK: - Setting background gradient
    private func setupGradientLayer() {
        // Set an array of Core Graphics colors (.cgColor) to create the gradient.
        gradientLayer.colors = [UIColor.systemTeal.cgColor, UIColor.systemBlue.cgColor]
        
        // Rasterize this static layer to improve app performance.
        gradientLayer.shouldRasterize = true
        gradientLayer.rasterizationScale = UIScreen.main.scale
        
        // Apply the gradient to the background
        view.layer.insertSublayer(gradientLayer, at: 0)
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
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add components to stackView instead of contentView
        [imageView, nameLabel, idLabel, heightLabel, weightLabel, typesLabel, baseExperienceLabel, progressBar].forEach {
            stackView.addArrangedSubview($0)
        }
        
        contentView.addSubview(stackView)
        
        // Set imageView's height and width
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        // Set progressBar's width and height
        progressBar.heightAnchor.constraint(equalToConstant: 20).isActive = true
        progressBar.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        
        // Constraints for stackView
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - UI updates
    
    private func updateUI() {
        self.navigationItem.title = pokemonViewModel.displayName
        view.backgroundColor = UIColor.blue
        nameLabel.text = pokemonViewModel.displayName
        idLabel.text = pokemonViewModel.displayIdentifier
        idLabel.font = UIFont.boldSystemFont(ofSize: 16)
        idLabel.textColor = UIColor.white
        heightLabel.text = pokemonViewModel.displayHeight
        heightLabel.font = UIFont.boldSystemFont(ofSize: 16)
        heightLabel.textColor = UIColor.white
        weightLabel.text = pokemonViewModel.displayWeight
        weightLabel.font = UIFont.boldSystemFont(ofSize: 16)
        weightLabel.textColor = UIColor.white
        typesLabel.text = pokemonViewModel.displayTypes
        typesLabel.font = UIFont.boldSystemFont(ofSize: 16)
        typesLabel.textColor = UIColor.white
        baseExperienceLabel.text = pokemonViewModel.displayBaseExperience
        baseExperienceLabel.font = UIFont.boldSystemFont(ofSize: 16)
        baseExperienceLabel.textColor = UIColor.white
        ImageLoader.loadImage(urlString: pokemonViewModel.imageUrl?.absoluteString, into: imageView)
        progressBar.progress = CGFloat(pokemonViewModel.baseExperienceValue)
    }
    
    // MARK: - Activity Indicator visibility
    private func showActivityIndicator(_ show: Bool) {
        show ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
    }
    
    // MARK: - Error Alert management
    private func showErrorAlert(message: String) {
        coordinator.showDetailsErrorAlert(message: message)
    }
}
