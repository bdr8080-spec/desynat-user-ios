//
//  AffiliatedCategorySearchDataModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 24/02/26.
//

import Foundation

// MARK: - AffiliatedLatestSearch
struct AffiliatedLatestSearch: Codable {
    let id, userID: Int?
    let name, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case name
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

