//
//  StoreFilterDataModel.swift
//  DesynatUser
//
//  Created by fluper on 17/11/25.
//

import Foundation

struct StoreFilterOption {
    let id: Int
    let title: String
    var isSelected: Bool
    let apiParcing: String
    let seletedImage: String
    let unselectedImage: String
}

struct StoreFilterSection {
    let header: String
    var options: [StoreFilterOption]
}
