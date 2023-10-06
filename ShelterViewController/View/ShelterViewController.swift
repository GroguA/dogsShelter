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
        navigationItem.title = "Dogs"
        
        let constraint = [
            dogsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dogsCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            dogsCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            dogsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            addDogButton.trailingAnchor.constraint(equalTo: dogsCollectionView.trailingAnchor, constant: -32),
            addDogButton.bottomAnchor.constraint(equalTo: dogsCollectionView.bottomAnchor, constant: -16),
            addDogButton.widthAnchor.constraint(equalToConstant: 44),
            addDogButton.heightAnchor.constraint(equalToConstant: 44)
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
            dogs = savedDogs
            dogsCollectionView.reloadData()
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
