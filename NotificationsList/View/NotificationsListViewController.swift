//
//  NotificationsListViewController.swift
//  Shelter
//
//  Created by Александра Сергеева on 17.01.2024.
//

import UIKit

class NotificationsListViewController: UIViewController {
    
    private let viewModel = NotificationsViewModel()
    
    private var notifications = [NotificationModel]()
    
    private let itemsPerRow: CGFloat = 1
    private let itemsPerView: CGFloat = 10
    private var sectionInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    
    private lazy var notificationsCollectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .lightGray.withAlphaComponent(0.1)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowsMultipleSelection = true
        collectionView.register(NotificationCollectionViewCell.self, forCellWithReuseIdentifier: NotificationCollectionViewCell.identifier)
        return collectionView
    }()
    
    private let bottomBackground: UIView = {
        let background = UIView()
        background.translatesAutoresizingMaskIntoConstraints = false
        background.backgroundColor = .lightGray.withAlphaComponent(0.1)
        return background
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.viewStateDidChange = { viewState in
            self.renderViewState(state: viewState)
        }
        
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(notificationsCollectionView)
        view.addSubview(bottomBackground)
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
        
        viewModel.getNotifications()
        
        let constraints = [
            notificationsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            notificationsCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            notificationsCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            notificationsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            bottomBackground.topAnchor.constraint(equalTo: notificationsCollectionView.bottomAnchor),
            bottomBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            
        ]
        NSLayoutConstraint.activate(constraints)
        
    }
    
    private func renderViewState(state: NotificationsState) {
        switch state {
        case .success(let notifications):
            self.notificationsCollectionView.reloadData()
            self.notifications = notifications
            if notifications.isEmpty {
                navigationItem.rightBarButtonItem = .none
            }
        }
    }
    
    @objc private func onDeleteNotificationClicked() {
        viewModel.onDeleteNotificationTapped()
    }
}

extension NotificationsListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let notificationIndex = indexPath.row
        viewModel.onNotificationClicked(index: notificationIndex)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .done, target: self, action: #selector(onDeleteNotificationClicked))
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let notificationIndex = indexPath.row
        viewModel.onNotificationClicked(index: notificationIndex)
        if !notifications.contains(where: { $0.isSelected} ) {
            navigationItem.rightBarButtonItem = .none
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .done, target: self, action: #selector(onDeleteNotificationClicked))
        }
        
    }
}

extension NotificationsListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotificationCollectionViewCell.identifier, for: indexPath) as! NotificationCollectionViewCell
        let notification = notifications[indexPath.row]
        cell.setupViews(bodyText: notification.body, dateText: notification.date, dogName: notification.dogName, dogBreed: notification.dogBreed, isSelected: notification.isSelected)
        return cell
    }
}


extension NotificationsListViewController: UICollectionViewDelegateFlowLayout {
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
        return sectionInsets.top
    }
}