//
//  DogListCollectionViewCell.swift
//  Shelter
//
//  Created by Александра Сергеева on 25.09.2023.
//

import UIKit

class DogListCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: DogListCollectionViewCell.self)
    
    private lazy var nameTitleLabel = LabelsFactory.createLabel(with: "name: ", isTextBold: true)
    private lazy var breedTitleLabel = LabelsFactory.createLabel(with: "breed: ", isTextBold: true)
    private lazy var ageTitleLabel = LabelsFactory.createLabel(with: "age: ", isTextBold: true)
    
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
        contentView.addSubview(nameTitleLabel)
        contentView.addSubview(breedTitleLabel)
        contentView.addSubview(ageTitleLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(breedLabel)
        contentView.addSubview(ageLabel)
        contentView.addSubview(dogImage)
        
        dogImage.image = nil
        
        setupConstraints()
    }
    
    func setupConstraints() {
        let constraints = [
            dogImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: offsetForConstraints),
            dogImage.widthAnchor.constraint(equalTo: dogImage.heightAnchor),
            dogImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            dogImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -offsetForConstraints),
            
            nameTitleLabel.topAnchor.constraint(equalTo: dogImage.topAnchor),
            nameTitleLabel.leadingAnchor.constraint(equalTo: dogImage.trailingAnchor, constant: offsetForConstraints),
            nameTitleLabel.trailingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: dogImage.topAnchor),
            
            breedTitleLabel.topAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor, constant: 4),
            breedTitleLabel.leadingAnchor.constraint(equalTo: nameTitleLabel.leadingAnchor),
            breedTitleLabel.trailingAnchor.constraint(equalTo: breedLabel.leadingAnchor),
            
            breedLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            breedLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            breedLabel.widthAnchor.constraint(equalToConstant: 134),
            
            ageTitleLabel.topAnchor.constraint(equalTo: nameTitleLabel.topAnchor),
            ageTitleLabel.leadingAnchor.constraint(lessThanOrEqualTo: breedLabel.trailingAnchor, constant: offsetForConstraints),
            ageTitleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: ageLabel.leadingAnchor),
            
            ageLabel.topAnchor.constraint(equalTo: ageTitleLabel.topAnchor),
            ageLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -offsetForConstraints)
            
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func fillCell(with dog: DogListDogModel) {
        nameLabel.text = dog.name
        breedLabel.text = dog.breed
        ageLabel.text = dog.age
        dogImage.image = UIImage(data: dog.image)
    }
    
}
