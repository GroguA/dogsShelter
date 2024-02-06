//
//  DogListState.swift
//
//  Created by Александра Сергеева on 27.09.2023.
//

import Foundation

enum DogListState {
    case success(dogs: [DogsListModel], isFiltering: Bool)
    case empty(isFiltering: Bool)
}
