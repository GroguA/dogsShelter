//
//  DogsFilterViewController.swift
//  Shelter
//
//  Created by Александра Сергеева on 25.10.2023.
//

import UIKit

class DogFiltersViewController: UIViewController {
    
    var onDogFiltersSelected: ((_ filter: DogFiltersModel) -> Void)?
    
    private var viewModel: IDogFiltersViewModel & IDogFiltersNavigation
    
    private lazy var breedFilterIcon: UIImageView = {
        let view = UIImageView()
        let image = UIImage(systemName: "circle")
        view.image = image
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        let breedFilterDeselectTap = UITapGestureRecognizer(target: self, action: #selector(onBreedFilterEnableClicked))
        view.addGestureRecognizer(breedFilterDeselectTap)
        return view
    }()
    
    private lazy var breedFilterLabel: UILabel = {
        let label = UILabel()
        label.text = "Filter by breed"
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.isUserInteractionEnabled = true
        let breedFilterSelectTap = UITapGestureRecognizer(target: self, action: #selector(onBreedFilterDisableClicked))
        label.addGestureRecognizer(breedFilterSelectTap)
        return label
    }()
    
    private lazy var selectedBreedsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var breedsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 16
        view.distribution = .equalSpacing
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var applyFilterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Apply", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var ageFilterIcon: UIImageView = {
        let view = UIImageView()
        let image = UIImage(systemName: "circle")
        view.image = image
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        let ageFilterDeselectTap = UITapGestureRecognizer(target: self, action: #selector(onAgeFilterDisableClicked))
        view.addGestureRecognizer(ageFilterDeselectTap)
        return view
    }()
    
    private lazy var ageFilterLabel: UILabel = {
        let label = UILabel()
        label.text = "Filter by age"
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.isUserInteractionEnabled = true
        let ageFilterSelectTap = UITapGestureRecognizer(target: self, action: #selector(onAgeFilterEnableClicked))
        label.addGestureRecognizer(ageFilterSelectTap)
        return label
    }()
    
    private lazy var ageFilterTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.placeholder = "Fill age"
        textField.keyboardType = .numbersAndPunctuation
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.returnKeyType = .done
        textField.addTarget(self, action: #selector(ageTextFieldEditingChanged), for: .editingChanged)
        return textField
    }()
    
    init(viewModel: IDogFiltersViewModel & IDogFiltersNavigation) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        viewModel.viewStateDidChange = { [weak self] state in
            self?.renderViewState(state: state)
        }
        viewModel.onAction = { [weak self] action in
            self?.processAction(action: action)
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(breedsStackView)
        view.addSubview(breedFilterIcon)
        breedsStackView.addArrangedSubview(breedFilterLabel)
        breedsStackView.addArrangedSubview(selectedBreedsLabel)
        view.addSubview(applyFilterButton)
        navigationItem.title = "Filter"
        view.addSubview(ageFilterLabel)
        view.addSubview(ageFilterIcon)
        view.addSubview(ageFilterTextField)
        
        self.selectedBreedsLabel.isHidden = true
        ageFilterTextField.isHidden = true
        
        let constraints = [
            breedFilterIcon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 16),
            breedFilterIcon.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -16),
            breedFilterIcon.heightAnchor.constraint(equalTo: breedFilterLabel.heightAnchor),
            breedFilterIcon.widthAnchor.constraint(equalTo: breedFilterIcon.heightAnchor),
            
            breedsStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            breedsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            breedsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            applyFilterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            applyFilterButton.widthAnchor.constraint(equalToConstant: 88),
            applyFilterButton.heightAnchor.constraint(equalToConstant: 44),
            applyFilterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            ageFilterLabel.topAnchor.constraint(equalTo: breedsStackView.bottomAnchor, constant: 16),
            ageFilterLabel.leadingAnchor.constraint(equalTo: breedsStackView.leadingAnchor),
            
            ageFilterIcon.topAnchor.constraint(equalTo: ageFilterLabel.topAnchor),
            ageFilterIcon.trailingAnchor.constraint(equalTo: breedFilterIcon.trailingAnchor),
            ageFilterIcon.widthAnchor.constraint(equalTo: breedFilterIcon.widthAnchor),
            ageFilterIcon.heightAnchor.constraint(equalTo: breedFilterIcon.heightAnchor),
            
            ageFilterTextField.topAnchor.constraint(equalTo: ageFilterLabel.bottomAnchor, constant: 16),
            ageFilterTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            ageFilterTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        let dismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(dismissKeyboard)
        
    }
    
    @objc private func onBreedFilterDisableClicked() {
        viewModel.showSelectBreedScreen { [weak self] selectedBreeds in
            self?.viewModel.onBreedFilterChanged(breeds: selectedBreeds)
        }
    }
    
    private func processAction(action: DogFiltersAction) {
        switch action {
        case .applyFilter(let filter):
            onDogFiltersSelected?(filter)
            viewModel.popDogFiltersScreen()
        }
    }
    
    @objc private func applyButtonTapped() {
        viewModel.onApplyButtonTapped()
    }
    
    @objc private func ageTextFieldEditingChanged() {
        if let age = ageFilterTextField.text {
            viewModel.onAgeFilterChanged(age: age)
        }
    }
    
    private func renderViewState(state: DogFiltersState) {
        switch state {
        case .success(let filter):
            if let breeds = filter.breeds {
                self.selectedBreedsLabel.text = breeds.joined(separator: ", ")
                self.breedFilterIcon.image = UIImage(systemName: "xmark")
                self.selectedBreedsLabel.isHidden = false
            } else {
                self.selectedBreedsLabel.isHidden = true
            }
        }
    }
    
    @objc private func onAgeFilterEnableClicked() {
        ageFilterIcon.image = UIImage(systemName: "xmark")
        ageFilterTextField.isHidden = false
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func onAgeFilterDisableClicked() {
        ageFilterTextField.isHidden = true
        ageFilterTextField.text = nil
        ageFilterIcon.image = UIImage(systemName: "circle")
        viewModel.deselectAgeFilterTapped()
    }
    
    @objc private func onBreedFilterEnableClicked() {
        selectedBreedsLabel.isHidden = true
        selectedBreedsLabel.text = nil
        breedFilterIcon.image = UIImage(systemName: "circle")
        viewModel.deselectBreedFilterTapped()
    }
}

extension DogFiltersViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
