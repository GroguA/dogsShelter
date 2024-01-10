//
//  OneDogViewController.swift
//  Shelter
//
//  Created by Александра Сергеева on 17.10.2023.
//

import UIKit

class OneDogViewController: UIViewController {
    
    var id = ""
    
    private let viewModel = OneDogViewModel()
    
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
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textColor = .black
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
        button.addTarget(self, action: #selector(updateDogsWash), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        viewModel.getOneDogByID(id: id)
        
        viewModel.viewStateDidChange = { viewState in
            self.renderViewState(state: viewState)
        }
        
        viewModel.onAction = { action in
            switch action {
            case .error:
                self.errorLabel.text = "Error"
                self.errorLabel.isHidden = false
            case .deleteDog:
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteDogTapped))
        self.navigationItem.rightBarButtonItem?.tintColor = .red
        
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
        view.addSubview(errorLabel)
        view.addSubview(dateOfWashTitle)
        view.addSubview(lastDogsWash)
        errorLabel.isHidden = true
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
            
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
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
    
    private func renderViewState(state: OneDogState) {
        switch state {
        case .success(let dog, let isDogWashed):
            errorLabel.isHidden = true
            dogName.text = dog.name
            dogBreed.text = dog.breed
            dogAge.text = dog.age
            dogImage.image = UIImage(data: dog.image)
            lastDogsWash.text = dog.dateOfWash
            if isDogWashed {
                self.lastDogsWash.text = dog.dateOfWash
            } else {
                self.lastDogsWash.text = "None"
            }
        }
    }
    
    @objc private func deleteDogTapped() {
        viewModel.deleteDogClicked(id: id)
    }
    
    @objc private func updateDogsWash() {
        viewModel.updateDogWashClicked()
        self.updateWashDateButton.setTitle("Dog washed", for: .normal)
        self.updateWashDateButton.isEnabled = false
        self.updateWashDateButton.backgroundColor = .systemGray
    }
    
}
