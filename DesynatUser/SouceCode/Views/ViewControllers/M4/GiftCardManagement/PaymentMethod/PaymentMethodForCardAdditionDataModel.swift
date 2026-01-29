//
//  PaymentMethodForCardAdditionDataModel.swift
//  DesynatUser
//
//  Created by fluper on 08/12/25.
//

import Foundation

// MARK: - PaymentMethodForCardAdditionDataModel
struct PaymentMethodForCardAdditionDataModel: Codable {
    let id: Int?
    let orderID, userID: String?
    let giftCardID: Int?
    let giftCardNo, giftCardPin, amount, receiverID: String?
    let receiverName, receiverEmail, senderName, senderEmail: String?
    let wishMessage, notes, paymentStatus, transactionID: String?
    let createdAt, updatedAt: String?

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
    }
}

struct PaymentMethod {
  let paymentMethodImage: String
  let paymentMethodTitle: String
  let showDescription: Bool
  var description: String
}


// MARK: - PaymentMoneyInWalletMoneyDataModel
struct PaymentMoneyInWalletMoneyDataModel: Codable {
    let uniqueID: String?
    let userID: Int?
//    let type: Int?
    let amount, paymentMethod, paymentStatus: String?
    let addedby, updatedAt, createdAt: String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case uniqueID = "unique_id"
        case userID = "user_id"
        case amount//, type
        case paymentMethod = "payment_method"
        case paymentStatus = "payment_status"
        case addedby
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id
    }
}
