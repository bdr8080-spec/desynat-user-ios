//
//  GiftCardsDataModel.swift
//  DesynatUser
//
//  Created by fluper on 06/12/25.
//

import Foundation

// MARK: - GiftCardsListDataModel
struct GiftCardsListDataModel: Codable {
    let id: Int?
    let orderID, userID: String?
    let giftCardID: Int?
    let giftCardNo, giftCardPin, amount, receiverID: String?
    let receiverName, receiverEmail, senderName, senderEmail: String?
    let wishMessage, notes, paymentStatus, transactionID: String?
    let createdAt, updatedAt: String?
    let giftDetails: GiftCardsDataModel?

    enum CodingKeys: String, CodingKey {
        case id
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
        case paymentStatus = "payment_status"
        case transactionID = "transaction_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case giftDetails = "gift_details"
    }
}

// MARK: - GiftCardsDataModel
struct GiftCardsDataModel: Codable {
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
