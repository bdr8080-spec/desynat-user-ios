//
//  UseGiftCardDataModel.swift
//  DesynatUser
//
//  Created by fluper on 08/12/25.
//

import Foundation

// MARK: - UseGiftCardDataModel
struct UseGiftCardDataModel: Codable {
    let id: Int?
    let giftCardAmount: String?

    enum CodingKeys: String, CodingKey {
        case id
        case giftCardAmount = "GiftCardAmount"
    }
}
