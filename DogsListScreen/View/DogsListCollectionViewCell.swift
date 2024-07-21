//
//  DogsListCollectionViewCell.swift
//  Shelter
//
//  Created by Александра Сергеева on 25.09.2023.
//

import UIKit

class DogsListCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: DogsListCollectionViewCell.self)
    
    private lazy var name = LabelsFactory.createLabel(with: "name: ", isTextBold: true)
    private lazy var breed = LabelsFactory.createLabel(with: "breed: ", isTextBold: true)
    private lazy var age = LabelsFactory.createLabel(with: "age: ", isTextBold: true)
    
    private lazy var nameLabel = LabelsFactory.createLabel()
    private lazy var breedLabel = LabelsFactory.createLabel()
    private lazy var ageLabel = LabelsFactory.createLabel()
    
    private lazy var dogImage: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 5
        return image
    }()
    
    private let offsetForConstraints: CGFloat = 16
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.addSubview(name)
        contentView.addSubview(breed)
        contentView.addSubview(age)
        contentView.addSubview(nameLabel)
        contentView.addSubview(breedLabel)
        contentView.addSubview(ageLabel)
        contentView.addSubview(dogImage)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        let constraints = [
            dogImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            dogImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            dogImage.widthAnchor.constraint(equalTo: dogImage.heightAnchor),
            dogImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: offsetForConstraints),
            
            name.topAnchor.constraint(equalTo: dogImage.topAnchor),
            name.leadingAnchor.constraint(equalTo: dogImage.trailingAnchor, constant: offsetForConstraints),
            name.trailingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: dogImage.topAnchor),
            
            breed.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 4),
            breed.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            breed.trailingAnchor.constraint(equalTo: breedLabel.leadingAnchor),
            
            breedLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            breedLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            breedLabel.widthAnchor.constraint(equalToConstant: 134),
            
            age.topAnchor.constraint(equalTo: name.topAnchor),
            age.leadingAnchor.constraint(lessThanOrEqualTo: breedLabel.trailingAnchor, constant: offsetForConstraints),
            age.trailingAnchor.constraint(equalTo: ageLabel.leadingAnchor),
            
            ageLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            ageLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor)
            
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func fillCell(with dog: DogsListDogModel) {
        nameLabel.text = dog.name
        breedLabel.text = dog.breed
        ageLabel.text = dog.age
        dogImage.image = UIImage(data: dog.image)
    }
    
}
