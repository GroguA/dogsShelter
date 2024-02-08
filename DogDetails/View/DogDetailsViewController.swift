//
//  DogDetailsViewController.swift
//  Shelter
//
//  Created by Александра Сергеева on 17.10.2023.
//

import UIKit

class DogDetailsViewController: UIViewController {
    
    var dogId = ""
    
    private let viewModel = DogDetailsViewModel()
    
    private lazy var infoStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 16
        view.distribution = .equalSpacing
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titlesStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 16
        view.distribution = .equalSpacing
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var dogImage: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 5
        return image
    }()
    
    private lazy var dogName: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    private lazy var dogBreed: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    private lazy var dogAge: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    private lazy var name: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textColor = .black
        label.text = "Name: "
        return label
    }()
    
    private lazy var breed: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textColor = .black
        label.text = "Breed: "
        return label
    }()
    
    private lazy var age: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textColor = .black
        label.text = "Age: "
        return label
    }()
    
    private lazy var dateOfWashTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textColor = .black
        label.numberOfLines = 0
        label.text = "Dog's last wash: "
        return label
    }()
    
    private lazy var lastDogsWash: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var updateWashDateButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .systemBlue
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5)
        let button = UIButton(configuration: configuration)
        button.setTitle("Wash dog", for: .normal)
        button.tintColor = .white
        button.configuration?.titleTextAttributesTransformer =
        UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            return outgoing
        }
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.isEnabled = true
        button.setTitleColor(.black, for: .disabled)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(washDogClicked), for: .touchUpInside)
        return button
    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        viewModel.getOneDogByID(id: dogId)
        
        viewModel.viewStateDidChange = { viewState in
            self.renderViewState(state: viewState)
        }
        
        viewModel.onAction = { action in
            switch action {
            case .showError:
                self.showAlert()
            case .closeScreen:
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        self.navigationItem.rightBarButtonItem = menuButton
        
    }
    
    private func setupViews() {
        view.addSubview(dogImage)
        view.backgroundColor = .white
        infoStackView.addArrangedSubview(dogName)
        infoStackView.addArrangedSubview(dogBreed)
        infoStackView.addArrangedSubview(dogAge)
        view.addSubview(infoStackView)
        titlesStackView.addArrangedSubview(name)
        titlesStackView.addArrangedSubview(breed)
        titlesStackView.addArrangedSubview(age)
        view.addSubview(titlesStackView)
        view.addSubview(dateOfWashTitle)
        view.addSubview(lastDogsWash)
        view.addSubview(updateWashDateButton)
        
        navigationItem.title = "Dog info"
        
        let constraints = [
            dogImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            dogImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            dogImage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            dogImage.widthAnchor.constraint(equalToConstant: view.bounds.width - 32),
            dogImage.heightAnchor.constraint(equalTo: dogImage.widthAnchor),
            
            titlesStackView.topAnchor.constraint(equalTo: dogImage.bottomAnchor, constant: 16),
            titlesStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            infoStackView.topAnchor.constraint(equalTo: dogImage.bottomAnchor, constant: 16),
            infoStackView.leadingAnchor.constraint(lessThanOrEqualTo: titlesStackView.trailingAnchor, constant: 1),
            infoStackView.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            dateOfWashTitle.topAnchor.constraint(equalTo: titlesStackView.bottomAnchor, constant: 16),
            dateOfWashTitle.trailingAnchor.constraint(equalTo: lastDogsWash.leadingAnchor, constant: -1),
            dateOfWashTitle.leadingAnchor.constraint(equalTo: titlesStackView.leadingAnchor),
            
            lastDogsWash.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: 16),
            lastDogsWash.leadingAnchor.constraint(equalTo: dateOfWashTitle.trailingAnchor, constant: 16),
            lastDogsWash.trailingAnchor.constraint(greaterThanOrEqualTo: updateWashDateButton.leadingAnchor, constant: -16),
            
            updateWashDateButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            updateWashDateButton.topAnchor.constraint(equalTo: infoStackView.bottomAnchor)
            
        ]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    private func renderViewState(state: DogDetailsState) {
        switch state {
        case .success(let dog):
            dogName.text = dog.name
            dogBreed.text = dog.breed
            dogAge.text = dog.age
            dogImage.image = UIImage(data: dog.image)
            lastDogsWash.text = dog.dateOfWash
            if dog.dateOfWash != nil {
                self.lastDogsWash.text = dog.dateOfWash
            } else {
                self.lastDogsWash.text = "None"
                
            }
        }
    }
    
    @objc private func deleteDogTapped() {
        viewModel.deleteDogClicked(id: dogId)
    }
    
    
    @objc private func washDogClicked() {
        viewModel.updateDogWashClicked()
        self.updateWashDateButton.setTitle("Dog washed", for: .normal)
        self.updateWashDateButton.isEnabled = false
        self.updateWashDateButton.backgroundColor = .systemGray
    }
    
    @objc private func scheduleReminderTapped() {
        let reminderVC = ScheduleReminderViewController()
        let isNotificationOn = DogsNotificationsManager.shared.getAvailability()
        if isNotificationOn {
            navigationController?.pushViewController(reminderVC, animated: true)
            reminderVC.id = self.dogId
        } else {
            return
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Error", message: "Error", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            if action.style == .default {
                self.navigationController?.popViewController(animated: true)
            }
        }))
        present(alert, animated: true)
    }
}
