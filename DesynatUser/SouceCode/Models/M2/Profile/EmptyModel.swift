//
//  EmptyModel.swift
//  DesynatUser
//
//  Created by fluper on 06/11/25.
//


import Foundation

// MARK: - EmptyModel
struct EmptyModel: Codable {
    
}


// MARK: - PromocodeApplied
struct PromocodeApplied: Codable {
    let discountCode, amount, discountPercentage: String?
    let originalDiscount, applyDiscountValue, finalAmount: Double?

    enum CodingKeys: String, CodingKey {
        case discountCode = "discount_code"
        case amount
        case discountPercentage = "discount_percentage"
        case originalDiscount = "original_discount"
        case applyDiscountValue = "Apply_discount_value"
        case finalAmount = "final_amount"
    }
}


// MARK: - sharedReelDataModel
struct sharedReelDataModel: Codable {
    let reelID: Int?
    let file: String?

    enum CodingKeys: String, CodingKey {
        case reelID = "reel_id"
        case file
    }
}
