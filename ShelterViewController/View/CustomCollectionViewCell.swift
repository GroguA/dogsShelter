//
//  CustomCollectionViewCell.swift
//  Shelter
//
//  Created by Александра Сергеева on 25.09.2023.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    static let identifier = "dogs"
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    private lazy var breedLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    private lazy var ageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    func setupViews(dog: DogModel) {
        contentView.addSubview(nameLabel)
        contentView.addSubview(breedLabel)
        contentView.addSubview(ageLabel)
        
        nameLabel.text = dog.name
        breedLabel.text = dog.breed
        ageLabel.text = dog.age
        
        let constraints = [
            nameLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            
            breedLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            breedLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            breedLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            
            ageLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 2),
            ageLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
            
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
