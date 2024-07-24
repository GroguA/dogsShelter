//
//  NotificationListViewController.swift
//  Shelter
//
//  Created by Александра Сергеева on 17.01.2024.
//

import UIKit

class NotificationListViewController: UIViewController {
    
    private var viewModel: INotificationListViewModel
    
    private lazy var containerView = NotificationListContainerView(delegate: self)
    
    private lazy var deleteButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .done, target: self, action: #selector(onDeleteNotificationClicked))
        return button
    }()
    
    init(viewModel: INotificationListViewModel) {
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
        
        viewModel.viewStateDidChange = { [weak self] viewState in
            self?.renderViewState(state: viewState)
        }
        
    }
}

private extension NotificationListViewController {
    func setupViews() {
        navigationItem.title = "Notifications"
    }
    
    func renderViewState(state: NotificationsState) {
        switch state {
        case .success(let notifications, let atLeastOneNotificationSelected):
            containerView.dataSource.setNotifications(notifications)
            containerView.notificationsCollectionView.reloadData()
            if atLeastOneNotificationSelected {
                navigationItem.rightBarButtonItem = deleteButton
            } else {
                navigationItem.rightBarButtonItem = .none
            }
        case .empty:
            containerView.notificationsCollectionView.isHidden = true
            containerView.emptyNotificationsLabel.isHidden = false
        }
    }
    
    @objc private func onDeleteNotificationClicked() {
        viewModel.onDeleteNotificationTapped()
    }
}

extension NotificationListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let notificationIndex = indexPath.row
        viewModel.onNotificationClicked(index: notificationIndex)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let notificationIndex = indexPath.row
        viewModel.onNotificationClicked(index: notificationIndex)
        
    }
}

