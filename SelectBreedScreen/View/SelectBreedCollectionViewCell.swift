//
//  SelectBreedCollectionViewCell.swift
//  Shelter
//
//  Created by Александра Сергеева on 25.10.2023.
//

import UIKit

class SelectBreedCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: SelectBreedCollectionViewCell.self)
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                selectBreedImage.image = UIImage(systemName: "circle.fill")
            } else {
                selectBreedImage.image = UIImage(systemName: "circle")
            }
        }
    }
        
    private lazy var selectBreedImage: UIImageView = {
       let view = UIImageView(image: UIImage(systemName: "circle"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    private lazy var breedLabel = LabelsFactory.createLabel()
    
    private let offsetForConstraints: CGFloat = 16
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.addSubview(selectBreedImage)
        contentView.addSubview(breedLabel)
                
        let constraints = [
            selectBreedImage.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: offsetForConstraints),
            selectBreedImage.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            selectBreedImage.heightAnchor.constraint(equalTo: breedLabel.heightAnchor),
            selectBreedImage.widthAnchor.constraint(equalTo: selectBreedImage.heightAnchor),
            selectBreedImage.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -offsetForConstraints),
            
            breedLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: offsetForConstraints),
            breedLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            breedLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -offsetForConstraints),

        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func fillCell(with breed: SelectBreedModel) {
        breedLabel.text = breed.breed
    }
    
}
