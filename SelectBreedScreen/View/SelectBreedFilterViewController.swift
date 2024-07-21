//
//  BreedsListFilterViewController.swift
//  Shelter
//
//  Created by Александра Сергеева on 25.10.2023.
//

import UIKit

class SelectBreedViewController: UIViewController {
    
    private var breeds: [SelectBreedModel] = []
    
    private let viewModel = SelectBreedViewModel()
    
    var doOnSingleSelect: ((_ selectedBreed: String) -> Void)? = nil
    var doOnMultiSelect: ((_ selectedBreeds: [String]) -> Void)? = nil
    var isSingleSelectMode = true
    
    private let itemsPerRow: CGFloat = 1
    private let itemsPerView: CGFloat = 10
    private let sectionInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    
    private lazy var breedsCollectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(SelectBreedCollectionViewCell.self, forCellWithReuseIdentifier: SelectBreedCollectionViewCell.identifier)
        collectionView.allowsMultipleSelection = true
        return collectionView
    }()
    
    private lazy var doneButtomMultiMode: UIButton = {
       let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Find breed"
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        viewModel.loadBreeds(isSingleSelect: isSingleSelectMode)
        
        viewModel.viewStateDidChange = { viewState in
            self.renderViewState(state: viewState)
        }
        viewModel.onAction = { action in
            self.processAction(action: action)
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(breedsCollectionView)
        view.addSubview(searchController.searchBar)
        navigationItem.title = "Breeds"
        navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        var constraints: [NSLayoutConstraint] = []
        
        if !isSingleSelectMode {
            view.addSubview(doneButtomMultiMode)
            
            constraints = [
                breedsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                breedsCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                breedsCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                
                doneButtomMultiMode.topAnchor.constraint(equalTo: breedsCollectionView.bottomAnchor, constant: 16),
                doneButtomMultiMode.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                doneButtomMultiMode.widthAnchor.constraint(equalToConstant: 88),
                doneButtomMultiMode.heightAnchor.constraint(equalToConstant: 44),
                doneButtomMultiMode.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
            ]
        } else {
            constraints = [
                breedsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                breedsCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                breedsCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                breedsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ]
        }
        
        NSLayoutConstraint.activate(constraints)

    }
    
    private func renderViewState(state: SelectBreedState) {
        switch state {
        case .success(let breeds):
            self.breeds = breeds
            breedsCollectionView.reloadData()
        }
    }
    
    private func processAction(action: SelectBreedAction) {
        switch action {
        case .closeWithBreed(let breed):
            doOnSingleSelect?(breed)
            self.navigationController?.popViewController(animated: true)
        case .closeWithBreeds(let breeds):
            doOnMultiSelect?(breeds)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func doneButtonTapped() {
        viewModel.onDoneButtonClicked()
    }

}

extension SelectBreedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dogIndex = indexPath.row
        viewModel.onBreedClicked(breedIndex: dogIndex)

    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let dogIndex = indexPath.row
        viewModel.onBreedClicked(breedIndex: dogIndex)
    }
}

extension SelectBreedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return breeds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectBreedCollectionViewCell.identifier, for: indexPath) as! SelectBreedCollectionViewCell
        let breed = breeds[indexPath.row]
        cell.fillCell(breed: breed)
        return cell
    }
}

extension SelectBreedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingWidht = sectionInsets.left * (itemsPerRow + 1)
        let paddingHeight = sectionInsets.top * itemsPerView
        let availableWidht = collectionView.bounds.width - paddingWidht
        let itemWidht = availableWidht/itemsPerRow
        let availibleHeight = collectionView.bounds.height - paddingHeight
        let itemHeight = availibleHeight/itemsPerView
        
        return CGSize(width: itemWidht, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.top
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

extension SelectBreedViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let text = searchBar.text else { return }
        viewModel.onSearchTextChanged(searchText: text)
    }
}

extension SelectBreedViewController:  UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.disableSearch()
    }
}

