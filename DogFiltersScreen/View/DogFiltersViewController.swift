//
//  DogFiltersViewController.swift
//  Shelter
//
//  Created by Александра Сергеева on 25.10.2023.
//

import UIKit

final class DogFiltersViewController: UIViewController {
    var onDogFiltersSelected: ((_ filter: DogFiltersModel) -> Void)?
    
    private var viewModel: IDogFiltersViewModel & IDogFiltersNavigation
    
    private lazy var containerView = DogFiltersContainerView(delegate: self)
    
    init(viewModel: IDogFiltersViewModel & IDogFiltersNavigation) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = containerView
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
    
}

private extension DogFiltersViewController {
    func setupViews() {
        navigationItem.title = "Filter"
        
        let breedFilterDeselectTap = UITapGestureRecognizer(
            target: self,
            action: #selector(onBreedFilterEnableClicked)
        )
        containerView.breedFilterIcon.addGestureRecognizer(breedFilterDeselectTap)
        
        let breedFilterSelectTap = UITapGestureRecognizer(
            target: self,
            action: #selector(onBreedFilterDisableClicked)
        )
        containerView.breedFilterLabel.addGestureRecognizer(breedFilterSelectTap)
        
        containerView.applyFilterButton.addTarget(
            self,
            action: #selector(applyButtonTapped),
            for: .touchUpInside
        )
        
        let ageFilterDeselectTap = UITapGestureRecognizer(
            target: self,
            action: #selector(onAgeFilterDisableClicked)
        )
        containerView.ageFilterIcon.addGestureRecognizer(ageFilterDeselectTap)
        
        let ageFilterSelectTap = UITapGestureRecognizer(
            target: self,
            action: #selector(onAgeFilterEnableClicked)
        )
        containerView.ageFilterLabel.addGestureRecognizer(ageFilterSelectTap)
        
        containerView.ageFilterTextField.addTarget(
            self,
            action: #selector(ageTextFieldEditingChanged),
            for: .editingChanged
        )
        
    }
    
    @objc func onBreedFilterDisableClicked() {
        viewModel.showSelectBreedScreen { [weak self] selectedBreeds in
            self?.viewModel.onBreedFilterChanged(breeds: selectedBreeds)
        }
    }
    
    func processAction(action: DogFiltersAction) {
        switch action {
        case .applyFilter(let filter):
            onDogFiltersSelected?(filter)
            viewModel.popDogFiltersScreen()
        }
    }
    
    @objc func applyButtonTapped() {
        viewModel.onApplyButtonTapped()
    }
    
    @objc func ageTextFieldEditingChanged() {
        if let age = containerView.ageFilterTextField.text {
            viewModel.onAgeFilterChanged(age: age)
        }
    }
    
    func renderViewState(state: DogFiltersState) {
        switch state {
        case .success(let filter):
            if let breeds = filter.breeds {
                containerView.selectedBreedsLabel.text = breeds.joined(separator: ", ")
                containerView.breedFilterIcon.image = UIImage(systemName: "xmark")
                containerView.selectedBreedsLabel.isHidden = false
            } else {
                containerView.selectedBreedsLabel.isHidden = true
            }
        }
    }
    
    @objc func onAgeFilterEnableClicked() {
        containerView.ageFilterIcon.image = UIImage(systemName: "xmark")
        containerView.ageFilterTextField.isHidden = false
    }
    
    @objc func onAgeFilterDisableClicked() {
        containerView.ageFilterTextField.isHidden = true
        containerView.ageFilterTextField.text = nil
        containerView.ageFilterIcon.image = UIImage(systemName: "circle")
        viewModel.deselectAgeFilterTapped()
    }
    
    @objc func onBreedFilterEnableClicked() {
        containerView.selectedBreedsLabel.isHidden = true
        containerView.selectedBreedsLabel.text = nil
        containerView.breedFilterIcon.image = UIImage(systemName: "circle")
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
