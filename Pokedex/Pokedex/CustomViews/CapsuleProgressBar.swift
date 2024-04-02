//
//  CapsuleProgressBar.swift
//  Pokedex
//

import UIKit

// A custom progress bar with a capsule shape
class CapsuleProgressBar: UIView {
    
    // MARK: - UI Components
    
    // Min value will be displayed on the left side of the progress bar
    private let minValueLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Max value will be displayed on the right side of the progress bar
    private let maxValueLabel: UILabel = {
        let label = UILabel()
        label.text = "360"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // The progress view that moves horizontally
    private let progressView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Public property to set the progress value
    var progress: CGFloat = 0 {
        didSet {
            updateProgressView()
        }
    }
    
    // Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // Common setup code
    private func commonInit() {
        setupLabels()
        setupProgressView()
    }
    
    // Setup the min and max value labels
    private func setupLabels() {
        addSubview(minValueLabel)
        addSubview(maxValueLabel)
        
        NSLayoutConstraint.activate([
            minValueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            minValueLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            maxValueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            maxValueLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    // Setup the progress view
    private func setupProgressView() {
        addSubview(progressView)
        sendSubviewToBack(progressView)
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressView.topAnchor.constraint(equalTo: topAnchor),
            progressView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        // Initial progress is set to zero
        updateProgressView()
    }
    
    // Update the progress view based on the current progress
    private func updateProgressView() {
        // Calculate the width of the progress view based on the current progress
        let totalWidth = bounds.width
        let progressWidth = totalWidth * (progress / 360.0)
        progressView.frame = CGRect(x: 0, y: 0, width: progressWidth, height: bounds.height)
        progressView.layer.cornerRadius = bounds.height / 2
    }
    
    // Layout adjustments and manage orientation changes
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.height / 2
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        clipsToBounds = true
        updateProgressView()
    }
}
