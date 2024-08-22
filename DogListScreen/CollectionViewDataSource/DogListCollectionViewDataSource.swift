//
//  DogListCollectionViewDataSource.swift
//  Shelter
//
//  Created by Александра Сергеева on 20.07.2024.
//

import UIKit

final class DogListCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    var dogs: [DogListDogModel] = []
    
    func setDogs(_ dogs: [DogListDogModel]) {
        self.dogs = dogs
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DogListCollectionViewCell.identifier,
            for: indexPath) as? DogListCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        let dog = dogs[indexPath.item]
        cell.fillCell(with: dog)
        
        return cell
    }
}
