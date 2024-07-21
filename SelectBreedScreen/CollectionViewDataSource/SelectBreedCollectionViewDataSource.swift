//
//  SelectBreedCollectionViewDataSource.swift
//  Shelter
//
//  Created by Александра Сергеева on 21.07.2024.
//

import UIKit

final class SelectBreedCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    var breeds: [SelectBreedModel] = []
    
    func setBreeds(_ breeds: [SelectBreedModel]) {
        self.breeds = breeds
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return breeds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SelectBreedCollectionViewCell.identifier,
            for: indexPath) as? SelectBreedCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        let breed = breeds[indexPath.item]
        cell.fillCell(with: breed)
        
        return cell
    }
}
