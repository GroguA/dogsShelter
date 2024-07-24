//
//  NotificationCollectionViewCell.swift
//  Shelter
//
//  Created by Александра Сергеева on 18.01.2024.
//

import UIKit

class NotificationCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "dogNotificationViewCell"
    
    private lazy var notificationStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .leading
        view.spacing = 16
        view.distribution = .fillProportionally
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var dogNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private lazy var notificationTextMessage: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        notificationStackView.addArrangedSubview(dogNameLabel)
        notificationStackView.addArrangedSubview(notificationTextMessage)
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.backgroundColor = .white
        contentView.addSubview(notificationStackView)
      
        let constraints = [
            notificationStackView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            notificationStackView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            notificationStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func fillCell(notification: NotificationModel) {
        self.dogNameLabel.text = "\(notification.dogName)\n\(notification.dogBreed)"
        self.notificationTextMessage.text = "\(notification.body)\n\(notification.date)"
        
        if notification.isSelected {
            self.layer.borderWidth = 2
            self.layer.borderColor = UIColor.green.withAlphaComponent(0.2).cgColor
        } else {
            self.layer.borderWidth = 0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

