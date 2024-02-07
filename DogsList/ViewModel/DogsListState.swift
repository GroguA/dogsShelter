//
//  DogsListState.swift
//
//  Created by Александра Сергеева on 27.09.2023.
//

import Foundation

enum DogsListState {
    case success(dogs: [DogsListDogModel], isFiltering: Bool)
    case empty(isFiltering: Bool)
}
