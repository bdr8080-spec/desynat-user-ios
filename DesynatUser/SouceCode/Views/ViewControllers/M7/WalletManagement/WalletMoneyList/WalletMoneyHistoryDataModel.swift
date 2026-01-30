//
//  WalletMoneyHistoryDataModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 29/01/26.
//

import Foundation

// MARK: - WalletMoneyHistoryDataModel
struct WalletMoneyHistoryDataModel: Codable {
    let walletBalance: String?
    let history: [WalletMoneyHistoryList]?

    enum CodingKeys: String, CodingKey {
        case walletBalance = "wallet_balance"
        case history
    }
}

// MARK: - WalletMoneyHistoryList
struct WalletMoneyHistoryList: Codable {
    let id: Int?
    let uniqueID: String?
    let userID, type: Int?
    let transactionID, giftcardno, orderId: String?
    let amount, addedby, createdAt, updatedAt: String?
    let paymentMethod, paymentStatus: String?

    enum CodingKeys: String, CodingKey {
        case id
        case uniqueID = "unique_id"
        case userID = "user_id"
        case type, giftcardno
        case transactionID = "transaction_id"
        case amount, addedby
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case paymentMethod = "payment_method"
        case paymentStatus = "payment_status"
        case orderId = "order_id"
    }
}
