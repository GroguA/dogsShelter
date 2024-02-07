//
//  AddNewDogViewController.swift
//  Shelter
//
//  Created by Александра Сергеева on 25.09.2023.
//

import UIKit

class AddNewDogViewController: UIViewController {
            
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
        breed.borderStyle = .roundedRect
        breed.autocorrectionType = .no
        breed.translatesAutoresizingMaskIntoConstraints = false
        breed.addTarget(self, action: #selector(onBreedTextFieldClicked), for: .touchDown)
        return breed
    }()
    
    private lazy var dateOfBirthTextField: UITextField = {
        let date = UITextField()
        date.delegate = self
        date.placeholder = "Select date of birth"
        date.keyboardType = .default
        date.borderStyle = .roundedRect
        date.autocorrectionType = .no
        date.inputView = dateOfBirthPicker
        date.inputAccessoryView = toolBar
        date.translatesAutoresizingMaskIntoConstraints = false
        return date
    }()
    
    private lazy var dateOfBirthPicker: UIDatePicker = {
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
    
    private lazy var saveDogButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .systemBlue
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5)
        let button = UIButton(configuration: configuration)
        button.configuration?.titleTextAttributesTransformer =
        UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            return outgoing
        }
        button.setTitle("Save this dog", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(onSaveDogClicked), for: .touchUpInside)
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
    
    private lazy var dogImage: UIImageView = {
        let defaultImage = UIImageView()
        defaultImage.image = UIImage(systemName: "dog")
        defaultImage.translatesAutoresizingMaskIntoConstraints = false
        defaultImage.contentMode = .scaleAspectFit
        return defaultImage
    }()
    
    private lazy var menuItems: [UIAction] = {
        return [
            UIAction(title: "Gallery", image: UIImage(systemName: "photo"), handler: { photo in self.onAddDogPhotoFromGalleryClicked()
            }),
            UIAction(title: "Camera", image: UIImage(systemName: "camera"), handler: { photo in
                self.onAddDogPhotoFromCameraClicked()
            })
        ]
    }()

    private lazy var addDogPhotoMenu: UIMenu = {
        return UIMenu(title: "Choose", image: nil, identifier: nil, options: [], children: menuItems)
    }()

    private lazy var addDogImageButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Add dog image", menu: addDogPhotoMenu)
       return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        viewModel.onAction = { action in
            switch action {
            case .showError(let text):
                self.showAlertMessage(message: text)
            case .closeScreen:
                self.navigationController?.popViewController(animated: true)
            }
        }

    }
    
    private func setupViews() {
        view.addSubview(nameTextField)
        view.addSubview(breedTextField)
        view.addSubview(saveDogButton)
        view.addSubview(dateOfBirthTextField)
        view.addSubview(dogImage)
        
        navigationItem.title = "Add new dog"
        navigationItem.rightBarButtonItem = addDogImageButton
        
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
            
            dogImage.topAnchor.constraint(equalTo: dateOfBirthTextField.bottomAnchor, constant: 16),
            dogImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            dogImage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -16),
            dogImage.bottomAnchor.constraint(lessThanOrEqualTo: saveDogButton.topAnchor, constant: -16),
            
            saveDogButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            saveDogButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func onSaveDogClicked(sender: UIButton) {
        viewModel.onAddDogBtnClicked(name: nameTextField.text, breed: breedTextField.text, dateOfBirth: dateOfBirthTextField.text, image: dogImage.image?.pngData())
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
    
    @objc private func onBreedTextFieldClicked(_ sender: UITextField) {
        let vc = SelectBreedViewController()
        vc.isSingleSelectMode = true
        vc.doOnSingleSelect = { selectedBreed in
            self.breedTextField.text = selectedBreed
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func onAddDogPhotoFromGalleryClicked() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    private func onAddDogPhotoFromCameraClicked() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .camera
        present(picker, animated: true)
    }
}

extension AddNewDogViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        false
    }
}

extension AddNewDogViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else { return }
        self.dogImage.image = image
    }
}
 
