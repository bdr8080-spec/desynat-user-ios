//
//  ProductFilterModel.swift
//  DesynatUser
//
//  Created by fluper on 17/11/25.
//

import Foundation

struct ProductFilterOption {
    let title: String
    var isSelected: Bool
    var apiParcing: String
    var havingColourCode: Bool
    var colourCode: String
}

struct ProductFilterSection {
    let header: String
    let description: String
    var options: [ProductFilterOption]
}
