//
//  AffiliatedUserProductDataModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 24/02/26.
//

import Foundation


// MARK: - AffiliatedUserMyProductsDataModel
struct AffiliatedUserMyProductsDataModel: Codable {
    let currentPage: Int?
    let data: [AffiliatedUserMyProductsList]?
    let firstPageURL: String?
    let from, lastPage: Int?
    let lastPageURL: String?
    let links: [Link]?
    let nextPageURL: String?
    let path: String?
    let perPage: Int?
    let prevPageURL: String?
    let to, total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case firstPageURL = "first_page_url"
        case from
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case links
        case nextPageURL = "next_page_url"
        case path
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to, total
    }
}

// MARK: - AffiliatedUserMyProductsList
struct AffiliatedUserMyProductsList: Codable {
    let id, affiliateID, productID: Int?
    let createdAt, updatedAt: String?
    let affiliateDetails: AffiliateDetails?
    let affiliateProductLink: AffiliateProductLink?
    let product: AffiliatedProductsList?
    let averageRating: AverageRating?
    let affiliateCommission: Int?
    let totalClicks: Int?
    let totalOrders: Int?
    let conversionRate: Double?
    let totalRevenue: Double?
    let myEarning: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case affiliateID = "affiliate_id"
        case productID = "product_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case affiliateDetails = "affiliate_details"
        case affiliateProductLink = "affiliate_product_link"
        case product
        case averageRating = "average_rating"
        case affiliateCommission = "affiliate_commission"
        case totalClicks = "affiliate_product_click_records_count"
        case totalOrders = "Total_order"
        case conversionRate = "conversionrate"
        case totalRevenue = "Total_revenue"
        case myEarning = "my_earning"
    }
}

// MARK: - AffiliateDetails
struct AffiliateDetails: Codable {
    let id, userID: Int?
    let profileImage: String?
    let fullName, countryCode, mobile, email: String?
    let emailVerifiedAt: String?
    let password, passwordOld: String?
    let document1, document2: String?
    let otp, otpVerify, deviceType: String?
    let deviceToken, affiliateDetailsLet, long: String?
    let addressUpdateStatus, bankUpdateStatus, adminVerify: String?
    let rejectReason, rememberToken: String?
    let status, lang, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case profileImage = "profile_image"
        case fullName = "full_name"
        case countryCode = "country_code"
        case mobile, email
        case emailVerifiedAt = "email_verified_at"
        case password
        case passwordOld = "password_old"
        case document1, document2, otp
        case otpVerify = "otp_verify"
        case deviceType = "device_type"
        case deviceToken = "device_token"
        case affiliateDetailsLet = "let"
        case long
        case addressUpdateStatus = "address_update_status"
        case bankUpdateStatus = "bank_update_status"
        case adminVerify = "admin_verify"
        case rejectReason = "reject_reason"
        case rememberToken = "remember_token"
        case status, lang
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - AffiliateProductLink
struct AffiliateProductLink: Codable {
    let id, affiliateID, productID: Int?
    let link: String?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case affiliateID = "affiliate_id"
        case productID = "product_id"
        case link
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
