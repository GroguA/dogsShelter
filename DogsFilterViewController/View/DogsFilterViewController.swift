//
//  DogsFilterViewController.swift
//  Shelter
//
//  Created by Александра Сергеева on 25.10.2023.
//

import UIKit

class DogsFilterViewController: UIViewController {
    
    var filterByBreed: ((_ selectedBreeds: [String]) -> Void)? = nil
    
    private var viewModel = DogsFilterViewModel()
    
        
    private lazy var breedFilterIcon: UIImageView = {
        let view = UIImageView()
        let image = UIImage(systemName: "circle")
        view.image = image
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var breedFilterLabel: UILabel = {
        let label = UILabel()
        label.text = "Filter by breed"
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private lazy var selectedBreedsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var applyFilterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Apply", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        viewModel.viewStateDidChange = { state in
            self.rendereViewState(state: state)
        }
        viewModel.onAction = { action in
            self.processAction(action: action)
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(breedFilterIcon)
        view.addSubview(breedFilterLabel)
        view.addSubview(selectedBreedsLabel)
        view.addSubview(applyFilterButton)
        navigationItem.title = "Filter"
        
        let constraints = [
            breedFilterIcon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 16),
            breedFilterIcon.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -16),
            breedFilterIcon.heightAnchor.constraint(equalTo: breedFilterLabel.heightAnchor),
            breedFilterIcon.widthAnchor.constraint(equalTo: breedFilterIcon.heightAnchor),
            
            breedFilterLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            breedFilterLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            selectedBreedsLabel.topAnchor.constraint(equalTo: breedFilterLabel.bottomAnchor, constant: 8),
            selectedBreedsLabel.leadingAnchor.constraint(equalTo: breedFilterLabel.leadingAnchor),
            selectedBreedsLabel.trailingAnchor.constraint(equalTo: breedFilterIcon.trailingAnchor),
            
            applyFilterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            applyFilterButton.widthAnchor.constraint(equalToConstant: 88),
            applyFilterButton.heightAnchor.constraint(equalToConstant: 44),
            applyFilterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        let breedFilterSelectTap = UITapGestureRecognizer(target: self, action: #selector(breedFilterSelected))
        breedFilterLabel.addGestureRecognizer(breedFilterSelectTap)
    }
    
    @objc private func breedFilterSelected() {
        breedFilterIcon.image = UIImage(systemName: "circle.fill")
        let vc = SelectBreedFilterViewController()
        vc.isSingleSelectMode = false
        vc.doOnMultiSelect = { selectedBreeds in
            self.viewModel.breedsSelected(breeds: selectedBreeds)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func processAction(action: FilterDogAction) {
        switch action {
        case .applyFilter(let value):
            self.filterByBreed?(value)
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func applyButtonTapped() {
        viewModel.onApplyButtonTapped()
    }
    
    private func rendereViewState(state: FilterDogState) {
        switch state {
        case .breedFilter(let breeds):
            self.selectedBreedsLabel.text = breeds.joined(separator: ", ")
        }
    }
}

