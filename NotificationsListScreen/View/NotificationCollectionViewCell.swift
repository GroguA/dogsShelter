//
//  NotificationCollectionViewCell.swift
//  Shelter
//
//  Created by Александра Сергеева on 18.01.2024.
//

import UIKit

final class NotificationCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: NotificationCollectionViewCell.self)
    
    private lazy var notificationStackView = StackViewsFactory.createStackView(axis: .horizontal)
    
    private lazy var dogNameLabel: UILabel = {
        let label = LabelsFactory.createLabel()
        label.textAlignment = .left
        return label
    }()
    
    private lazy var notificationTextMessage: UILabel = {
        let label = LabelsFactory.createLabel()
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
        self.backgroundColor = .systemBackground
        contentView.addSubview(notificationStackView)
        
        let constraints = [
            notificationStackView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            notificationStackView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            notificationStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func fillCell(with notification: NotificationModel) {
        self.dogNameLabel.text = "\(notification.dogName)\n\(notification.dogBreed)"
        self.notificationTextMessage.text = "\(notification.body)\n\(notification.date)"
        
        if notification.isSelected {
            self.layer.borderWidth = 2
            self.layer.borderColor = UIColor.systemGreen.cgColor
        } else {
            self.layer.borderWidth = 0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

