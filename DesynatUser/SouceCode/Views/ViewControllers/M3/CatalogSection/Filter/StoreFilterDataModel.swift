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
    var apiParcing: String
    var seletedImage: String
    var unselectedImage: String
}

struct StoreFilterSection {
    let header: String
    var options: [StoreFilterOption]
}
