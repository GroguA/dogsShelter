//
//  AddNewDogContainerView.swift
//  Shelter
//
//  Created by Александра Сергеева on 21.07.2024.
//

import UIKit

class AddNewDogContainerView: UIView {
    lazy var nameTextField = TextFieldsFactory.createTextField(with: "Fill name")
    
    lazy var breedTextField: UITextField = {
        let textField = TextFieldsFactory.createTextField(with: "Select breed")
        textField.delegate = delegate
        return textField
    }()
    
    lazy var dateOfBirthTextField: UITextField = {
        let textField = TextFieldsFactory.createTextField(with: "Select date of birth")
        textField.delegate = delegate
        textField.inputView = dateOfBirthPicker
        textField.inputAccessoryView = toolBar
        return textField
    }()
    
    lazy var dateOfBirthPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.timeZone = .current
        picker.backgroundColor = .white
        picker.maximumDate = Calendar.current.date(byAdding: .day, value: 0, to: Date())
        picker.minimumDate = Calendar.current.date(byAdding: .year, value: -30, to: Date())
        picker.datePickerMode = .date
        picker.timeZone = .autoupdatingCurrent
        picker.preferredDatePickerStyle = .wheels
        picker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        return picker
    }()
    
    lazy var toolBar: UIToolbar = {
        let bar = UIToolbar()
        bar.barStyle = UIBarStyle.default
        bar.isTranslucent = true
        bar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard))
        bar.setItems([doneButton], animated: false)
        bar.isUserInteractionEnabled = true
        return bar
    }()
    
    lazy var dogImage: UIImageView = {
        let defaultImage = UIImageView()
        defaultImage.image = UIImage(systemName: "dog")
        defaultImage.translatesAutoresizingMaskIntoConstraints = false
        defaultImage.contentMode = .scaleAspectFit
        return defaultImage
    }()
    
    lazy var saveDogButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.setTitle("Save this dog", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .regular)
        return button
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

private extension AddNewDogContainerView {
    func setupViews() {
        addSubview(nameTextField)
        addSubview(breedTextField)
        addSubview(saveDogButton)
        addSubview(dateOfBirthTextField)
        addSubview(dogImage)
        
        backgroundColor = .white
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(tap)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        let constraints = [
            nameTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: offsetForConstraints),
            nameTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -offsetForConstraints),
            nameTextField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: offsetForConstraints),
            
            breedTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: offsetForConstraints),
            breedTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            breedTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            
            dateOfBirthTextField.topAnchor.constraint(equalTo: breedTextField.bottomAnchor, constant: offsetForConstraints),
            dateOfBirthTextField.trailingAnchor.constraint(equalTo: breedTextField.trailingAnchor),
            dateOfBirthTextField.leadingAnchor.constraint(equalTo: breedTextField.leadingAnchor),
            
            dogImage.topAnchor.constraint(equalTo: dateOfBirthTextField.bottomAnchor, constant: offsetForConstraints),
            dogImage.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: offsetForConstraints),
            dogImage.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,constant: -offsetForConstraints),
            dogImage.bottomAnchor.constraint(lessThanOrEqualTo: saveDogButton.topAnchor, constant: -offsetForConstraints),
            
            saveDogButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -48),
            saveDogButton.widthAnchor.constraint(equalToConstant: 140),
            saveDogButton.heightAnchor.constraint(equalToConstant: 50),
            saveDogButton.centerXAnchor.constraint(equalTo: centerXAnchor)
            
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func dismissKeyboard() {
        self.endEditing(true)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let selectedDate: String = dateFormatter.string(from: sender.date)
        dateOfBirthTextField.text = selectedDate
    }
    
}
