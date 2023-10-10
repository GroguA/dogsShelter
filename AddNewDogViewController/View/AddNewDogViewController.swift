//
//  AddNewDogViewController.swift
//  Shelter
//
//  Created by Александра Сергеева on 25.09.2023.
//

import UIKit

class AddNewDogViewController: UIViewController {
    
    private let breeds = ["German Shepherd Dog","Basset Hound","Dachshund","Beagle","Akita", "Dalmatian"]
    
    private let viewModel = AddNewDogViewModel()
        
    private lazy var nameTextField: UITextField = {
        let name = UITextField()
        name.placeholder = "Fill name"
        name.keyboardType = .default
        name.autocapitalizationType = .words
        name.borderStyle = .roundedRect
        name.autocorrectionType = .no
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    private lazy var breedTextField: UITextField = {
        let breed = UITextField()
        breed.delegate = self
        breed.placeholder = "Select breed"
        breed.keyboardType = .default
        breed.autocapitalizationType = .words
        breed.borderStyle = .roundedRect
        breed.autocorrectionType = .no
        breed.inputView = breedPicker
        breed.inputAccessoryView = toolBar
        breed.translatesAutoresizingMaskIntoConstraints = false
        return breed
    }()
    
    private lazy var dateOfBirthTextField: UITextField = {
        let date = UITextField()
        date.delegate = self
        date.placeholder = "Select date of birth"
        date.keyboardType = .default
        date.autocapitalizationType = .words
        date.borderStyle = .roundedRect
        date.autocorrectionType = .no
        date.inputView = dateOfBirthPicker
        date.inputAccessoryView = toolBar
        date.translatesAutoresizingMaskIntoConstraints = false
        return date
    }()
    
    private lazy var breedPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    private lazy var dateOfBirthPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.timeZone = .current
        picker.backgroundColor = .white
        picker.datePickerMode = .date
        picker.timeZone = .autoupdatingCurrent
        picker.preferredDatePickerStyle = .wheels
        picker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        return picker
    }()
    
    private lazy var saveDogButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .systemBlue
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5)
        let button = UIButton(configuration: configuration)
        button.setTitle("Save this dog", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveDogToStorage), for: .touchUpInside)
        return button
    }()
    
    private lazy var toolBar: UIToolbar = {
       let bar = UIToolbar()
        bar.barStyle = UIBarStyle.default
        bar.isTranslucent = true
        bar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard))
        bar.setItems([doneButton], animated: false)
        bar.isUserInteractionEnabled = true
        return bar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        viewModel.viewStateDidChange = { viewState in
            if viewState == .success {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        viewModel.onAction = { action in
            switch action {
            case .editingError:
                self.showAlertMessage(message: action.rawValue)
            case .saveError:
                self.showAlertMessage(message: action.rawValue)
            }
        }
    }
    
    private func setupViews() {
        view.addSubview(nameTextField)
        view.addSubview(breedTextField)
        view.addSubview(saveDogButton)
        view.addSubview(dateOfBirthTextField)
        navigationItem.title = "Add new dog"

        view.backgroundColor = .white
        
        let constraints = [
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            breedTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            breedTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            breedTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            
            dateOfBirthTextField.topAnchor.constraint(equalTo: breedTextField.bottomAnchor, constant: 16),
            dateOfBirthTextField.trailingAnchor.constraint(equalTo: breedTextField.trailingAnchor),
            dateOfBirthTextField.leadingAnchor.constraint(equalTo: breedTextField.leadingAnchor),
            
            saveDogButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            saveDogButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func saveDogToStorage(sender: UIButton) {
        viewModel.onAddDogBtnClicked(name: nameTextField.text, breed: breedTextField.text, dateOfBirth: dateOfBirthTextField.text)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func showAlertMessage(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker){
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let selectedDate: String = dateFormatter.string(from: sender.date)
        dateOfBirthTextField.text = selectedDate
    }
}

extension AddNewDogViewController: UIPickerViewDelegate {
    
}

extension AddNewDogViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breeds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return breeds[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        breedTextField.text = breeds[row]
    }
    
}

extension AddNewDogViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        false
    }
}
