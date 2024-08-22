//
//  NotificationListContainerView.swift
//  Shelter
//
//  Created by Александра Сергеева on 24.07.2024.
//

import UIKit

final class NotificationListContainerView: UIView {
    lazy var notificationsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        collectionView.backgroundColor = .lightGray.withAlphaComponent(0.1)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowsMultipleSelection = true
        collectionView.register(NotificationCollectionViewCell.self, forCellWithReuseIdentifier: NotificationCollectionViewCell.identifier)
        return collectionView
    }()
    
    lazy var emptyNotificationsLabel = LabelsFactory.createLabel(with: "No notifications added yet")
    
    let dataSource = NotificationListCollectionViewDataSource()
    
    private let delegate: UICollectionViewDelegate
    
    init(delegate: UICollectionViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension NotificationListContainerView {
    func setupViews() {
        addSubview(notificationsCollectionView)
        backgroundColor = .systemBackground
        addSubview(emptyNotificationsLabel)
        
        emptyNotificationsLabel.isHidden = true
        
        setupConstraints()
    }
    
    func setupConstraints() {
        let constraints = [
            notificationsCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            notificationsCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            notificationsCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            notificationsCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            emptyNotificationsLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            emptyNotificationsLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
            
        ]
        NSLayoutConstraint.activate(constraints)
        
    }
    
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}
