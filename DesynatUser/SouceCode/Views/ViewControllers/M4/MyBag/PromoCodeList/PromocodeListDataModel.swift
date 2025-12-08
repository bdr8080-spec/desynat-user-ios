//
//  PromocodeListDataModel.swift
//  DesynatUser
//
//  Created by fluper on 08/12/25.
//

import Foundation

// MARK: - GetPromoCodeListDataModel
struct GetPromoCodeListDataModel: Codable {
    let id, countryID: Int?
    let nameEnglish, nameArabic, descriptionEnglish, descriptionArabic: String?
    let applicableFor: Int?
    let discountPercent, minOrderValue, uptoDiscount, startDate: String?
    let endDate: String?
    let status: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case countryID = "country_id"
        case nameEnglish = "name_english"
        case nameArabic = "name_arabic"
        case descriptionEnglish = "description_english"
        case descriptionArabic = "description_arabic"
        case applicableFor = "applicable_for"
        case discountPercent = "discount_percent"
        case minOrderValue = "min_order_value"
        case uptoDiscount = "upto_discount"
        case startDate = "start_date"
        case endDate = "end_date"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
