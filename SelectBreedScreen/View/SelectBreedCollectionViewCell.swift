//
//  SelectBreedCollectionViewCell.swift
//  Shelter
//
//  Created by Александра Сергеева on 25.10.2023.
//

import UIKit

class SelectBreedCollectionViewCell: UICollectionViewCell {
    static let identifier = "selectBreedViewCell"
    
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
        
    private lazy var breedLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        contentView.addSubview(selectBreedImage)
        contentView.addSubview(breedLabel)
                
        let constraints = [
            selectBreedImage.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            selectBreedImage.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            selectBreedImage.heightAnchor.constraint(equalTo: breedLabel.heightAnchor),
            selectBreedImage.widthAnchor.constraint(equalTo: selectBreedImage.heightAnchor),
            
            breedLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            breedLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func fillCell(breed: SelectBreedModel) {
        breedLabel.text = breed.breed
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
