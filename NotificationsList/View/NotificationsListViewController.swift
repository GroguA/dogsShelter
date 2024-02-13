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
    private let itemsPerView: CGFloat = 9.5
    private let sectionInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    
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
    
    private lazy var emptyNotificationsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textColor = .black
        label.text = " No notifications added yet"
        return label
    }()
    
    private lazy var trashButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .done, target: self, action: #selector(onDeleteNotificationClicked))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.viewStateDidChange = { viewState in
            self.renderViewState(state: viewState)
        }
        
        setupViews()
        viewModel.getNotifications()

    }
    
    private func setupViews() {
        view.addSubview(notificationsCollectionView)
        view.addSubview(bottomBackground)
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
        view.addSubview(emptyNotificationsLabel)
        
        emptyNotificationsLabel.isHidden = true
                
        let constraints = [
            notificationsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            notificationsCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            notificationsCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            notificationsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            bottomBackground.topAnchor.constraint(equalTo: notificationsCollectionView.bottomAnchor),
            bottomBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            emptyNotificationsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyNotificationsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ]
        NSLayoutConstraint.activate(constraints)
        
    }
    
    private func renderViewState(state: NotificationsState) {
        switch state {
        case .success(let notifications, let isAtLeastOneNotificationSelected):
            self.notifications = notifications
            self.notificationsCollectionView.reloadData()
            if isAtLeastOneNotificationSelected {
                navigationItem.rightBarButtonItem = trashButton
            } else {
                navigationItem.rightBarButtonItem = .none
            }
        case .empty:
            notificationsCollectionView.isHidden = true
            emptyNotificationsLabel.isHidden = false
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
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let notificationIndex = indexPath.row
        viewModel.onNotificationClicked(index: notificationIndex)
        
    }
}

extension NotificationsListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotificationCollectionViewCell.identifier, for: indexPath) as! NotificationCollectionViewCell
        let notification = notifications[indexPath.row]
        cell.setupViews(notification: notification)
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
