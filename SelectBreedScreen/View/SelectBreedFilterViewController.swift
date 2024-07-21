//
//  BreedsListFilterViewController.swift
//  Shelter
//
//  Created by Александра Сергеева on 25.10.2023.
//

import UIKit

class SelectBreedViewController: UIViewController {
    var doOnSingleSelect: ((String) -> Void)?
    var doOnMultiSelect: (([String]) -> Void)?
    var isSingleSelectMode = true
    
    private var viewModel: ISelectBreedViewModel & ISelectBreedNavigation
    
    private lazy var containerView = SelectBreedContainerView(
        isSingleSelectMode: isSingleSelectMode,
        delegate: self, searchBarDelegate: self,
        searchResultsUpdater: self
    )
    
    init(viewModel: ISelectBreedViewModel & ISelectBreedNavigation) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = containerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        viewModel.loadBreeds(isSingleSelect: isSingleSelectMode)
        
        viewModel.viewStateDidChange = { [weak self] viewState in
            self?.renderViewState(state: viewState)
        }
        
        viewModel.onAction = { [weak self] action in
            self?.processAction(action: action)
        }
    }
}

private extension SelectBreedViewController {
    func setupViews() {
        navigationItem.title = "Breeds"
        navigationItem.searchController = containerView.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        containerView.doneButtomMultiMode.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)

    }
    
    func renderViewState(state: SelectBreedState) {
        switch state {
        case .success(let breeds):
            containerView.dataSource.setBreeds(breeds)
            containerView.breedsCollectionView.reloadData()
        }
    }
    
    func processAction(action: SelectBreedAction) {
        switch action {
        case .closeWithBreed(let breed):
            doOnSingleSelect?(breed)
            viewModel.popSelectBreedScreen()
        case .closeWithBreeds(let breeds):
            doOnMultiSelect?(breeds)
            viewModel.popSelectBreedScreen()
        }
    }
    
    @objc func doneButtonTapped() {
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

