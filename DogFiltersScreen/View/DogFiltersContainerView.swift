//
//  DogFiltersContainerView.swift
//  Shelter
//
//  Created by Александра Сергеева on 22.07.2024.
//

import UIKit

final class DogFiltersContainerView: UIView {
    lazy var breedFilterIcon: UIImageView = {
        let view = UIImageView()
        let image = UIImage(systemName: "circle")
        view.image = image
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var breedFilterLabel: UILabel = {
        let label = LabelsFactory.createLabel(with: "Filter by breed")
        label.isUserInteractionEnabled = true
        return label
    }()
    
    lazy var selectedBreedsLabel = LabelsFactory.createLabel()

    lazy var breedsStackView = StackViewsFactory.createStackView()
    
    lazy var applyFilterButton = ButtonsFactory.createButton(with: "Apply")
    
    lazy var ageFilterIcon: UIImageView = {
        let view = UIImageView()
        let image = UIImage(systemName: "circle")
        view.image = image
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var ageFilterLabel: UILabel = {
        let label = LabelsFactory.createLabel(with: "Filter by age")
        label.isUserInteractionEnabled = true
        return label
    }()
    
    lazy var ageFilterTextField: UITextField = {
        let textField = TextFieldsFactory.createTextField(with: "Fill age")
        textField.delegate = delegate
        textField.keyboardType = .numbersAndPunctuation
        textField.returnKeyType = .done
        return textField
    }()
    
    private let delegate: UITextFieldDelegate
    
    private let offsetForConstraints: CGFloat = 16
    
    init(delegate: UITextFieldDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension DogFiltersContainerView {
    func setupViews() {
        backgroundColor = .white
        
        addSubview(breedsStackView)
        addSubview(breedFilterIcon)
        addSubview(applyFilterButton)
        addSubview(ageFilterLabel)
        addSubview(ageFilterIcon)
        addSubview(ageFilterTextField)
        
        breedsStackView.addArrangedSubview(breedFilterLabel)
        breedsStackView.addArrangedSubview(selectedBreedsLabel)
        
        selectedBreedsLabel.isHidden = true
        ageFilterTextField.isHidden = true
        
        setupConstraints()
        
        let dismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(dismissKeyboard)
    }
        
        func setupConstraints() {
        let constraints = [
            breedFilterIcon.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,constant: offsetForConstraints),
            breedFilterIcon.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,constant: -offsetForConstraints),
            breedFilterIcon.heightAnchor.constraint(equalTo: breedFilterLabel.heightAnchor),
            breedFilterIcon.widthAnchor.constraint(equalTo: breedFilterIcon.heightAnchor),
            
            breedsStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: offsetForConstraints),
            breedsStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: offsetForConstraints),
            breedsStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -offsetForConstraints),
            
            applyFilterButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -offsetForConstraints),
            applyFilterButton.widthAnchor.constraint(equalToConstant: 88),
            applyFilterButton.heightAnchor.constraint(equalToConstant: 44),
            applyFilterButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            ageFilterLabel.topAnchor.constraint(equalTo: breedsStackView.bottomAnchor, constant: offsetForConstraints),
            ageFilterLabel.leadingAnchor.constraint(equalTo: breedsStackView.leadingAnchor),
            
            ageFilterIcon.topAnchor.constraint(equalTo: ageFilterLabel.topAnchor),
            ageFilterIcon.trailingAnchor.constraint(equalTo: breedFilterIcon.trailingAnchor),
            ageFilterIcon.widthAnchor.constraint(equalTo: breedFilterIcon.widthAnchor),
            ageFilterIcon.heightAnchor.constraint(equalTo: breedFilterIcon.heightAnchor),
            
            ageFilterTextField.topAnchor.constraint(equalTo: ageFilterLabel.bottomAnchor, constant: offsetForConstraints),
            ageFilterTextField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: offsetForConstraints),
            ageFilterTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -offsetForConstraints)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    @objc func dismissKeyboard() {
        endEditing(true)
    }
}
