//
//  NotificationCollectionViewCell.swift
//  Shelter
//
//  Created by Александра Сергеева on 18.01.2024.
//

import UIKit

class NotificationCollectionViewCell: UICollectionViewCell {
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.layer.borderWidth = 2
                self.layer.borderColor = UIColor.green.withAlphaComponent(0.2).cgColor
            } else {
                self.layer.borderWidth = 0
            }
        }
    }
    
    static let identifier = "notifications"
    
    private lazy var notificationStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .leading
        view.spacing = 16
        view.distribution = .fillProportionally
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var dogLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private lazy var notificationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    
    func setupViews(notification: NotificationModel) {
        notificationStackView.addArrangedSubview(dogLabel)
        notificationStackView.addArrangedSubview(notificationLabel)
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.backgroundColor = .white
        contentView.addSubview(notificationStackView)
        
        self.dogLabel.text = "\(notification.dogName)\n\(notification.dogBreed)"
        self.notificationLabel.text = "\(notification.body)\n\(notification.date)"
      
        let constraints = [
            notificationStackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 8),
            notificationStackView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            notificationStackView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            notificationStackView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}

