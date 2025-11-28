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

// MARK: - AllBrandsListData
struct AllBrandsListData: Codable {
    let id: Int?
    let nameEnglish, nameArabic: String?
    let image: String?
    let status: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case nameEnglish = "name_english"
        case nameArabic = "name_arabic"
        case image, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - AllColorsList
struct AllColorsList: Codable {
    let id: Int?
    let name, hexCode: String?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case hexCode = "hex_code"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - AllSizesList
struct AllSizesList: Codable {
    let id: Int?
    let name, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
