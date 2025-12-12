//
//  OrderPlaceDataModel.swift
//  DesynatUser
//
//  Created by fluper on 08/12/25.
//

import Foundation

// MARK: - OrderPlaceDataModel
struct OrderPlaceDataModel: Codable {
    let orderID: String?
    let userID, deliveryAddress: Int?
    let totalMrp, discountMrp, promocodeStatus: String?
    let promocodeID, promocodeValue: String?
    let shippingFees, tax, totalAmount, giftcardID: String?
    let giftcardAmount, paymentMethod, updatedAt, createdAt: String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case orderID = "order_id"
        case userID = "user_id"
        case deliveryAddress = "delivery_address"
        case totalMrp = "total_mrp"
        case discountMrp = "discount_mrp"
        case promocodeStatus = "promocode_status"
        case promocodeID = "promocode_id"
        case promocodeValue = "promocode_value"
        case shippingFees = "shipping_fees"
        case tax
        case totalAmount = "total_amount"
        case giftcardID = "giftcard_id"
        case giftcardAmount = "giftcard_amount"
        case paymentMethod = "Payment_method"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id
    }
}

struct PaymentMethodForPlaceOrder {
  let paymentMethodImage: String
  let paymentMethodTitle: String
  let showDescription: Bool
  var description: String
}


// MARK: - WalletAmountDataModel
struct WalletAmountDataModel: Codable {
    let balance: Double?
}
