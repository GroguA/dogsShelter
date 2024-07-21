//
//  AddNewDogViewController.swift
//  Shelter
//
//  Created by Александра Сергеева on 25.09.2023.
//

import UIKit

class AddNewDogViewController: UIViewController, UINavigationControllerDelegate {
    private lazy var contentView = AddNewDogContainerView(delegate: self)
    
    private var viewModel: IAddNewDogViewModel & IAddNewDogNavigation
    
    private lazy var menuItems: [UIAction] = {
        return [
            UIAction(title: "Gallery", image: UIImage(systemName: "photo"), handler: { photo in self.onAddDogPhotoFromGalleryClicked()
            }),
            UIAction(title: "Camera", image: UIImage(systemName: "camera"), handler: { photo in
                self.onAddDogPhotoFromCameraClicked()
            })
        ]
    }()
    
    private lazy var addDogImageButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Add dog image", menu: addDogPhotoMenu)
        return button
    }()
    
    private lazy var addDogPhotoMenu: UIMenu = {
        return UIMenu(title: "Choose", image: nil, identifier: nil, options: [], children: menuItems)
    }()
    
    init(viewModel: IAddNewDogViewModel & IAddNewDogNavigation) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        viewModel.onAction = { action in
            switch action {
            case .showError(let text):
                self.showAlertMessage(message: text)
            case .closeScreen:
                self.viewModel.popSelectBreedScreen()
            }
        }
        
    }
}

private extension AddNewDogViewController {
    func setupViews() {
        navigationItem.title = "Add new dog"
        navigationItem.rightBarButtonItem = addDogImageButton
        
        contentView.saveDogButton.addTarget(self, action: #selector(onSaveDogClicked), for: .touchUpInside)
        contentView.breedTextField.addTarget(self, action: #selector(onBreedTextFieldClicked), for: .touchDown)

    }
    
    @objc func onSaveDogClicked(sender: UIButton) {
        viewModel.onAddDogButtonClicked(
            name: contentView.nameTextField.text,
            breed: contentView.breedTextField.text,
            dateOfBirth: contentView.dateOfBirthTextField.text,
            image: contentView.dogImage.image?.pngData())
    }
    
    @objc func onBreedTextFieldClicked(_ sender: UITextField) {
        viewModel.navigateToSelectBreedScreen() { selectedBreed in
            self.contentView.breedTextField.text = selectedBreed
        }
    }
    
    func showAlertMessage(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
    func onAddDogPhotoFromGalleryClicked() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func onAddDogPhotoFromCameraClicked() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .camera
        picker.delegate = self
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
        contentView.dogImage.image = image
    }
}

