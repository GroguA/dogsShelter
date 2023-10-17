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
        label.text = "name: "
        return label
    }()
    
    private lazy var breed: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textColor = .black
        label.text = "breed: "
        return label
    }()
    
    private lazy var age: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textColor = .black
        label.text = "age: "
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
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
            infoStackView.leadingAnchor.constraint(lessThanOrEqualTo: titlesStackView.trailingAnchor),
            infoStackView.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        let dog = viewModel.getOneDog(id: id)
        guard let nonOptDog = dog else { return }
        dogName.text = nonOptDog.name
        dogBreed.text = nonOptDog.breed
        dogAge.text = nonOptDog.age
        dogImage.image = UIImage(data: nonOptDog.image)
    }
    
}
