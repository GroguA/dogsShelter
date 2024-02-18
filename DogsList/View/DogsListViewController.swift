//
//  DogsListViewController.swift
//  Shelter
//
//  Created by Александра Сергеева on 25.09.2023.
//

import UIKit

class DogsListViewController: UIViewController {
    
    private var dogs = [DogsListDogModel]()
    
    private let itemsPerRow: CGFloat = 1
    private let itemsPerView: CGFloat = 6
    private let sectionInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    
    private let viewModel = DogsListViewModel()
    
    private lazy var resetFilterButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Reset filter", style: .plain, target: self, action: #selector(onResetFilterClicked))
        return button
    }()
    
    private lazy var notificationsListButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Notifications list", style: .plain, target: self, action: #selector(onNotificationsButtonClicked))
        return button
    }()
    
    private lazy var dogsCollectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(DogsListCollectionViewCell.self, forCellWithReuseIdentifier: DogsListCollectionViewCell.identifier)
        return collectionView
    }()
    
    private lazy var addDogButton: UIImageView = {
        let button = UIImageView()
        button.image = UIImage(systemName: "plus.circle.fill")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(onAddNewDogClicked))
        button.addGestureRecognizer(tap)
        return button
    }()
    
    private lazy var emptyDogsStorageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textColor = .black
        label.text = "No dogs added yet"
        return label
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Find dog"
        definesPresentationContext = false
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()
    
    private lazy var addFilterButton: UIBarButtonItem = {
       let button = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(onFilterButtonClicked))
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewModel.loadSavedDogs()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DogsNotificationsManager.shared.checkForPermission()
        setupViews()
        viewModel.viewStateDidChange = { viewState in
            self.renderViewState(state: viewState)
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(dogsCollectionView)
        view.addSubview(addDogButton)
        view.addSubview(emptyDogsStorageLabel)
        emptyDogsStorageLabel.isHidden = true
        navigationItem.title = "Dogs"
        navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false

        navigationItem.rightBarButtonItem = addFilterButton
        navigationItem.leftBarButtonItem = notificationsListButton

        let constraint = [
            dogsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dogsCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            dogsCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            dogsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            addDogButton.trailingAnchor.constraint(equalTo: dogsCollectionView.trailingAnchor, constant: -32),
            addDogButton.bottomAnchor.constraint(equalTo: dogsCollectionView.bottomAnchor, constant: -16),
            addDogButton.widthAnchor.constraint(equalToConstant: 44),
            addDogButton.heightAnchor.constraint(equalToConstant: 44),
            
            emptyDogsStorageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyDogsStorageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(constraint)
        
    }
    
    @objc private func onAddNewDogClicked(tapGestureRecognizer: UITapGestureRecognizer) {
        navigationController?.pushViewController(AddNewDogViewController(), animated: true)
    }
    
    private func renderViewState(state: DogsListState) {
        switch state {
        case .success(let savedDogs, let isFiltering):
            dogsCollectionView.isHidden = false
            emptyDogsStorageLabel.isHidden = true
            dogsCollectionView.reloadData()
            dogs = savedDogs
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
            dogsCollectionView.isHidden = true
            emptyDogsStorageLabel.isHidden = false
        }
    }
    
    @objc private func onFilterButtonClicked() {
        let vc = DogsFilterViewController()
        vc.onDogFiltersSelected = { filter in
            self.viewModel.onFilterSelected(filter: filter)
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
        let clickedDog = dogs[indexPath.row]
        let dogDetailsViewController = DogDetailsViewController()
        dogDetailsViewController.dogId = clickedDog.id
        navigationController?.pushViewController(dogDetailsViewController, animated: true)
    }
}

extension DogsListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DogsListCollectionViewCell.identifier, for: indexPath) as! DogsListCollectionViewCell
        let dog = dogs[indexPath.row]
        cell.fillCell(dog: dog)
        return cell
    }
}


extension DogsListViewController: UICollectionViewDelegateFlowLayout {
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

extension DogsListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let text = searchBar.text else { return }
        if !text.isEmpty {
            viewModel.searchDogByName(searchText: text)
        }
    }
}

extension DogsListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.disableSearch()
    }
}

