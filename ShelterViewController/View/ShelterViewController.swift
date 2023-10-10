//
//  ShelterViewController.swift
//  Shelter
//
//  Created by Александра Сергеева on 25.09.2023.
//

import UIKit

class ShelterViewController: UIViewController {
    
    private var dogs = [DogModel]()
    
    private let itemsPerRow: CGFloat = 1
    private let itemsPerView: CGFloat = 13
    private var sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    private let viewModel = ShelterViewModel()
    
    private lazy var dogsCollectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        return collectionView
    }()
    
    private lazy var addDogButton: UIImageView = {
        let button = UIImageView()
        button.image = UIImage(systemName: "plus.circle.fill")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        return button
    }()
    
    private lazy var emptyDogsStorageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textColor = .black
        label.text = "No one dog added"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        viewModel.loadSavedDogs()
        viewModel.viewStateDidChange = { viewState in
            self.renderViewState(state: viewState)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.loadSavedDogs()

    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(dogsCollectionView)
        view.addSubview(addDogButton)
        view.addSubview(emptyDogsStorageLabel)
        emptyDogsStorageLabel.isHidden = true
        navigationItem.title = "Dogs"
        
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(addNewDogVC))
        addDogButton.addGestureRecognizer(tap)
    }
    
    @objc private func addNewDogVC(tapGestureRecognizer: UITapGestureRecognizer) {
        navigationController?.pushViewController(AddNewDogViewController(), animated: true)
    }
    
    private func renderViewState(state: ShelterState) {
        switch state {
        case .success(let savedDogs):
            dogsCollectionView.isHidden = false
            emptyDogsStorageLabel.isHidden = true
            dogs = savedDogs
            dogsCollectionView.reloadData()
        case .empty:
            dogsCollectionView.isHidden = true
            emptyDogsStorageLabel.isHidden = false
        }
    }
}

extension ShelterViewController: UICollectionViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension ShelterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as! CustomCollectionViewCell
        let dog = dogs[indexPath.row]
        cell.setupViews(dog: dog)
        return cell
    }
    
}

extension ShelterViewController: UICollectionViewDelegateFlowLayout {
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
