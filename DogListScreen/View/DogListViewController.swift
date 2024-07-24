//
//  DogListViewController.swift
//  Shelter
//
//  Created by Александра Сергеева on 25.09.2023.
//

import UIKit

final class DogListViewController: UIViewController {
    private lazy var contentView = DogListContainerView(delegate: self, searchResultsUpdater: self, searchBarDelegate: self)
    
    private var viewModel: IDogListViewModel & IDogListNavigation
    
    private lazy var resetFilterButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Reset filter", style: .plain, target: self, action: #selector(onResetFilterClicked))
        return button
    }()
    
    private lazy var notificationsListButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Notifications list", style: .plain, target: self, action: #selector(onNotificationsButtonClicked))
        return button
    }()
    
    private lazy var addFilterButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(onFilterButtonClicked))
        return button
    }()
    
    init(viewModel: IDogListViewModel & IDogListNavigation) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewModel.loadSavedDogs()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DogsNotificationsManager.shared.checkForPermission()
        
        setupViews()
        
        viewModel.viewStateDidChange = { [weak self] viewState in
            self?.renderViewState(state: viewState)
        }
    }
    
    func setupViews() {
        navigationItem.title = "Dogs"
        navigationItem.searchController = contentView.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        navigationItem.rightBarButtonItem = addFilterButton
        navigationItem.leftBarButtonItem = notificationsListButton
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onAddNewDogClicked))
        contentView.addDogButton.addGestureRecognizer(tap)
    }
    
    @objc private func onAddNewDogClicked(_ tapGestureRecognizer: UITapGestureRecognizer) {
        viewModel.navigateToAddNewDogScreen()
    }
    
    private func renderViewState(state: DogListState) {
        switch state {
        case .success(let savedDogs, let isFiltering):
            contentView.dataSource.setDogs(savedDogs)
            contentView.dogsCollectionView.isHidden = false
            contentView.emptyDogsStorageLabel.isHidden = true
            contentView.dogsCollectionView.reloadData()
            if isFiltering {
                navigationItem.leftBarButtonItem = resetFilterButton
            } else {
                navigationItem.leftBarButtonItem = notificationsListButton
            }
        case .empty(let isFiltering):
            if isFiltering {
                navigationItem.leftBarButtonItem = resetFilterButton
            } else {
                navigationItem.leftBarButtonItem = notificationsListButton
            }
            contentView.dogsCollectionView.isHidden = true
            contentView.emptyDogsStorageLabel.isHidden = false
        }
    }
    
    @objc private func onFilterButtonClicked() {
        viewModel.navigateToDogFiltersScreen { [weak self] filter in
            self?.viewModel.onFilterSelected(filter)
        }
    }
    
    @objc private func onResetFilterClicked() {
        viewModel.onResetFilterTapped()
        navigationItem.leftBarButtonItem = notificationsListButton
    }
    
    @objc private func onNotificationsButtonClicked() {
        navigationController?.pushViewController(NotificationsListViewController(), animated: true)
    }
}


extension DogListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let clickedDog = contentView.dataSource.dogs[indexPath.row]
        viewModel.navigateToDogDetailsScreen(with: clickedDog.id)
    }
}

extension DogListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let name = searchBar.text else { return }
        if !name.isEmpty {
            viewModel.searchDogByName(name)
        }
    }
}

extension DogListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.disableSearch()
    }
}

