//
//  GiftCardAddedDataModel.swift
//  DesynatUser
//
//  Created by fluper on 08/12/25.
//

import Foundation

// MARK: - GiftCardAddedDataModel
struct GiftCardAddedDataModel: Codable {
    let orderID: String?
    let userID: Int?
    let giftCardID: String?
    let giftCardNo: Double?
    let giftCardPin, amount, receiverID: Int?
    let receiverName, receiverEmail, senderName, senderEmail: String?
    let wishMessage, notes, updatedAt, createdAt: String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case orderID = "order_id"
        case userID = "user_id"
        case giftCardID = "gift_card_id"
        case giftCardNo, giftCardPin, amount
        case receiverID = "receiver_id"
        case receiverName = "receiver_name"
        case receiverEmail = "receiver_email"
        case senderName = "sender_name"
        case senderEmail = "sender_email"
        case wishMessage = "wish_message"
        case notes
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id
    }
}
