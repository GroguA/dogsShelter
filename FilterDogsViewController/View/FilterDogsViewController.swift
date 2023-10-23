//
//  FilterDogsViewController.swift
//  Shelter
//
//  Created by Александра Сергеева on 20.10.2023.
//

import UIKit

class FilterDogsViewController: UIViewController {
    
    let viewModel = FilterDogsViewModel()
    
    private lazy var breedFilterImage: UIImageView = {
        let button = UIImageView()
        button.image = UIImage(systemName: "circle")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        return button
    }()
    
    private lazy var breedFilterLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textColor = .black
        label.text = "Filter by breed"
        return label
    }()
    
    private lazy var ageFilterImage: UIImageView = {
        let button = UIImageView()
        button.image = UIImage(systemName: "circle")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        return button
    }()
    
    private lazy var ageFilterLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textColor = .black
        label.text = "Filter by age"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        viewModel.viewStateDidChange = { state in
            self.renderViewState(state: state)
        }
    }
    
    func setupViews() {
        view.backgroundColor = .white
        navigationItem.title = "Filter"
        view.addSubview(breedFilterImage)
        view.addSubview(breedFilterLabel)
        view.addSubview(ageFilterImage)
        view.addSubview(ageFilterLabel)
        
        let constraints = [
            breedFilterImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            breedFilterImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            breedFilterImage.heightAnchor.constraint(equalTo: breedFilterLabel.heightAnchor),
            breedFilterImage.widthAnchor.constraint(equalTo: breedFilterImage.heightAnchor),
            
            breedFilterLabel.topAnchor.constraint(equalTo: breedFilterImage.topAnchor),
            breedFilterLabel.leadingAnchor.constraint(equalTo: breedFilterImage.trailingAnchor, constant: 8),
            breedFilterLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            ageFilterImage.topAnchor.constraint(equalTo: breedFilterImage.bottomAnchor, constant: 16),
            ageFilterImage.leadingAnchor.constraint(equalTo: breedFilterImage.leadingAnchor),
            ageFilterImage.heightAnchor.constraint(equalTo: ageFilterLabel.heightAnchor),
            ageFilterImage.widthAnchor.constraint(equalTo: ageFilterImage.heightAnchor),
            
            ageFilterLabel.topAnchor.constraint(equalTo: ageFilterImage.topAnchor),
            ageFilterLabel.leadingAnchor.constraint(equalTo: ageFilterImage.trailingAnchor, constant: 8),
            ageFilterLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        let tapBreedFilterNotActive = UITapGestureRecognizer(target: self, action: #selector(breedFilterNotActive))
        breedFilterImage.addGestureRecognizer(tapBreedFilterNotActive)
        
        let tapAgeFilterNotActive = UITapGestureRecognizer(target: self, action: #selector(ageFilterNotActive))
        ageFilterImage.addGestureRecognizer(tapAgeFilterNotActive)
    }
    
    @objc func breedFilterNotActive() {
        breedFilterImage.image = UIImage(systemName: "circle.fill")
        ageFilterImage.image = UIImage(systemName: "circle")
        viewModel.dogBreedFilter(active: true)
        viewModel.dogAgeFilter(active: false)
    }
    
    @objc func breedFilterActive() {
        breedFilterImage.image = UIImage(systemName: "circle")
        viewModel.dogBreedFilter(active: false)
    }
    
    @objc func ageFilterNotActive() {
        ageFilterImage.image = UIImage(systemName: "circle.fill")
        breedFilterImage.image = UIImage(systemName: "circle")
        viewModel.dogAgeFilter(active: true)
        viewModel.dogBreedFilter(active: false)
    }
    
    @objc func ageFilterActive() {
        ageFilterImage.image = UIImage(systemName: "circle")
        viewModel.dogAgeFilter(active: false)
    }
    
    private func renderViewState(state: FilterDogsState) {
        switch state {
        case .ageFilter(let active):
            if active {
                let tapAgeFilterActive = UITapGestureRecognizer(target: self, action: #selector(ageFilterActive))
                ageFilterImage.addGestureRecognizer(tapAgeFilterActive)
            } else {
                let tapAgeFilterNotActive = UITapGestureRecognizer(target: self, action: #selector(ageFilterNotActive))
                ageFilterImage.addGestureRecognizer(tapAgeFilterNotActive)
            }
        case .breedFilter(let active):
            if active {
                let tapBreedFilterActive = UITapGestureRecognizer(target: self, action: #selector(breedFilterActive))
                breedFilterImage.addGestureRecognizer(tapBreedFilterActive)
            } else {
                let tapBreedFilterNotActive = UITapGestureRecognizer(target: self, action: #selector(breedFilterNotActive))
                breedFilterImage.addGestureRecognizer(tapBreedFilterNotActive)
            }
        }
    }
    
}
