//
//  SortByStoreDataModel.swift
//  DesynatUser
//
//  Created by fluper on 25/11/25.
//

import Foundation
// MARK: - SortByStoreDataModel
struct SortByStoreDataModel: Codable {
    let id: Int?
    let name, nameAr, status, createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case nameAr = "name_ar"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
