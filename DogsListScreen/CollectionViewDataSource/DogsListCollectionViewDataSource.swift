//
//  DogsListCollectionViewDataSource.swift
//  Shelter
//
//  Created by Александра Сергеева on 20.07.2024.
//

import UIKit

final class DogsListCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    var dogs: [DogsListDogModel] = []
    
    func setDogs(_ dogs: [DogsListDogModel]) {
        self.dogs = dogs
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DogsListCollectionViewCell.identifier,
            for: indexPath) as? DogsListCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        let dog = dogs[indexPath.item]
        cell.fillCell(with: dog)
        
        return cell
    }
}
