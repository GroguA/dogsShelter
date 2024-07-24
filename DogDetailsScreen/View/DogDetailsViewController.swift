//
//  DogDetailsViewController.swift
//  Shelter
//
//  Created by Александра Сергеева on 17.10.2023.
//

import UIKit

class DogDetailsViewController: UIViewController {
    private var viewModel: IDogDetailsViewModel & IDogDetailsNavigation
    
    private let containerView = DogDetailsContainerView()
    
    private lazy var menuItems: [UIAction] = {
        return [
            UIAction(title: "Schedule a reminder", image: UIImage(systemName: "calendar.badge.plus"), handler: { _ in
                self.scheduleReminderTapped()
            }),
            UIAction(title: "Delete", image: UIImage(systemName: "trash"), handler: { _ in
                self.deleteDogTapped()
            })
        ]
    }()
    
    private lazy var menu: UIMenu = {
        let menu = UIMenu(options: .displayInline, children: menuItems)
        return menu
    }()
    
    private lazy var menuButton: UIBarButtonItem = {
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), menu: menu)
        return menuButton
    }()
    
    init(viewModel: IDogDetailsViewModel & IDogDetailsNavigation) {
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
        
        viewModel.viewStateDidChange = { [weak self] viewState in
            self?.renderViewState(state: viewState)
        }
        
        viewModel.onAction = { [weak self] action in
            switch action {
            case .showError:
                self?.showAlert()
            case .closeScreen:
                self?.viewModel.popDogDetailsScreen()
            }
        }
        
    }
}

private extension DogDetailsViewController {
    func setupViews() {
        navigationItem.rightBarButtonItem = menuButton
        navigationItem.title = "Dog info"
        
        containerView.updateWashDateButton.addTarget(self, action: #selector(washDogClicked), for: .touchUpInside)
    }
    
    func renderViewState(state: DogDetailsState) {
        switch state {
        case .success(let dog):
            containerView.dogNameLabel.text = dog.name
            containerView.dogBreedLabel.text = dog.breed
            containerView.dogAgeLabel.text = dog.age
            containerView.dogImage.image = UIImage(data: dog.image)
            containerView.lastDogsWashLabel.text = dog.dateOfWash
        }
    }
    
    @objc func deleteDogTapped() {
        viewModel.deleteDogClicked()
    }
    
    
    @objc func washDogClicked() {
        viewModel.updateDogWashClicked()
        containerView.updateWashDateButton.setTitle("Dog washed", for: .normal)
        containerView.updateWashDateButton.isEnabled = false
        containerView.updateWashDateButton.backgroundColor = .systemGray
    }
    
    @objc func scheduleReminderTapped() {
        viewModel.navigateToScheduleReminderScreen()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Error", message: "Error", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            if action.style == .default {
                self.navigationController?.popViewController(animated: true)
            }
        }))
        present(alert, animated: true)
    }
}
