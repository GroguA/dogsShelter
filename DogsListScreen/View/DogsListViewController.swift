//
//  DogsListViewController.swift
//  Shelter
//
//  Created by Александра Сергеева on 25.09.2023.
//

import UIKit

class DogsListViewController: UIViewController {
    
    private lazy var contentView = DogsListContainerView(delegate: self, searchResultsUpdater: self, searchBarDelegate: self)
    
    private var viewModel: IDogsListViewModel & IDogsListNavigation
    
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
    
    init(viewModel: IDogsListViewModel & IDogsListNavigation) {
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
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        navigationItem.rightBarButtonItem = addFilterButton
        navigationItem.leftBarButtonItem = notificationsListButton
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onAddNewDogClicked))
        contentView.addDogButton.addGestureRecognizer(tap)
    }
    
    @objc private func onAddNewDogClicked(_ tapGestureRecognizer: UITapGestureRecognizer) {
        viewModel.navigateToAddNewDogScreen()
    }
    
    private func renderViewState(state: DogsListState) {
        switch state {
        case .success(let savedDogs, let isFiltering):
            contentView.dataSource.setDogs(savedDogs)
            contentView.dogsCollectionView.isHidden = false
            contentView.emptyDogsStorageLabel.isHidden = true
            contentView.dogsCollectionView.reloadData()
            if isFiltering {
                self.navigationItem.leftBarButtonItem = resetFilterButton
            } else {
                self.navigationItem.leftBarButtonItem = notificationsListButton
            }
        case .empty(let isFiltering):
            if isFiltering {
                self.navigationItem.leftBarButtonItem = resetFilterButton
            } else {
                self.navigationItem.leftBarButtonItem = notificationsListButton
            }
            contentView.dogsCollectionView.isHidden = true
            contentView.emptyDogsStorageLabel.isHidden = false
        }
    }
    
    @objc private func onFilterButtonClicked() {
        let vc = DogsFilterViewController()
        vc.onDogFiltersSelected = { filter in
            self.viewModel.onFilterSelected(filter)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func onResetFilterClicked() {
        viewModel.onResetFilterTapped()
        self.navigationItem.leftBarButtonItem = notificationsListButton
    }
    
    @objc private func onNotificationsButtonClicked() {
        navigationController?.pushViewController(NotificationsListViewController(), animated: true)
    }
}


extension DogsListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let clickedDog = contentView.dataSource.dogs[indexPath.row]
        let dogDetailsViewController = DogDetailsViewController()
        dogDetailsViewController.dogId = clickedDog.id
        navigationController?.pushViewController(dogDetailsViewController, animated: true)
    }
}

extension DogsListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let name = searchBar.text else { return }
        if !name.isEmpty {
            viewModel.searchDogByName(name)
        }
    }
}

extension DogsListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.disableSearch()
    }
}

