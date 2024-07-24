//
//  DogDetailsContainerView.swift
//  Shelter
//
//  Created by Александра Сергеева on 23.07.2024.
//

import UIKit

final class DogDetailsContainerView: UIView {
    lazy var infoStackView = StackViewsFactory.createStackView()
    
    lazy var titlesStackView = StackViewsFactory.createStackView()

    lazy var dogImage: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 5
        return image
    }()
    
    lazy var dogNameLabel = LabelsFactory.createLabel()
    lazy var dogBreedLabel = LabelsFactory.createLabel()
    lazy var dogAgeLabel = LabelsFactory.createLabel()
    lazy var lastDogsWashLabel = LabelsFactory.createLabel()
    
    lazy var nameTitleLabel = LabelsFactory.createLabel(with: "Name: ", isTextBold: true)
    lazy var breedTitleLabel = LabelsFactory.createLabel(with: "Breed: ", isTextBold: true)
    lazy var ageTitleLabel = LabelsFactory.createLabel(with: "Age: ", isTextBold: true)
    lazy var dateOfWashTitleLabel = LabelsFactory.createLabel(with: "Last wash: ", isTextBold: true)
    
    lazy var updateWashDateButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.setTitle("Wash dog", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.setTitleColor(.black, for: .disabled)
        button.titleLabel?.font = .systemFont(ofSize: 19, weight: .regular)
        return button
    }()
    
    private let offsetForConstraints: CGFloat = 16
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension DogDetailsContainerView {
    func setupViews() {
        addSubview(dogImage)
        addSubview(infoStackView)
        addSubview(titlesStackView)
        addSubview(dateOfWashTitleLabel)
        addSubview(lastDogsWashLabel)
        addSubview(updateWashDateButton)
        
        backgroundColor = .white
        
        infoStackView.addArrangedSubview(dogNameLabel)
        infoStackView.addArrangedSubview(dogBreedLabel)
        infoStackView.addArrangedSubview(dogAgeLabel)
        titlesStackView.addArrangedSubview(nameTitleLabel)
        titlesStackView.addArrangedSubview(breedTitleLabel)
        titlesStackView.addArrangedSubview(ageTitleLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        let constraints = [
            dogImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: offsetForConstraints),
            dogImage.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: offsetForConstraints),
            dogImage.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -offsetForConstraints),
            dogImage.heightAnchor.constraint(equalTo: dogImage.widthAnchor),
            
            titlesStackView.topAnchor.constraint(equalTo: dogImage.bottomAnchor, constant: offsetForConstraints),
            titlesStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: offsetForConstraints),
            
            infoStackView.topAnchor.constraint(equalTo: dogImage.bottomAnchor, constant: offsetForConstraints),
            infoStackView.leadingAnchor.constraint(lessThanOrEqualTo: titlesStackView.trailingAnchor, constant: 1),
            infoStackView.trailingAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.trailingAnchor, constant: -offsetForConstraints),
            
            dateOfWashTitleLabel.topAnchor.constraint(equalTo: titlesStackView.bottomAnchor, constant: offsetForConstraints),
            dateOfWashTitleLabel.leadingAnchor.constraint(equalTo: titlesStackView.leadingAnchor),
            
            lastDogsWashLabel.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: offsetForConstraints),
            lastDogsWashLabel.leadingAnchor.constraint(equalTo: dateOfWashTitleLabel.trailingAnchor, constant: offsetForConstraints),
            lastDogsWashLabel.trailingAnchor.constraint(greaterThanOrEqualTo: updateWashDateButton.leadingAnchor, constant: -offsetForConstraints),
            
            updateWashDateButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -offsetForConstraints),
            updateWashDateButton.centerYAnchor.constraint(equalTo: lastDogsWashLabel.centerYAnchor)
            
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
