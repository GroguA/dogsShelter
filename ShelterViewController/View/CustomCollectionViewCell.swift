//
//  CustomCollectionViewCell.swift
//  Shelter
//
//  Created by Александра Сергеева on 25.09.2023.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    static let identifier = "dogs"
    
    private lazy var name: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textColor = .black
        label.text = "name: "
        return label
    }()
    
    private lazy var breed: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textColor = .black
        label.text = "breed: "
        return label
    }()
    
    private lazy var age: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textColor = .black
        label.text = "age: "
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    private lazy var breedLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    private lazy var ageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    private lazy var dogImage: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 5
        return image
    }()
    
    func setupViews(dog: ShelterDogModel) {
        contentView.addSubview(name)
        contentView.addSubview(breed)
        contentView.addSubview(age)
        contentView.addSubview(nameLabel)
        contentView.addSubview(breedLabel)
        contentView.addSubview(ageLabel)
        contentView.addSubview(dogImage)
        
        nameLabel.text = dog.name
        breedLabel.text = dog.breed
        ageLabel.text = dog.age
        dogImage.image = UIImage(data: dog.image)
        
        let constraints = [
            dogImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            dogImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            dogImage.widthAnchor.constraint(equalTo: dogImage.heightAnchor),
            dogImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            name.topAnchor.constraint(equalTo: dogImage.topAnchor),
            name.leadingAnchor.constraint(equalTo: dogImage.trailingAnchor, constant: 16),
            name.trailingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: dogImage.topAnchor),

            breed.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 4),
            breed.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            breed.trailingAnchor.constraint(equalTo: breedLabel.leadingAnchor),
            
            breedLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            breedLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            breedLabel.widthAnchor.constraint(equalToConstant: 134),
            
            age.topAnchor.constraint(equalTo: name.topAnchor),
            age.leadingAnchor.constraint(lessThanOrEqualTo: breedLabel.trailingAnchor, constant: 16),
            age.trailingAnchor.constraint(equalTo: ageLabel.leadingAnchor),
            
            ageLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            ageLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor)
            
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
