//
//  SelectBreedContainerView.swift
//  Shelter
//
//  Created by Александра Сергеева on 21.07.2024.
//

import UIKit

final class SelectBreedContainerView: UIView {
    var isSingleSelectMode: Bool
    
    lazy var breedsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.register(SelectBreedCollectionViewCell.self, forCellWithReuseIdentifier: SelectBreedCollectionViewCell.identifier)
        collectionView.allowsMultipleSelection = true
        return collectionView
    }()
    
    lazy var doneButtomMultiMode = ButtonsFactory.createButton(with: "Done")
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = searchResultsUpdater
        searchController.searchBar.placeholder = "Breed"
        searchController.searchBar.delegate = searchBarDelegate
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        return searchController
    }()
    
    let dataSource = SelectBreedCollectionViewDataSource()
    
    private let offsetForConstraints: CGFloat = 16
    
    private let delegate: UICollectionViewDelegate
    private let searchBarDelegate: UISearchBarDelegate
    private let searchResultsUpdater: UISearchResultsUpdating
    
    init(isSingleSelectMode: Bool, delegate: UICollectionViewDelegate, searchBarDelegate: UISearchBarDelegate, searchResultsUpdater: UISearchResultsUpdating) {
        self.isSingleSelectMode = isSingleSelectMode
        self.delegate = delegate
        self.searchBarDelegate = searchBarDelegate
        self.searchResultsUpdater = searchResultsUpdater
        super.init(frame: .zero)
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension SelectBreedContainerView {
    func setupViews() {
        backgroundColor = .systemBackground
        addSubview(breedsCollectionView)
        addSubview(searchController.searchBar)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        var constraints: [NSLayoutConstraint] = []
        
        if !isSingleSelectMode {
            addSubview(doneButtomMultiMode)
            constraints = [
                breedsCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                breedsCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
                breedsCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
                
                doneButtomMultiMode.topAnchor.constraint(equalTo: breedsCollectionView.bottomAnchor, constant: offsetForConstraints),
                doneButtomMultiMode.centerXAnchor.constraint(equalTo: centerXAnchor),
                doneButtomMultiMode.widthAnchor.constraint(equalToConstant: 88),
                doneButtomMultiMode.heightAnchor.constraint(equalToConstant: 44),
                doneButtomMultiMode.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -offsetForConstraints)
            ]
        } else {
            constraints = [
                breedsCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                breedsCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
                breedsCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
                breedsCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
            ]
        }
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    func createLayout() -> UICollectionViewLayout {
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
            let layoutSection =  NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
            
            layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: -8, bottom: 8, trailing: 8)
            
            return layoutSection
        }
        
        return layout
    }
    
}
