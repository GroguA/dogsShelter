//
//  DogListContainerView.swift
//  Shelter
//
//  Created by Александра Сергеева on 20.07.2024.
//

import UIKit

final class DogListContainerView: UIView {
    lazy var dogsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.dataSource = dataSource
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.register(DogListCollectionViewCell.self, forCellWithReuseIdentifier: DogListCollectionViewCell.identifier)
        return collectionView
    }()
    
    lazy var emptyDogsStorageLabel = LabelsFactory.createLabel(with: "No dogs added yet")
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Dog name"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()
    
    lazy var addDogButton: UIImageView = {
        let button = UIImageView()
        button.image = UIImage(systemName: "plus.circle.fill")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        return button
    }()
    
    let dataSource = DogListCollectionViewDataSource()
    
    init(delegate: UICollectionViewDelegate, searchResultsUpdater: UISearchResultsUpdating, searchBarDelegate: UISearchBarDelegate) {
        super.init(frame: .zero)
        dogsCollectionView.delegate = delegate
        searchController.searchBar.delegate = searchBarDelegate
        searchController.searchResultsUpdater = searchResultsUpdater
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension DogListContainerView {
    func setupViews() {
        backgroundColor = .systemBackground
        addSubview(dogsCollectionView)
        addSubview(addDogButton)
        addSubview(emptyDogsStorageLabel)
        emptyDogsStorageLabel.isHidden = true
        
        setupConstraints()
    }
    
    func setupConstraints() {
        let constraint = [
            dogsCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            dogsCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            dogsCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            dogsCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            addDogButton.trailingAnchor.constraint(equalTo: dogsCollectionView.trailingAnchor, constant: -32),
            addDogButton.bottomAnchor.constraint(equalTo: dogsCollectionView.bottomAnchor, constant: -16),
            addDogButton.widthAnchor.constraint(equalToConstant: 44),
            addDogButton.heightAnchor.constraint(equalToConstant: 44),
            
            emptyDogsStorageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyDogsStorageLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(constraint)
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.backgroundColor = .systemBackground
        configuration.showsSeparators = true
        
        let indexPathToHide = IndexPath()
        
        configuration.itemSeparatorHandler = { (indexPath, sectionSeparatorConfiguration) in
            var configuration = sectionSeparatorConfiguration
            if indexPath == indexPathToHide {
                configuration.bottomSeparatorVisibility = .visible
            } else if indexPath.row == 0 {
                configuration.topSeparatorVisibility = .hidden
            }
            return configuration
        }
        
        let layout = UICollectionViewCompositionalLayout() { section, layoutEnvironment in
            let layoutSection = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
            layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -8, bottom: 0, trailing: 8)
            return layoutSection
        }
        
        return layout
    }
}
