//
//  SavedCardsDataModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 21/04/26.
//

import Foundation

// MARK: - SavedCardsDataModel
struct SavedCardsDataModel: Codable {
    let id, userID: Int?
    let cardHolderName, cardNumber, expiryDate, cvv: String?
    var isFuture: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case cardHolderName = "card_holder_name"
        case cardNumber = "card_number"
        case expiryDate = "expiry_date"
        case cvv
        case isFuture = "is_future"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
