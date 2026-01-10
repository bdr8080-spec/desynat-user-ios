//
//  FullScreenBannersList.swift
//  DesynatUser
//
//  Created by fluper on 10/01/26.
//

import Foundation


// MARK: - FullscreenBannersList
struct FullscreenBannersList: Codable {
    let id: Int?
    let image: String?
    let countryID: Int?
    let title, startDate, endDate: String?
    let status: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, image
        case countryID = "country_id"
        case title
        case startDate = "start_date"
        case endDate = "end_date"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
